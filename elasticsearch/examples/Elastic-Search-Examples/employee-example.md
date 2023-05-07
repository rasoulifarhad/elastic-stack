### Search example

[base link](https://dev.to/lisahjung/beginner-s-guide-to-running-queries-with-elasticsearch-and-kibana-4kn9)

1. Run Elasticsearch && Kibana 
```markdown
docker compose up -d
``` 
Open the Kibana console(AKA Dev Tools). 

---

<details open><summary><i>Define index</i></summary><blockquote>

```
curl -X PUT 'http://localhost:9200/employee?pretty' -H 'Content-Type: application/json'
```

  <details><summary><i>Response</i></summary>

  ```
  {
    "acknowledged" : true,
    "shards_acknowledged" : true,
    "index" : "employee"
  }
  ```

  </details>

</blockquote></details>

---

<details open><summary><i>Index data</i></summary><blockquote>

```
curl -X PUT 'http://localhost:9200/employee/_doc/1?pretty' -H 'Content-Type: application/json' -d'
{
 "first_name": "John",
 "last_name": "Smith",
 "age": 25,
 "about": "I love to go rock climbing",
 "interests": ["sports", "music"]
}
'

curl -X PUT 'http://localhost:9200/employee/_doc/2?pretty' -H 'Content-Type: application/json' -d'
{
 "first_name": "Jane",
 "last_name": "Smith",
 "age": 32,
 "about": "I like to collect rock albums",
 "interests": ["music"]
}
'

curl -X PUT 'http://localhost:9200/employee/_doc/3?pretty' -H 'Content-Type: application/json' -d'
{
 "first_name": "Douglas",
 "last_name": "Fir",
 "age": 35,
 "about": "I like to build cabinets",
 "interests": ["forestry"]
}
'
```

</blockquote></details>

---


<details open><summary><i>Search all employees</i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -X GET 'http://localhost:9200/employee/_doc/_search?pretty' -H 'Content-Type: application/json'
  ```

  </details>


  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /employee/_doc/_search
  ```

  </details>

  <details><summary><i>Response</i></summary>

  ```
  {
    "took" : 459,
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
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.0,
          "_source" : {
            "first_name" : "John",
            "last_name" : "Smith",
            "age" : 25,
            "about" : "I love to go rock climbing",
            "interests" : [
              "sports",
              "music"
            ]
          }
        },
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 1.0,
          "_source" : {
            "first_name" : "Jane",
            "last_name" : "Smith",
            "age" : 32,
            "about" : "I like to collect rock albums",
            "interests" : [
              "music"
            ]
          }
        },
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : 1.0,
          "_source" : {
            "first_name" : "Douglas",
            "last_name" : "Fir",
            "age" : 35,
            "about" : "I like to build cabinets",
            "interests" : [
              "forestry"
            ]
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

<details open><summary><i>Search with Query-string</i></summary><blockquote>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /employee/_search?q=last_name:Smith
  ```

  </details>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -X GET 'http://localhost:9200/employee/_search?q=last_name:Smith&pretty'  -H 'Content-Type: application/json'
  ```

  </details>

  <details><summary><i>Response</i></summary>

  ```
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
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : 0.4700036,
      "hits" : [
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 0.4700036,
          "_source" : {
            "first_name" : "John",
            "last_name" : "Smith",
            "age" : 25,
            "about" : "I love to go rock climbing",
            "interests" : [
              "sports",
              "music"
            ]
          }
        },
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 0.4700036,
          "_source" : {
            "first_name" : "Jane",
            "last_name" : "Smith",
            "age" : 32,
            "about" : "I like to collect rock albums",
            "interests" : [
              "music"
            ]
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

<details open><summary><i>Search with query dsl</i></summary><blockquote>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /employee/_search
  {
    "query": {
      "match": {
        "last_name": "Smith"
      }
    }
  }
  ```

  </details>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/employee/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "match": {
        "last_name": "Smith"
      }
    }
  }'
  ```

  <details><summary><i>Response</i></summary>

  ```
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
      "max_score" : 0.4700036,
      "hits" : [
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 0.4700036,
          "_source" : {
            "first_name" : "John",
            "last_name" : "Smith",
            "age" : 25,
            "about" : "I love to go rock climbing",
            "interests" : [
              "sports",
              "music"
            ]
          }
        },
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 0.4700036,
          "_source" : {
            "first_name" : "Jane",
            "last_name" : "Smith",
            "age" : 32,
            "about" : "I like to collect rock albums",
            "interests" : [
              "music"
            ]
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Query dsl and filter

<details open><summary><i>query last name 'Smith' and 'age' older than 30</i></summary><blockquote>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /employee/_search
  { 
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "last_name": "Smith"
            }
          }
        ],
        "filter": [
          {
            "range": {
              "age": {
                "gt": 30
                }
            }
          }
        ]
      }
    }
  }
  ```

  </details>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/employee/_search?pretty" -H 'Content-Type: application/json' -d'
  { 
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "last_name": "Smith"
            }
          }
        ],
        "filter": [
          {
            "range": {
              "age": {
                "gt": 30
                }
            }
          }
        ]
      }
    }
  }'
  ```

  <details><summary><i>Response</i></summary>

  ```
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
      "max_score" : 0.4700036,
      "hits" : [
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 0.4700036,
          "_source" : {
            "first_name" : "Jane",
            "last_name" : "Smith",
            "age" : 32,
            "about" : "I like to collect rock albums",
            "interests" : [
              "music"
            ]
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Fuul-text search

The **_score** field ranks searches results

The higher the score, the **better**

<details open><summary><i>query 'rock climbing' employes</i></summary><blockquote>

  <details><summary><i>Dev Tools</i></summary>

  ``` 
  GET /employee/_search
  {
    "query": {
      "match": {
        "about": "rock climbing"
      }
    }
  }
  ```

  </details>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/employee/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "match": {
        "about": "rock climbing"
      }
    }
  }'
  ```

  </details>

  <details><summary><i>Response</i></summary>

  ```
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
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : 1.4167401,
      "hits" : [
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.4167401,
          "_source" : {
            "first_name" : "John",
            "last_name" : "Smith",
            "age" : 25,
            "about" : "I love to go rock climbing",
            "interests" : [
              "sports",
              "music"
            ]
          }
        },
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 0.4589591,
          "_source" : {
            "first_name" : "Jane",
            "last_name" : "Smith",
            "age" : 32,
            "about" : "I like to collect rock albums",
            "interests" : [
              "music"
            ]
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Phrase search

<details open><summary><i>query 'rock climbing' phrase</i></summary><blockquote>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /employee/_search
  {
    "query": {
      "match_phrase": {
        "about": "rock climbing"
      }
    }
  }
  ```

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/employee/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "match_phrase": {
        "about": "rock climbing"
      }
    }
  }'
  ```

  <details><summary><i>Response</i></summary>

  ```
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
      "max_score" : 1.4167401,
      "hits" : [
        {
          "_index" : "employee",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.4167401,
          "_source" : {
            "first_name" : "John",
            "last_name" : "Smith",
            "age" : 25,
            "about" : "I love to go rock climbing",
            "interests" : [
              "sports",
              "music"
            ]
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>
