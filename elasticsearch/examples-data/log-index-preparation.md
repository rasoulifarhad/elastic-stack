### logs Data 

The schema for the logs data set has dozens of different fields, but the notable ones used in this tutorial are:

```json
{
    "memory": INT,
    "geo.coordinates": "geo_point"
    "@timestamp": "date"
}

```

1. Create index

```json

PUT /logs
{
  "mappings": {
    "properties": {
      "memory": {
        "type": "integer"
      },
      "geo": {
        "properties": {
          "coordinates": {
            "type": "geo_point"
          }
        }
      }
    }
  }
}

```

2. Index Some data

```

curl -s -XPOST 'localhost:9200/logs/_bulk?pretty' -H 'Content-Type: application/x-ndjson' --data-binary @logs.jsonl

```

3. Check Data

```json

GET /person/_count

GET /logs/_search?size=1

```
