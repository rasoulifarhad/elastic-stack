echo
echo =================
echo "index the sample documents"
echo =================
for file in *.json; do
  echo -n $file
  curl -XPOST localhost:9200/videos/_doc/ -d "`cat $file`"
  echo
done

echo
echo =================
echo "get mapping"
echo =================
curl localhost:9200/videos/_mapping?pretty

echo
echo =================
echo "update mapping and reindex"
echo =================
curl -XDELETE localhost:9200/videos
curl -XPUT localhost:9200/videos -d '{
  "mappings": {
        "properties": {
            "id": {
                "type": "keyword",
                "copy_to": "_id"
            },
            "likes": {
                "type": "long"
            },
            "tags": {
                "type": "string",
                "index": "not_analyzed"
            },
            "title": {
                "type": "string"
            },
            "upload_date": {
                "type": "date",
                "format": "dateOptionalTime"
            },
            "uploaded_by": {
                "type": "string"
            },
            "url": {
                "type": "string"
            },
            "views": {
                "type": "long"
            }
        }
  }
}'
for file in *.json; do
  echo -n $file
  curl -XPOST localhost:9200/videos/_doc/ -d "`cat $file`"
  echo
done
curl -XPOST localhost:9200/videos/_refresh

echo
echo =================
echo "URI search"
echo =================
curl 'localhost:9200/videos/_search?q=elasticsearch&pretty'

curl 'localhost:9200/videos/_search?pretty' -d '{
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

curl 'localhost:9200/videos/_search?pretty' -d '{
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

echo
echo =================
echo "Aggregations"
echo =================
curl 'localhost:9200/videos/_search?pretty' -d '{
    "size": 0,
    "aggregations" : {
        "tags" : {
            "terms" : { "field" : "tags" }
        }
    }
}'

curl 'localhost:9200/videos/_search?pretty' -d '{
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

curl 'localhost:9200/videos/_search?pretty' -d '{
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

