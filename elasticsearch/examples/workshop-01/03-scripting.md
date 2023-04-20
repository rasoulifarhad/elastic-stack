### scripting

From [Ingest Pipelines](https://cdax.ch/2022/01/30/elastic-workshop-2-ingest-pipelines/)

#### Hello World

```json
POST /_scripts/painless/_execute?pretty
{
  "script": {
    "source": "return('Hello World')"
  }
}

Response:

{
  "result" : "Hello Worldqqqqqq"
}
```

<details>
<summary>cURL</summary>

```json
curl -XPOST "http://singleElasticsearch:9200/_scripts/painless/_execute?pretty" -H 'Content-Type: application/json' -d'
{
  "script": {
    "source": "return('\''Hello World'\'')"
  }
}'

Response:

{
  "result" : "Hello Worldqqqqqq"
}
```

</details>

#### Hello World with parameters

```json
POST /_scripts/painless/_execute?pretty
{
  "script": {
    "source": """
      // This is a oneline comment
      
      return(params.phrase)
      
      /* This is a
         multiline comment */
      """,
      "params": {
        "phrase": "Hello World"
      }
  }
}

Response:

{
  "result" : "Hello Worldqqqqqq"
}
```

<details>
<summary>cURL</summary>
    
```json
curl -XPOST "http://singleElasticsearch:9200/_scripts/painless/_execute?pretty" -H 'Content-Type: application/json' -d'
{
  "script": {
    "source": "\n      return(params.phrase)\n      ",
      "params": {
	"phrase": "Hello World"
      }
  }
}'

Response:

{
  "result" : "Hello Worldqqqqqq"
}
```
      
</details>
