### Ingest Pipelines

From [Ingest Pipelines](https://cdax.ch/2022/01/30/elastic-workshop-2-ingest-pipelines/)

#### Raw data

```json

"company_name": "Elastic EV", 
"address": "800 West El Camino Real, Suite 350", 
"city": "Mountain View, Ca 94040",
"ticker_symbol": "ESTC", 
"market_cap": "8B"

```

#### Create a pipeline with a set processor

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

<details>
  <summary>cURL</summary>
  
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

<details>
  <summary>cURL</summary>
  
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

#### Run _update_by_query

```json

POST companies/_update_by_query?pretty&pipeline=split-city-string-to-array
{
  "query": {
    "match_all": {}
  }
}

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

<details>
  <summary>cURL</summary>

```json

curl -XPOST "localhost:9200/companies/_update_by_query?pretty&pipeline=split-city-string-to-array" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_all": {}
  }
}'

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

#### Remove leading spaces with gsub processor

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

<details>
  <summary>cURL</summary>

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
