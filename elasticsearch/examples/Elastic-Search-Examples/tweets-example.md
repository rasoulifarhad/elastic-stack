### Tweets example

[base link](https://dev.to/lisahjung/beginner-s-guide-to-running-queries-with-elasticsearch-and-kibana-4kn9)

1. Run Elasticsearch && Kibana 
 
docker compose up -d
 
Open the Kibana console(AKA Dev Tools). 

2. Define index

curl -X PUT 'http://localhost:9200/user?pretty' -H 'Content-Type: application/json'
curl -X PUT 'http://localhost:9200/tweet?pretty' -H 'Content-Type: application/json'

3. Index data

curl -X PUT 'http://localhost:9200/user/_doc/1?pretty' -H 'Content-Type: application/json' -d'
{
 "email": "john@smith.com",
 "name": "John Smith",
 "username": "@john",
 "country_code": "us"
}
'

curl -X PUT 'http://localhost:9200/user/_doc/2?pretty' -H 'Content-Type: application/json' -d'
{
 "email": "mary@jones.com",
 "name": "Mary Jones",
 "username": "@mary",
 "country_code": "gb"
}
'

curl -X PUT 'http://localhost:9200/tweet/_doc/3?pretty' -H 'Content-Type: application/json' -d'
{
 "date": "2014-09-13",
 "name": "Mary Jones",
 "tweet": "Elasticsearch means full text search has never been so easy",
 "user_id": 2,
 "country_code": "gb"
}
'

curl -X PUT 'http://localhost:9200/tweet/_doc/4?pretty' -H 'Content-Type: application/json' -d'
{
 "date": "2014-09-13",
 "name": "John Smith",
 "tweet": "The Elasticsearch API is really easy to use",
 "user_id": 1,
 "country_code": "gb"
}
'

curl -X PUT 'http://localhost:9200/tweet/_doc/5?pretty' -H 'Content-Type: application/json' -d'
{
 "date": "2014-09-13",
 "name": "John Smith",
 "tweet": "Elasticsearch surely is one of the hottest new NoSQL products",
 "user_id": 1,
 "country_code": "gb"
}
'

curl -X PUT 'http://localhost:9200/tweet/_doc/6?pretty' -H 'Content-Type: application/json' -d'
{
 "date": "2014-09-13",
 "name": "John Smith",
 "tweet": "Elasticsearch and I have left the honeymoon stage, and I still love her.",
 "user_id": 1,
 "country_code": "gb"
}
'

4. Search all 

curl -X GET 'http://localhost:9200/user/_search?pretty' -H 'Content-Type: application/json'

curl -X GET 'http://localhost:9200/tweet/_search?pretty' -H 'Content-Type: application/json'

curl -X GET "http://localhost:9200/user/_search?size=5&pretty"  -H 'Content-Type: application/json'

curl -X GET "http://localhost:9200/user/_search?size=5&from=5&pretty" -H 'Content-Type: application/json'

5. 

curl -XGET "http://localhost:9200/tweet/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "tweet": "elasticsearch"
    }
  }
}'

Response:

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
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "tweet",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 0.2876821,
        "_source" : {
          "date" : "2014-09-13",
          "name" : "Mary Jones",
          "tweet" : "Elasticsearch means full text search has never been so easy",
          "user_id" : 2,
          "country_code" : "gb"
        }
      }
    ]
  }
}

6. 

curl -XGET "http://singleElasticsearch71602:9200/tweet/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "tweet": "elasticsearch"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "name": "mary"
          }
        }
      ],
      "should": [
        {
          "match": {
            "tweet": "full text"
          }
        }
      ]
    }
  }
}'

Response: 

{
  "took" : 424,
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
    "max_score" : 0.1157554,
    "hits" : [
      {
        "_index" : "tweet",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 0.1157554,
        "_source" : {
          "date" : "2014-09-13",
          "name" : "John Smith",
          "tweet" : "The Elasticsearch API is really easy to use",
          "user_id" : 1,
          "country_code" : "gb"
        }
      },
      {
        "_index" : "tweet",
        "_type" : "_doc",
        "_id" : "5",
        "_score" : 0.10642238,
        "_source" : {
          "date" : "2014-09-13",
          "name" : "John Smith",
          "tweet" : "Elasticsearch surely is one of the hottest new NoSQL products",
          "user_id" : 1,
          "country_code" : "gb"
        }
      },
      {
        "_index" : "tweet",
        "_type" : "_doc",
        "_id" : "6",
        "_score" : 0.094940245,
        "_source" : {
          "date" : "2014-09-13",
          "name" : "John Smith",
          "tweet" : "Elasticsearch and I have left the honeymoon stage, and I still love her.",
          "user_id" : 1,
          "country_code" : "gb"
        }
      }
    ]
  }
}


