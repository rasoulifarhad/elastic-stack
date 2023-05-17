#### Index the sample documents

```markdown
curl -s -XPOST "localhost:9200/videos/_bulk?pretty" -H 'Content-Type: application/x-ndjson' --data-binary "@es_bulk_videos.json"; echo;
# curl -s -XPOST "localhost:9200/videosearch/_bulk?pretty" -H 'Content-Type: application/x-ndjson' --data-binary "@es_bulk_videosearch_2014.json"; echo;
```

#### Get mapping

```markdown
curl "localhost:9200/videos/_mapping?pretty"
```

#### Update mapping and reindex

```markdown
curl -XDELETE "localhost:9200/videos?pretty"
curl -XPUT "http://localhost:9200/videos?pretty" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "properties": {
      "id": {
        "type": "keyword"
      },
      "likes": {
        "type": "long"
      },
      "tags": {
        "type": "keyword"
      },
      "title": {
        "type": "text"
      },
      "upload_date": {
        "type": "date",
        "format": "dateOptionalTime"
      },
      "uploaded_by": {
        "type": "keyword"
      },
      "url": {
        "type": "text"
      },
      "views": {
        "type": "long"
      }
    }
  }
}'
```

#### Create pipeline

```markdown
curl -XPUT "localhost:9200/_ingest/pipeline/my-pipeline?pretty" -H 'Content-Type: application/json' -d'
{
  "processors": [
    {
      "set": {
        "description": "Set '_id' to 'id' value",
        "field": "_id",
        "value": "{{{id}}}"
      }
    }
  ]
}'
```

#### Index the sample documents

```markdown
curl -s  -XPOST "localhost:9200/videos/_bulk?pretty&pipeline=my-pipeline" -H 'Content-Type: application/x-ndjson'  --data-binary "@es_bulk_videos.json"; echo;
curl -XPOST "localhost:9200/videos/_refresh?pretty"
```

#### Search

```markdown
curl -XGET "localhost:9200/videos/_search?q=elasticsearch&pretty"
```

```markdown
curl -XGET "localhost:9200/videos/_search?pretty"  -H 'Content-Type: application/json' -d'
{
    "query": {
        "bool": {
            "should": [
                {
                    "match": {
                        "title": "elasticsearch"
                    }
                },
                {
                    "term": {
                        "tags": "logs"
                    }
                }
            ]
        }
    }
}'
```

```markdown
curl -XGET "localhost:9200/videos/_search?pretty"  -H 'Content-Type: application/json' -d'
{
    "query": {
        "function_score": {
            "query": {
                "match": {
                    "title": "elasticsearch"
                }
            },
            "functions": [
                {
                    "exp": {
                        "upload_date": {
                            "origin": "now",
                            "scale": "500d",
                            "offset": "60d",
                            "decay": 0.1
                        }
                    }
                }
            ]
        }
    }
}'
```

```markdown
curl localhost:9200/videos/_search?pretty -d '{
  "query": {
    "multi_match": {
      "query": "elasticsearch solr",
      "fields": ["tags^5", "uploaded_by^3", "title"],
      "tie_breaker": 0.3
    }
  },
  "fields": "title"
}'
```

#### Aggregations

```markdown
curl -XGET "localhost:9200/videos/_search?pretty"  -H 'Content-Type: application/json' -d'
{
    "size": 0,
    "aggregations" : {
        "tags" : {
            "terms" : { "field" : "tags" }
        }
    }
}'
```

```markdown
curl -XGET "localhost:9200/videos/_search?pretty"  -H 'Content-Type: application/json' -d'
{
    "size": 0,
    "aggregations": {
        "uploader_count": {
            "cardinality": {
                "field": "uploaded_by",
                "precision_threshold": 100
            }
        }
    }
}'
```

```markdown
curl -XGET "localhost:9200/videos/_search?pretty"  -H 'Content-Type: application/json' -d'
{
    "size": 0,
    "aggregations" : {
        "tags" : {
            "terms" : { "field" : "tags" },
            "aggregations": {
                "dates": {
                    "date_histogram": {
                        "field": "upload_date",
                        "interval": "month",
                        "format" : "yyyy-MM"
                    }
                }
            }
        }
    }
}'
```
