### Elasticsearch Aggregations

See [5 simple examples to understand ES aggregation](https://blog.joshsoftware.com/2020/11/18/5-simple-examples-to-understand-elasticsearch-aggregation/)

#### Bulk Insert documents (Cars store) 

<details><summary><i>Mapping:</i></summary><blockquote>

```json
PUT /cars
{
  "mappings": {
    "properties": {
      "manufacturer": {
        "type": "keyword"
      },
      "model": {
        "type": "keyword"
      },
      "price": {
        "type": "long"
      },
      "sold_date": {
        "type": "date"
      }
    }
  }
}
```

</blockquote></details>

---

<details><summary><i>Bulk insert:</i></summary><blockquote>

```json
POST _bulk
{"index":{"_index":"cars","_id":"1"}}
{"manufacturer":"Audi","model":"A6","price":3900000,"sold_date":"2020-03-10"}
{"index":{"_index":"cars","_id":"2"}}
{"manufacturer":"Ford","model":"Fiesta","price":580000,"sold_date":"2020-07-18"}
{"index":{"_index":"cars","_id":"3"}}
{"manufacturer":"Audi","model":"A7","price":6500000,"sold_date":"2020-05-28"}
{"index":{"_index":"cars","_id":"4"}}
{"manufacturer":"Audi","model":"A8","price":14900000,"sold_date":"2020-06-10"}
{"index":{"_index":"cars","_id":"5"}}
{"manufacturer":"Ford","model":"Linea","price":420000,"sold_date":"2020-05-26"}
{"index":{"_index":"cars","_id":"6"}}
{"manufacturer":"Ford","model":"Figo","price":480000,"sold_date":"2020-07-13"}
{"index":{"_index":"cars","_id":"7"}}
{"manufacturer":"Maruti","model":"Swift","price":680000,"sold_date":"2020-05-25"}
{"index":{"_index":"cars","_id":"8"}}
{"manufacturer":"Tata","model":"Nexon","price":880000,"sold_date":"2020-05-25"}
{"index":{"_index":"cars","_id":"8"}}
{"manufacturer":"Tata","model":"Altroz","price":680000,"sold_date":"2020-03-25"}
{"index":{"_index":"cars","_id":"9"}}
{"manufacturer":"Tata","model":"Tigor","price":520000,"sold_date":"2020-07-25"}
```

</blockquote></details>

---

#### What is the average price of all sold cars which have manufacturer Audi ?

What elasticsearch query we can use to get this result:

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /cars/_search
{
  "size": 0,
  "query": {
    "match": {
      "manufacturer": "Audi"
    }
  },
  "aggs": {
    "average price": {
      "avg": {
        "field": "price"
      }
    }
  }
}
```

  <details><summary><i>Response</i></summary>

  ```json
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
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "average price" : {
        "value" : 8433333.333333334
      }
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Find all cars made by Ford and average price of only those cars sold in Jul 2020

What elasticsearch query we can use to get this result:

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /cars/_search
{
  "size": 100,
  "query": {
    "match": {
      "manufacturer": "Ford"
    }
  },
  "aggs": {
    "ju_2020_solded": {
      "filter": {
        "range": {
          "sold_date": {
            "gte": "2020-07-01",
            "lte": "2020-07-31"
          }
        }
      },
      "aggs": {
        "average price": {
          "avg": {
            "field": "price"
          }
        }
      }
    }
  }
}
```

  <details><summary><i>Response</i></summary>

  ```json
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
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : 1.1451323,
      "hits" : [
        {
          "_index" : "cars",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 1.1451323,
          "_source" : {
            "manufacturer" : "Ford",
            "model" : "Fiesta",
            "price" : 580000,
            "sold_date" : "2020-07-18"
          }
        },
        {
          "_index" : "cars",
          "_type" : "_doc",
          "_id" : "5",
          "_score" : 1.1451323,
          "_source" : {
            "manufacturer" : "Ford",
            "model" : "Linea",
            "price" : 420000,
            "sold_date" : "2020-05-26"
          }
        },
        {
          "_index" : "cars",
          "_type" : "_doc",
          "_id" : "6",
          "_score" : 1.1451323,
          "_source" : {
            "manufacturer" : "Ford",
            "model" : "Figo",
            "price" : 480000,
            "sold_date" : "2020-07-13"
          }
        }
      ]
    },
    "aggregations" : {
      "ju_2020_solded" : {
        "doc_count" : 2,
        "average price" : {
          "value" : 530000.0
        }
      }
    }
  }
  ```

  </details>

</blockquote></details>

---

#### What is the total price of all cars sold in Jul 2020 ?

What elasticsearch query we can use to get this result:

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /cars/_search
{
  "size": 0, 
  "query": {
    "range": {
      "sold_date": {
        "gte": "2020-07-01",
        "lte": "2020-07-31"
      }
    }
  },
  "aggs": {
    "total_price": {
      "sum": {
        "field": "price"
      }
    }
  }
}
```

  <details><summary><i>Response</i></summary>

  ```json
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
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "total_price" : {
        "value" : 1580000.0
      }
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Which are the most popular car manufacturers?

What elasticsearch query we can use to get this result:

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /cars/_search
{
  "size": 0,
  "query": {
    "range": {
      "sold_date": {
        "from": "now-3y"
      }
    }
  },
  "aggs": {
    "group_by_make": {
      "terms": {
        "field": "manufacturer"
      }
    }
  }
}
```

  <details><summary><i>Response</i></summary>

  ```json
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
        "value" : 7,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "group_by_make" : {
        "doc_count_error_upper_bound" : 0,
        "sum_other_doc_count" : 0,
        "buckets" : [
          {
            "key" : "Ford",
            "doc_count" : 3
          },
          {
            "key" : "Audi",
            "doc_count" : 2
          },
          {
            "key" : "Maruti",
            "doc_count" : 1
          },
          {
            "key" : "Tata",
            "doc_count" : 1
          }
        ]
      }
    }
  }
  ```

  </details>

</blockquote></details>

---

####  How much sales were made each month ?

What elasticsearch query we can use to get this result:

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /cars/_search
{
  "size": 0,
  "aggs": {
    "sales_over_time": {
      "date_histogram": {
        "field": "sold_date",
        "calendar_interval": "month",
        "format": "MM-yyyy"
      },
      "aggs": {
        "monthly_sales": {
          "sum": {
            "field": "price"
          }
        }
      }
    }
  }
}
```

  <details><summary><i>Response</i></summary>

  ```json
  {
    "took" : 3,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 9,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "sales_over_time" : {
        "buckets" : [
          {
            "key_as_string" : "03-2020",
            "key" : 1583020800000,
            "doc_count" : 2,
            "monthly_sales" : {
              "value" : 4580000.0
            }
          },
          {
            "key_as_string" : "04-2020",
            "key" : 1585699200000,
            "doc_count" : 0,
            "monthly_sales" : {
              "value" : 0.0
            }
          },
          {
            "key_as_string" : "05-2020",
            "key" : 1588291200000,
            "doc_count" : 3,
            "monthly_sales" : {
              "value" : 7600000.0
            }
          },
          {
            "key_as_string" : "06-2020",
            "key" : 1590969600000,
            "doc_count" : 1,
            "monthly_sales" : {
              "value" : 1.49E7
            }
          },
          {
            "key_as_string" : "07-2020",
            "key" : 1593561600000,
            "doc_count" : 3,
            "monthly_sales" : {
              "value" : 1580000.0
            }
          }
        ]
      }
    }
  }
  ```

  </details>

</blockquote></details>

---
