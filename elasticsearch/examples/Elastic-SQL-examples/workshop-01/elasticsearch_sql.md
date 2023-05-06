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

---

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
    ORDER BY
      cnt desc
  """
}
```

  <details><summary><i>Response</i></summary>

  ```
        cst      |      cnt      
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
  45             |134            
  18             |132            
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
      cnt >= 100
    ORDER BY
      cnt desc
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
  ```
  
  </details>

</blockquote></details>

</blockquote></details>

----

<details open><summary><i>SQL</i></summary><blockquote>

```json
GET /_sql?format=txt
{
  "query": """
    SELECT 
      *
    FROM  
      "kibana_sample_data_ecommerce"
    ORDER BY
      customer_id desc
    LIMIT
      5
  """,
  "field_multi_value_leniency": true
}
```

  <details><summary><i>Response</i></summary>

  ```
      category     |   currency    |customer_birth_date|customer_first_name|customer_full_name|customer_gender|  customer_id  |customer_last_name|customer_phone |  day_of_week  | day_of_week_i |          email          | event.dataset  |geoip.city_name|geoip.continent_name|geoip.country_iso_code| geoip.location  |geoip.region_name| manufacturer  |       order_date       |   order_id    |      products._id       |products.base_price|products.base_unit_price|products.category|  products.created_on   |products.discount_amount|products.discount_percentage|products.manufacturer|products.min_price|products.price |products.product_id|  products.product_name   |products.quantity| products.sku  |products.tax_amount|products.taxful_price|products.taxless_price|products.unit_discount_amount|      sku      |taxful_total_price|taxless_total_price|total_quantity |total_unique_products|     type      |     user      
  -----------------+---------------+-------------------+-------------------+------------------+---------------+---------------+------------------+---------------+---------------+---------------+-------------------------+----------------+---------------+--------------------+----------------------+-----------------+-----------------+---------------+------------------------+---------------+-------------------------+-------------------+------------------------+-----------------+------------------------+------------------------+----------------------------+---------------------+------------------+---------------+-------------------+--------------------------+-----------------+---------------+-------------------+---------------------+----------------------+-----------------------------+---------------+------------------+-------------------+---------------+---------------------+---------------+---------------
  Men's Shoes      |EUR            |null               |Mostafa            |Mostafa Romero    |MALE           |9              |Romero            |               |Friday         |4              |mostafa@romero-family.zzz|sample_ecommerce|Cairo          |Africa              |EG                    |POINT (31.3 30.1)|Cairo Governorate|Elitelligence  |2023-04-28T07:48:00.000Z|561676         |sold_product_561676_1702 |25.984375          |25.984375               |Men's Shoes      |2016-12-09T07:48:00.000Z|0.0                     |0.0                         |Elitelligence        |12.21875          |25.984375      |1702               |Trainers - black/grey     |1                |ZO0512705127   |0.0                |25.984375            |25.984375             |0.0                          |ZO0512705127   |36.96875          |36.96875           |2              |2                    |order          |mostafa        
  Men's Clothing   |EUR            |null               |Mostafa            |Mostafa Graham    |MALE           |9              |Graham            |               |Thursday       |3              |mostafa@graham-family.zzz|sample_ecommerce|Cairo          |Africa              |EG                    |POINT (31.3 30.1)|Cairo Governorate|Elitelligence  |2023-05-18T19:01:55.000Z|589169         |sold_product_589169_17806|14.9921875         |14.9921875              |Men's Clothing   |2016-12-29T19:01:55.000Z|0.0                     |0.0                         |Elitelligence        |7.5               |14.9921875     |17806              |Long sleeved top - white  |1                |ZO0552005520   |0.0                |14.9921875           |14.9921875            |0.0                          |ZO0552005520   |26.984375         |26.984375          |2              |2                    |order          |mostafa        
  Men's Clothing   |EUR            |null               |Mostafa            |Mostafa Jacobs    |MALE           |9              |Jacobs            |               |Sunday         |6              |mostafa@jacobs-family.zzz|sample_ecommerce|Cairo          |Africa              |EG                    |POINT (31.3 30.1)|Cairo Governorate|Elitelligence  |2023-04-30T16:00:29.000Z|564844         |sold_product_564844_24343|10.9921875         |10.9921875              |Men's Clothing   |2016-12-11T16:00:29.000Z|0.0                     |0.0                         |Elitelligence        |5.390625          |10.9921875     |24343              |Print T-shirt - white     |1                |ZO0553205532   |0.0                |10.9921875           |10.9921875            |0.0                          |ZO0553205532   |35.96875          |35.96875           |2              |2                    |order          |mostafa        
  Men's Accessories|EUR            |null               |Mostafa            |Mostafa Rivera    |MALE           |9              |Rivera            |               |Sunday         |6              |mostafa@rivera-family.zzz|sample_ecommerce|Cairo          |Africa              |EG                    |POINT (31.3 30.1)|Cairo Governorate|Oceanavigations|2023-05-07T11:15:22.000Z|574002         |sold_product_574002_12599|11.9921875         |11.9921875              |Men's Accessories|2016-12-18T11:15:22.000Z|0.0                     |0.0                         |Oceanavigations      |6.0117188         |11.9921875     |12599              |Hat - dark grey multicolor|1                |ZO0308603086   |0.0                |11.9921875           |11.9921875            |0.0                          |ZO0308603086   |26.984375         |26.984375          |2              |2                    |order          |mostafa        
  Men's Clothing   |EUR            |null               |Mostafa            |Mostafa Valdez    |MALE           |9              |Valdez            |               |Tuesday        |1              |mostafa@valdez-family.zzz|sample_ecommerce|Cairo          |Africa              |EG                    |POINT (31.3 30.1)|Cairo Governorate|Elitelligence  |2023-04-25T09:59:02.000Z|557681         |sold_product_557681_18223|11.9921875         |11.9921875              |Men's Clothing   |2016-12-06T09:59:02.000Z|0.0                     |0.0                         |Elitelligence        |5.640625          |11.9921875     |18223              |Print T-shirt - light grey|1                |ZO0556005560   |0.0                |11.9921875           |11.9921875            |0.0                          |ZO0556005560   |72.0              |72.0               |2              |2                    |order          |mostafa        
  ```

  </details>

<details><summary><i>Translate To Query DSL</i></summary><blockquote>

```json
GET /_sql/translate
{
  "query": """
    SELECT 
      *
    FROM  
      "kibana_sample_data_ecommerce"
    ORDER BY
      customer_id desc
    LIMIT
      5
  """,
  "field_multi_value_leniency": true
}
```

  <details><summary><i>Response</i></summary>

  ```json
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
  ```
  
  </details>

</blockquote></details>

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
    ORDER BY
      cnt desc
  """
}
```

  <details><summary><i>Response</i></summary>

  ```
        cst      |      cnt      
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
  45             |134            
  18             |132            
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
        count(customer_id)
    FROM  
        "kibana_sample_data_ecommerce"

  """
}
```

  <details><summary><i>Response</i></summary>

  ```
  count(customer_id)
  ------------------
  4675              
  ```
  
  </details>

<details><summary><i>Translate To Query DSL</i></summary><blockquote>

```json
GET /_sql/translate
{
  
  "query": """
  
    SELECT 
        count(customer_id)
    FROM  
        "kibana_sample_data_ecommerce"

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
  ```
  
  </details>

</blockquote></details>

</blockquote></details>

---

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
```

  <details><summary><i>Response</i></summary>

  ```
  avg(taxful_total_price)
  -----------------------
  75.05542864304813      
  ```

  </details>

<details><summary><i>Translate To Query DSL</i></summary><blockquote>

```json
GET /_sql/translate
{
  
  "query": """
  
    SELECT 
        avg(taxful_total_price)
    FROM  
        "kibana_sample_data_ecommerce"

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
  ```

  </details>

</blockquote></details>

</blockquote></details>

<!--
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
