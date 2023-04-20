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

```json
PUT _scripts/calc_age_script?pretty
{
  "script": {
    "lang": "painless",
    "source": """
      params['today'] - doc['year_of_birth'].value;
    """
  }
}

GET /persons/_search?pretty
{
  "script_fields": {
    "age": {
      "script": {
        "id": "calc_age_script",
        "params": {
          "today": 2044
        }
      }
    }
  }
}

Response:

{
  "took" : 4,
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
        "fields" : {
          "age" : [
            119
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
curl -XPUT "http://singleElasticsearch:9200/_scripts/calc_age_script?pretty" -H 'Content-Type: application/json' -d'
{
  "script": {
    "lang": "painless",
    "source": "\n      params['\''today'\''] - doc['\''year_of_birth'\''].value;\n    "
  }
}'

curl -XGET "http://singleElasticsearch:9200/persons/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "script_fields": {
    "age": {
      "script": {
        "id": "calc_age_script",
        "params": {
          "today": 2044
        }
      }
    }
  }
}'

Response:

{
  "took" : 4,
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
        "fields" : {
          "age" : [
            119
          ]
        }
      }
    ]
  }
}
```

</details>

#### Calling scripts with a search-template

Stored scripts are not supported for runtime mappings. Therefore, the script has to be stored inline. However, we can use search templates. Search templates are scripts, but written in “mustache”.

The request’s source supports the same parameters as the search API's request body. source also supports Mustache variables, typically enclosed in double curly brackets: {{my-var}}. When you run a templated search, Elasticsearch replaces these variables with values from params.

```json
PUT _scripts/calc_age_template
{
  "script": {
    "lang": "mustache",
    "source": {
      "runtime_mappings": {
        "age": {
          "type": "long",
          "script": {
            "source": """ 
             long age = {{act_year}} - doc['year_of_birth'].value;
             emit(age)
            """
          }
        }
      },
      "fields": [
        "age"
      ]
    }
  },
  "params": {
    "act_year": "today"
  }
}

# Validate a search templateedit
POST _render/template?pretty
{
  "id": "calc_age_template",
  "params": {
    "act_year": 2022
  }
}

Result:

{
  "template_output" : {
    "runtime_mappings" : {
      "age" : {
        "type" : "long",
        "script" : {
          "source" : """ 
             long age = 2022 - doc['year_of_birth'].value;
             emit(age)
            """
        }
      }
    },
    "fields" : [
      "age"
    ]
  }
}

GET persons/_search/template
{
  "source": "fields",
  "id": "calc_age_template",
  "params": {
    "act_year": 2022
  }
}

Response:

{
  "took" : 5,
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
          "age" : 99,
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
curl -XPUT "http://singleElasticsearch:9200/_scripts/calc_age_template" -H 'Content-Type: application/json' -d'
{
  "script": {
    "lang": "mustache",
    "source": {
      "runtime_mappings": {
        "age": {
          "type": "long",
          "script": {
            "source": " \n             long age = {{act_year}} - doc['\''year_of_birth'\''].value;\n             emit(age)\n            "
          }
        }
      },
      "fields": [
        "age"
      ]
    }
  },
  "params": {
    "act_year": "today"
  }
}'

# Validate a search templateedit
curl -XPOST "http://singleElasticsearch:9200/_render/template?pretty" -H 'Content-Type: application/json' -d'
{
  "id": "calc_age_template",
  "params": {
    "act_year": 2022
  }
}'

Result:

{
  "template_output" : {
    "runtime_mappings" : {
      "age" : {
        "type" : "long",
        "script" : {
          "source" : """ 
             long age = 2022 - doc['year_of_birth'].value;
             emit(age)
            """
        }
      }
    },
    "fields" : [
      "age"
    ]
  }
}

curl -XGET "http://singleElasticsearch:9200/persons/_search/template" -H 'Content-Type: application/json' -d'
{
  "source": "fields",
  "id": "calc_age_template",
  "params": {
    "act_year": 2022
  }
}'

Response:

{
  "took" : 5,
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
          "age" : 99,
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

#### Context

A context provides variables and fields, classes and methods, and what kind of values can be returned. So to speak: your script may run perfectly in a pipeline, but it fails in a runtime field. And even worse; your stored script works flawlessly in your pipeline, but if you use it for an update, it fails.

To make it short: a context provides and sets the boundaries in which your script will operate.

examples:

- ingest-processor (pipelines)
- update
- update_by_query
- reindex
- runtime fields
- fields

##### the challenge

To show you how to handle the different contexts, we will solve the same challenge in all the contexts. This is our data:

```json
PUT companies/_doc/1?pretty
{
  "ticker_symbol": "ESTC",
  "market_cap": 8000000000,
  "share_price": 82.5
}
```

<details>
   <summary>cURL</summary>

```json
curl -XPUT "http://singleElasticsearch:9200/companies/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "ticker_symbol": "ESTC",
  "market_cap": 8000000000,
  "share_price": 82.5
}'
```

</details>

##### ingest-processor-context

Pipelines can access the source of a document direct via the “ctx-map” variable and by “dot-notion”:

```json
PUT _ingest/pipeline/calc_outstanding_pipeline?pretty
{
  "processors": [
    {
      "script": {
        "source": """
          double outstanding = ctx.market_cap / ctx.share_price;
          ctx.outstanding = (long) outstanding;
        """
      }
    }
  ]
}

POST companies/_update_by_query?pretty&pipeline=calc_outstanding_pipeline

GET companies/_search?pretty

Result:

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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "ticker_symbol" : "ESTC",
          "market_cap" : 8000000000,
          "outstanding" : 96969696,
          "share_price" : 82.5
        }
      }
    ]
  }
}
```

<details>
   <summary>cURL</summary>

```json
curl -XPUT "http://singleElasticsearch:9200/_ingest/pipeline/calc_outstanding_pipeline?pretty" -H 'Content-Type: application/json' -d'
{
  "processors": [
    {
      "script": {
        "source": "double outstanding = ctx.market_cap / ctx.share_price; ctx.outstanding = (long) outstanding;"
      }
    }
  ]
}'

curl -XPOST "http://singleElasticsearch:9200/companies/_update_by_query?pretty&pipeline=calc_outstanding_pipeline"

curl -XGET "http://singleElasticsearch:9200/companies/_search?pretty"

Result:

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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "ticker_symbol" : "ESTC",
          "market_cap" : 8000000000,
          "outstanding" : 96969696,
          "share_price" : 82.5
        }
      }
    ]
  }
}
```

</details>

The fields can also be addressed with “ctx[field-name]”, called the “bracket-notion”:

```markdown
double outstanding = ctx['market_cap'] / ctx['share_price'];
ctx['outstanding'] = (long)outstanding
```

The **“bracket-notion”** allows greater flexibility. Fields like ctx[‘a b’] are possible, while the **“dot-notion”** prevents a call like “ctx.a b”. To be safe, use the “dot-notion” as much as possible.

##### update- and update_by_query-contex

The update-, update_by_query- and the reindex-contexts use the map “ctx._source” to access the document fields:

```json
DELETE companies/_doc/1?pretty

PUT companies/_doc/1?pretty
{
  "ticker_symbol": "ESTC",
  "market_cap": 8000000000,
  "share_price": 82.5
}

POST companies/_update/1?pretty
{
  "script": {
    "source": """
       double outstanding = ctx._source.market_cap / ctx._source.share_price;
       ctx._source.outstanding=(long)outstanding;
    """
  }
}

GET companies/_doc/1?pretty

Result:

{
  "_index" : "companies",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 7,
  "_seq_no" : 6,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "ticker_symbol" : "ESTC",
    "market_cap" : 8000000000,
    "share_price" : 82.5,
    "outstanding" : 96969696
  }
}
```

<details>
   <summary>cURL</summary>

```json
curl -XDELETE "http://singleElasticsearch:9200/companies/_doc/1?pretty"

curl -XPUT "http://singleElasticsearch:9200/companies/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "ticker_symbol": "ESTC",
  "market_cap": 8000000000,
  "share_price": 82.5
}'

curl -XPOST "http://singleElasticsearch:9200/companies/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
  "script": {
    "source": "\n       double outstanding = ctx._source.market_cap / ctx._source.share_price;\n       ctx._source.outstanding=(long)outstanding;\n    "
  }
}'

curl -XGET "http://singleElasticsearch:9200/companies/_doc/1?pretty"

Result:

{
  "_index" : "companies",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 7,
  "_seq_no" : 6,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "ticker_symbol" : "ESTC",
    "market_cap" : 8000000000,
    "share_price" : 82.5,
    "outstanding" : 96969696
  }
}
```

</details>

The update-context also provides the variable **“ctx.now”** with the current timestamp. update_by_query and reindex do not provide this variable.

The update-, update_by_query- and the reindex-contexts are providing the special variable “op”. Which lets you delete the document if needed:

```
"script" : {
  "source": """
  ctx.op = 'delete'      
  """
}
```

##### reindex-context

The reindex-context does not provide any further variables or methods other than the update or update_by_query does. Here is just an example for a script that accesses the “ctx._source”-map by the “dot-notion”:

```json
POST _reindex?pretty
{
  "source": {
    "index": "companies"
  },
  "dest": {
    "index": "companies_new"
  },
  "script": {
    "source": """
      double outstanding = ctx._source.market_cap / ctx._source.share_price;
      ctx._source.outstanding_reindexed = (long)outstanding 
    """
  }
}

GET companies_new/_doc/1?pretty

Result:

{
  "_index" : "companies_new",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "ticker_symbol" : "ESTC",
    "market_cap" : 8000000000,
    "outstanding" : 96969696,
    "outstanding_reindexed" : 96969696,
    "share_price" : 82.5
  }
}
```

<details>
   <summary>cURL</summary>

```json
curl -XPOST "http://singleElasticsearch:9200/_reindex?pretty" -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "companies"
  },
  "dest": {
    "index": "companies_new"
  },
  "script": {
    "source": "double outstanding = ctx._source.market_cap / ctx._source.share_price;ctx._source.outstanding_reindexed = (long)outstanding"
  }
}'

curl -XGET "http://singleElasticsearch:9200/companies_new/_doc/1?pretty"

Result:

{
  "_index" : "companies_new",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "ticker_symbol" : "ESTC",
    "market_cap" : 8000000000,
    "outstanding" : 96969696,
    "outstanding_reindexed" : 96969696,
    "share_price" : 82.5
  }
}
```

</details>

##### runetime_field-context

The runtime_field-context uses “doc-map” for accessing document fields. This map is read-only.

```json
GET companies/_search
{
  "query": {
    "match": {
      "ticker_symbol.keyword": "ESTC"
    }
  }, 
  "runtime_mappings": {
    "outstanding": {
      "type": "long",
      "script": {
        "lang": "painless", 
        "source": """
        long result;
        double outstanding = doc.market_cap.value / doc['share_price'].value;
        result = (long)outstanding; 
        emit(result);
        """
      }
    }
  },
  "fields": ["outstanding"]
}

Result:

{
  "took" : 2,
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
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "ticker_symbol" : "ESTC",
          "market_cap" : 8000000000,
          "outstanding" : 96969696,
          "outstanding_reindexed" : 96969696,
          "share_price" : 82.5
        },
        "fields" : {
          "outstanding" : [
            96969696
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
curl -XGET "http://singleElasticsearch:9200/companies/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "ticker_symbol.keyword": "ESTC"
    }
  }, 
  "runtime_mappings": {
    "outstanding": {
      "type": "long",
      "script": {
        "lang": "painless", 
        "source": """
        long result;
        double outstanding = doc.market_cap.value / doc['share_price'].value;
        result = (long)outstanding; 
        emit(result);
        """
      }
    }
  },
  "fields": ["outstanding"]
}

Result:

{
  "took" : 2,
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
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "ticker_symbol" : "ESTC",
          "market_cap" : 8000000000,
          "outstanding" : 96969696,
          "outstanding_reindexed" : 96969696,
          "share_price" : 82.5
        },
        "fields" : {
          "outstanding" : [
            96969696
          ]
        }
      }
    ]
  }
}
```

</details>

The runtime_field-context is the only one that uses the emit-method for returning results. emit can’t return null-values and at least one object must be returned, therefore test the values before you emit them.

##### fields-context

Scripted fields are very similar to the runtime-field context. However, grok and dissect patterns are not available – runtime_fields do provide these methods.

```json
GET companies/_search
{
  "script_fields": {
    "free_float": {
      "script": {
        "source": """
          long result;
          double outstanding = doc.market_cap.value / doc['share_price'].value;
          result = (long)outstanding; 
          return (result)
        """
      }
    }
  }
}

Result:

{
  "took" : 1,
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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "free_float" : [
            96969696
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
curl -XGET "http://singleElasticsearch:9200/companies/_search" -H 'Content-Type: application/json' -d'
{
  "script_fields": {
    "free_float": {
      "script": {
        "source": "long result;double outstanding = doc.market_cap.value / doc['\''share_price'\''].value;result = (long)outstanding;return (result)"
      }
    }
  }
}'

Result:

{
  "took" : 1,
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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "free_float" : [
            96969696
          ]
        }
      }
    ]
  }
}
```

</details>
