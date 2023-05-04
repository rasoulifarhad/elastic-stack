### Ingest Pipelines

from [elastic-workshop](https://github.com/jsanz/elastic-workshop)

#### Steps

Source document :

```json

{
  "content": "\"coords\":[75.9570722,30.8503599],\"name\":\"Sahnewal\",\"abbrev\":\"LUH\",\"type\":\"small\""
}

```

Buid a pipeline which transforms it to:

```json

{
  "abbrev": "LUH",
  "name": "Sahnewal",
  "type": "small",
  "coords": [75.9570722,30.8503599]
}

```

#### Create ingest pipeline

1. Create target index mapping

```json

curl -s -XPUT "localhost:9200/airports" -u elastic:$ELASTIC_PASSWORD  -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_replicas": 0,  
    "number_of_shards": 1
  },
  "mappings": {
    "properties": {
      "abbrev": {
        "type": "keyword"
      },
      "coords": {
        "type": "geo_point"
      },
      "name": {
        "type": "text"
      },
      "type": {
        "type": "keyword"
      }
    }
  }
}'

PUT /airports
{
  "settings": {
    "number_of_replicas": 0,  
    "number_of_shards": 1
  },
  "mappings": {
    "properties": {
      "abbrev": {
        "type": "keyword"
      },
      "coords": {
        "type": "geo_point"
      },
      "name": {
        "type": "text"
      },
      "type": {
        "type": "keyword"
      }
    }
  }
}`

```
2. Bulk insert `dataset/airports-bulk.ndjson

```json

curl -XPOST "localhost:9200/airports/_bulk" -s -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/x-ndjson' --data-binary "@dataset/airports-bulk.ndjson" | jq '{took: .took, errors: .errors}' ; echo


