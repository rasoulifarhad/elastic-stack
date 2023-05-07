### ElasticSearch: Zero to Hero in 12 Commands

From [ElasticSearch: Zero to Hero in 12 Commands](https://dev.to/awscommunity-asean/the-guided-elasticsearch-cheatsheet-you-need-to-get-started-with-es-54f5)

#### Setup the index

In ElasticSearch, we store our data in indexes (similar to tables in your MySQL database). We populate indexes with documents (similar to rows). We will create and set up your first index in the subsequent commands.

1. **Verify the ES cluster is accessible**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -X GET "localhost:9200"
  ```

  <details><summary><i>Response:</i></summary>

  ```json
  {
    "name" : "elasticsearch71602",
    "cluster_name" : "elasticsearch-cluster71602",
    "cluster_uuid" : "YQeo4JTTQkaNij06HlD_WQ",
    "version" : {
      "number" : "7.16.2",
      "build_flavor" : "default",
      "build_type" : "docker",
      "build_hash" : "2b937c44140b6559905130a8650c64dbd0879cfb",
      "build_date" : "2021-12-18T19:42:46.604893745Z",
      "build_snapshot" : false,
      "lucene_version" : "8.10.1",
      "minimum_wire_compatibility_version" : "6.8.0",
      "minimum_index_compatibility_version" : "6.0.0-beta1"
    },
    "tagline" : "You Know, for Search"
  }
  ```

  </details>

</blockquote></details>


2. **Create an index**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -X PUT "localhost:9200/my-index-000001?pretty"
  ```

  <details><summary><i>Response:</i></summary>

  ```json
  {
    "acknowledged" : true,
    "shards_acknowledged" : true,
    "index" : "my-index-000001"
  }
  ```

  </details>

</blockquote></details>


3. **Create the mapping for the index**

The index we just created has no mapping. A mapping is similar to a schema in SQL databases.

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPUT "http://localhost:9200/my-index-000001/_mapping" -H 'Content-Type: application/json' -d'
  {
      "properties": {
          "product_id": {
              "type": "keyword"
          },
          "price": {
              "type": "float"
          },
          "stocks": {
              "type": "integer"
          },
          "published": {
              "type": "boolean"
          },
          "title": {
              "type": "text"
          },
          "sortable_title": {
              "type": "text"
          },
          "tags": {
              "type": "text"
          }
      }
  }'
  ```

  <details><summary><i>Response:</i></summary>

  ```json
  {"acknowledged":true}
  ```

  </details>

</blockquote></details>


4. **Show the mapping of the index**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XGET "http://localhost:9200/my-index-000001/_mapping?pretty"
  ```

  <details><summary><i>Response:</i></summary>

  ```json
  {
    "my-index-000001" : {
      "mappings" : {
        "properties" : {
          "price" : {
            "type" : "float"
          },
          "product_id" : {
            "type" : "keyword"
          },
          "published" : {
            "type" : "boolean"
          },
          "sortable_title" : {
            "type" : "text"
          },
          "stocks" : {
            "type" : "integer"
          },
          "tags" : {
            "type" : "text"
          },
          "title" : {
            "type" : "text"
          }
        }
      }
    }
  }
  ```

  </details>

</blockquote></details>


#### Data Operations with our ES Index

5. **Create data for the index**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
  {
    "product_id": "123",
    "price": 99.75,
    "stocks": 10,
    "published": true,
    "sortable_title": "Kenny Rogers Chicken Sauce",
    "title": "Kenny Rogers Chicken Sauce",
    "tags": "chicken sauce poultry cooked party"
  }'
  ```

  <details><summary><i>Response:</i></summary>

  ```json
  {
    "_index" : "my-index-000001",
    "_type" : "_doc",
    "_id" : "i7kVdocBfrudywCYQDSY",
    "_version" : 1,
    "result" : "created",
    "_shards" : {
      "total" : 2,
      "successful" : 1,
      "failed" : 0
    },
    "_seq_no" : 1,
    "_primary_term" : 1
  }
  ```

  </details>

</blockquote></details>


<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
  {
    "product_id": "456",
    "price": 200.75,
    "stocks": 0,
    "published": true,
    "sortable_title": "Best Selling Beer Flavor",
    "title": "Best Selling Beer Flavor",
    "tags": "beer best-seller party"
  }'
  ```

  <details><summary><i>Response:</i></summary>

  ```json
  {
    "_index" : "my-index-000001",
    "_type" : "_doc",
    "_id" : "jLkVdocBfrudywCY2jR4",
    "_version" : 1,
    "result" : "created",
    "_shards" : {
      "total" : 2,
      "successful" : 1,
      "failed" : 0
    },
    "_seq_no" : 1,
    "_primary_term" : 1
  }
  ```

  </details>

</blockquote></details>


<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
  {
    "product_id": "789",
    "price": 350.5,
    "stocks": 200,
    "published": false,
    "sortable_title": "Female Lotion",
    "title": "Female Lotion",
    "tags": "lotion female"  
  }'
  ```

  <details><summary><i>Response:</i></summary>

  ```json
  {
    "_index" : "my-index-000001",
    "_type" : "_doc",
    "_id" : "jbkXdocBfrudywCYwjQ7",
    "_version" : 1,
    "result" : "created",
    "_shards" : {
      "total" : 2,
      "successful" : 1,
      "failed" : 0
    },
    "_seq_no" : 2,
    "_primary_term" : 1
  }
  ```

  </details>

</blockquote></details>


6. **Display all the data**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "match_all": {}
    }
  }'
  ```

7. **Exact search with product id**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "term": {
        "product_id": "456"
      }
    }
  }'
  ```

  <details><summary><i>Response:</i></summary>

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
      "max_score" : 0.9808291,
      "hits" : [
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "jLkVdocBfrudywCY2jR4",
          "_score" : 0.9808291,
          "_source" : {
            "product_id" : "456",
            "price" : 200.75,
            "stocks" : 0,
            "published" : true,
            "sortable_title" : "Best Selling Beer Flavor",
            "title" : "Best Selling Beer Flavor",
            "tags" : "beer best-seller party"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>


8. **Fuzzy search with titles**

Fuzzy searches allow us to search for products by typing just a few words instead of the whole text of the field. Instead of typing the full name of the product name (i.e Incredible Tuna Mayo Jumbo 250), the customer just instead has to search for the part he recalls of the product (i.e Tuna Mayo).

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "match": {
        "title": "Beer Flavor"
      }
    }
  }'
  ```

  <details><summary><i>Response:</i></summary>

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
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 1.8132977,
      "hits" : [
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "jLkVdocBfrudywCY2jR4",
          "_score" : 1.8132977,
          "_source" : {
            "product_id" : "456",
            "price" : 200.75,
            "stocks" : 0,
            "published" : true,
            "sortable_title" : "Best Selling Beer Flavor",
            "title" : "Best Selling Beer Flavor",
            "tags" : "beer best-seller party"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>


In the default setting, we can get the product "Best Selling Beer Flavor" even with our incomplete query "Beer Flavor". There are other settings that allow us to tolerate misspellings or incomplete words to show results (i.e Bee Flavo)

9. **Sorted by prices**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "match_all": {}
    },
    "sort": [
      {
        "price": {
          "order": "desc"
        }
      },
      "_score"
    ]
  }'
  ```

  <details><summary><i>Response:</i></summary>

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
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "jbkXdocBfrudywCYwjQ7",
          "_score" : 1.0,
          "_source" : {
            "product_id" : "789",
            "price" : 350.5,
            "stocks" : 200,
            "published" : false,
            "sortable_title" : "Female Lotion",
            "title" : "Female Lotion",
            "tags" : "lotion female"
          },
          "sort" : [
            350.5,
            1.0
          ]
        },
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "jLkVdocBfrudywCY2jR4",
          "_score" : 1.0,
          "_source" : {
            "product_id" : "456",
            "price" : 200.75,
            "stocks" : 0,
            "published" : true,
            "sortable_title" : "Best Selling Beer Flavor",
            "title" : "Best Selling Beer Flavor",
            "tags" : "beer best-seller party"
          },
          "sort" : [
            200.75,
            1.0
          ]
        },
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "i7kVdocBfrudywCYQDSY",
          "_score" : 1.0,
          "_source" : {
            "product_id" : "123",
            "price" : 99.75,
            "stocks" : 10,
            "published" : true,
            "sortable_title" : "Kenny Rogers Chicken Sauce",
            "title" : "Kenny Rogers Chicken Sauce",
            "tags" : "chicken sauce poultry cooked party"
          },
          "sort" : [
            99.75,
            1.0
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>


10. **Search for all "beer" products that are PUBLISHED, and in stock. Sorted by cheapest to most expensive**

**Let's add several more beer products.**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
  {
    "product_id": "111",
    "price": 350.55,
    "stocks": 10,
    "published": true,
    "sortable_title": "Tudor Beer Lights",
    "title": "Tudor Beer Lights",
    "tags": "beer tudor party"
  }'

  curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
  {
    "product_id": "222",
    "price": 700.5,
    "stocks": 500,
    "published": false,
    "sortable_title": "Stella Beer 6pack",
    "title": "Stella Beer 6pack",
    "tags": "beer stella party"
  }'

  curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
  {
    "product_id": "333",
    "price": 340,
    "stocks": 500,
    "published": true,
    "sortable_title": "Kampai Beer 6pack",
    "title": "Kampai Beer 6pack",
    "tags": "beer kampai party"
  }'
  ```

**Search:**

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "title": "Beer"
            }
          },
          {
            "term": {
              "published": true
            }
          },
          {
            "range": {
              "stocks": {
                "gt": 0
              }
            }
          }
        ]
      }
    },
    "sort": [
      {
        "price": "asc"
      },
      "_score"
    ]
  }'
  ```

  <details><summary><i>Response:</i></summary>

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
      "hits" : [
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "kLl4docBfrudywCYpzT_",
          "_score" : 1.893388,
          "_source" : {
            "product_id" : "333",
            "price" : 340,
            "stocks" : 500,
            "published" : true,
            "sortable_title" : "Kampai Beer 6pack",
            "title" : "Kampai Beer 6pack",
            "tags" : "beer kampai party"
          },
          "sort" : [
            340.0,
            1.893388
          ]
        },
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "jrl4docBfrudywCYVTRP",
          "_score" : 1.893388,
          "_source" : {
            "product_id" : "111",
            "price" : 350.55,
            "stocks" : 10,
            "published" : true,
            "sortable_title" : "Tudor Beer Lights",
            "title" : "Tudor Beer Lights",
            "tags" : "beer tudor party"
          },
          "sort" : [
            350.55,
            1.893388
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>


11. **Search for all products that have at least 1 of the following tags ['poultry, 'kampai', 'best-seller'], that are PUBLISHED, and in stock. Sorted by cheapest to most expensive**

Previous query just involved three conditions that must be ALL TRUE to hold. That's equivalent to "A and B and C".

In this query, we still have three conditions that have to be all true, but the 1st condition is marked as true if it has either "poultry", "kampai", or "best-seller". In this example, we introduce the syntax for "OR":

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "must": [
          {
            "bool": {
              "should": [
                {
                "match": {
                  "tags": "poultry"
                } 
                },
                {
                  "match": {
                    "tags": "kampai"
                  }
                },
                {
                  "match": {
                    "tags": "best-seller"
                  }
                }
              ],
              "minimum_should_match": 1
            }
          },
          {
            "term": {
              "published": true
            }
          },
          {
            "range": {
              "stocks": {
                "gt": 0
              }
            }
          }
        ]
      }
    },
    "sort": [
      {
        "price": "asc"
      },
      "_score"
    ]
  }'
  ```

  <details><summary><i>Response:</i></summary>

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
      "hits" : [
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "i7kVdocBfrudywCYQDSY",
          "_score" : 2.7206926,
          "_source" : {
            "product_id" : "123",
            "price" : 99.75,
            "stocks" : 10,
            "published" : true,
            "sortable_title" : "Kenny Rogers Chicken Sauce",
            "title" : "Kenny Rogers Chicken Sauce",
            "tags" : "chicken sauce poultry cooked party"
          },
          "sort" : [
            99.75,
            2.7206926
          ]
        },
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "kLl4docBfrudywCYpzT_",
          "_score" : 3.047984,
          "_source" : {
            "product_id" : "333",
            "price" : 340,
            "stocks" : 500,
            "published" : true,
            "sortable_title" : "Kampai Beer 6pack",
            "title" : "Kampai Beer 6pack",
            "tags" : "beer kampai party"
          },
          "sort" : [
            340.0,
            3.047984
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>


**Note:** 

In this query, we still have a "must" keyword, but its first contains a "should" keyword. The whole query is equivalent to: (A or B or C) AND D AND E. The "should" implies that as long as one condition is met, the (A or B or C) statement returns true.

A tweak we can do is adjust the "minimum_should_match" (msm) parameter, so we can require that two or three or N conditions be met for the statement to be true. In our example, if msm=2, it means a product has to have two matching tags to be considered true (i.e a product has to be both poultry and kampai).

12. **Search for all products that have at least 1 of the following tags ['poultry, 'kampai', 'best-seller'], and in stock. The price should be between 0 to 300 only. Sorted by cheapest to most expensive**

This query is similar to #11 but we added another criteria that the price of the products returned should only be between 0 and 300.

<details open><summary><i></i></summary><blockquote>

  ```json
  curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "bool": {
        "must": [
          {
            "bool": {
              "should": [
                {
                "match": {
                  "tags": "poultry"
                } 
                },
                {
                  "match": {
                    "tags": "kampai"
                  }
                },
                {
                  "match": {
                    "tags": "best-seller"
                  }
                }
              ],
              "minimum_should_match": 1
            }
          },
          {
            "term": {
              "published": true
            }
          },
          {
            "range": {
              "stocks": {
                "gt": 0
              }
            }
          },
          {
            "range": {
              "price": {
                "gt": 0,
                "lt": 300
              }
            }
          }
        ]
      }
    },
    "sort": [
      {
        "price": "asc"
      },
      "_score"
    ]
  }'
  ```

  <details><summary><i>Response:</i></summary>

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
          "_id" : "i7kVdocBfrudywCYQDSY",
          "_score" : 3.7206926,
          "_source" : {
            "product_id" : "123",
            "price" : 99.75,
            "stocks" : 10,
            "published" : true,
            "sortable_title" : "Kenny Rogers Chicken Sauce",
            "title" : "Kenny Rogers Chicken Sauce",
            "tags" : "chicken sauce poultry cooked party"
          },
          "sort" : [
            99.75,
            3.7206926
          ]
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

