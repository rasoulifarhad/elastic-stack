### Ingest Pipelines

From [Ingest Pipelines](https://cdax.ch/2022/01/30/elastic-workshop-2-ingest-pipelines/)

---

#### Goal

<details open><summary><i>Raw document</i></summary><blockquote>

```json
{
  "company_name": "Elastic EV", 
  "address": "800 West El Camino Real, Suite 350", 
  "city": "Mountain View, Ca 94040",
  "ticker_symbol": "ESTC", 
  "market_cap": "8B"
}
```

</blockquote></details>

<details open><summary><i>Converted document</i></summary><blockquote>

```json
{
  "company_name": "Elastic EV", 
  "address": "800 West El Camino Real, Suite 350", 
  "ticker_symbol": "ESTC", 
  "market_cap": "8B",
  "state": "CA",
  "city": "Mountain View",
  "zip": 94040
}
```

</blockquote></details>

---

#### Create a pipeline with a set processor

<details open><summary><i>Pipeline</i></summary><blockquote>

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city"
      }
    }
  ]
}
```

<details><summary><i>Test pipeline</i></summary>

```json
PUT /companies/_doc/1?pretty&pipeline=split-city-string-to-array
{
  "company_name": "Elastic EV",
  "address": "800 West El Camino Real, Suite 350",
  "city": "Mountain View, Ca 94040",
  "ticker_symbol": "ESTC",
  "market_cap": "8B"
}

GET /companies/_doc/1?pretty

{
  "_index" : "companies",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "address" : "800 West El Camino Real, Suite 350",
    "ticker_symbol" : "ESTC",
    "market_cap" : "8B",
    "city" : "Mountain View, Ca 94040",
    "company_name" : "Elastic EV",
    "city_array" : "Mountain View, Ca 94040"
  }
}
```

</details>

</blockquote></details>

<details><summary><i>curl:</i></summary><blockquote>
  
<details open><summary><i>Pipeline</i></summary><blockquote>

```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city"
      }
    }
  ]
}'
```

<details><summary><i>Test pipeline</i></summary>

```json
curl -XPUT "localhost:9200/companies/_doc/1?pretty&pipeline=split-city-string-to-array" -H 'Content-Type: application/json' -d'
{
  "company_name": "Elastic EV",
  "address": "800 West El Camino Real, Suite 350",
  "city": "Mountain View, Ca 94040",
  "ticker_symbol": "ESTC",
  "market_cap": "8B"
}'

curl -XGET "localhost:9200/companies/_doc/1?pretty"

{
  "_index" : "companies",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "address" : "800 West El Camino Real, Suite 350",
    "ticker_symbol" : "ESTC",
    "market_cap" : "8B",
    "city" : "Mountain View, Ca 94040",
    "company_name" : "Elastic EV",
    "city_array" : "Mountain View, Ca 94040"
  }
}
```

</details>

</blockquote></details>

</blockquote></details>

---

#### Split processor

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "field": "city_array",
        "separator": ","
      }
    }
  ]
}
```

<details><summary>curl</summary>
  
```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "field": "city_array",
        "separator": ","
      }
    }
  ]
}'

```

</details>

---

#### Run _update_by_query

<details open><summary><i>update by query</i></summary><blockquote>

```json
POST companies/_update_by_query?pretty&pipeline=split-city-string-to-array
{
  "query": {
    "match_all": {}
  }
}
```

<details><summary>check update</summary>

```json
GET /companies/_search?pretty

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
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "city_array" : [
            "Mountain View",
            " Ca 94040"
          ]
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>


<details><summary><i>curl:</i></summary><blockquote>

<details open><summary><i>update by query</i></summary><blockquote>

```json
curl -XPOST "localhost:9200/companies/_update_by_query?pretty&pipeline=split-city-string-to-array" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_all": {}
  }
}'
```

<details><summary>check update</summary>

```json
curl -XGET "localhost:9200/companies/_search?pretty"

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
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "city_array" : [
            "Mountain View",
            " Ca 94040"
          ]
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

</blockquote></details>

---

#### Remove leading spaces with gsub processor


<details open><summary><i>Pipeline</i></summary><blockquote>

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      }
    }
  ]
}
```

<details><summary><i>Test pipeline</i></summary>

```json
POST /_ingest/pipeline/split-city-string-to-array/_simulate?pretty
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}

Error:

{
  "docs" : [
    {
      "error" : {
        "root_cause" : [
          {
            "type" : "illegal_argument_exception",
            "reason" : "field [city_array] of type [java.util.ArrayList] cannot be cast to [java.lang.String]"
          }
        ],
        "type" : "illegal_argument_exception",
        "reason" : "field [city_array] of type [java.util.ArrayList] cannot be cast to [java.lang.String]"
      }
    }
  ]
}
```

</details>

</blockquote></details>


<details><summary><i>curl:</i></summary><blockquote>

<details open><summary><i>Pipeline</i></summary><blockquote>

```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      }
    }
  ]
}'
```

<details><summary><i>Test</i></summary>

```json
curl -XPOST "localhost:9200/_ingest/pipeline/split-city-string-to-array/_simulate?pretty" -H 'Content-Type: application/json' -d'
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}'

Error: 

{
  "docs" : [
    {
      "error" : {
        "root_cause" : [
          {
            "type" : "illegal_argument_exception",
            "reason" : "field [city_array] of type [java.util.ArrayList] cannot be cast to [java.lang.String]"
          }
        ],
        "type" : "illegal_argument_exception",
        "reason" : "field [city_array] of type [java.util.ArrayList] cannot be cast to [java.lang.String]"
      }
    }
  ]
}
```

</details>

</blockquote></details>

</blockquote></details>

---

#### Setting conditions in processors

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String", 
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      }
    }
  ]
}
```

<details><summary><i>Test pipeline</i></summary>

```json
POST /_ingest/pipeline/split-city-string-to-array/_simulate?pretty
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "city_array" : [
            "Mountain View",
            "Ca 94040"
          ]
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T22:01:31.515391428Z"
        }
      }
    }
  ]
}
```

</details>

<details><summary><i>curl:</i></summary><blockquote>

```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String", 
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      }
    }
  ]
}'

curl -XPOST "localhost:9200/_ingest/pipeline/split-city-string-to-array/_simulate?pretty" -H 'Content-Type: application/json' -d'
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}'

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "city_array" : [
            "Mountain View",
            "Ca 94040"
          ]
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T22:01:31.515391428Z"
        }
      }
    }
  ]
}
```

</blockquote></details>

---

#### Handling pipeline failures

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String", 
        "ignore_failure": true, 
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      }
    }
  ]
}
```

<details><summary><i>curl:</i></summary><blockquote>

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String", 
        "ignore_failure": true, 
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      }
    }
  ]
}
```

</blockquote></details>

---

#### The script processor

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": """
          ctx['city_name'] = ctx['city_array'].0;
          def split_statezip = ctx['city_array'].1.splitOnToken(' ');
          ctx['state'] = split_statezip[0];
          ctx['zip'] = split_statezip[1];
          """
      }
    }
  ]
}
```

<details><summary><i>Test pipeline</i></summary>

```json
POST /_ingest/pipeline/split-city-string-to-array/_simulate?pretty
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : "94040",
          "city_name" : "Mountain View",
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "state" : "Ca",
          "city_array" : [
            "Mountain View",
            "Ca 94040"
          ]
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T22:47:56.47760847Z"
        }
      }
    }
  ]
}
```

</details>

<details><summary><i>curl:</i></summary><blockquote>

```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": """
          ctx['city_name'] = ctx['city_array'].0;
          def split_statezip = ctx['city_array'].1.splitOnToken(' ');
          ctx['state'] = split_statezip[0];
          ctx['zip'] = split_statezip[1];
          """
      }
    }
  ]
}'

curl -XPOST "localhost:9200/_ingest/pipeline/split-city-string-to-array/_simulate?pretty" -H 'Content-Type: application/json' -d'
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}'

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : "94040",
          "city_name" : "Mountain View",
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "state" : "Ca",
          "city_array" : [
            "Mountain View",
            "Ca 94040"
          ]
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T22:47:56.47760847Z"
        }
      }
    }
  ]
}
```

</blockquote></details>

---

#### The uppercase processor


```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": """
          ctx['city_name'] = ctx['city_array'].0;
          def split_statezip = ctx['city_array'].1.splitOnToken(' ');
          ctx['state'] = split_statezip[0];
          ctx['zip'] = split_statezip[1];
          """
      },
      "uppercase": {
        "field": "state"
      }
    }
  ]
}
```

<details><summary><i>Test pipeline</i></summary>

```json
POST /_ingest/pipeline/split-city-string-to-array/_simulate?pretty
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : "94040",
          "city_name" : "Mountain View",
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "state" : "CA",
          "city_array" : [
            "Mountain View",
            "Ca 94040"
          ]
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T22:51:47.367647523Z"
        }
      }
    }
  ]
}
```

</details>

<details><summary><i>curl:</i></summary><blockquote>

```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": """
          ctx['city_name'] = ctx['city_array'].0;
          def split_statezip = ctx['city_array'].1.splitOnToken(' ');
          ctx['state'] = split_statezip[0];
          ctx['zip'] = split_statezip[1];
          """
      },
      "uppercase": {
        "field": "state"
      }
    }
  ]
}'

curl -XPOST "localhost:9200/_ingest/pipeline/split-city-string-to-array/_simulate?pretty" -H 'Content-Type: application/json' -d'
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}'

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : "94040",
          "city_name" : "Mountain View",
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "state" : "CA",
          "city_array" : [
            "Mountain View",
            "Ca 94040"
          ]
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T22:51:47.367647523Z"
        }
      }
    }
  ]
}

```
  
</blockquote></details>

---

#### The convert processor

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": """
          ctx['city_name'] = ctx['city_array'].0;
          def split_statezip = ctx['city_array'].1.splitOnToken(' ');
          ctx['state'] = split_statezip[0];
          ctx['zip'] = split_statezip[1];
          """
      },
      "uppercase": {
        "field": "state"
      },
      "convert": {
        "field": "zip",
        "type": "long"
      }
    }
  ]
}
```

<details><summary><i>Test pipeline</i></summary>

```json
POST /_ingest/pipeline/split-city-string-to-array/_simulate?pretty
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : 94040,
          "city_name" : "Mountain View",
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "state" : "CA",
          "city_array" : [
            "Mountain View",
            "Ca 94040"
          ]
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T22:58:55.638881889Z"
        }
      }
    }
  ]
}
```

</details>

<details><summary><i>curl:</i></summary><blockquote>
  
  ```json
  
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": "\n          ctx['\''city_name'\''] = ctx['\''city_array'\''].0;\n          def split_statezip = ctx['\''city_array'\''].1.splitOnToken('\'' '\'');\n          ctx['\''state'\''] = split_statezip[0];\n          ctx['\''zip'\''] = split_statezip[1];\n          "
      },
      "uppercase": {
        "field": "state"
      },
      "convert": {
        "field": "zip",
        "type": "long"
      }
    }
  ]
}'
  
curl -XPOST "localhost:9200/_ingest/pipeline/split-city-string-to-array/_simulate?pretty" -H 'Content-Type: application/json' -d'
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}'

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : 94040,
          "city_name" : "Mountain View",
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View, Ca 94040",
          "company_name" : "Elastic EV",
          "state" : "CA",
          "city_array" : [
            "Mountain View",
            "Ca 94040"
          ]
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T22:58:55.638881889Z"
        }
      }
    }
  ]
}

  ```
  
</blockquote></details>

---

#### The remove processor

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": """
          ctx['city_name'] = ctx['city_array'].0;
          def split_statezip = ctx['city_array'].1.splitOnToken(' ');
          ctx['state'] = split_statezip[0];
          ctx['zip'] = split_statezip[1];
          """
      },
      "uppercase": {
        "field": "state"
      },
      "convert": {
        "field": "zip",
        "type": "long"
      },
      "remove": {
        "field": ["city_array", "city"]
      }
    }
  ]
}
```

<details><summary><i>Test pipeline</i></summary>

```json
POST /_ingest/pipeline/split-city-string-to-array/_simulate?pretty
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : 94040,
          "city_name" : "Mountain View",
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "company_name" : "Elastic EV",
          "state" : "CA"
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T23:03:09.817897742Z"
        }
      }
    }
  ]
}
```

</details>

<details><summary><i>curl:</i></summary><blockquote>
  
  ```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": "\n          ctx['\''city_name'\''] = ctx['\''city_array'\''].0;\n          def split_statezip = ctx['\''city_array'\''].1.splitOnToken('\'' '\'');\n          ctx['\''state'\''] = split_statezip[0];\n          ctx['\''zip'\''] = split_statezip[1];\n          "
      },
      "uppercase": {
        "field": "state"
      },
      "convert": {
        "field": "zip",
        "type": "long"
      },
      "remove": {
        "field": ["city_array", "city"]
      }
    }
  ]
}'

curl -XPOST "localhost:9200/_ingest/pipeline/split-city-string-to-array/_simulate?pretty" -H 'Content-Type: application/json' -d'
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}'

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : 94040,
          "city_name" : "Mountain View",
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "company_name" : "Elastic EV",
          "state" : "CA"
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T23:03:09.817897742Z"
        }
      }
    }
  ]
}
  
  ```
  
</blockquote></details>

---

#### The rename processor

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": """
          ctx['city_name'] = ctx['city_array'].0;
          def split_statezip = ctx['city_array'].1.splitOnToken(' ');
          ctx['state'] = split_statezip[0];
          ctx['zip'] = split_statezip[1];
          """
      },
      "uppercase": {
        "field": "state"
      },
      "convert": {
        "field": "zip",
        "type": "long"
      },
      "remove": {
        "field": ["city_array", "city"]
      },
      "rename": {
        "field": "city_name",
        "target_field": "city"
      }
    }
  ]
}
```

<details><summary><i>Test pipeline</i></summary>

```json
POST /_ingest/pipeline/split-city-string-to-array/_simulate?pretty
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}

Result:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : 94040,
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View",
          "company_name" : "Elastic EV",
          "state" : "CA"
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T23:06:54.390812156Z"
        }
      }
    }
  ]
}
```

</details>

<details><summary><i>curl:</i></summary><blockquote>
  
```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": "\n          ctx['\''city_name'\''] = ctx['\''city_array'\''].0;\n          def split_statezip = ctx['\''city_array'\''].1.splitOnToken('\'' '\'');\n          ctx['\''state'\''] = split_statezip[0];\n          ctx['\''zip'\''] = split_statezip[1];\n          "
      },
      "uppercase": {
        "field": "state"
      },
      "convert": {
        "field": "zip",
        "type": "long"
      },
      "remove": {
        "field": ["city_array", "city"]
      },
      "rename": {
        "field": "city_name",
        "target_field": "city"
      }
    }
  ]
}'

curl -XPOST "localhost:9200/_ingest/pipeline/split-city-string-to-array/_simulate?pretty" -H 'Content-Type: application/json' -d'
{
  "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "company_name": "Elastic EV",
        "address": "800 West El Camino Real, Suite 350",
        "city": "Mountain View, Ca 94040",
        "ticker_symbol": "ESTC",
        "market_cap": "8B",
        "city_array": [
          "Mountain View",
          " Ca 94040"
        ]
      }
    }
  ]
}'

Result:
  
{
  "docs" : [
    {
      "doc" : {
        "_index" : "index",
        "_type" : "_doc",
        "_id" : "id",
        "_source" : {
          "zip" : 94040,
          "address" : "800 West El Camino Real, Suite 350",
          "ticker_symbol" : "ESTC",
          "market_cap" : "8B",
          "city" : "Mountain View",
          "company_name" : "Elastic EV",
          "state" : "CA"
        },
        "_ingest" : {
          "_value" : null,
          "timestamp" : "2023-04-19T23:06:54.390812156Z"
        }
      }
    }
  ]
}
```

</blockquote></details>

---

#### The full pipeline

```json
PUT /_ingest/pipeline/split-city-string-to-array?pretty
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": """
          ctx['city_name'] = ctx['city_array'].0;
          def split_statezip = ctx['city_array'].1.splitOnToken(' ');
          ctx['state'] = split_statezip[0];
          ctx['zip'] = split_statezip[1];
          """
      },
      "uppercase": {
        "field": "state"
      },
      "convert": {
        "field": "zip",
        "type": "long"
      },
      "remove": {
        "field": ["city_array", "city"]
      },
      "rename": {
        "field": "city_name",
        "target_field": "city"
      }
    }
  ]
}
```

<details><summary><i>curl:</i></summary><blockquote>
  
```json
curl -XPUT "localhost:9200/_ingest/pipeline/split-city-string-to-array?pretty" -H 'Content-Type: application/json' -d'
{
  "description": "Changes incoming company data",
  "processors": [
    {
      "set": {
        "field": "city_array",
        "copy_from": "city",
        "override": false
      },
      "split": {
        "if": "ctx.city_array instanceof String",
        "ignore_failure": true,
        "field": "city_array",
        "separator": ","
      },
      "foreach": {
        "field": "city_array",
        "processor": {
          "gsub": {
            "field": "_ingest._value",
            "pattern": "^ ",
            "replacement": ""
          }
        }
      },
      "script": {
        "tag": "script",
        "ignore_failure": true,
        "source": "\n          ctx['\''city_name'\''] = ctx['\''city_array'\''].0;\n          def split_statezip = ctx['\''city_array'\''].1.splitOnToken('\'' '\'');\n          ctx['\''state'\''] = split_statezip[0];\n          ctx['\''zip'\''] = split_statezip[1];\n          "
      },
      "uppercase": {
        "field": "state"
      },
      "convert": {
        "field": "zip",
        "type": "long"
      },
      "remove": {
        "field": ["city_array", "city"]
      },
      "rename": {
        "field": "city_name",
        "target_field": "city"
      }
    }
  ]
}'
```
  
</blockquote></details>

---

#### The result

```json
POST /companies/_update_by_query?pretty&pipeline=split-city-string-to-array

GET /companies/_doc/1?pretty

Result:

{
  "_index" : "companies",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 2,
  "_seq_no" : 1,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "zip" : 94040,
    "address" : "800 West El Camino Real, Suite 350",
    "ticker_symbol" : "ESTC",
    "city" : "Mountain View",
    "market_cap" : "8B",
    "company_name" : "Elastic EV",
    "state" : "CA"
  }
}
```

<details><summary><i>curl:</i></summary><blockquote>

```json
curl -XPOST "http://singleElasticsearch:9200/companies/_update_by_query?pretty&pipeline=split-city-string-to-array"

curl -XGET "http://singleElasticsearch:9200/companies/_doc/1?pretty"

Result:

{
  "_index" : "companies",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 2,
  "_seq_no" : 1,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "zip" : 94040,
    "address" : "800 West El Camino Real, Suite 350",
    "ticker_symbol" : "ESTC",
    "city" : "Mountain View",
    "market_cap" : "8B",
    "company_name" : "Elastic EV",
    "state" : "CA"
  }
}
```
  
</blockquote></details>

---

#### Setting a pipeline as default for an index

Instead of defining the pipeline, every time we ingest data, the pipeline can be set as a default per index:

```json
PUT companies/_settings
{
  "index.default_pipeline": "split-city-string-to-array"
}
```

<details><summary><i>curl:</i></summary><blockquote>

```json
curl -XPUT "localhost:9200/companies/_settings" -H 'Content-Type: application/json' -d'
{
  "index.default_pipeline": "split-city-string-to-array"
}'
```

</blockquote></details>

