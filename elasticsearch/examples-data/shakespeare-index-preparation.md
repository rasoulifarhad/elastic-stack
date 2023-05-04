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

OR :

```json

PUT /shakespeare

```

OR:

```json

{
  "mappings": {
    "properties": {
      "line_id": {
        "type": "long"
      },
      "line_number": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "play_name": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "speaker": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "speech_number": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "text_entry": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "type": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      }
    }
  }
}

```
2. Index Some data

```

curl -s -XPOST 'localhost:9200/shakespeare/_bulk?pretty' -H 'Content-Type: application/x-ndjson' --data-binary @shakespeare_7.0.json

curl -s -XPOST 'localhost:9200/shakespeare/_bulk?pretty' -H 'Content-Type: application/x-ndjson' -u elastic:changeme --data-binary @shakespeare_7.0.json

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

GET /shakespeare/_search?size=1000
{
  "query": {
    "match_all": {}
  }
}

GET /shakespeare/_search
{
  "query": {
    "match": {
      "play_name": "Antony"
    }
  }
}

GET /shakespeare/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "play_name": "Antony"
          }
        },
        {
          "match": {
            "speaker": "Demetrius"
          }
        }
      ]
    }
  }
}

GET /shakespeare/_search
{
  "size": 0, 
  "aggs": {
    "Totall plays": {
      "cardinality": {
        "field": "play_name.keyword"
      }
    }
  }
}

GET /shakespeare/_search
{
  "size": 0, 
  "aggs": {
    "Popular plays": {
      "terms": {
        "field": "play_name.keyword"
      }
    }
  }
}

GET /shakespeare/_search
{
  "size": 0, 
  "aggs": {
    "Popular plays": {
      "terms": {
        "field": "play_name.keyword"
      },
      "aggs": {
        "Per type": {
          "terms": {
            "field": "type.keyword"
          }
        }
      }
    }
  }
}

```
