### You index and search a wildcard field as follows

**Create mappings**:

```.json

DELETE /my-index-000001

PUT my-index-000001
{
  "mappings": {
    "properties": {
      "my_wildcard": {
        "type": "wildcard"
      }
    }
  }
}

```

**Index doc**:

```json

PUT my-index-000001/_doc/1
{
  "my_wildcard" : "This string can be quite lengthy"
}

```

**Search wildcard**:

```json

GET my-index-000001/_search
{
  "query": {
    "wildcard": {
      "my_wildcard": {
        "value": "*quite*lengthy"
      }
    }
  }
}

Response:

```json

{
  "took" : 4,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "my-index-000001",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "my_wildcard" : "This string can be quite lengthy"
        }
      }
    ]
  }
}

```

**Clean**:

``` json

DELETE /my-index-000001

```


