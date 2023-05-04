### Joining queries

> See [Joining queries](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/joining-queries.html#joining-queries)
> 

Elasticsearch offers two forms of join:

> 
> [***nested*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-nested-query.html)
> 
>> 
>> Documents may contain fields of type [nested](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/nested.html). These fields are used to index arrays of objects.
>> 
>> Each object can be queried (with the nested query) as an independent document.
>> 
>> ***Index setup*** `{"mappings":{"properties":{"obj1":{"type":"nested"}}}}`
>> 
>> ***Example query*** `{"query":{"nested":{"path":"obj1","query":{"bool":{"must":[{"match":{"obj1.name":"blue"}}]}}}}}	`
>> 
>
> [***has_child***](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-has-child-query.html) **and** [***has_parent***](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-has-parent-query.html) **queries**
> 
>> 
>> A [***join*** field relationship](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/parent-join.html) can exist between documents within a single index. You can create parent-child relationships between documents in the same index using a join field mapping.
>> 
>> 
>> - The `has_child` query returns parent documents whose child documents match the specified query,
>> 
>> ***Index setup*** `{"mappings":{"properties":{"my-join-field":{"type":"join","relations":{"parent":"child"}}}}}`
>> 
>> ***Example query*** `{"query":{"has_child":{"type":"child","query":{"match_all":{}},"max_children":10,"min_children":2,"score_mode":"min"}}}`
>>
>> - The `has_parent` query returns child documents whose parent document matches the specified query.
>> 
>> ***Index setup*** `{"mappings":{"properties":{"my-join-field":{"type":"join","relations":{"parent":"child"}},"tag":{"type":"keyword"}}}}`
>> 
>> ***Example query*** `{"query":{"has_parent":{"parent_type":"parent","query":{"term":{"tag":{"value":"Elasticsearch"}}}}}}`
>> 

> 
> See the [terms-lookup mechanism](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-terms-query.html#query-dsl-terms-lookup) in the terms query, which allows you to build a terms query from values contained in another document.
> 


<!--

The nested query searches nested field objects as if they were indexed as separate documents. If an object matches the search, the nested query returns the root parent document.

- Index setup(Nested)

```json
PUT my-index-000010
{
  "mappings": {
    "properties": {
      "obj1": {
        "type": "nested"
      }
    }
  }
}

POST /my-index-000010/_doc
{
  "test": "TEST 1",
  "obj1":  [
    {
      "name": "blue",
      "count": 10
    },
    {
      "name": "red",
      "count": 12
    },
    {
      "name": "gren",
      "count": 2
    }
  ]
}

POST /my-index-000010/_doc
{
  "test": "TEST 2",
  "obj1":  [
    {
      "name": "blue",
      "count": 4
    },
    {
      "name": "red",
      "count": 22
    },
    {
      "name": "gren",
      "count": 10
    }
  ]
}
```

- Query

```json
GET /my-index-000010/_search
{
  "query": {
    "nested": {
      "path": "obj1",
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "obj1.name": "blue"
              }
            },
            {
              "range": {
                "obj1.count": {
                  "gt": 5
                }
              }
            }
          ]
        }
      },
      "score_mode": "avg"
    }
  }
}
```

- Response

```json
{
  "took" : 1,
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
    "max_score" : 2.0296195,
    "hits" : [
      {
        "_index" : "my-index-000010",
        "_type" : "_doc",
        "_id" : "k5lM6IcBxfuUhEIK7V-z",
        "_score" : 2.0296195,
        "_source" : {
          "test" : "TEST 1",
          "obj1" : [
            {
              "name" : "blue",
              "count" : 10
            },
            {
              "name" : "red",
              "count" : 12
            },
            {
              "name" : "gren",
              "count" : 2
            }
          ]
        }
      }
    ]
  }
}
```

-->

<!--

- Index setup(Nested)

```json
PUT my-index-000011
{
  "mappings": {
    "properties": {
      "comments": {
        "type": "nested"
      }
    }
  }
}

PUT /my-index-000011/_doc/1
{
  "comments": [
    {
      "author": "kimchy"
    }
  ]
}

PUT /my-index-000011/_doc/2
{
  "comments": [
    {
      "author": "kimchy"
    },
    {
      "author": "nik9000"
    }
  ]
}

PUT /my-index-000011/_doc/3
{
  "comments": [
    {
      "author": "nik9000"
    }
  ]
}
```

- Query

```json
GET /my-index-000011/_search
{
  "query": {
    "nested": {
      "path": "comments",
      "query": {
        "bool": {
          "must_not": [
            {
              "term": {
                "comments.author": {
                  "value": "nik9000"
                }
              }
            }
          ]
        }
      }
    }
  }
}

Response: 

{
  "took" : 730,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 0.0,
    "hits" : [
      {
        "_index" : "my-index-000011",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.0,
        "_source" : {
          "comments" : [
            {
              "author" : "kimchy"
            }
          ]
        }
      },
      {
        "_index" : "my-index-000011",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 0.0,
        "_source" : {
          "comments" : [
            {
              "author" : "kimchy"
            },
            {
              "author" : "nik9000"
            }
          ]
        }
      }
    ]
  }
}
```

- Query(for excluding doc#2)

```json
GET /my-index-000011/_search
{
  "query": {
    "bool": {
      "must_not": [
        {
          "nested": {
            "path": "comments",
            "query": {
              "term": {
                "comments.author": {
                  "value": "nik9000"
                }
              }
            }
          }
        }
      ]
    }
  }
}


Response:

{
  "took" : 1,
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
    "max_score" : 0.0,
    "hits" : [
      {
        "_index" : "my-index-000011",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.0,
        "_source" : {
          "comments" : [
            {
              "author" : "kimchy"
            }
          ]
        }
      }
    ]
  }
}
```

-->
