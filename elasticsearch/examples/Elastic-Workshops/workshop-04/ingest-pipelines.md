### Ingest Pipelines

from [elastic-workshop](https://github.com/jsanz/elastic-workshop)

#### Dataset?

The [Natural Earth Airports](https://www.naturalearthdata.com/downloads/10m-cultural-vectors/airports/) dataset is `airports-bulk.ndjson`

#### Goal

> **Buid a pipeline which transforms ___Source Document___ to ___target Document___**


<details open><summary><i>Source Document:</i></summary>

```json
{
  "content": "\"coords\":[75.9570722,30.8503599],\"name\":\"Sahnewal\",\"abbrev\":\"LUH\",\"type\":\"small\""
}
```

</details>



<details open><summary><i>Target Document:</i></summary>

```json
{
  "abbrev": "LUH",
  "name": "Sahnewal",
  "type": "small",
  "coords": [75.9570722,30.8503599]
}
```

</details>

#### Create ingest pipeline

***1. Create target index mapping***


<details open><summary><i>create mapping</i></summary><blockquote>

```json
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
}
```

<details><summary><i>curl</i></summary>

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
```

</details>

</blockquote></details>


***2. Bulk insert `dataset/airports-bulk.ndjson`***

```
curl -XPOST "localhost:9200/airports/_bulk" \
  -s -u elastic:$ELASTIC_PASSWORD \
  -H 'Content-Type: application/x-ndjson' \
  --data-binary "@dataset/airports-bulk.ndjson" \
  | jq '{took: .took, errors: .errors}' ; echo
```

