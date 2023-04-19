### Enrich documents

#### Add docs

1. 

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

<details>
  <summary>cURL</summary>
  
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

#### Addd enrichment policy

2.

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

PUT /_enrich/policy/add_company_data_policy/_execute?pretty

GET /.enrich-add_company_data_policy?pretty

```

<details>
  <summary>cURL</summary>
  
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

curl -XPUT "localhost:9200/_enrich/policy/add_company_data_policy/_execute?pretty"

curl -XGET "localhost:9200/.enrich-add_company_data_policy?pretty"

```

</details>

#### Add a pipeline that uses the enrichment policy

3.

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


<details>
  <summary>cURL</summary>
  
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
