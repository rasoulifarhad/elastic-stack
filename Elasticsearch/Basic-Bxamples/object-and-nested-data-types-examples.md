### Object and Nested Data Types

From [Elasticsearch: Object and Nested Data Types](https://dev.to/rivelles/elasticsearch-object-and-nested-data-types-11oe)

Mapping basically defines the structure of documents and it is also used to configure how values will be indexed within Elasticsearch.


Elasticsearch doesn't require us to create a mapping for our indices, because it works using dynamic mapping. So, it will infer our data types based on what we are inserting in our document.

Since mapping is quite flexible, we can also combine explicit mapping with dynamic mapping. So, we can create an index with explicit data types and, when we add documents, they may have new fields and Elasticsearch will store them according to their types.

1. Run Elasticsearch And Kibana

```markdown
docker compose up -d
docker compose logs --follow
```

#### The object data type'

The object data type represents how Elasticsearch stores its JSON values, basically every document is an object, and we can have nested objects.

2. Define index 

```markdown
PUT users
{
  "mappings": {
    "properties": {
      "name": {"type": "text"},
      "birthday": {"type": "date"},
      "address": {
        "properties": {
          "country": {"type": "text"},
          "zipCode": {"type": "text"}
        }
      }
    }
  }
}
```
3. Examin mappings

```markdown
GET users/_mapping?pretty"
```

Result:

```markdown
{
  "users" : {
    "mappings" : {
      "properties" : {
        "address" : {
          "properties" : {
            "country" : {
              "type" : "text"
            },
            "zipCode" : {
              "type" : "text"
            }
          }
        },
        "birthday" : {
          "type" : "date"
        },
        "name" : {
          "type" : "text"
        }
      }
    }
  }
}
```

4. Index Data

```markdown
PUT users/_doc/1
{
  "name": "Lucas",
  "birthday": "1990-09-28",
  "address": {
    "country": "Brazil",
    "zipCode": "04896060"
  }
}
```

Results:

```markdown
{
  "_index" : "users",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}
```
#### How arrays of objects are flattened

Elasticsearch has no concept of inner objects. Therefore, it flattens object hierarchies into a simple list of field names and values. 

5. Index array of address

```markdown
PUT users/_doc/2
{
  "name": "farhad",
  "birthday": "1992-10-01",
  "address": [
    {
      "country": "Iran",
      "zipCode": "2222222"
    },
    {
      "country": "Usa",
      "zipCode": "4444444"
    }
  ]
}
```
In this case, Elasticsearch would then store our fields like an array of countries and an array of zipCodes. document would be transformed internally into a document that looks more like this:

```markdown
{
  "name": "farhad",
  "birthday": "1992-10-01",
  "address.country": [ "Iran", "Usa" ],
  "address.zipCode": [ "2222222", "4444444" ],
}
```
**address.country** and **address.zipCode** fields are flattened into multi-value fields, and the association between **Iran** country and **2222222** zipCode is lost.

Example:

6. we indexed a document representing an article that contains 2 reviews from 2 different users. 

```markdown
PUT articles/_doc/1
{
  "name": "Elasticsearch article",
  "reviews": [
    {
      "name": "Lucas",
      "rating": 5
    },
    {
      "name": "Eduardo",
      "rating": 3
    }
  ]
}
```
Document would be transformed internally into a document that looks more like this:

```markdown
{
  "name": "Elasticsearch article",
  "reviews.name": [ "Lucas", "Eduardo"],
  "reviews.rating": [5, 3],
}
```

**reviews.name** and **reviews.rating** fields are flattened into multi-value fields, and the association between **Eduardo**  and **3** is lost.

7. get articles reviewed by Eduardo with rating greater than 4

```markdown
GET articles/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "reviews.name": "Eduardo"
          }
        },
        {
          "range": {
            "reviews.rating": {
              "gt": 4
            }
          }
        }
      ]
    }
  }
}
```
Result:

```markdown
{
  "took" : 5,
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
    "max_score" : 1.287682,
    "hits" : [
      {
        "_index" : "articles",
        "_type" : "_doc",
        "_id" : "BQbHg4cBL2gLFYPzCkVw",
        "_score" : 1.287682,
        "_source" : {
          "name" : "Elasticsearch article",
          "reviews" : [
            {
              "name" : "Lucas",
              "rating" : 5
            },
            {
              "name" : "Eduardo",
              "rating" : 3
            }
          ]
        }
      }
    ]
  }
}
```

**This is not exactly what we are looking for.**

Basically, since Elasticsearch flattened our document, it can't query based on these filter because they are not **related**. 

8. Index data

```markdown
PUT my-index-000001/_doc/1
{
  "group" : "fans",
  "user" : [ 
    {
      "first" : "John",
      "last" :  "Smith"
    },
    {
      "first" : "Alice",
      "last" :  "White"
    }
  ]
}
```
Document would be transformed internally into a document that looks more like this:
```markdown
{
  "group" :        "fans",
  "user.first" : [ "alice", "john" ],
  "user.last" :  [ "smith", "white" ]
}
```

The **user.first** and **user.last** fields are flattened into multi-value fields, and the association between **alice** and **white** is lost. 

9. query for alice AND smith

```markdown
GET my-index-000001/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "user.first": "alice"
          }
        },
        {
          "match": {
            "user.last": "Smith"
          }
        }
      ]
    }
  }
}
```

Result:

```markdown
{
  "took" : 2,
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
    "max_score" : 0.5753642,
    "hits" : [
      {
        "_index" : "my-index-000001",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.5753642,
        "_source" : {
          "group" : "fans",
          "user" : [
            {
              "first" : "John",
              "last" : "Smith"
            },
            {
              "first" : "Alice",
              "last" : "White"
            }
          ]
        }
      }
    ]
  }
}
```
#### Using nested fields for arrays of objects

The **nested** type is a specialised version of the **object** data type that allows arrays of objects to be indexed in a way that they can be queried independently of each other.

If you need to index arrays of objects and to maintain the independence of each object in the array, use the **nested** data type instead of the **object** data type.

Internally, nested objects index each object in the array as a separate hidden document, meaning that each nested object can be queried independently of the others with the **nested query**:

10. Define nested vertion of articles index

```markdown
PUT articles_v2
{
  "mappings": {
    "properties": {
      "name": {
        "type": "text"
      },
      "reviews": {
        "type": "nested"
      }
    }
  }
}
```

11. index data

```markdown
PUT articles_v2/_doc/1
{
  "name": "Elasticsearch article",
  "reviews": [
    {
      "name": "Lucas",
      "rating": 5
    },
    {
      "name": "Eduardo",
      "rating": 3
    }
  ]
}
```

Result:

```markdown
{
  "_index" : "articles_v2",
  "_type" : "_doc",
  "_id" : "Bgblg4cBL2gLFYPzwkUC",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}
```
12. test mappings
```markdown
GET articles_v2/_mapping"
```
13. get articles reviewed by Eduardo with rating greater than 4
```markdown
GET articles_v2/_search
{
  "query": {
    "nested": {
      "path": "reviews",
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "reviews.name": "Eduardo"
              }
            },
            {
              "range": {
                "reviews.rating": {
                  "gt": 4
                }
              }
            }
          ]
        }
      }
    }
  }
}
```

Result:

```markdown
{
  "took" : 641,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 0,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  }
}
```
And the return shows as that we have no articles matching these conditions, which is **correct!**

14. Define nested vertion of my-index-000001 index

```markdown
PUT my-index-000001_v2
{
  "mappings": {
    "properties": {
      "group": {
        "type": "keyword"
      },
      "user": {
        "type": "nested"
      }
    }
  }
}
```

15. index data into my-index-000001_v2
```markdown
PUT my-index-000001_v2/_doc/1
{
  "group" : "fans",
  "user" : [ 
    {
      "first" : "John",
      "last" :  "Smith"
    },
    {
      "first" : "Alice",
      "last" :  "White"
    }
  ]
}
```

16. test my-index-000001_v2 mappings 
```markdown
GET my-index-000001_v2/_mapping"
```
17. query for alice AND smith

```markdown
GET my-index-000001_v2/_search
{
  "query": {
    "nested": {
      "path": "user",
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "user.first": "Alice"
              }
            },
            {
              "match": {
                "user.last": "Smith"
              }
            }
          ]
        }
      }
    }
  }
}
```

Result:

```markdown
{
  "took" : 453,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 0,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  }
}
```
18. query for alice AND White

```markdown
GET my-index-000001_v2/_search
{
  "query": {
    "nested": {
      "path": "user",
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "user.first": "Alice"
              }
            },
            {
              "match": {
                "user.last": "White"
              }
            }
          ]
        }
      }
    }
  }
}
```

Result:

```markdown
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
    "max_score" : 1.3862942,
    "hits" : [
      {
        "_index" : "my-index-000001_v2",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.3862942,
        "_source" : {
          "group" : "fans",
          "user" : [
            {
              "first" : "John",
              "last" : "Smith"
            },
            {
              "first" : "Alice",
              "last" : "White"
            }
          ]
        }
      }
    ]
  }
}
```
19. clean
20. 
```markdown
DELETE user
DELETE articles
DELETE articles_v2
DELETE my-index-000001
DELETE my-index-000001_v2
```
#### Interacting with nested documentsedit

Nested documents can be:

- queried with the **nested** query.
- analyzed with the **nested** and **reverse_nested** aggregations.
- sorted with **nested sorting**.
- retrieved and highlighted with **nested inner hits**.
