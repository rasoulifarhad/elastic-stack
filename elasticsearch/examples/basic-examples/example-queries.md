### Example Queries

##### Create an index

1. Create a new index and index some documents using the [bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html):
```markdown
PUT /book
{ 
  "settings": { "number_of_shards": 1 }
}

curl -XPUT "http://singleElasticsearch71602:9200/book" -H 'Content-Type: application/json' -d'
{ 
  "settings": { "number_of_shards": 1 }
}'
```

```markdown
POST /book/_bulk
{"index":{"_id":1}}
{"title":"Elasticsearch: The Definitive Guide","authors":["clinton gormley","zachary tong"],"summary":"A distibuted real-time search and analytics engine","publish_date":"2015-02-07","num_reviews":20,"publisher":"oreilly"}
{"index":{"_id":2}}
{"title":"Taming Text: How to Find, Organize, and Manipulate It","authors":["grant ingersoll","thomas morton","drew farris"],"summary":"organize text using approaches such as full-text search, proper name recognition, clustering, tagging, information extraction, and summarization","publish_date":"2013-01-24","num_reviews":12,"publisher":"manning"}
{"index":{"_id":3}}
{"title":"Elasticsearch in Action","authors":["radu gheorge","matthew lee hinman","roy russo"],"summary":"build scalable search applications using Elasticsearch without having to do complex low-level programming or understand advanced data science algorithms","publish_date":"2015-12-03","num_reviews":18,"publisher":"manning"}
{"index":{"_id":4}}
{"title":"Solr in Action","authors":["trey grainger","timothy potter"],"summary":"Comprehensive guide to implementing a scalable search engine using Apache Solr","publish_date":"2014-04-05","num_reviews":23,"publisher":"manning"}

curl -XPOST "http://singleElasticsearch71602:9200/book/_bulk" -H 'Content-Type: application/json' -d'
{"index":{"_id":1}}
{"title":"Elasticsearch: The Definitive Guide","authors":["clinton gormley","zachary tong"],"summary":"A distibuted real-time search and analytics engine","publish_date":"2015-02-07","num_reviews":20,"publisher":"oreilly"}
{"index":{"_id":2}}
{"title":"Taming Text: How to Find, Organize, and Manipulate It","authors":["grant ingersoll","thomas morton","drew farris"],"summary":"organize text using approaches such as full-text search, proper name recognition, clustering, tagging, information extraction, and summarization","publish_date":"2013-01-24","num_reviews":12,"publisher":"manning"}
{"index":{"_id":3}}
{"title":"Elasticsearch in Action","authors":["radu gheorge","matthew lee hinman","roy russo"],"summary":"build scalable search applications using Elasticsearch without having to do complex low-level programming or understand advanced data science algorithms","publish_date":"2015-12-03","num_reviews":18,"publisher":"manning"}
{"index":{"_id":4}}
{"title":"Solr in Action","authors":["trey grainger","timothy potter"],"summary":"Comprehensive guide to implementing a scalable search engine using Apache Solr","publish_date":"2014-04-05","num_reviews":23,"publisher":"manning"}
'
```
##### Basic match query

2. Basic match query(searches for the string “guide” in all the fields)

```markdown
GET /book/_search?q=guide

curl -XGET "http://singleElasticsearch71602:9200/book/_search?q=guide"
```
```markdown
GET /book/_search
{
  "query": {
    "multi_match": {
      "query": "guide",
      "fields": ["title", "authors", "summary", "publisher"]
    }
  }
}

curl -XGET "http://singleElasticsearch71602:9200/book/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "multi_match": {
      "query": "guide",
      "fields": ["title", "authors", "summary", "publisher"]
    }
  }
}'
```

2. Search for books with the words “in Action” in the title field:

```markdown
GET /book/_search?q=title:in action

curl -XGET "http://singleElasticsearch71602:9200/book/_search?q=title:in action"
```
```markdown
GET /book/_search
{
  "query": {
    "match": {
      "title": "in action"
    }
  },
  "size": 2,
  "from": 0,
  "_source": ["title", "summary", "publish_date"]
}

curl -XGET "http://singleElasticsearch71602:9200/book/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "title": "in action"
    }
  },
  "size": 2,
  "from": 0,
  "_source": ["title", "summary", "publish_date"]
}'
```
##### Boosting

3. Boosting

```markdown
GET /book/_search
{
  "query": {
    "multi_match": {
      "query": "elasticsearch guide",
      "fields": ["title", "summary^3"]
    }
  },
  "_source": ["title", "summary", "publish_date"]
}

curl -XGET "http://singleElasticsearch71602:9200/book/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "multi_match": {
      "query": "elasticsearch guide",
      "fields": ["title", "summary^3"]
    }
  },
  "_source": ["title", "summary", "publish_date"]
}'
```
##### Bool Query

4. Search for a book with the word “Elasticsearch” OR “Solr” in the title, AND is authored by “clinton gormley” but NOT authored by “radu gheorge”

```markdown
GET /book/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "bool": {
            "should": [
              {
                "match": {
                "title": "Elasticsearch"
                }
              },
              {
                "match": {
                  "title": "Solr"
                }
              }
            ],
            "must": [
              {
                "match": {
                  "authors": "clinton gormely"
                }
              }
            ]
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "authors": "radu gheorge"
          }
        }
      ]
    }
  }
}

curl -XGET "http://singleElasticsearch71602:9200/book/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        {
          "bool": {
            "should": [
              {
                "match": {
                "title": "Elasticsearch"
                }
              },
              {
                "match": {
                  "title": "Solr"
                }
              }
            ],
            "must": [
              {
                "match": {
                  "authors": "clinton gormely"
                }
              }
            ]
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "authors": "radu gheorge"
          }
        }
      ]
    }
  }
}'
```

```markdown
# simplified version
GET /book/_search
{
  "query": {
    "bool": {
      "must": {
        "bool": {
          "should": [
            {"match": {"title": "Elasticsearch"}},
            {"match": {"title": "Solr"}}
          ],
          "must": {"match": {"authors": "clinton gormely"}}
        }
      },
      "must_not": {"match": {"authors": "radu gheorge"}}
    }
  }
}

curl -XGET "http://singleElasticsearch71602:9200/book/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": {
        "bool": {
          "should": [
            {"match": {"title": "Elasticsearch"}},
            {"match": {"title": "Solr"}}
          ],
          "must": {"match": {"authors": "clinton gormely"}}
        }
      },
      "must_not": {"match": {"authors": "radu gheorge"}}
    }
  }
}'
```
