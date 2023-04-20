### scripting part 2

From [Ingest Pipelines](https://cdax.ch/2022/01/30/elastic-workshop-2-ingest-pipelines/)

#### Primitive data types and their reference objects

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      boolean a ;
      long market_cap = 8000000000L;
      if (market_cap > 1000){
        a = true ;
      } else {
        a = false;
      }
      return a;
    """
  }
}

Result:

{
  "result" : "true"
}
```

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      def a ;
      def market_cap = 8000000000L;
      if (market_cap > 1000){
        a = true ;
      } else {
        a = false;
      }
      return a;
    """
  }
}

Result:

{
  "result" : "true"
}
```


|primitive    | reference object
|-------------|-----------
|int          | Integer
|long         | Long
|char         | Character
|boolean      | Boolean

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      boolean i = true ;
      boolean j = false ;
      return i.equals(j);
    """
  }
}

Result:

{
  "result" : "false"
}
```

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      long l = 80000000L;
      return l.toString();
    """
  }
}

Result:

{
  "result" : "80000000"
}
```
