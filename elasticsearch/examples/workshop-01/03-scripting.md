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

#### Working with data

```json

PUT persons/_doc/1?pretty
{
  "name": "John",
  "sur_name": "Smith",
  "year_of_birth": 1925
}

GET persons/_search?pretty
{
  "runtime_mappings": {
    "age": {
      "type": "long",
      "script": {
        "source": """
          long age = params.today - doc['year_of_birth'].value;
          emit(age);
        """,
        "params": {
          "today": 2022
        }
      }
    }
  },
  "fields": [
    "age"
  ]
}

Response:

{
  "took" : 10,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "persons",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "name" : "John",
          "sur_name" : "Smith",
          "year_of_birth" : 1925
        },
        "fields" : {
          "age" : [
            97
          ]
        }
      }
    ]
  }
}

```

<details>
<summary>cURL</summary>

```json

curl -XPUT "http://singleElasticsearch:9200/persons/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "John",
  "sur_name": "Smith",
  "year_of_birth": 1925
}'

curl -XGET "http://singleElasticsearch:9200/persons/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "runtime_mappings": {
    "age": {
      "type": "long",
      "script": {
        "source": "\n          long age = params.today - doc['\''year_of_birth'\''].value;\n          emit(age);\n        ",
        "params": {
          "today": 2022
        }
      }
    }
  },
  "fields": [
    "age"
  ]
}'

{
  "took" : 10,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "persons",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "name" : "John",
          "sur_name" : "Smith",
          "year_of_birth" : 1925
        },
        "fields" : {
          "age" : [
            97
          ]
        }
      }
    ]
  }
}

```
	
</details>
