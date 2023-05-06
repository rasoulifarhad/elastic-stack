## Elasticsearch SQL


<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
    SELECT 
      customer_id, count(*) as cnt  
    FROM  
      "kibana_sample_data_ecommerce" as t 
    GROUP BY 
      t.customer_id 
    ORDER BY  
      cnt desc
    LIMIT 10
  """
}
```

  <details><summary><i>Response</i></summary>

  ```
    customer_id  |      cnt      
  ---------------+---------------
  27             |348            
  52             |188            
  17             |170            
  5              |158            
  20             |154            
  44             |148            
  12             |135            
  42             |135            
  43             |135            
  24             |134            
  ```
  
  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
    SELECT 
      TOP 5 customer_id, count(*) as cnt  
    FROM  
      "kibana_sample_data_ecommerce" as t 
    GROUP BY 
      t.customer_id 
    ORDER BY  
      cnt desc
  """
}
```

  <details><summary><i>Response</i></summary>

  ```
    customer_id  |      cnt      
  ---------------+---------------
  27             |348            
  52             |188            
  17             |170            
  5              |158            
  20             |154            
  ```

  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
    SELECT TOP 5 customer_id, count(*) as cnt  
    FROM  "kibana_sample_data_ecommerce" as t 
    GROUP BY t.customer_id 
  """
}
```

  <details><summary><i>Response</i></summary>

  ```
    customer_id  |      cnt      
  ---------------+---------------
  10             |59             
  11             |75             
  12             |135            
  13             |114            
  14             |72             
  ```
  
  </details>

</blockquote></details>

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
    SELECT customer_id, count(*) as cnt  
    FROM  "kibana_sample_data_ecommerce" as t 
    GROUP BY t.customer_id 
    ORDER BY  cnt desc
  """,
  
  "fetch_size": 65536
}
```

  <details><summary><i>Response</i></summary>

  ```
  ```

  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
    SELECT customer_id, count(*) as cnt  
    FROM  "kibana_sample_data_ecommerce" as t 
    GROUP BY t.customer_id 
    HAVING count(*) > 300

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
    customer_id  |      cnt      
  ---------------+---------------
  27             |348            
  ```
  
  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
    SELECT customer_id, count(*) as cnt  
    FROM  "kibana_sample_data_ecommerce" as t 
    GROUP BY t.customer_id 
    HAVING cnt > 300

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
    customer_id  |      cnt      
  ---------------+---------------
  27             |348            
  ```
  
  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
  
    SELECT 
        customer_id, count(*) as cnt  
    FROM  
        "kibana_sample_data_ecommerce" as t 
    GROUP BY 
        t.customer_id 
    HAVING 
        cnt > 300

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
  ```

  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
  
    SELECT 
        customer_id as cst, count(*) as cnt  
    FROM  
        "kibana_sample_data_ecommerce" as t 
    GROUP BY 
        cst 
    HAVING 
        cnt > 300

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
  ```

  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
  
    SELECT 
        customer_id as cst, count(*) as cnt  
    FROM  
        "kibana_sample_data_ecommerce" as t 
    GROUP BY 
        cst 
    HAVING 
        cnt >= 100

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
        cst      |      cnt      
  ---------------+---------------
  12             |135            
  13             |114            
  17             |170            
  18             |132            
  19             |109            
  20             |154            
  22             |111            
  24             |134            
  25             |101            
  26             |122            
  27             |348            
  28             |106            
  38             |100            
  42             |135            
  43             |135            
  44             |148            
  45             |134            
  46             |128            
  5              |158            
  52             |188            
  6              |116            
  ```
  
  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
  
    SELECT 
        customer_id as cst, count(*) as cnt  
    FROM  
        "kibana_sample_data_ecommerce" as t 
    GROUP BY 
        cst 
    HAVING 
        cnt >= 100 AND cnt <= 130

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
        cst      |      cnt      
  ---------------+---------------
  13             |114            
  19             |109            
  22             |111            
  25             |101            
  26             |122            
  28             |106            
  38             |100            
  46             |128            
  6              |116            


    customer_id  |      cnt      
  ---------------+---------------
  27             |348            
  ```
  
  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
  
    SELECT 
        customer_id as cst, count(*) as cnt  
    FROM  
        "kibana_sample_data_ecommerce" as t 
    GROUP BY 
        cst 
    HAVING 
        cnt >= 100 AND cnt <= 130
    ORDER BY
        cnt desc

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
        cst      |      cnt      
  ---------------+---------------
  46             |128            
  26             |122            
  6              |116            
  13             |114            
  22             |111            
  19             |109            
  28             |106            
  25             |101            
  38             |100            
  ```
  
  </details>

</blockquote></details>

---

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
  
    SELECT 
        customer_id as cst, count(*) as cnt  
    FROM  
        "kibana_sample_data_ecommerce" as t 
    GROUP BY 
        cst 
    HAVING 
        cnt >= 100 AND cnt <= 130
    ORDER BY
        cnt desc
    LIMIT 
        4

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
        cst      |      cnt      
  ---------------+---------------
  46             |128            
  26             |122            
  6              |116            
  13             |114            
  ```
  
  </details>


  <details><summary><i>Translate To Query DSL</i></summary><blockquote>

  ```json
  GET /_sql/translate
  {
    
    "query": """
    
      SELECT 
          customer_id as cst, count(*) as cnt  
      FROM  
          "kibana_sample_data_ecommerce" as t 
      GROUP BY 
          cst 
      HAVING 
          cnt >= 100 AND cnt <= 130
      ORDER BY
          cnt desc
      LIMIT 
          4

    """
  }
  ```

  <details><summary><i>Response</i></summary>

  ```json
  {
    "size" : 0,
    "_source" : false,
    "aggregations" : {
      "groupby" : {
        "composite" : {
          "size" : 1000,
          "sources" : [
            {
              "2c4bbc05" : {
                "terms" : {
                  "field" : "customer_id",
                  "missing_bucket" : true,
                  "order" : "asc"
                }
              }
            }
          ]
        },
        "aggregations" : {
          "having.d2ae3524" : {
            "bucket_selector" : {
              "buckets_path" : {
                "a0" : "_count",
                "a1" : "_count"
              },
              "script" : {
                "source" : "InternalQlScriptUtils.nullSafeFilter(InternalQlScriptUtils.and(InternalQlScriptUtils.gte(params.a0, params.v0), InternalQlScriptUtils.lte(params.a1, params.v1)))",
                "lang" : "painless",
                "params" : {
                  "v0" : 100,
                  "v1" : 130
                }
              },
              "gap_policy" : "skip"
            }
          }
        }
      }
    }
  }
  ```

  </details>

  </blockquote></details>

</blockquote></details>


<!--

GET /_sql/translate
{
  
  "query": """
  
    SELECT 
        customer_id as cst, count(*) as cnt  
    FROM  
        "kibana_sample_data_ecommerce" as t 
    GROUP BY 
        cst 
    HAVING 
        cnt >= 100 AND cnt <= 130
    ORDER BY
        cnt desc

  """
}

{
  "size" : 0,
  "_source" : false,
  "aggregations" : {
    "groupby" : {
      "composite" : {
        "size" : 1000,
        "sources" : [
          {
            "2c4bbc05" : {
              "terms" : {
                "field" : "customer_id",
                "missing_bucket" : true,
                "order" : "asc"
              }
            }
          }
        ]
      },
      "aggregations" : {
        "having.d2ae3524" : {
          "bucket_selector" : {
            "buckets_path" : {
              "a0" : "_count",
              "a1" : "_count"
            },
            "script" : {
              "source" : "InternalQlScriptUtils.nullSafeFilter(InternalQlScriptUtils.and(InternalQlScriptUtils.gte(params.a0, params.v0), InternalQlScriptUtils.lte(params.a1, params.v1)))",
              "lang" : "painless",
              "params" : {
                "v0" : 100,
                "v1" : 130
              }
            },
            "gap_policy" : "skip"
          }
        }
      }
    }
  }
}


GET /_sql/translate
{
  
  "query": """
  
    SELECT 
        customer_id as cst, count(*) as cnt  
    FROM  
        "kibana_sample_data_ecommerce" as t 
    GROUP BY 
        cst 
    HAVING 
        cnt >= 100
    ORDER BY
        cnt desc

  """
}

{
  "size" : 0,
  "_source" : false,
  "aggregations" : {
    "groupby" : {
      "composite" : {
        "size" : 1000,
        "sources" : [
          {
            "2c4bbc05" : {
              "terms" : {
                "field" : "customer_id",
                "missing_bucket" : true,
                "order" : "asc"
              }
            }
          }
        ]
      },
      "aggregations" : {
        "having.d2ae3524" : {
          "bucket_selector" : {
            "buckets_path" : {
              "a0" : "_count"
            },
            "script" : {
              "source" : "InternalQlScriptUtils.nullSafeFilter(InternalQlScriptUtils.gte(params.a0,params.v0))",
              "lang" : "painless",
              "params" : {
                "v0" : 100
              }
            },
            "gap_policy" : "skip"
          }
        }
      }
    }
  }
}


GET /_sql/translate
{
  
  "query": """
  
    SELECT 
        *
    FROM  
        "kibana_sample_data_ecommerce"
    ORDER BY
        customer_id desc

  """
}

{
  "size" : 1000,
  "_source" : false,
  "fields" : [
    {
      "field" : "category"
    },
    {
      "field" : "currency"
    },
    {
      "field" : "customer_birth_date",
      "format" : "strict_date_optional_time_nanos"
    },
    {
      "field" : "customer_first_name"
    },
    {
      "field" : "customer_full_name"
    },
    {
      "field" : "customer_gender"
    },
    {
      "field" : "customer_id"
    },
    {
      "field" : "customer_last_name"
    },
    {
      "field" : "customer_phone"
    },
    {
      "field" : "day_of_week"
    },
    {
      "field" : "day_of_week_i"
    },
    {
      "field" : "email"
    },
    {
      "field" : "event.dataset"
    },
    {
      "field" : "geoip.city_name"
    },
    {
      "field" : "geoip.continent_name"
    },
    {
      "field" : "geoip.country_iso_code"
    },
    {
      "field" : "geoip.location"
    },
    {
      "field" : "geoip.region_name"
    },
    {
      "field" : "manufacturer"
    },
    {
      "field" : "order_date",
      "format" : "strict_date_optional_time_nanos"
    },
    {
      "field" : "order_id"
    },
    {
      "field" : "products._id"
    },
    {
      "field" : "products.base_price"
    },
    {
      "field" : "products.base_unit_price"
    },
    {
      "field" : "products.category"
    },
    {
      "field" : "products.created_on",
      "format" : "strict_date_optional_time_nanos"
    },
    {
      "field" : "products.discount_amount"
    },
    {
      "field" : "products.discount_percentage"
    },
    {
      "field" : "products.manufacturer"
    },
    {
      "field" : "products.min_price"
    },
    {
      "field" : "products.price"
    },
    {
      "field" : "products.product_id"
    },
    {
      "field" : "products.product_name"
    },
    {
      "field" : "products.quantity"
    },
    {
      "field" : "products.sku"
    },
    {
      "field" : "products.tax_amount"
    },
    {
      "field" : "products.taxful_price"
    },
    {
      "field" : "products.taxless_price"
    },
    {
      "field" : "products.unit_discount_amount"
    },
    {
      "field" : "sku"
    },
    {
      "field" : "taxful_total_price"
    },
    {
      "field" : "taxless_total_price"
    },
    {
      "field" : "total_quantity"
    },
    {
      "field" : "total_unique_products"
    },
    {
      "field" : "type"
    },
    {
      "field" : "user"
    }
  ],
  "sort" : [
    {
      "customer_id" : {
        "order" : "desc",
        "missing" : "_first",
        "unmapped_type" : "keyword"
      }
    }
  ]
}


GET /_sql/translate
{
  
  "query": """
  
    SELECT 
        *
    FROM  
        "kibana_sample_data_ecommerce"
    ORDER BY
        customer_id desc

  """,
  "fetch_size": 10
}

{
  "size" : 10,
  "_source" : false,
  "fields" : [
    {
      "field" : "category"
    },
    {
      "field" : "currency"
    },
    {
      "field" : "customer_birth_date",
      "format" : "strict_date_optional_time_nanos"
    },
    {
      "field" : "customer_first_name"
    },
    {
      "field" : "customer_full_name"
    },
    {
      "field" : "customer_gender"
    },
    {
      "field" : "customer_id"
    },
    {
      "field" : "customer_last_name"
    },
    {
      "field" : "customer_phone"
    },
    {
      "field" : "day_of_week"
    },
    {
      "field" : "day_of_week_i"
    },
    {
      "field" : "email"
    },
    {
      "field" : "event.dataset"
    },
    {
      "field" : "geoip.city_name"
    },
    {
      "field" : "geoip.continent_name"
    },
    {
      "field" : "geoip.country_iso_code"
    },
    {
      "field" : "geoip.location"
    },
    {
      "field" : "geoip.region_name"
    },
    {
      "field" : "manufacturer"
    },
    {
      "field" : "order_date",
      "format" : "strict_date_optional_time_nanos"
    },
    {
      "field" : "order_id"
    },
    {
      "field" : "products._id"
    },
    {
      "field" : "products.base_price"
    },
    {
      "field" : "products.base_unit_price"
    },
    {
      "field" : "products.category"
    },
    {
      "field" : "products.created_on",
      "format" : "strict_date_optional_time_nanos"
    },
    {
      "field" : "products.discount_amount"
    },
    {
      "field" : "products.discount_percentage"
    },
    {
      "field" : "products.manufacturer"
    },
    {
      "field" : "products.min_price"
    },
    {
      "field" : "products.price"
    },
    {
      "field" : "products.product_id"
    },
    {
      "field" : "products.product_name"
    },
    {
      "field" : "products.quantity"
    },
    {
      "field" : "products.sku"
    },
    {
      "field" : "products.tax_amount"
    },
    {
      "field" : "products.taxful_price"
    },
    {
      "field" : "products.taxless_price"
    },
    {
      "field" : "products.unit_discount_amount"
    },
    {
      "field" : "sku"
    },
    {
      "field" : "taxful_total_price"
    },
    {
      "field" : "taxless_total_price"
    },
    {
      "field" : "total_quantity"
    },
    {
      "field" : "total_unique_products"
    },
    {
      "field" : "type"
    },
    {
      "field" : "user"
    }
  ],
  "sort" : [
    {
      "customer_id" : {
        "order" : "desc",
        "missing" : "_first",
        "unmapped_type" : "keyword"
      }
    }
  ]
}


<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  
  "query": """
  
    SELECT 
        count(customer_id)
    FROM  
        "kibana_sample_data_ecommerce"

  """
}


count(customer_id)
------------------
4675              


GET /_sql/translate
{
  
  "query": """
  
    SELECT 
        count(customer_id)
    FROM  
        "kibana_sample_data_ecommerce"

  """
}

{
  "size" : 0,
  "_source" : false,
  "aggregations" : {
    "groupby" : {
      "filters" : {
        "filters" : [
          {
            "match_all" : {
              "boost" : 1.0
            }
          }
        ],
        "other_bucket" : false,
        "other_bucket_key" : "_other_"
      },
      "aggregations" : {
        "bc56fa9b" : {
          "filter" : {
            "exists" : {
              "field" : "customer_id",
              "boost" : 1.0
            }
          }
        }
      }
    }
  }
}

GET /kibana_sample_data_ecommerce/_search
{
  "size": 0,
  "aggs": {
    "groupby": {
      "value_count": {
        "field": "customer_id"
      }
    }
  }
}



<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  
  "query": """
  
    SELECT 
        avg(taxful_total_price)
    FROM  
        "kibana_sample_data_ecommerce"

  """
}

avg(taxful_total_price)
-----------------------
75.05542864304813      


GET /_sql/translate
{
  
  "query": """
  
    SELECT 
        avg(taxful_total_price)
    FROM  
        "kibana_sample_data_ecommerce"

  """
}

{
  "size" : 0,
  "_source" : false,
  "aggregations" : {
    "groupby" : {
      "filters" : {
        "filters" : [
          {
            "match_all" : {
              "boost" : 1.0
            }
          }
        ],
        "other_bucket" : false,
        "other_bucket_key" : "_other_"
      },
      "aggregations" : {
        "63dfff34" : {
          "avg" : {
            "field" : "taxful_total_price"
          }
        }
      }
    }
  }
}


GET /kibana_sample_data_ecommerce/_search
{
  "size" : 0,
  "aggs": {
    "avg___": {
      "avg": {
        "field": "taxful_total_price"
      }
    }
  }
}


-->