## Sort

> ***Sort Values***  
> ***Sort Ordere***  
> ***Sort mode option***  
> ***Sorting numeric fields***  
> ***Sorting within nested objects***  
> ***Missing Values***  
> ***Ignoring Unmapped Fields***  
> ***Geo Distance Sorting***  
> ***Script Based Sorting***  
> ***Track Scores***  

See [Sort search results](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/sort-search-results.html)

---

### Run Elasticsearch && Kibana 

```
docker compose up -d
```

---

### Examples

#### Index sample data

<details open><summary><i>Indexing</i></summary><blockquote>

  ```json
  PUT /my-index-000001/_doc/1?refresh
  {
    "product": "chocolate",
    "price": [20, 4]
  }
  ```

</blockquote></details>

---

#### Sort mode option

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /my-index-000001/_search
{
  "query": {
    "term": {
      "product": {
        "value": "chocolate"
      }
    }
  },
  "sort": [
    {
      "price": {
        "order": "asc",
        "mode": "avg"
      }
    }
  ]
}

``` 

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 8,
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
      "max_score" : null,
      "hits" : [
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : null,
          "_source" : {
            "product" : "chocolate",
            "price" : [
              20,
              4
            ]
          },
          "sort" : [
            12
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Sort mode option

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /my-index-000001/_search
{
  "query": {
    "term": {
      "product": {
        "value": "chocolate"
      }
    }
  },
  "sort": [
    {
      "price": {
        "order": "asc"
      }
    }
  ]
}
``` 

  <details><summary>Response:</summary>

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
      "max_score" : null,
      "hits" : [
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : null,
          "_source" : {
            "product" : "chocolate",
            "price" : [
              20,
              4
            ]
          },
          "sort" : [
            4
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### The search response includes sort values for each document. 

###### Index data

<details open><summary><i>Index data</i></summary><blockquote>

  <details open><summary><i>Mapping</i></summary>

  ```json
  PUT /my-index-000001
  {
    "mappings": {
      "properties": {
        "post_date": { "type": "date" },
        "user": {
          "type": "keyword"
        },
        "name": {
          "type": "keyword"
        },
        "age": { "type": "integer" }
      }
    }
  }
  ```

  </details>


  <details open><summary><i>Indexing</i></summary>

  ```json
  PUT /my-index-000002/_doc/1
  {
    "post_date": "2023-02-05",
    "user": "farhad",
    "name": "alireza",
    "age": 45
  }
  ```

  </details>

</blockquote></details>

---

###### Search data

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /my-index-000002/_search
{
  "query": {
    "term": {
      "user": {
        "value": "farhad"
      }
    }
  },
  "sort": [
    {"post_date": {"order": "asc", "format": "strict_date_optional_time_nanos"}},
    "user",
    {"name": "desc"},
    {"age": {"order": "desc"}},
    "_score"
  ]
}
```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 768,
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
      "max_score" : null,
      "hits" : [
        {
          "_index" : "my-index-000002",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 0.2876821,
          "_source" : {
            "post_date" : "2023-02-05",
            "user" : "farhad",
            "name" : "alireza",
            "age" : 45
          },
          "sort" : [
            "2023-02-05T00:00:00.000Z",
            "farhad",
            "alireza",
            45,
            0.2876821
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### The search response includes sort values for each document.

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /my-index-000002/_search
{
  "query": {
    "term": {
      "user": {
        "value": "farhad"
      }
    }
  },
  "sort": [
    {"post_date": {"order": "asc", "format": "strict_date_optional_time_nanos"}}
  ]
}

``` 

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 0,
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
      "max_score" : null,
      "hits" : [
        {
          "_index" : "my-index-000002",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : null,
          "_source" : {
            "post_date" : "2023-02-05",
            "user" : "farhad",
            "name" : "alireza",
            "age" : 45
          },
          "sort" : [
            "2023-02-05T00:00:00.000Z"
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### For numeric fields it is also possible to cast the values from one type to another using the numeric_type option. 

##### Index data

<details open><summary><i>Index data</i></summary><blockquote>

  <details open><summary><i>Mapping</i></summary>

  ```json
  PUT /index_long
  {
    "mappings": {
      "properties": {
        "field01": {
          "type": "long"
        }
      }
    }
  }
  ```

  </details>

  <details open><summary><i>Indexing</i></summary>

  ```json
  PUT /index_double
  {
    "mappings": {
      "properties": {
        "field01": {
          "type": "double"
        }
      }
    }
  }

  PUT /index_long/_doc/1
  {
    "field01": 30
  }

  PUT /index_double/_doc/2
  {
    "field01": 55.34
  }
  ```

  </details>

</blockquote></details>

---

##### Search data

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /index_double,index_long/_search
{
  "sort": [
    {
      "field01": {
        "order": "desc",
        "numeric_type": "double"
      }
    }
  ]
}
```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 886,
    "timed_out" : false,
    "_shards" : {
      "total" : 2,
      "successful" : 2,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [
        {
          "_index" : "index_double",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : null,
          "_source" : {
            "field01" : 55.34
          },
          "sort" : [
            55.34
          ]
        },
        {
          "_index" : "index_long",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : null,
          "_source" : {
            "field01" : 30
          },
          "sort" : [
            30.0
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### For numeric fields it is also possible to cast the values from one type to another using the numeric_type option. 

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /index_double,index_long/_search
{
  "sort": [
    {
      "field01": {
        "order": "desc",
        "numeric_type": "long"
      }
    }
  ]
}

``` 

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 14,
    "timed_out" : false,
    "_shards" : {
      "total" : 2,
      "successful" : 2,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [
        {
          "_index" : "index_double",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : null,
          "_source" : {
            "field01" : 55.34
          },
          "sort" : [
            55
          ]
        },
        {
          "_index" : "index_long",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : null,
          "_source" : {
            "field01" : 30
          },
          "sort" : [
            30
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Sorting within nested objects 


#### Missing Values

The `missing` parameter specifies how docs which are missing the sort field should be treated: The `missing` value can be set to `_last`, `_first`, or a custom value (that will be used for missing docs as the sort value). The default is `_last`.

###### Index data

<details open><summary><i>Index data</i></summary><blockquote>

  <details open><summary><i>Mapping</i></summary>

  ```json
  PUT /my-index-000003
  ```

  </details>

  <details open><summary><i>Indexing</i></summary>

  ```json
  PUT /my-index-000003/_doc/1
  {
    "product": "product-01",
    "price": 100
    
  }

  PUT /my-index-000003/_doc/2
  {
    "product": "product-02",
    "price": 50
    
  }

  PUT /my-index-000003/_doc/3
  {
    "product": "product-03"

  }
  ```

  </details>

</blockquote></details>

---

###### Search data

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /my-index-000003/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "price": {
        "order": "asc"
      }
    }
  ]
}
```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 0,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : null,
          "_source" : {
            "product" : "product-02",
            "price" : 50
          },
          "sort" : [
            50
          ]
        },
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : null,
          "_source" : {
            "product" : "product-01",
            "price" : 100
          },
          "sort" : [
            100
          ]
        },
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : null,
          "_source" : {
            "product" : "product-03"
          },
          "sort" : [
            9223372036854775807
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Missing values

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /my-index-000003/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "price": {
        "order": "asc",
        "missing": "_first"
      }
    }
  ]
}

``` 

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 0,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : null,
          "_source" : {
            "product" : "product-03"
          },
          "sort" : [
            -9223372036854775808
          ]
        },
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : null,
          "_source" : {
            "product" : "product-02",
            "price" : 50
          },
          "sort" : [
            50
          ]
        },
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : null,
          "_source" : {
            "product" : "product-01",
            "price" : 100
          },
          "sort" : [
            100
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Ignoring Unmapped Fields

By default, the search request will fail if there is no mapping associated with a field. The unmapped_type option allows you to ignore fields that have no mapping and not sort by them. The value of this parameter is used to determine what sort values to emit. Here is an example of how it can be used:

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /_search
{
  "sort" : [
    { "price" : {"unmapped_type" : "long"} }
  ],
  "query" : {
    "term" : { "product" : "chocolate" }
  }
}
```

</blockquote></details>

---

If any of the indices that are queried doesn’t have a mapping for price then Elasticsearch will handle it as if there was a mapping of type long, with all documents in this index having no value for this field.


#### Script Based Sorting

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /my-index-000003/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "_script": {
        "type": "number",
        "script": {
          "lang": "painless",
          "source": "if (doc['price'].size() != 0 ) {doc['price'].value * params.factor }",
          "params": {
            "factor": 1.1
          }
        },
        "order": "asc"
      }
    }
  ]
}

``` 

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 8,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : null,
          "_source" : {
            "product" : "product-03"
          },
          "sort" : [
            0.0
          ]
        },
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : null,
          "_source" : {
            "product" : "product-02",
            "price" : 50
          },
          "sort" : [
            55.00000000000001
          ]
        },
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : null,
          "_source" : {
            "product" : "product-01",
            "price" : 100
          },
          "sort" : [
            110.00000000000001
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Track Scores

When sorting on a field, scores are not computed. By setting `track_scores` to true, scores will still be computed and tracked.

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /my-index-000003/_search
{
  "query": {
    "match_all": {}
  },
  "track_scores": true,
  "sort": [
    {
      "_script": {
        "type": "number",
        "script": {
          "lang": "painless",
          "source": "if (doc['price'].size() != 0 ) {doc['price'].value * params.factor }",
          "params": {
            "factor": 1.1
          }
        },
        "order": "desc"
      }
    }
  ]
}
```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 7,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : 1.0,
      "hits" : [
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.0,
          "_source" : {
            "product" : "product-01",
            "price" : 100
          },
          "sort" : [
            110.00000000000001
          ]
        },
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 1.0,
          "_source" : {
            "product" : "product-02",
            "price" : 50
          },
          "sort" : [
            55.00000000000001
          ]
        },
        {
          "_index" : "my-index-000003",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : 1.0,
          "_source" : {
            "product" : "product-03"
          },
          "sort" : [
            0.0
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

###### Clean

<details open><summary><i>Clean</i></summary><blockquote>

```json
DELETE /my-index-000001
DELETE /my-index-000002
DELETE /my-index-000003
DELETE /index_double
DELETE /index_long

```

</blockquote></details>
