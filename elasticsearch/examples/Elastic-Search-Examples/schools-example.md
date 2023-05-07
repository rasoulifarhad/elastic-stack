### Schools example

<details open><summary><i>Run Elasticsearch && Kibana </i></summary><blockquote>

``` 
docker compose up -d
``` 

</blockquote></details>

---

<details open><summary><i>Define index </i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -X PUT 'http://localhost:9200/schools?pretty' -H 'Content-Type: application/json'
  ```

  </details>

</blockquote></details>

---

<details open><summary><i>Index data </i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XPUT "http://localhost:9200/schools/_doc/3?pretty" -H 'Content-Type: application/json' -d'
  {
    "name": "Central School",
    "description": "CBSE Affiliation",
    "street": "Nagan",
    "city": "paprola",
    "state": "HP",
    "zip": "176115",
    "location": [
      31.8955385,
      76.8380405
    ],
    "fees": 2200,
    "tags": [
      "Senior Secondary",
      "beautiful campus"
    ],
    "rating": "3.3"
  }'

  PUT /schools/_doc/3
  {
    "name": "Central School",
    "description": "CBSE Affiliation",
    "street": "Nagan",
    "city": "paprola",
    "state": "HP",
    "zip": "176115",
    "location": [
      31.8955385,
      76.8380405
    ],
    "fees": 2200,
    "tags": [
      "Senior Secondary",
      "beautiful campus"
    ],
    "rating": "3.3"
  }

  curl -XPUT "http://localhost:9200/schools/_doc/4?pretty" -H 'Content-Type: application/json' -d'
  {
    "name": "City Best School",
    "description": "ICSE",
    "street": "West End",
    "city": "Meerut",
    "state": "UP",
    "zip": "250002",
    "location": [
      28.9926174,
      77.692485
    ],
    "fees": 3500,
    "tags": [
      "fully computerized"
    ],
    "rating": "4.5"
  }'

  PUT /schools/_doc/4
  {
    "name": "City Best School",
    "description": "ICSE",
    "street": "West End",
    "city": "Meerut",
    "state": "UP",
    "zip": "250002",
    "location": [
      28.9926174,
      77.692485
    ],
    "fees": 3500,
    "tags": [
      "fully computerized"
    ],
    "rating": "4.5"
  }

  curl -XPUT "http://localhost:9200/schools/_doc/5?pretty	" -H 'Content-Type: application/json' -d'
  {
    "name": "City School",
    "description": "ICSE",
    "street": "West End",
    "city": "Meerut",
    "state": "UP",
    "zip": "250002",
    "location": [
      28.9926174,
      77.692485
    ],
    "fees": 3500,
    "tags": [
      "fully computerized"
    ],
    "rating": "4.5"
  }'

  PUT /schools/_doc/5
  {
    "name": "City School",
    "description": "ICSE",
    "street": "West End",
    "city": "Meerut",
    "state": "UP",
    "zip": "250002",
    "location": [
      28.9926174,
      77.692485
    ],
    "fees": 3500,
    "tags": [
      "fully computerized"
    ],
    "rating": "4.5"
  }

  curl -XPUT "http://localhost:9200/school/_doc/10?pretty" -H 'Content-Type: application/json' -d'
  {
    "name": "Saint Paul School",
    "description": "ICSE Afiliation",
    "street": "Dawarka",
    "city": "Delhi",
    "state": "Delhi",
    "zip": "110075",
    "location": [
      28.5733056,
      77.0122136
    ],
    "fees": 5000,
    "tags": [
      "Good Faculty",
      "Great Sports"
    ],
    "rating": "4.5"
  }'

  PUT school/_doc/10
  {
    "name": "Saint Paul School",
    "description": "ICSE Afiliation",
    "street": "Dawarka",
    "city": "Delhi",
    "state": "Delhi",
    "zip": "110075",
    "location": [
      28.5733056,
      77.0122136
    ],
    "fees": 5000,
    "tags": [
      "Good Faculty",
      "Great Sports"
    ],
    "rating": "4.5"
  }

  curl -XPUT "http://localhost:9200/school/_doc/16?pretty" -H 'Content-Type: application/json' -d'
  {
    "name": "Crescent School",
    "description": "State Board Affiliation",
    "street": "Tonk Road",
    "city": "Jaipur",
    "state": "RJ",
    "zip": "176114",
    "location": [
      26.8535922,
      75.7923988
    ],
    "fees": 2500,
    "tags": [
      "Well equipped labs"
    ],
    "rating": "4.5"
  }'

  PUT school/_doc/16
  {
    "name": "Crescent School",
    "description": "State Board Affiliation",
    "street": "Tonk Road",
    "city": "Jaipur",
    "state": "RJ",
    "zip": "176114",
    "location": [
      26.8535922,
      75.7923988
    ],
    "fees": 2500,
    "tags": [
      "Well equipped labs"
    ],
    "rating": "4.5"
  }
  ```

  </details>

</blockquote></details>

---

#### Match All Query

<details open><summary><i>Match All Query </i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/schools/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "match_all": {}
    }
  }'
  ```

  </details>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /schools/_search
  {
    "query": {
      "match_all": {}
    }
  }
  ```

  </details>

</blockquote></details>

---

#### Full Text Queries

##### Match query


<details open><summary><i>This query matches a text or phrase with the values of one or more fields.</i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/schools/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "match": {
        "rating": "4.5"
      }
    }
  }'
  ```

  </details>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /schools/_search
  {
    "query": {
      "match": {
        "rating": "4.5"
      }
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Multi Match Query

<details open><summary><i>This query matches a text or phrase with more than one field.</i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/schools/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "multi_match": {
        "query": "paprola",
        "fields": ["city", "state"]
      }
    }  
  }'
  ```

  </details>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /schools/_search 
  {
    "query": {
      "multi_match": {
        "query": "paprola",
        "fields": ["city", "state"]
      }
    }  
  }
  ```

  </details>

  <details><summary><i>Response</i></summary>

  ```
  {
    "took" : 950,
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
          "_index" : "schools",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : 1.3862942,
          "_source" : {
            "name" : "Central School",
            "description" : "CBSE Affiliation",
            "street" : "Nagan",
            "city" : "paprola",
            "state" : "HP",
            "zip" : "176115",
            "location" : [
              31.8955385,
              76.8380405
            ],
            "fees" : 2200,
            "tags" : [
              "Senior Secondary",
              "beautiful campus"
            ],
            "rating" : "3.3"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Query String Query

This query uses query parser and query_string keyword.

7. 
<details open><summary><i>This query matches a text or phrase with more than one field.</i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://singleElasticsearch71602:9200/schools/_search" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "query_string": {
        "query": "beautiful"
      }
    }
  }'
  ```

  </details>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /schools/_search
  {
    "query": {
      "query_string": {
        "query": "beautiful"
      }
    }
  }
  ```

  </details>

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
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 1.2199391,
      "hits" : [
        {
          "_index" : "schools",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : 1.2199391,
          "_source" : {
            "name" : "Central School",
            "description" : "CBSE Affiliation",
            "street" : "Nagan",
            "city" : "paprola",
            "state" : "HP",
            "zip" : "176115",
            "location" : [
              31.8955385,
              76.8380405
            ],
            "fees" : 2200,
            "tags" : [
              "Senior Secondary",
              "beautiful campus"
            ],
            "rating" : "3.3"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Term Level Queries

<details open><summary><i>This query matches a text or phrase with more than one field.</i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/schools/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "term": {
        "zip": {
          "value": "176115"
        }
      }
    }
  }'
  ```

  </details>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /schools/_search
  {
    "query": {
      "term": {
        "zip": {
          "value": "176115"
        }
      }
    }
  }
  ```

  </details>

  <details><summary><i>Response</i></summary>

  ```
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
      "max_score" : 1.3862942,
      "hits" : [
        {
          "_index" : "schools",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : 1.3862942,
          "_source" : {
            "name" : "Central School",
            "description" : "CBSE Affiliation",
            "street" : "Nagan",
            "city" : "paprola",
            "state" : "HP",
            "zip" : "176115",
            "location" : [
              31.8955385,
              76.8380405
            ],
            "fees" : 2200,
            "tags" : [
              "Senior Secondary",
              "beautiful campus"
            ],
            "rating" : "3.3"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Range Query

This query is used to find the objects having values between the ranges of values given. For this, we need to use operators such as :

- gte: greater than equal to
- gt : greater-than
- lte: less-than equal to
- lt : less-than

<details open><summary><i>Range Query</i></summary><blockquote>

  <details open><summary><i>Curl</i></summary>

  ```
  curl -XGET "http://localhost:9200/schools/_search?pretty" -H 'Content-Type: application/json' -d'
  {
    "query": {
      "range": {
        "rating": {
          "gte": 3.5
        }
      }
    }
  }'
  ```

  </details>

  <details><summary><i>Dev Tools</i></summary>

  ```
  GET /schools/_search
  {
    "query": {
      "range": {
        "rating": {
          "gte": 3.5
        }
      }
    }
  }
  ```

  </details>

</blockquote></details>


There exist other types of term level queries also such as −

- **Exists query**: If a certain field has non null value.

- **Missing query**: This is completely opposite to exists query, this query searches for objects without specific fields or fields having null value.

- **Wildcard or regexp query**: This query uses regular expressions to find patterns in the objects.

---

##### Compound Queries

10. 

curl -XGET "http://singleElasticsearch71602:9200/schools/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        {
         "term": {
           "state": {
             "value": "UP"
           }
         } 
        }
      ],
      "filter": [
        {
          "term": {
            "fees": "2200"
          }
        }
      ],
      "minimum_should_match": 1,
      "boost": 1.0
    }
  }
}'

GET /schools/_search
{
  "query": {
    "bool": {
      "must": [
        {
         "term": {
           "state": {
             "value": "UP"
           }
         } 
        }
      ],
      "filter": [
        {
          "term": {
            "fees": "2200"
          }
        }
      ],
      "minimum_should_match": 1,
      "boost": 1.0
    }
  }
}

##### Geo Queries

11. 

curl -XPUT "http://singleElasticsearch71602:9200/geo_example" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "properties": {
      "location": {
        "type": "geo_shape"
      }
    }
  }
}'

PUT /geo_example
{
  "mappings": {
    "properties": {
      "location": {
        "type": "geo_shape"
      }
    }
  }
}

curl -XPOST "http://singleElasticsearch71602:9200/geo_example/_doc?refresh" -H 'Content-Type: application/json' -d'
{
  "name": "Chapter One, London, UK",
  "location": {
    "type": "point",
    "coordinates": [
      11.660544,
      57.800286
    ]
  }
}'

POST /geo_example/_doc?refresh
{
  "name": "Chapter One, London, UK",
  "location": {
    "type": "point",
    "coordinates": [
      11.660544,
      57.800286
    ]
  }
}

