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

#### non-static methods

- int compareTo(Long)
- double doubleValue()
- boolean equals(Object)
- null toString()
- ..

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

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      long l1 = 80000000L;
      long l2 = 2000L;
      int a = l1.compareTo(l2);
      return a ;
    """
  }
}

Result:

{
  "result" : "1"
}
```

#### static methods

- static long max(long, long)
- static long divideUnsigned(long, long)
- static int compare(long, long)
- static int numberOfTrailingZeros(long)
-  ..

```
POST /_scripts/painless/_execute
{
  "script": {
    "source": """
      long l1 = 80000000L;
      long l2 = 2000L;
      long max = Long.max(l1,l2);
      return max ;
    """
  }
}

{
  "result" : "80000000"
}
```

