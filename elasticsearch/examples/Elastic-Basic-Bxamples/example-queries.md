### Example Queries

***Create an index***

***1. Create a new index and index some documents using the [bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html):***

<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
PUT /book
{ 
  "settings": { "number_of_shards": 1 }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPUT "http://localhost:9200/book?pretty" -H 'Content-Type: application/json' -d'
{ 
  "settings": { "number_of_shards": 1 }
}'
```

</details>

</blockquote></details>


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_bulk
{"index":{"_id":1}}
{"title":"Elasticsearch: The Definitive Guide","authors":["clinton gormley","zachary tong"],"summary":"A distibuted real-time search and analytics engine","publish_date":"2015-02-07","num_reviews":20,"publisher":"oreilly"}
{"index":{"_id":2}}
{"title":"Taming Text: How to Find, Organize, and Manipulate It","authors":["grant ingersoll","thomas morton","drew farris"],"summary":"organize text using approaches such as full-text search, proper name recognition, clustering, tagging, information extraction, and summarization","publish_date":"2013-01-24","num_reviews":12,"publisher":"manning"}
{"index":{"_id":3}}
{"title":"Elasticsearch in Action","authors":["radu gheorge","matthew lee hinman","roy russo"],"summary":"build scalable search applications using Elasticsearch without having to do complex low-level programming or understand advanced data science algorithms","publish_date":"2015-12-03","num_reviews":18,"publisher":"manning"}
{"index":{"_id":4}}
{"title":"Solr in Action","authors":["trey grainger","timothy potter"],"summary":"Comprehensive guide to implementing a scalable search engine using Apache Solr","publish_date":"2014-04-05","num_reviews":23,"publisher":"manning"}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_bulk?pretty" -H 'Content-Type: application/json' -d'
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

</details>

</blockquote></details>

***Basic match query***

***2. Basic match query(searches for the string “guide” in all the fields)***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
GET /book/_search?q=guide
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET "http://localhost:9200/book/_search?q=guide"
```

</details>

</blockquote></details>

<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
GET /book/_search
{
  "query": {
    "multi_match": {
      "query": "guide",
      "fields": ["title", "authors", "summary", "publisher"]
    }
  }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "multi_match": {
      "query": "guide",
      "fields": ["title", "authors", "summary", "publisher"]
    }
  }
}'
```

</details>

</blockquote></details>

***2. Search for books with the words “in Action” in the title field:***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
GET /book/_search?q=title:in action
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET "http://localhost:9200/book/_search?q=title:in action"
```

</details>

</blockquote></details>

<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
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
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
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

</details>

</blockquote></details>

***Boosting***

***3. Boosting***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
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
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
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

</details>

</blockquote></details>

***Bool Query***

***4. Search for a book with the word “Elasticsearch” OR “Solr” in the title, AND is authored by “clinton gormley” but NOT authored by “radu gheorge”***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
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
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
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

</details>

</blockquote></details>


***simplified version***

<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
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
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
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

</details>

</blockquote></details>

***Fuzzy Queries***

***5. Fuzzy matching can be enabled on Match and Multi-Match queries to catch spelling errors. ***

<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search
{
  "query": {
    "multi_match": {
      "query": "comprihensiv guide",
      "fields": ["title", "summary"],
      "fuzziness": "AUTO"
    }
  },
  "_source": ["title", "summary", "publish_date"],
  "size": 1
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "multi_match": {
      "query": "comprihensiv guide",
      "fields": ["title", "summary"],
      "fuzziness": "AUTO"
    }
  },
  "_source": ["title", "summary", "publish_date"],
  "size": 1
}'
```

</details>

  <details><summary><i>Response:</i></summary>

```json
...
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 2.4344182,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 2.4344182,
        "_source" : {
          "summary" : "Comprehensive guide to implementing a scalable search engine using Apache Solr",
          "title" : "Solr in Action",
          "publish_date" : "2014-04-05"
        }
 .....       
```
</details>

</details>

</blockquote></details>


**Note:** Instead of specifying "AUTO" you can specify the numbers 0, 1, or 2 to indicate the maximum number of edits that can be made to the string to find a match.

***Wildcard Query***

Wildcard queries allow you to specify a pattern to match instead of the entire term. ? matches any character and * matches zero or more characters.

***6. find all records that have an author whose name begins with the letter ‘t’:***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search
{
  "query": {
    "wildcard": {
      "authors": {
        "value": "t*"
      }
    }
  },
  "_source": ["title", "authors"],
  "highlight": {
    "fields": {
      "authors": {}
    }
  }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "wildcard": {
      "authors": {
        "value": "t*"
      }
    }
  },
  "_source": ["title", "authors"],
  "highlight": {
    "fields": {
      "authors": {}
    }
  }
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
      "value" : 3,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "title" : "Elasticsearch: The Definitive Guide",
          "authors" : [
            "clinton gormley",
            "zachary tong"
          ]
        },
        "highlight" : {
          "authors" : [
            "zachary <em>tong</em>"
          ]
        }
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "title" : "Taming Text: How to Find, Organize, and Manipulate It",
          "authors" : [
            "grant ingersoll",
            "thomas morton",
            "drew farris"
          ]
        },
        "highlight" : {
          "authors" : [
            "<em>thomas</em> morton"
          ]
        }
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "title" : "Solr in Action",
          "authors" : [
            "trey grainger",
            "timothy potter"
          ]
        },
        "highlight" : {
          "authors" : [
            "<em>trey</em> grainger",
            "<em>timothy</em> potter"
          ]
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Regexp Query***

***7. Regexp Query***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search
{
  "query": {
    "regexp": {
      "authors": "t[a-z]*y"
    }
  },
  "_source": ["title", "authors"],
  "highlight": {
    "fields": {
      "authors": {}
    }
  }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "regexp": {
      "authors": "t[a-z]*y"
    }
  },
  "_source": ["title", "authors"],
  "highlight": {
    "fields": {
      "authors": {}
    }
  }
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "title" : "Solr in Action",
          "authors" : [
            "trey grainger",
            "timothy potter"
          ]
        },
        "highlight" : {
          "authors" : [
            "<em>trey</em> grainger",
            "<em>timothy</em> potter"
          ]
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Match Phrase Query***

The match phrase query requires that all the terms in the query string be present in the document, be in the order specified in the query string and be close to each other. By default, the terms are required to be exactly beside each other but you can specify the slop value which indicates how far apart terms are allowed to be while still considering the document a match.

***8. Match Phrase Query***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search
{
  "query": {
    "multi_match": {
      "query": "search engine",
      "fields": ["title", "summary"],
      "type": "phrase",
      "slop": 3
    }
  },
  "_source": ["title", "summary", "publish_date"]
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "multi_match": {
      "query": "search engine",
      "fields": ["title", "summary"],
      "type": "phrase",
      "slop": 3
    }
  },
  "_source": ["title", "summary", "publish_date"]
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

```json
{
  "took" : 8,
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
    "max_score" : 0.88067603,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 0.88067603,
        "_source" : {
          "summary" : "Comprehensive guide to implementing a scalable search engine using Apache Solr",
          "title" : "Solr in Action",
          "publish_date" : "2014-04-05"
        }
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.5142931,
        "_source" : {
          "summary" : "A distibuted real-time search and analytics engine",
          "title" : "Elasticsearch: The Definitive Guide",
          "publish_date" : "2015-02-07"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Match Phrase Prefix***

Match phrase prefix queries provide search-as-you-type or a poor man’s version of autocomplete at query time without needing to prepare your data in any way. Like the match_phrase query, it accepts a slop parameter to make the word order and relative positions somewhat less rigid. It also accepts the max_expansions parameter to limit the number of terms matched in order to reduce resource intensity.

***9. Match Phrase Prefix***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search
{
  "query": {
    "match_phrase_prefix": {
      "summary": {
        "query": "search en",
        "slop": 3 ,
        "max_expansions": 10
      }
    }
  },
  "_source": ["title", "summary", "publish_date"]
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_phrase_prefix": {
      "summary": {
        "query": "search en",
        "slop": 3 ,
        "max_expansions": 10
      }
    }
  },
  "_source": ["title", "summary", "publish_date"]
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 0.88067603,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 0.88067603,
        "_source" : {
          "summary" : "Comprehensive guide to implementing a scalable search engine using Apache Solr",
          "title" : "Solr in Action",
          "publish_date" : "2014-04-05"
        }
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.5142931,
        "_source" : {
          "summary" : "A distibuted real-time search and analytics engine",
          "title" : "Elasticsearch: The Definitive Guide",
          "publish_date" : "2015-02-07"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

**Note:** Using the match phrase prefix query for search autocompletion

***Query String***

The query_string query provides a means of executing multi_match queries, bool queries, boosting, fuzzy matching, wildcards, regexp, and range queries in a concise shorthand syntax.

***10. Search for the terms “search algorithm” in which one of the book authors is “grant ingersoll” or “tom morton.” apply a boost of 2 to the summary field.***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search
{
  "query": {
    "query_string": {
      "query": "(search~1 algorithm~1) AND (grant ingersoll) OR (tom morton)",
      "fields": ["title", "authors", "summary^2"]
    }
  },
  "_source": ["title", "summary", "authors"],
  "highlight": {
    "fields": {
      "summary": {}
    }
  }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "query_string": {
      "query": "(search~1 algorithm~1) AND (grant ingersoll) OR (tom morton)",
      "fields": ["title", "authors", "summary^2"]
    }
  },
  "_source": ["title", "summary", "authors"],
  "highlight": {
    "fields": {
      "summary": {}
    }
  }
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

```json
{
  "took" : 13,
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
    "max_score" : 3.6027284,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 3.6027284,
        "_source" : {
          "summary" : "organize text using approaches such as full-text search, proper name recognition, clustering, tagging, information extraction, and summarization",
          "title" : "Taming Text: How to Find, Organize, and Manipulate It",
          "authors" : [
            "grant ingersoll",
            "thomas morton",
            "drew farris"
          ]
        },
        "highlight" : {
          "summary" : [
            "organize text using approaches such as full-text <em>search</em>, proper name recognition, clustering, tagging"
          ]
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Simple Query String***

The simple_query_string query is a version of the query_string query that is more suitable for use in a single search box that is exposed to users because it replaces the use of AND/OR/NOT with +/|/-, respectively, and it discards invalid parts of a query instead of throwing an exception if a user makes a mistake.

***11. Simple Query String***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search
{
  "query": {
    "simple_query_string": {
      "query": "(search~1 algorithm~1) + (grant ingersoll) | (tom morton)",
      "fields": ["title", "authors", "summary^2"]
    }
  },
  "_source": ["title", "summary", "authors"],
  "highlight": {
    "fields": {
      "summary": {}
    }
  }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "simple_query_string": {
      "query": "(search~1 algorithm~1) + (grant ingersoll) | (tom morton)",
      "fields": ["title", "authors", "summary^2"]
    }
  },
  "_source": ["title", "summary", "authors"],
  "highlight": {
    "fields": {
      "summary": {}
    }
  }
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 3.6027284,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 3.6027284,
        "_source" : {
          "summary" : "organize text using approaches such as full-text search, proper name recognition, clustering, tagging, information extraction, and summarization",
          "title" : "Taming Text: How to Find, Organize, and Manipulate It",
          "authors" : [
            "grant ingersoll",
            "thomas morton",
            "drew farris"
          ]
        },
        "highlight" : {
          "summary" : [
            "organize text using approaches such as full-text <em>search</em>, proper name recognition, clustering, tagging"
          ]
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Term/Terms Query***

***12. Search for all books in our index published by Manning Publications.***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search
{
  "query": {
    "term": {
      "publisher": {
        "value": "manning"
      }
    }
  },
  "_source": ["title", "publish_date", "publisher"]
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "term": {
      "publisher": {
        "value": "manning"
      }
    }
  },
  "_source": ["title", "publish_date", "publisher"]
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
    "max_score" : 0.35667494,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 0.35667494,
        "_source" : {
          "publisher" : "manning",
          "title" : "Taming Text: How to Find, Organize, and Manipulate It",
          "publish_date" : "2013-01-24"
        }
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 0.35667494,
        "_source" : {
          "publisher" : "manning",
          "title" : "Elasticsearch in Action",
          "publish_date" : "2015-12-03"
        }
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 0.35667494,
        "_source" : {
          "publisher" : "manning",
          "title" : "Solr in Action",
          "publish_date" : "2014-04-05"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***13. Search for all books in our index published by oreilly or packt Publications.***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search?pretty
{
  "query": {
    "terms": {
      "publisher": ["oreilly", "packt"]
    }
  },
  "_source": ["title", "publish_date", "publisher"]
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "terms": {
      "publisher": ["oreilly", "packt"]
    }
  },
  "_source": ["title", "publish_date", "publisher"]
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "publisher" : "oreilly",
          "title" : "Elasticsearch: The Definitive Guide",
          "publish_date" : "2015-02-07"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Term Query - Sorted***

***14. Search for all books in our index published by Manning Publications and sort with publish date.***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search?pretty
{
  "query": {
    "term": {
      "publisher": "manning"
    }
  },
  "_source": ["title", "publish_date", "publisher"],
  "sort": [
    {
      "publish_date": {
        "order": "desc"
      }
    }
  ]
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "term": {
      "publisher": "manning"
    }
  },
  "_source": ["title", "publish_date", "publisher"],
  "sort": [
    {
      "publish_date": {
        "order": "desc"
      }
    }
  ]
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : null,
        "_source" : {
          "publisher" : "manning",
          "title" : "Elasticsearch in Action",
          "publish_date" : "2015-12-03"
        },
        "sort" : [
          1449100800000
        ]
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : null,
        "_source" : {
          "publisher" : "manning",
          "title" : "Solr in Action",
          "publish_date" : "2014-04-05"
        },
        "sort" : [
          1396656000000
        ]
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : null,
        "_source" : {
          "publisher" : "manning",
          "title" : "Taming Text: How to Find, Organize, and Manipulate It",
          "publish_date" : "2013-01-24"
        },
        "sort" : [
          1358985600000
        ]
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Range Query***

***15. Search for books published in 2015.***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search?pretty
{
  "query": {
    "range": {
      "publish_date": {
        "gte": "2015-01-01",
        "lte": "2015-12-31"
      }
    }
  },
  "_source": ["title", "publish_date", "publisher"]
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "range": {
      "publish_date": {
        "gte": "2015-01-01",
        "lte": "2015-12-31"
      }
    }
  },
  "_source": ["title", "publish_date", "publisher"]
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "publisher" : "oreilly",
          "title" : "Elasticsearch: The Definitive Guide",
          "publish_date" : "2015-02-07"
        }
      },
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "publisher" : "manning",
          "title" : "Elasticsearch in Action",
          "publish_date" : "2015-12-03"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Bool Query***

***16. Search for books with the term “Elasticsearch” in the title or summary but we want to filter our results to only those with 20 or more reviews.***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search?pretty
{
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "elasticsearch",
            "fields": ["title", "summary"]
          }
        }
      ],
      "filter": [
        {
          "range": {
            "num_reviews": {
              "gte": 20
            }
          }
        }
      ]
    }
  },
  "_source": ["title","summary","publisher", "num_reviews"]
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "elasticsearch",
            "fields": ["title", "summary"]
          }
        }
      ],
      "filter": [
        {
          "range": {
            "num_reviews": {
              "gte": 20
            }
          }
        }
      ]
    }
  },
  "_source": ["title","summary","publisher", "num_reviews"]
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
    "max_score" : 0.74101156,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.74101156,
        "_source" : {
          "summary" : "A distibuted real-time search and analytics engine",
          "publisher" : "oreilly",
          "num_reviews" : 20,
          "title" : "Elasticsearch: The Definitive Guide"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***17. Search for books that have at least 20 reviews, must not be published before 2015 and should be published by O'Reilly.***


<details open><summary><i></i></summary><blockquote>

<details open><summary><i>dev tools</i></summary>

```json
POST /book/_search?pretty
{
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "elasticsearch",
            "fields": ["title", "summary"]
          }
        }
      ],
      "filter": [
        {
          "range": {
            "num_reviews": {
              "gte": 20
            }
          }
        }
      ],
      "must_not": [
        {
          "range": {
            "publish_date": {
              "lte": "2014-12-31"
            }
          }
        }
      ]
    }
  },
  "_source": ["title","summary","publisher", "num_reviews", "publish_date"]
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XPOST "http://localhost:9200/book/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "elasticsearch",
            "fields": ["title", "summary"]
          }
        }
      ],
      "filter": [
        {
          "range": {
            "num_reviews": {
              "gte": 20
            }
          }
        }
      ],
      "must_not": [
        {
          "range": {
            "publish_date": {
              "lte": "2014-12-31"
            }
          }
        }
      ]
    }
  },
  "_source": ["title","summary","publisher", "num_reviews", "publish_date"]
}'
  ```

</details>

</blockquote></details>

  <details><summary><i>Response:</i></summary><blockquote>

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
    "max_score" : 0.74101156,
    "hits" : [
      {
        "_index" : "book",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.74101156,
        "_source" : {
          "summary" : "A distibuted real-time search and analytics engine",
          "publisher" : "oreilly",
          "num_reviews" : 20,
          "title" : "Elasticsearch: The Definitive Guide",
          "publish_date" : "2015-02-07"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

***Function Score***


