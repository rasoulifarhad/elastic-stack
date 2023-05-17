### Tips

#### Search in ElasticSearch with where condition

```json

{
  "query": {
    "bool": {
      "must": [
        {
          "match_all": {}
        }
      ],
      "filter": {
        "script": {
          "script": "doc['costprice'].value - doc['sellingprice'].value > 0"
        }
      }
    }
  }
}

```

#### Search (COUNT*) with group by and where condition

```json

{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "date": {
              "gt": "2016-08-22T00:00:00.000Z",
              "lt": "2016-08-22T13:41:09.000Z"
            }
          }
        },
        {
          "term": {
            "service": "http"
          }
        },
        {
          "term": {
            "destination": "10.17.102.1"
          }
        }
      ]
    }
  },
  "aggs": {
    "group_by_ip": {
      "terms": {
        "field": "ip"
      }
    }
  }
}

```

#### Elasticsearch GROUP BY column HAVING COUNT(*)

Use SQl translate query of kibana:

```json

POST /_sql/translate
{
  "query": """
    SELECT 
      * 
    FROM 
      IndexName 
    WHERE 
      id=1 
  """,
"fetch_size": 10
}

```

