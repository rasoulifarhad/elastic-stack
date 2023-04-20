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

To read the value of a field, you need to access the “doc-map”, then the field-name and you should also use the “.value” notion to read fields in the runtime_mapping API.

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

#### Storing Scripts

We can store the script in a pipeline with a script processor:

```json
PUT _ingest/pipeline/calc_age_pipeline?pretty
{
  "processors": [
    {
      "script": {
        "source": """
          ctx['age'] = params.today - ctx['year_of_birth'];
        """,
        "params": {
          "today": 2022
        }
      }
    }
  ]
}
```

<details>
<summary>cURL</summary>

```json
curl -XPUT "http://singleElasticsearch:9200/_ingest/pipeline/calc_age_pipeline?pretty" -H 'Content-Type: application/json' -d'
{
  "processors": [
    {
      "script": {
        "source": "\n          ctx['\''age'\''] = params.today - ctx['\''year_of_birth'\''];\n        ",
        "params": {
          "today": 2022
        }
      }
    }
  ]
}'
```

</details>

In pipelines you address now the fields not anymore over the “doc-map”, but over “ctx-map”. The painless contexts and their different variables and ways to access data can be confusing.

Note:
- if your script is used in a pipeline, request the field-values with “ctx[field-name]”
- if your script is used in an _update or _update_by_query API, request field-values by “ctx._source[field-name]”
- if your script is used in the _search API with a query or runtime-mapping statement, request the field-values by doc[field-name].value
- parameters can ingested by dot-notion, for example params.today, or by bracket-notion like params[‘today’].
- Params in a stored script cannot be accessed over params.xxx or params[xxx]. Pass them when you call the script as you see it in the example for calling scripts by the APIs.

You can store the script under the “calc_age_script” in the cluster state and call it later by its ID:

```json
PUT _scripts/calc_age_script?pretty
{
  "script": {
    "lang": "painless",
    "source": """
      ctx._source['age'] = params['today'] - ctx._source['year_of_birth'];
    """
  }
}
```

<details>
<summary>cURL</summary>

```json
curl -XPUT "http://singleElasticsearch:9200/_scripts/calc_age_script?pretty" -H 'Content-Type: application/json' -d'
{
  "script": {
    "lang": "painless",
    "source": "\n      ctx._source['\''age'\''] = params['\''today'\''] - ctx._source['\''year_of_birth'\''];\n    "
  }
}'
```

</details>

#### Calling scripts with the update_by_query API

The document fields are now called by “ctx._source[field-name]”. 

```json
POST persons/_update_by_query?pretty
{
  "query": {
    "match_all": {}
  },
  "script": {
    "id": "calc_age_script", 
    "params": {
      "today": 2022
    }
  }
}
```

<details>
   <summary>cURL</summary>

```json
curl -XPOST "http://singleElasticsearch:9200/persons/_update_by_query?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_all": {}
  },
  "script": {
    "id": "calc_age_script", 
    "params": {
      "today": 2022
    }
  }
}'
```
	
</details>

#### Calling scripts with the update API

```json
POST persons/_update/1?pretty
{
  "script": {
    "id": "calc_age_script",
    "params": {
      "today": 2024
    }
  }
}
```

<details>
   <summary>cURL</summary>

```json
curl -XPOST "http://singleElasticsearch:9200/persons/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
  "script": {
    "id": "calc_age_script",
    "params": {
      "today": 2024
    }
  }
}'
```

</details>

#### Calling Scripts with the reindex API

```json
POST _reindex?pretty
{
  "source": {
    "index": "persons"
  },
  "dest": {
    "index": "persons_with_age"
  },
  "script": {
    "id": "calc_age_script",
    "params": {
      "today": 2044
    }
  }
}

GET persons_with_age/_search?pretty

Response:

{
  "took" : 0,
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
        "_index" : "persons_with_age",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "name" : "John",
          "sur_name" : "Smith",
          "age" : 119,
          "year_of_birth" : 1925
        }
      }
    ]
  }
}
```

<details>
   <summary>cURL</summary>

```json
curl -XPOST "http://singleElasticsearch:9200/_reindex?pretty" -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "persons"
  },
  "dest": {
    "index": "persons_with_age"
  },
  "script": {
    "id": "calc_age_script",
    "params": {
      "today": 2044
    }
  }
}'

curl -XGET "http://singleElasticsearch:9200/persons_with_age/_search?pretty"

{
  "took" : 0,
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
        "_index" : "persons_with_age",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "name" : "John",
          "sur_name" : "Smith",
          "age" : 119,
          "year_of_birth" : 1925
        }
      }
    ]
  }
}
```

</details>

#### Calling scripts with the _search API

To get the script working we need to update the script and the variables. We need the “doc-map” and the “.value” method to access the values:

#### Calling scripts with a search-template
