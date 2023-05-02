### Shakespeare Data 

The Shakespeare data set is organized in the following schema:

```

{
    "line_id": INT,
    "play_name": "String",
    "speech_number": INT,
    "line_number": "String",
    "speaker": "String",
    "text_entry": "String",
}

```

1. Create index

```json

PUT /shakespeare
{
  "mappings": {
    "properties": {
      "speaker": {
        "type": "keyword"
      },
      "play_name": {
        "type": "keyword"
      },
      "line_id": {
        "type": "integer"
      },
      "speech_number": {
        "type": "integer"
      }
    }
  }
}

```

2. Index Some data

```

curl -s -XPOST 'localhost:9200/shakespeare/_bulk?pretty' -H 'Content-Type: application/x-ndjson' --data-binary @shakespeare_7.0.json

```

3. Check Data

```json

GET /shakespeare/_count

GET /shakespeare/_search?size=1

GET /shakespeare/_search
{
  "query" : {
    "match_phrase" : {
      "text_entry" : "to be or not to be"
    }
  }
}

```
