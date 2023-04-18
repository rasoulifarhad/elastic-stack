### Example Queries

##### Create an index

1. Create a new index and index some documents using the [bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html):
```markdown
PUT /book
{ 
  "settings": { "number_of_shards": 1 }
}

curl -XPUT "http://localhost:9200/book?pretty" -H 'Content-Type: application/json' -d'
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
##### Basic match query

2. Basic match query(searches for the string “guide” in all the fields)

```markdown
GET /book/_search?q=guide

curl -XGET "http://localhost:9200/book/_search?q=guide"
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

2. Search for books with the words “in Action” in the title field:

```markdown
GET /book/_search?q=title:in action

curl -XGET "http://localhost:9200/book/_search?q=title:in action"
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
##### Fuzzy Queries

5. Fuzzy matching can be enabled on Match and Multi-Match queries to catch spelling errors. 

```markdown
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

Result:
```
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

**Note:** Instead of specifying "AUTO" you can specify the numbers 0, 1, or 2 to indicate the maximum number of edits that can be made to the string to find a match.

##### Wildcard Query

Wildcard queries allow you to specify a pattern to match instead of the entire term. ? matches any character and * matches zero or more characters.

6. find all records that have an author whose name begins with the letter ‘t’:

```markdown
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
Result:

```markdown
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

##### Regexp Query

7. 

```markdown
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

Result:

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

##### Match Phrase Query

The match phrase query requires that all the terms in the query string be present in the document, be in the order specified in the query string and be close to each other. By default, the terms are required to be exactly beside each other but you can specify the slop value which indicates how far apart terms are allowed to be while still considering the document a match.

8. 

```markdown
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

Result:

```markdown
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

##### Match Phrase Prefix

Match phrase prefix queries provide search-as-you-type or a poor man’s version of autocomplete at query time without needing to prepare your data in any way. Like the match_phrase query, it accepts a slop parameter to make the word order and relative positions somewhat less rigid. It also accepts the max_expansions parameter to limit the number of terms matched in order to reduce resource intensity.

9. 

```markdown
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

Result:

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

**Note:** Using the match phrase prefix query for search autocompletion

##### Query String

The query_string query provides a means of executing multi_match queries, bool queries, boosting, fuzzy matching, wildcards, regexp, and range queries in a concise shorthand syntax.

10. Search for the terms “search algorithm” in which one of the book authors is “grant ingersoll” or “tom morton.” apply a boost of 2 to the summary field.

```markdown
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

Result:

```markdown
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

##### Simple Query String

The simple_query_string query is a version of the query_string query that is more suitable for use in a single search box that is exposed to users because it replaces the use of AND/OR/NOT with +/|/-, respectively, and it discards invalid parts of a query instead of throwing an exception if a user makes a mistake.

11. 

```markdown
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

Result:

```markdown
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

##### Term/Terms Query

12. Search for all books in our index published by Manning Publications.

```markdown
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

Result:

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

