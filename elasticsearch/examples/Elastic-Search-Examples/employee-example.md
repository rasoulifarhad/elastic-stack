### Search example

[base link](https://dev.to/lisahjung/beginner-s-guide-to-running-queries-with-elasticsearch-and-kibana-4kn9)

1. Run Elasticsearch && Kibana 
```markdown
docker compose up -d
``` 
Open the Kibana console(AKA Dev Tools). 

2. Define index
```markdown
curl -X PUT 'http://localhost:9200/employee?pretty' -H 'Content-Type: application/json'
```
Response:
```markdown
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "employee"
}
```
3. Index data
```markdown
curl -X PUT 'http://localhost:9200/employee/_doc/1?pretty' -H 'Content-Type: application/json' -d'
{
 "first_name": "John",
 "last_name": "Smith",
 "age": 25,
 "about": "I love to go rock climbing",
 "interests": ["sports", "music"]
}
'
```
Response:
```markdown
{
  "_index" : "employee",
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

```markdown
curl -X PUT 'http://localhost:9200/employee/_doc/2?pretty' -H 'Content-Type: application/json' -d'
{
 "first_name": "Jane",
 "last_name": "Smith",
 "age": 32,
 "about": "I like to collect rock albums",
 "interests": ["music"]
}
'
```
Response:
```markdown
{
  "_index" : "employee",
  "_type" : "_doc",
  "_id" : "2",
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

```markdown
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
```markdown
{
  "_index" : "employee",
  "_type" : "_doc",
  "_id" : "3",
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
4. Search all employees
```markdown
curl -X GET 'http://localhost:9200/employee/_doc/_search?pretty' -H 'Content-Type: application/json'
```
```markdown
GET /employee/_doc/_search
```
Response:
```markdown
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
5. Search with Query-string
```markdown
GET /employee/_search?q=last_name:Smith
```
```markdown
curl -X GET 'http://localhost:9200/employee/_search?q=last_name:Smith&pretty'  -H 'Content-Type: application/json'
```
Response: 
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
6. Search with query dsl
```markdown
GET /employee/_search
{
  "query": {
    "match": {
      "last_name": "Smith"
    }
  }
}
```
```markdown
curl -XGET "http://localhost:9200/employee/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "last_name": "Smith"
    }
  }
}'
```
Response: 
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
#### Query dsl and filter

7. query last name 'Smith' and 'age' older than 30 
```markdown
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
```markdown
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
Response: 
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
#### Fuul-text search

The **_score** field ranks searches results

The higher the score, the **better**

8. query 'rock climbing' employes
```markdown
GET /employee/_search
{
  "query": {
    "match": {
      "about": "rock climbing"
    }
  }
}
```
```markdown
curl -XGET "http://localhost:9200/employee/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "about": "rock climbing"
    }
  }
}'
```
Response:
```markdown
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
#### Phrase search

9. query 'rock climbing' phrase 
```markdown
GET /employee/_search
{
  "query": {
    "match_phrase": {
      "about": "rock climbing"
    }
  }
}
```
```markdown
curl -XGET "http://localhost:9200/employee/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_phrase": {
      "about": "rock climbing"
    }
  }
}'
```
Response:
```markdown
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