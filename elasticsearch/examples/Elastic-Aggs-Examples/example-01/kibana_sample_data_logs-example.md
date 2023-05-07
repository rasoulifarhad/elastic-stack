### Aggregation Example

***1. Run Elasticsearch && Kibana*** 

```
docker compose up -d
```

***2. Add kibana_sample_data_logs && kibana_sample_data_ecommerce data Kibana /Home /Try sample data***

***3. How many unique sku’s can be found in our e-commerce data?***

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /kibana_sample_data_ecommerce/_search
{
  "size": 0,
  "aggs": {
    "unique_sku": {
      "cardinality": {
        "field": "sku"
      }
    }
  }
}
```

  <details><summary><i>Response</i></summary>

  ```json
  {
    "took" : 32,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 4675,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "unique_sku" : {
        "value" : 7186
      }
    }
  }
  ```
  </details>

</blockquote></details>

**Note:** 
> Needing to find the number of unique values for a particular field is a common requirement. The cardinality aggregation can be used to determine the number of unique elements.  
> 

---

***4. Let’s check the stats of field “total_quantity” in our e-commerce data.***

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /kibana_sample_data_ecommerce/_search
{
  "size": 0,
  "aggs": {
    "total_quantity_stats": {
      "stats": {
        "field": "total_quantity"
      }
    }
  }
}
```

  <details><summary><i>Response</i></summary>

  ```json
  {
    "took" : 6,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 4675,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "total_quantity_stats" : {
        "count" : 4675,
        "min" : 1.0,
        "max" : 8.0,
        "avg" : 2.1585026737967916,
        "sum" : 10091.0
      }
    }
  }
  ```

  </details>

</blockquote></details>

---

***5. Calculate the average price of the products “eddie” purchased.***

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /kibana_sample_data_ecommerce/_search
{
  "size": 0,
  "aggs": {
    "user_filter": {
      "filter": {
        "term": {
          "user": "eddie"
        }
      },
      "aggs": {
        "avg_price": {
          "avg": {
            "field": "products.price"
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
    "took" : 6,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 4675,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "user_filter" : {
        "doc_count" : 100,
        "avg_price" : {
          "value" : 34.85423743206522
        }
      }
    }
  }
  ```

  </details>

</blockquote></details>

---

***6. Top 5 buyers***

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /kibana_sample_data_ecommerce/_search
{
  "size": 0,
  "aggs": {
    "users_product_count": {
      "terms": {
        "field": "user",
        "size": 5
      }
    }
  }
}
```

  <details><summary><i>Response</i></summary>

  ```json
  {
    -----
    "aggregations" : {
      "users_product_count" : {
        "doc_count_error_upper_bound" : 0,
        "sum_other_doc_count" : 3657,
        "buckets" : [
          {
            "key" : "elyssa",
            "doc_count" : 348
          },
          {
            "key" : "abd",
            "doc_count" : 188
          },
          {
            "key" : "wilhemina",
            "doc_count" : 170
          },
          {
            "key" : "rabbia",
            "doc_count" : 158
          },
          {
            "key" : "mary",
            "doc_count" : 154
          }
        ]
      }
    }
  }
  ```

  </details>

</blockquote></details>

---

***7. Nested aggregation***

<details open><summary><i></i></summary><blockquote>

  <details><summary><i>Define index: Mapping</i></summary>

  ```json
  PUT nested_aggregation
    {
      "mappings": {
        "properties": {
          "Employee": {
            "type": "nested",
            "properties": {
              "first": {
                "type": "text"
              },
              "last": {
                "type": "text"
              },
              "salary": {
                "type": "double"
              }
            }
          }
        }
      }
  }
  ```

  </details>

  <details><summary><i>Ingest Some data</i></summary><blockquote>

  ```json
  PUT nested_aggregation/_doc/1
    {
      "group": "Logz",
      "Employee": [
        {
          "first": "Ana",
          "last": "Roy",
          "salary": "70000"
        },
        {
          "first": "Jospeh",
          "last": "Lein",
          "salary": "64000"
        },
        {
          "first": "Chris",
          "last": "Gayle",
          "salary": "82000"
        },
        {
          "first": "Brendon",
          "last": "Maculum",
          "salary": "58000"
        },
        {
          "first": "Vinod",
          "last": "Kambli",
          "salary": "63000"
        },
        {
          "first": "DJ",
          "last": "Bravo",
          "salary": "71000"
        },
        {
          "first": "Jaques",
          "last": "Kallis",
          "salary": "75000"
        }
      ]
  }
  ```
  </details>

  <details open><summary><i>Find min salary</i></summary><blockquote>

  ```json
  GET /nested_aggregation/_search
    {
      "size": 0,
      "aggs": {
        "employee_nested": {
          "nested": {
            "path": "Employee"
          },
          "aggs": {
            "min_salary": {
              "min": {
                "field": "Employee.salary"
              }
            }
          }
        }
      }
  }
  ```

  </details>

</blockquote></details>

