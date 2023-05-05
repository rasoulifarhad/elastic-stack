### Join field type

> See [Join field type](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/parent-join.html)
> 

The join data type is a special field that creates parent/child relation within documents of the same index. 

> 
> Defining a parent/child relation:
> 

>> 
>> `{"mappings":{"properties":{"my_id":{"type":"keyword"},"my_join_field":{"type":"join","relations":{"question":"answer"}}}}}`
>> 
>> ***`question`*** is parent of ***`answer`***
>>
 
>  
> For Index ***parent*** document with a join: 
> 
>> Name of the relation and the optional parent of the document must be provided in the `source`. 
>> 
>> ***Parent document*** (`question`) `{"my_id":"1","text":"This is a question","my_join_field":{"name":"question"}}`
>> 

>  
> For Index ***child*** document with a join: 
> 
>> The name of the relation as well as the parent id of the document must be added in the `_source.`
>> 
>> ***child document*** (`answer`) `PUT my-index/_doc/2?routing=1&refresh {"my_id":"2","text":"This is an answer","my_join_field":{"name":"answer","parent":"1"}}`
>>

***Note***:
> 
> Always route child documents using their greater parent id. they musb be in same shard.
>  

***Note***:
> 
> The parent-join creates one field to index the name of the relation within the document(`question`, `answer`). 
>  

***Note***:
> 
> It also creates one field per parent/child relation. The name of this field is the name of the join field followed by # and the name of the parent in the relation. 
>  
>> The name of this field is the name of the `join` field followed by `#` and the name of the parent in the relation(`my_join_field#question`).
>> 
>> This field contains the parent `_id` that the document links to if the document is a child (`answer`) and the `_id` of document if it’s a parent ('question').
>> 


<!--

- Index setup 

```json
PUT my-index-000012
{
  "mappings": {
    "properties": {
      "my_id": {
        "type": "keyword"
      },
      "my_join_field": {
        "type": "join",
        "relations": {
          "question": "answer"
        }
      }
    }
  }
}

- Index parent documents

```json
PUT my-index-000012/_doc/1?refresh
{
  "my_id": "1",
  "text": "This is a question",
  "my_join_field": {
    "name": "question"
  }
}

PUT my-index-000012/_doc/2?refresh
{
  "my_id": "2",
  "text": "This is another question",
  "my_join_field": {
    "name": "question"
  }
}

- OR

```json
PUT /my-index-000012/_doc/1?refresh
{
  "my_id": "1",
  "text": "This is a question",
  "my_join_field": "question"
}

PUT /my-index-000012/_doc/2?refresh
{
  "my_id": "2",
  "text": "This is another question",
  "my_join_field": "question"
}
```

- Index child documents

```json
PUT /my-index-000012/_doc/3?routing=1&refresh
{
  "my_id": "3",
  "text": "This is an answer",
  "my_join_field": {
    "name": "answer",
    "parent": "1"
  }
}

PUT /my-index-000012/_doc/4?routing=1&refresh
{
  "my_id": "4",
  "text": "This is another an answer",
  "my_join_field": {
    "name": "answer",
    "parent": "1"
  }
}
```

- Searching with parent-join

```json
GET /my-index-000012/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "my_id": {
        "order": "asc"
      }
    }
  ]
}

- Search childs with [***parent_id*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-parent-id-query.html)

```json
GET /my-index-000012/_search
{
  "query": {
    "parent_id": {
      "type": "answer",
      "id": 1
    }
  }
}
```

Response:

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
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 0.35667494,
    "hits" : [
      {
        "_index" : "my-index-000012",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 0.35667494,
        "_routing" : "1",
        "_source" : {
          "my_id" : "3",
          "text" : "This is an answer",
          "my_join_field" : {
            "name" : "answer",
            "parent" : "1"
          }
        }
      },
      {
        "_index" : "my-index-000012",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 0.35667494,
        "_routing" : "1",
        "_source" : {
          "my_id" : "4",
          "text" : "This is another an answer",
          "my_join_field" : {
            "name" : "answer",
            "parent" : "1"
          }
        }
      }
    ]
  }
}
```

- [***parent_id*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-parent-id-query.html)

```json
GET /my-index-000012/_search
{
  "size": 0, 
  "query": {
    "parent_id": {
      "type": "answer",
      "id": 1
    }
  },
  "aggs": {
    "parents": {
      "terms": {
        "field": "my_join_field#question",
        "size": 10
      }
    }
  }
}
```

Response:

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
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "parents" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "1",
          "doc_count" : 2
        }
      ]
    }
  }
}
```

- Count child of  parents

```json
GET /my-index-000012/_search
{
  "size": 0, 
  "aggs": {
    "parents": {
      "terms": {
        "field": "my_join_field#question",
        "size": 10
      }
    }
  }
}
```

Response:

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
      "value" : 4,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "parents" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "1",
          "doc_count" : 3
        },
        {
          "key" : "2",
          "doc_count" : 1
        }
      ]
    }
  }
}
```

- Runtime fields

```json
GET /my-index-000012/_search
{
  "query": {
    "parent_id": {
      "type": "answer",
      "id": 1
    }
  },
  "aggs": {
    "parents": {
      "terms": {
        "field": "my_join_field#question",
        "size": 10
      }
    }
  },
  "runtime_mappings": {
    "parent": {
      "type": "long",
      "script": """
        emit(Integer.parseInt(doc['my_join_field#question'].value))
      """
    }
  },
  "fields": [
    "parent"
  ]
}
```

Response:

```json
{
  "took" : 15,
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
    "max_score" : 0.35667494,
    "hits" : [
      {
        "_index" : "my-index-000012",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 0.35667494,
        "_routing" : "1",
        "_source" : {
          "my_id" : "3",
          "text" : "This is an answer",
          "my_join_field" : {
            "name" : "answer",
            "parent" : "1"
          }
        },
        "fields" : {
          "parent" : [
            1
          ]
        }
      },
      {
        "_index" : "my-index-000012",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 0.35667494,
        "_routing" : "1",
        "_source" : {
          "my_id" : "4",
          "text" : "This is another an answer",
          "my_join_field" : {
            "name" : "answer",
            "parent" : "1"
          }
        },
        "fields" : {
          "parent" : [
            1
          ]
        }
      }
    ]
  },
  "aggregations" : {
    "parents" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "1",
          "doc_count" : 2
        }
      ]
    }
  }
}
```
-->

<!--

Another example 

- Index setup

```json
PUT test
{
  "mappings": {
    "properties": {
      "my_join_field": {
        "type": "join",
        "relations": {
          "my_parent": "my_child"
        }
      }
    }
  }
}
```

- Index parent documents

```json
PUT test/_doc/1?refresh
{
  "number": 1,
  "my_join_field": "my_parent"
}
```

- Index child documents

```json
PUT test/_doc/2?routing=1&refresh
{
  "number": 1,
  "my_join_field": {
    "name": "my_child",
    "parent": "1"
  }
}
```

- Query

```json
POST test/_search
{
  "query": {
    "has_child": {
      "type": "my_child",
      "query": {
        "match": {
          "number": 1
        }
      },
      "inner_hits": {}    
    }
  }
}
```

- Response:

```json
{
  "took" : 23,
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
        "_index" : "test",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "number" : 1,
          "my_join_field" : "my_parent"
        },
        "inner_hits" : {
          "my_child" : {
            "hits" : {
              "total" : {
                "value" : 1,
                "relation" : "eq"
              },
              "max_score" : 1.0,
              "hits" : [
                {
                  "_index" : "test",
                  "_type" : "_doc",
                  "_id" : "2",
                  "_score" : 1.0,
                  "_routing" : "1",
                  "_source" : {
                    "number" : 1,
                    "my_join_field" : {
                      "name" : "my_child",
                      "parent" : "1"
                    }
                  }
                }
              ]
            }
          }
        }
      }
    ]
  }
}
```
-->

<!--

> ***Note***: The amount of heap used by global ordinals can be checked per parent relation as follows:
> 
>> # Per-index
>> GET _stats/fielddata?human&fields=my_join_field#question
>> 
>> # Per-node per-index
>> GET _nodes/stats/indices/fielddata?human&fields=my_join_field#question
>> 



-->
