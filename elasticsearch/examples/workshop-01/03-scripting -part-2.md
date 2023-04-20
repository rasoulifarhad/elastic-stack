### scripting part 2

From [Ingest Pipelines](https://cdax.ch/2022/01/30/elastic-workshop-2-ingest-pipelines/)

#### Primitive data types and their reference objects

```json
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
