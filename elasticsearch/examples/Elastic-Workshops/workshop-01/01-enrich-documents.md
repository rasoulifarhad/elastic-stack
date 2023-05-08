### Enrich documents

From [ElasticWorkshop](https://github.com/PascalThalmann/ElasticWorkshop/tree/gh-pages/1_enrich_documents)

The enrich processor adds new data to incoming documents and requires a few special components:

![enrich process](enrich-process.svg)

#### Create source index

Use the [create index API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) or [index API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html) to create a source index.

<details open><summary><i>Define index</i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST _bulk?pretty
{"index":{"_index":"companies","_id":"1"}}
{"company_name":"Elastic EV","address":"800 West El Camino Real, Suite 350","city":"Mountain View, CA 94040","ticker_symbol":"ESTC","market_cap":"8B"}
{"create":{"_index":"companies","_id":"2"}}
{"company_name":"Mongo DB, Inc","address":"1633 Broadway, 38th Floor","city":"New York, NY 10019","ticker_symbol":"MDB","market_cap":"23B"}
{"create":{"_index":"companies","_id":"3"}}
{"company_name":"Splunk Inc","address":"270 Brannan Street","city":"San Francisco, CA 94107","ticker_symbol":"SPLK","market_cap":"18B"}

GET /companies/_search?pretty

PUT /stocks/_doc/1?pretty
{
  "ticker": "ESTC",
  "last_trade": 82.5
}

PUT /stocks/_doc/2?pretty
{
  "ticker": "MDB",
  "last_trade": 365
}
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XPOST "localhost:9200/_bulk?pretty" -H 'Content-Type: application/json' -d'
{"index":{"_index":"companies","_id":"1"}}
{"company_name":"Elastic EV","address":"800 West El Camino Real, Suite 350","city":"Mountain View, CA 94040","ticker_symbol":"ESTC","market_cap":"8B"}
{"create":{"_index":"companies","_id":"2"}}
{"company_name":"Mongo DB, Inc","address":"1633 Broadway, 38th Floor","city":"New York, NY 10019","ticker_symbol":"MDB","market_cap":"23B"}
{"create":{"_index":"companies","_id":"3"}}
{"company_name":"Splunk Inc","address":"270 Brannan Street","city":"San Francisco, CA 94107","ticker_symbol":"SPLK","market_cap":"18B"}
'
curl -XGET "localhost:9200/companies/_search?pretty"

curl -XPUT "localhost:9200/stocks/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "ticker": "ESTC",
  "last_trade": 82.5
}'

curl -XPUT "localhost:9200/stocks/_doc/2?pretty" -H 'Content-Type: application/json' -d'
{
  "ticker": "MDB",
  "last_trade": 365
}'
```
  
</details>

</blockquote></details>

#### Create an enrich policy 

***Use the [create enrich policy API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/put-enrich-policy-api.html) to create a enrich policy.***


<details open><summary><i>define enrich policy</i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
PUT /_enrich/policy/add_company_data_policy?pretty
{
  "match": {
    "indices": "companies",
    "match_field": "ticker_symbol",
    "enrich_fields": [
      "company_name",
      "address",
      "city",
      "market_cap"
    ]
  }
}
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XPUT "localhost:9200/_enrich/policy/add_company_data_policy?pretty" -H 'Content-Type: application/json' -d'
{
  "match": {
    "indices": "companies",
    "match_field": "ticker_symbol",
    "enrich_fields": [
      "company_name",
      "address",
      "city",
      "market_cap"
    ]
  }
}'
```

</details>

</blockquote></details>


#### Execute enrich policy 

***Use the [execute enrich policy API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/execute-enrich-policy-api.html) to create the enrich index for the policy.***

> ***Note:***
>> Once created, you cannot update or index documents to an enrich index. Instead, update your source indices and execute the enrich policy again. 

>> Use the delete enrich policy API to delete an existing enrich policy and its enrich index.

<details open><summary><i>execute enrich policy</i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
PUT /_enrich/policy/add_company_data_policy/_execute?pretty
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XPUT "localhost:9200/_enrich/policy/add_company_data_policy/_execute?pretty"
```

</details>

</blockquote></details>

#### Chech enrich index

***The enrich index contains documents from the policy’s source indices. Enrich indices always begin with .enrich-*, are read-only, and are force merged.***

<details open><summary><i>enrich index</i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
GET /.enrich-add_company_data_policy?pretty
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XGET "localhost:9200/.enrich-add_company_data_policy?pretty"
```

</details>

</blockquote></details>

#### Enrich stats API

> `GET /_enrich/_stats`


#### Add a pipeline that uses the enrichment policy

***Use the create or update pipeline API to create an ingest pipeline.***

<details><summary><i>Recap</i></summary><blockquote>

> ***In the pipeline, add an enrich processor that includes:***

>> Your enrich policy.  

>> The field of incoming documents used to match documents from the enrich index.  

>> The target_field used to store appended enrich data for incoming documents. This field contains the match_field and enrich_fields specified in your enrich policy.  

</blockquote></details>


<details open><summary><i>define pipeline</i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
PUT /_ingest/pipeline/enrich_stock_data?pretty
{
  "processors": [
    {
      "set": {
        "field": "enriched",
        "value": 1
      }
    },
    {
      "enrich": {
        "policy_name": "add_company_data_policy",
        "field": "ticker",
        "target_field": "company"
      }
    }
  ]
}
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XPUT "localhost:9200/_ingest/pipeline/enrich_stock_data?pretty" -H 'Content-Type: application/json' -d'
{
  "processors": [
    {
      "set": {
        "field": "enriched",
        "value": 1
      }
    },
    {
      "enrich": {
        "policy_name": "add_company_data_policy",
        "field": "ticker",
        "target_field": "company"
      }
    }
  ]
}'
```

</details>

</blockquote></details>

#### Enrich existing documents

***Use reindex API with pipeline to index enriched data into another index .***

<details open><summary><i>enrich</i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /_reindex?pretty
{
  "source": {
    "index": "stocks"
  },
  "dest": {
    "index": "full_stock_data",
    "pipeline": "enrich_stock_data"
  }
}

GET /full_stock_data/_search?pretty
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XPOST "localhost:9200/_reindex?pretty" -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "stocks"
  },
  "dest": {
    "index": "full_stock_data",
    "pipeline": "enrich_stock_data"
  }
}'

curl -XGET "localhost:9200/full_stock_data/_search?pretty"
```

</details>

</blockquote></details>

#### Enrich incoming data

***Use the ingest pipeline to index a document.***

> The incoming document should include the field specified in your enrich processor.


<details open><summary><i>enrich</i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
PUT /full_stock_data/_doc/3?pretty&pipeline=enrich_stock_data
{
  "ticker": "SPLK",
  "last_trade": 113
}

GET /full_stock_data/_doc/3?pretty

PUT /full_stock_data/_settings?pretty
{
  "index.default_pipeline": "enrich_stock_data"
}

PUT /companies/_doc/4?pretty
{
  "company_name": "Datadog, Inc.",
  "address": "620 8th Avenue, 45th Floor",
  "city": "New York, NY 10018",
  "ticker_symbol": "DDOG",
  "market_cap": "40B"
}

PUT /_enrich/policy/add_company_data_policy/_execute?pretty

POST /full_stock_data/_doc/4?pretty
{
  "ticker": "DDOG",
  "last_trade": 113
}

GET /full_stock_data/_doc/4?pretty

{
  "_index" : "full_stock_data",
  "_type" : "_doc",
  "_id" : "4",
  "_version" : 4,
  "_seq_no" : 13,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "ticker" : "DDOG",
    "last_trade" : 113,
    "enriched" : 1,
    "company" : {
      "address" : "620 8th Avenue, 45th Floor",
      "ticker_symbol" : "DDOG",
      "market_cap" : "40B",
      "city" : "New York, NY 10018",
      "company_name" : "Datadog, Inc."
    }
  }
}
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XPUT "localhost:9200/full_stock_data/_doc/3?pretty&pipeline=enrich_stock_data" -H 'Content-Type: application/json' -d'
{
  "ticker": "SPLK",
  "last_trade": 113
}'

curl -XGET "localhost:9200/full_stock_data/_doc/3?pretty"

curl -XPUT "localhost:9200/full_stock_data/_settings?pretty" -H 'Content-Type: application/json' -d'
{
  "index.default_pipeline": "enrich_stock_data"
}'

curl -XPUT "localhost:9200/companies/_doc/4?pretty" -H 'Content-Type: application/json' -d'
{
  "company_name": "Datadog, Inc.",
  "address": "620 8th Avenue, 45th Floor",
  "city": "New York, NY 10018",
  "ticker_symbol": "DDOG",
  "market_cap": "40B"
}'

curl -XPUT "localhost:9200/_enrich/policy/add_company_data_policy/_execute?pretty"

curl -XPOST "localhost:9200/full_stock_data/_doc/4?pretty" -H 'Content-Type: application/json' -d'
{
  "ticker": "DDOG",
  "last_trade": 113
}'

curl -XGET "localhost:9200/full_stock_data/_doc/4?pretty"

{
  "_index" : "full_stock_data",
  "_type" : "_doc",
  "_id" : "4",
  "_version" : 4,
  "_seq_no" : 13,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "ticker" : "DDOG",
    "last_trade" : 113,
    "enriched" : 1,
    "company" : {
      "address" : "620 8th Avenue, 45th Floor",
      "ticker_symbol" : "DDOG",
      "market_cap" : "40B",
      "city" : "New York, NY 10018",
      "company_name" : "Datadog, Inc."
    }
  }
}
```

</details>

</blockquote></details>

#### Fix documents that could not be enriched by the last run


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
PUT /_enrich/policy/add_company_data_policy/_execute?pretty

GET /.enrich-add_company_data_policy?pretty

POST full_stock_data/_update_by_query?pretty
{
  "query": {
    "bool": {
      "must_not": [
        {
          "exists": {
            "field": "company"
          }
        }
      ]
    }
  }
}
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XPUT "localhost:9200/_enrich/policy/add_company_data_policy/_execute?pretty"

curl -XGET "localhost:9200/.enrich-add_company_data_policy?pretty"

curl -XPOST "localhost:9200/full_stock_data/_update_by_query?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must_not": [
        {
          "exists": {
            "field": "company"
          }
        }
      ]
    }
  }
}'
```

</details>

</blockquote></details>


#### Final

<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
GET _cat/indices/.enrich-add_company_data_policy*,companies,full_stock_data?s=i&v&h=idx,storeSize&pretty

DELETE /companies?pretty

DELETE /stocks?pretty

DELETE /full_stock_data?pretty
```

</details>

<details><summary><i>curl</i></summary>

```json
curl -XGET "localhost:9200/_cat/indices/.enrich-add_company_data_policy*,companies,full_stock_data?s=i&v&h=idx,storeSize&pretty"

curl -XDELETE "localhost:9200/companies?pretty"

curl -XDELETE "localhost:9200/stocks?pretty"

curl -XDELETE "localhost:9200/full_stock_data?pretty"
```

</details>

</blockquote></details>


