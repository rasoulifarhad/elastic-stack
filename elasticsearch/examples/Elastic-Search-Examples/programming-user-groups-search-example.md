	### Search

See [elasticsearch7 query filter aggregation workshop](https://github.com/mtumilowicz/elasticsearch7-query-filter-aggregation-workshop)

#### Create index

```json

PUT /programming-user-groups
{
  "settings": {
    "index": {
      "number_of_replicas": 0,
      "number_of_shards": 1
    },
    "analysis": {
      "analyzer": {
        "std_english": {
          "type": "standard",
          "stopwords": "_english_"
        }
      }
    }
  }, 
  "mappings": {
    "properties": {
      "name": { "type": "text" },
      "organizer": { "type": "text" },
      "description": { 
        "type": "text",
        "analyzer": "std_english",
        "fields": {
          "standard": {
            "type": "text",
            "analyzer": "standard"
          }
        }
      },
      "created_on": { 
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd"
      },
      "tags": { "type": "keyword" },
      "members": { "type": "text" },
      "location_group": { "type": "text" }
    }
  }
}

```

##### Test Analyzer

Test A built-in analyzer:

```json

POST _analyze
{
  "analyzer": "whitespace",
  "text": "The quick brown fox."
}

```

<details>
  <summary>Response:</summary>

```json

{
  "tokens" : [
    {
      "token" : "The",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "word",
      "position" : 0
    },
    {
      "token" : "quick",
      "start_offset" : 4,
      "end_offset" : 9,
      "type" : "word",
      "position" : 1
    },
    {
      "token" : "brown",
      "start_offset" : 10,
      "end_offset" : 15,
      "type" : "word",
      "position" : 2
    },
    {
      "token" : "fox.",
      "start_offset" : 16,
      "end_offset" : 20,
      "type" : "word",
      "position" : 3
    }
  ]
}

```

</details>

Test combinations of:

- A tokenizer
- Zero or more token filters
- Zero or more character filters

```json

POST _analyze
{
  "tokenizer": "standard",
  "filter": [ "lowercase", "asciifolding" ],
  "text": "Is this déja vu?"
}

```

<details>
  <summary>Response:</summary>

```json

{
  "tokens" : [
    {
      "token" : "is",
      "start_offset" : 0,
      "end_offset" : 2,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "this",
      "start_offset" : 3,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "deja",
      "start_offset" : 8,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "vu",
      "start_offset" : 13,
      "end_offset" : 15,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}

```

</details>

Custom analyzer can be referred to when running the analyze API on a specific index:

```json

POST programming-user-groups/_analyze
{
  "field": "description",
  "text": "The old brown cow"
}

```

<details>
  <summary>Response:</summary>

```json

{
  "tokens" : [
    {
      "token" : "old",
      "start_offset" : 4,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "brown",
      "start_offset" : 8,
      "end_offset" : 13,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "cow",
      "start_offset" : 14,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}

```

</details>

```json

POST programming-user-groups/_analyze
{
  "field": "description.standard",
  "text": "The old brown cow"
}

```

<details>
  <summary>Response:</summary>

```json

{
  "tokens" : [
    {
      "token" : "the",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "old",
      "start_offset" : 4,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "brown",
      "start_offset" : 8,
      "end_offset" : 13,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "cow",
      "start_offset" : 14,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}

```

</details>

```json

GET programming-user-groups/_analyze
{
  "analyzer": "std_english",
  "text": "The old brown cow"
}

GET programming-user-groups/_analyze
{
  "analyzer": "standard",
  "text": "The old brown cow"
}

GET programming-user-groups/_analyze
{
  "field": "description", 
  "text": "The old brown cow"
}

GET programming-user-groups/_analyze
{
  "field": "description.standard", 
  "text": "The old brown cow"
}

```

#### Index Documents

```json

PUT /programming-user-groups/_doc/1
{
  "name": "Denver Clojure",
  "organizer": ["Daniel", "Lee"],
  "description": "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
  "created_on": "2012-06-15",
  "tags": ["clojure", "denver", "functional programming", "jvm", "java"],
  "members": ["Lee", "Daniel", "Mike"],
  "location_group": "Denver, Colorado, USA"
}

```

```json

PUT /programming-user-groups/_doc/2
{
  "name": "Elasticsearch Denver",
  "organizer": "Lee",
  "description": "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
  "created_on": "2013-03-15",
  "tags": ["denver", "elasticsearch", "big data", "lucene", "solr"],
  "members": ["Lee", "Mike"],
  "location_group": "Denver, Colorado, USA"
}

```

```json

PUT /programming-user-groups/_doc/3
{
  "name": "Elasticsearch San Francisco",
  "organizer": "Mik",
  "description": "Elasticsearch group for ES users of all knowledge levels",
  "created_on": "2012-08-07",
  "tags": ["elasticsearch", "big data", "lucene", "open source"],
  "members": ["Lee", "Igor"],
  "location_group": "San Francisco, California, USA"
}

```

```json

PUT /programming-user-groups/_doc/4
{
  "name": "Boulder/Denver big data get-together",
  "organizer": "Andy",
  "description": "Come learn and share your experience with nosql & big data technologies, no experience required",
  "created_on": "2010-04-02",
  "tags": ["big data", "data visualization", "open source", "cloud computing", "hadoop"],
  "members": ["Greg", "Bill"],
  "location_group": "Boulder, Colorado, USA"
}

```

```json

PUT /programming-user-groups/_doc/5
{
  "name": "Enterprise search London get-together",
  "organizer": "Tyler",
  "description": "Enterprise search get-togethers are an opportunity to get together with other people doing search.",
  "created_on": "2009-11-25",
  "tags": ["enterprise search", "apache lucene", "solr", "open source", "text analytics"],
  "members": ["Clint", "James"],
  "location_group": "London, England, UK"
}

```

#### Verify index

```json

GET /programming-user-groups

```

<details>
  <summary>Response:</summary>

```json

{
  "programming-user-groups" : {
    "aliases" : { },
    "mappings" : {
      "properties" : {
        "created_on" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd"
        },
        "description" : {
          "type" : "text",
          "fields" : {
            "standard" : {
              "type" : "text",
              "analyzer" : "standard"
            }
          },
          "analyzer" : "std_english"
        },
        "location_group" : {
          "type" : "text"
        },
        "members" : {
          "type" : "text"
        },
        "name" : {
          "type" : "text"
        },
        "organizer" : {
          "type" : "text"
        },
        "tags" : {
          "type" : "keyword"
        }
      }
    },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "programming-user-groups",
        "creation_date" : "1682638256023",
        "analysis" : {
          "analyzer" : {
            "std_english" : {
              "type" : "standard",
              "stopwords" : "_english_"
            }
          }
        },
        "number_of_replicas" : "0",
        "uuid" : "lzSVyrDpRFuABeijxk_T6Q",
        "version" : {
          "created" : "7170999"
        }
      }
    }
  }
}

```

</details>

#### Analyze example text 

```json

GET programming-user-groups/_analyze
{
  "analyzer": "std_english",
  "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
}

```

<details>
  <summary>Response:</summary>

```json

{
  "tokens" : [
    {
      "token" : "2",
      "start_offset" : 4,
      "end_offset" : 5,
      "type" : "<NUM>",
      "position" : 1
    },
    {
      "token" : "quick",
      "start_offset" : 6,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "brown",
      "start_offset" : 12,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "foxes",
      "start_offset" : 18,
      "end_offset" : 23,
      "type" : "<ALPHANUM>",
      "position" : 4
    },
    {
      "token" : "jumped",
      "start_offset" : 24,
      "end_offset" : 30,
      "type" : "<ALPHANUM>",
      "position" : 5
    },
    {
      "token" : "over",
      "start_offset" : 31,
      "end_offset" : 35,
      "type" : "<ALPHANUM>",
      "position" : 6
    },
    {
      "token" : "lazy",
      "start_offset" : 40,
      "end_offset" : 44,
      "type" : "<ALPHANUM>",
      "position" : 8
    },
    {
      "token" : "dog's",
      "start_offset" : 45,
      "end_offset" : 50,
      "type" : "<ALPHANUM>",
      "position" : 9
    },
    {
      "token" : "bone",
      "start_offset" : 51,
      "end_offset" : 55,
      "type" : "<ALPHANUM>",
      "position" : 10
    }
  ]
}

```

</details>

```json

GET programming-user-groups/_analyze
{
  "field": "description", 
  "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
}

```

<details>
  <summary>Response:</summary>

```json

{
  "tokens" : [
    {
      "token" : "2",
      "start_offset" : 4,
      "end_offset" : 5,
      "type" : "<NUM>",
      "position" : 1
    },
    {
      "token" : "quick",
      "start_offset" : 6,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "brown",
      "start_offset" : 12,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "foxes",
      "start_offset" : 18,
      "end_offset" : 23,
      "type" : "<ALPHANUM>",
      "position" : 4
    },
    {
      "token" : "jumped",
      "start_offset" : 24,
      "end_offset" : 30,
      "type" : "<ALPHANUM>",
      "position" : 5
    },
    {
      "token" : "over",
      "start_offset" : 31,
      "end_offset" : 35,
      "type" : "<ALPHANUM>",
      "position" : 6
    },
    {
      "token" : "lazy",
      "start_offset" : 40,
      "end_offset" : 44,
      "type" : "<ALPHANUM>",
      "position" : 8
    },
    {
      "token" : "dog's",
      "start_offset" : 45,
      "end_offset" : 50,
      "type" : "<ALPHANUM>",
      "position" : 9
    },
    {
      "token" : "bone",
      "start_offset" : 51,
      "end_offset" : 55,
      "type" : "<ALPHANUM>",
      "position" : 10
    }
  ]
}

```

</details>

```json

GET programming-user-groups/_analyze
{
  "field": "description.standard", 
  "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
}

```

<details>
  <summary>Response:</summary>

```json

{
  "tokens" : [
    {
      "token" : "the",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "2",
      "start_offset" : 4,
      "end_offset" : 5,
      "type" : "<NUM>",
      "position" : 1
    },
    {
      "token" : "quick",
      "start_offset" : 6,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "brown",
      "start_offset" : 12,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "foxes",
      "start_offset" : 18,
      "end_offset" : 23,
      "type" : "<ALPHANUM>",
      "position" : 4
    },
    {
      "token" : "jumped",
      "start_offset" : 24,
      "end_offset" : 30,
      "type" : "<ALPHANUM>",
      "position" : 5
    },
    {
      "token" : "over",
      "start_offset" : 31,
      "end_offset" : 35,
      "type" : "<ALPHANUM>",
      "position" : 6
    },
    {
      "token" : "the",
      "start_offset" : 36,
      "end_offset" : 39,
      "type" : "<ALPHANUM>",
      "position" : 7
    },
    {
      "token" : "lazy",
      "start_offset" : 40,
      "end_offset" : 44,
      "type" : "<ALPHANUM>",
      "position" : 8
    },
    {
      "token" : "dog's",
      "start_offset" : 45,
      "end_offset" : 50,
      "type" : "<ALPHANUM>",
      "position" : 9
    },
    {
      "token" : "bone",
      "start_offset" : 51,
      "end_offset" : 55,
      "type" : "<ALPHANUM>",
      "position" : 10
    }
  ]
}

```

</details>

```json

GET programming-user-groups/_analyze
{
  "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
}

```

<details>
  <summary>Response:</summary>

```json

{
  "tokens" : [
    {
      "token" : "the",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "2",
      "start_offset" : 4,
      "end_offset" : 5,
      "type" : "<NUM>",
      "position" : 1
    },
    {
      "token" : "quick",
      "start_offset" : 6,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "brown",
      "start_offset" : 12,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "foxes",
      "start_offset" : 18,
      "end_offset" : 23,
      "type" : "<ALPHANUM>",
      "position" : 4
    },
    {
      "token" : "jumped",
      "start_offset" : 24,
      "end_offset" : 30,
      "type" : "<ALPHANUM>",
      "position" : 5
    },
    {
      "token" : "over",
      "start_offset" : 31,
      "end_offset" : 35,
      "type" : "<ALPHANUM>",
      "position" : 6
    },
    {
      "token" : "the",
      "start_offset" : 36,
      "end_offset" : 39,
      "type" : "<ALPHANUM>",
      "position" : 7
    },
    {
      "token" : "lazy",
      "start_offset" : 40,
      "end_offset" : 44,
      "type" : "<ALPHANUM>",
      "position" : 8
    },
    {
      "token" : "dog's",
      "start_offset" : 45,
      "end_offset" : 50,
      "type" : "<ALPHANUM>",
      "position" : 9
    },
    {
      "token" : "bone",
      "start_offset" : 51,
      "end_offset" : 55,
      "type" : "<ALPHANUM>",
      "position" : 10
    }
  ]
}
  
```

</details>

#### Verify terms document 1

```json

GET /programming-user-groups/_termvectors/1?fields=description

```

<details>
  <summary>Response:</summary>

```json

{
  "_index" : "programming-user-groups",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "took" : 0,
  "term_vectors" : {
    "description" : {
      "field_statistics" : {
        "sum_doc_freq" : 53,
        "doc_count" : 5,
        "sum_ttf" : 57
      },
      "terms" : {
        "about" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 16,
              "start_offset" : 90,
              "end_offset" : 95
            }
          ]
        },
        "clojure" : {
          "term_freq" : 2,
          "tokens" : [
            {
              "position" : 2,
              "start_offset" : 9,
              "end_offset" : 16
            },
            {
              "position" : 17,
              "start_offset" : 96,
              "end_offset" : 103
            }
          ]
        },
        "code" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 11,
              "start_offset" : 61,
              "end_offset" : 65
            }
          ]
        },
        "denver" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 5,
              "start_offset" : 34,
              "end_offset" : 40
            }
          ]
        },
        "enthusiasts" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 3,
              "start_offset" : 17,
              "end_offset" : 28
            }
          ]
        },
        "from" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 4,
              "start_offset" : 29,
              "end_offset" : 33
            }
          ]
        },
        "group" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 0,
              "start_offset" : 0,
              "end_offset" : 5
            }
          ]
        },
        "hack" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 9,
              "start_offset" : 53,
              "end_offset" : 57
            }
          ]
        },
        "learn" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 14,
              "start_offset" : 79,
              "end_offset" : 84
            }
          ]
        },
        "more" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 15,
              "start_offset" : 85,
              "end_offset" : 89
            }
          ]
        },
        "together" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 12,
              "start_offset" : 66,
              "end_offset" : 74
            }
          ]
        },
        "want" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 7,
              "start_offset" : 45,
              "end_offset" : 49
            }
          ]
        },
        "who" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 6,
              "start_offset" : 41,
              "end_offset" : 44
            }
          ]
        }
      }
    }
  }
}

```

</details>

Try this:

```json

GET /programming-user-groups/_termvectors/1?fields=description.standard

```

<details>
  <summary>Response:</summary>

```json

{
  "_index" : "programming-user-groups",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "took" : 0,
  "term_vectors" : {
    "description.standard" : {
      "field_statistics" : {
        "sum_doc_freq" : 70,
        "doc_count" : 5,
        "sum_ttf" : 74
      },
      "terms" : {
        "about" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 16,
              "start_offset" : 90,
              "end_offset" : 95
            }
          ]
        },
        "and" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 13,
              "start_offset" : 75,
              "end_offset" : 78
            }
          ]
        },
        "clojure" : {
          "term_freq" : 2,
          "tokens" : [
            {
              "position" : 2,
              "start_offset" : 9,
              "end_offset" : 16
            },
            {
              "position" : 17,
              "start_offset" : 96,
              "end_offset" : 103
            }
          ]
        },
        "code" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 11,
              "start_offset" : 61,
              "end_offset" : 65
            }
          ]
        },
        "denver" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 5,
              "start_offset" : 34,
              "end_offset" : 40
            }
          ]
        },
        "enthusiasts" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 3,
              "start_offset" : 17,
              "end_offset" : 28
            }
          ]
        },
        "from" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 4,
              "start_offset" : 29,
              "end_offset" : 33
            }
          ]
        },
        "group" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 0,
              "start_offset" : 0,
              "end_offset" : 5
            }
          ]
        },
        "hack" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 9,
              "start_offset" : 53,
              "end_offset" : 57
            }
          ]
        },
        "learn" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 14,
              "start_offset" : 79,
              "end_offset" : 84
            }
          ]
        },
        "more" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 15,
              "start_offset" : 85,
              "end_offset" : 89
            }
          ]
        },
        "of" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 1,
              "start_offset" : 6,
              "end_offset" : 8
            }
          ]
        },
        "on" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 10,
              "start_offset" : 58,
              "end_offset" : 60
            }
          ]
        },
        "to" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 8,
              "start_offset" : 50,
              "end_offset" : 52
            }
          ]
        },
        "together" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 12,
              "start_offset" : 66,
              "end_offset" : 74
            }
          ]
        },
        "want" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 7,
              "start_offset" : 45,
              "end_offset" : 49
            }
          ]
        },
        "who" : {
          "term_freq" : 1,
          "tokens" : [
            {
              "position" : 6,
              "start_offset" : 41,
              "end_offset" : 44
            }
          ]
        }
      }
    }
  }
}

```

</details>

And Try this: 

```json

GET /programming-user-groups/_termvectors/1?fields=created_on

```

<details>
  <summary>Response:</summary>

```json

{
  "_index" : "programming-user-groups",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "took" : 0,
  "term_vectors" : { }
}

```

</details>

#### Search

##### search `clojure` or `group` (ignore case) in `description` field.

```json

GET /programming-user-groups/_search
{
  "query": {
    "match": {
      "description": "group clojure"
    }
  }
}

```

<details>
  <summary>Response:</summary>

```json

{
  "took" : 9,
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
    "max_score" : 2.592012,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 2.592012,
        "_source" : {
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 1.0396191,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      }
    ]
  }
}

```

</details>

##### search `clojure` and `group` (ignore case) . the more the higher the score.

```json

GET /programming-user-groups/_search
{
  "query": {
    "query_string": {
      "query": "clojure AND group"
    }
  }
}

```

<details>
  <summary>Response:</summary>

```json

{
  "took" : 18,
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
    "max_score" : 2.8546424,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 2.8546424,
        "_source" : {
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  }
}

```

</details>

##### search `group clojure` in `description` field - suppose at most 1 words between

```json

GET /programming-user-groups/_search
{
  "query": {
    "match_phrase": {
      "description": {
        "query": "group clojure"
      }
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
      "value" : 0,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  }
}

```

</details>

**With slop = 1**

```json

GET /programming-user-groups/_search
{
  "query": {
    "match_phrase": {
      "description": {
        "query": "group clojure",
        "slop": 1
      }
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
    "max_score" : 1.3058243,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.3058243,
        "_source" : {
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  }
}

```

</details>


##### Search for group created after 2011.

```json

GET /programming-user-groups/_search
{
  "query": {
    "range": {
      "created_on": {
        "gte": "2011-01-01"
      }
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
      "value" : 3,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      }
    ]
  }
}

```

</details>

##### find all organized by Lee

```json

GET /programming-user-groups/_search
{
  "query": {
    "term": {
      "organizer": {
        "value": "lee"
      }
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
    "max_score" : 0.9395274,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 0.9395274,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.68786836,
        "_source" : {
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  }
}

```

</details>

##### find all not organized by Lee

```json

GET /programming-user-groups/_search
{
  "query": {
    "bool": {
      "must_not": [
        {
          "match": {
            "organizer": "Lee"
          }
        }
      ]
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
      "value" : 3,
      "relation" : "eq"
    },
    "max_score" : 0.0,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 0.0,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "4",
        "_score" : 0.0,
        "_source" : {
          "name" : "Boulder/Denver big data get-together",
          "organizer" : "Andy",
          "description" : "Come learn and share your experience with nosql & big data technologies, no experience required",
          "created_on" : "2010-04-02",
          "tags" : [
            "big data",
            "data visualization",
            "open source",
            "cloud computing",
            "hadoop"
          ],
          "members" : [
            "Greg",
            "Bill"
          ],
          "location_group" : "Boulder, Colorado, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "5",
        "_score" : 0.0,
        "_source" : {
          "name" : "Enterprise search London get-together",
          "organizer" : "Tyler",
          "description" : "Enterprise search get-togethers are an opportunity to get together with other people doing search.",
          "created_on" : "2009-11-25",
          "tags" : [
            "enterprise search",
            "apache lucene",
            "solr",
            "open source",
            "text analytics"
          ],
          "members" : [
            "Clint",
            "James"
          ],
          "location_group" : "London, England, UK"
        }
      }
    ]
  }
}

```

</details>

##### name has to contain elasticsearch and organizer cannot be Lee

```json

GET /programming-user-groups/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "name": "elasticsearch"
          }
        }
      ], 
      "must_not": [
        {
          "match": {
            "organizer": "Lee"
          }
        }
      ]
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
    "max_score" : 0.9395274,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 0.9395274,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      }
    ]
  }
}

```

</details>

##### event must contain group and organizer should be Lee

```json

GET /programming-user-groups/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "group"
          }
        }
      ],
      "should": [
        {
          "match": {
            "organizer": "Lee"
          }
        }
      ]
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
    "max_score" : 1.492193,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.492193,
        "_source" : {
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 1.0426211,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      }
    ]
  }
}

```

</details>

##### filter events that has tag clojure or lucene

```json

GET /programming-user-groups/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "terms": {
            "tags": [
              "clojure",
              "lucene"
            ]
          }
        }
      ]
    }
  }
}

OR

GET /programming-user-groups/_search
{
  "query": {
    "terms": {
      "tags": [
        "clojure",
        "lucene"
      ]
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
      "value" : 3,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "programming-user-groups",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      }
    ]
  }
}

```

</details>

#### aggregations

##### group by tags and display count in each bucket

```json

GET /programming-user-groups/_search
{
  "size": 0,
  "aggs": {
    "by_tags": {
      "terms": {
        "field": "tags",
        "size": 100
      }
    }
  }
}
```

<details>
  <summary>Response:</summary>

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
      "value" : 5,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "by_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "big data",
          "doc_count" : 3
        },
        {
          "key" : "open source",
          "doc_count" : 3
        },
        {
          "key" : "denver",
          "doc_count" : 2
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 2
        },
        {
          "key" : "lucene",
          "doc_count" : 2
        },
        {
          "key" : "solr",
          "doc_count" : 2
        },
        {
          "key" : "apache lucene",
          "doc_count" : 1
        },
        {
          "key" : "clojure",
          "doc_count" : 1
        },
        {
          "key" : "cloud computing",
          "doc_count" : 1
        },
        {
          "key" : "data visualization",
          "doc_count" : 1
        },
        {
          "key" : "enterprise search",
          "doc_count" : 1
        },
        {
          "key" : "functional programming",
          "doc_count" : 1
        },
        {
          "key" : "hadoop",
          "doc_count" : 1
        },
        {
          "key" : "java",
          "doc_count" : 1
        },
        {
          "key" : "jvm",
          "doc_count" : 1
        },
        {
          "key" : "text analytics",
          "doc_count" : 1
        }
      ]
    }
  }
}

```

</details>

##### group by tags and display date of the newest group in each bucket

```json

GET /programming-user-groups/_search
{
  "size": 0,
  "aggs": {
    "by_tags": {
      "terms": {
        "field": "tags",
        "size": 10
      },
      "aggs": {
        "newest_group_date": {
          "max": {
            "field": "created_on"
          }
        }
      }
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
      "value" : 5,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "by_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 6,
      "buckets" : [
        {
          "key" : "big data",
          "doc_count" : 3,
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "open source",
          "doc_count" : 3,
          "newest_group_date" : {
            "value" : 1.3442976E12,
            "value_as_string" : "2012-08-07 00:00:00"
          }
        },
        {
          "key" : "denver",
          "doc_count" : 2,
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 2,
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "lucene",
          "doc_count" : 2,
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "solr",
          "doc_count" : 2,
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "apache lucene",
          "doc_count" : 1,
          "newest_group_date" : {
            "value" : 1.2591072E12,
            "value_as_string" : "2009-11-25 00:00:00"
          }
        },
        {
          "key" : "clojure",
          "doc_count" : 1,
          "newest_group_date" : {
            "value" : 1.3397184E12,
            "value_as_string" : "2012-06-15 00:00:00"
          }
        },
        {
          "key" : "cloud computing",
          "doc_count" : 1,
          "newest_group_date" : {
            "value" : 1.2701664E12,
            "value_as_string" : "2010-04-02 00:00:00"
          }
        },
        {
          "key" : "data visualization",
          "doc_count" : 1,
          "newest_group_date" : {
            "value" : 1.2701664E12,
            "value_as_string" : "2010-04-02 00:00:00"
          }
        }
      ]
    }
  }
}

```

</details>

##### group by tags and display date of the newest and oldest group in each bucket

```json

GET /programming-user-groups/_search
{
  "size": 0,
  "aggs": {
    "by_tags": {
      "terms": {
        "field": "tags",
        "size": 10
      },
      "aggs": {
        "newest_group_date": {
          "max": {
            "field": "created_on"
          }
        },
        "oldest_group_date": {
          "min": {
            "field": "created_on"
          }
        }
      }
    }
  }
}

```

<details>
  <summary>Response:</summary>

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
      "value" : 5,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "by_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 6,
      "buckets" : [
        {
          "key" : "big data",
          "doc_count" : 3,
          "oldest_group_date" : {
            "value" : 1.2701664E12,
            "value_as_string" : "2010-04-02 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "open source",
          "doc_count" : 3,
          "oldest_group_date" : {
            "value" : 1.2591072E12,
            "value_as_string" : "2009-11-25 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.3442976E12,
            "value_as_string" : "2012-08-07 00:00:00"
          }
        },
        {
          "key" : "denver",
          "doc_count" : 2,
          "oldest_group_date" : {
            "value" : 1.3397184E12,
            "value_as_string" : "2012-06-15 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 2,
          "oldest_group_date" : {
            "value" : 1.3442976E12,
            "value_as_string" : "2012-08-07 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "lucene",
          "doc_count" : 2,
          "oldest_group_date" : {
            "value" : 1.3442976E12,
            "value_as_string" : "2012-08-07 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "solr",
          "doc_count" : 2,
          "oldest_group_date" : {
            "value" : 1.2591072E12,
            "value_as_string" : "2009-11-25 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.3633056E12,
            "value_as_string" : "2013-03-15 00:00:00"
          }
        },
        {
          "key" : "apache lucene",
          "doc_count" : 1,
          "oldest_group_date" : {
            "value" : 1.2591072E12,
            "value_as_string" : "2009-11-25 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.2591072E12,
            "value_as_string" : "2009-11-25 00:00:00"
          }
        },
        {
          "key" : "clojure",
          "doc_count" : 1,
          "oldest_group_date" : {
            "value" : 1.3397184E12,
            "value_as_string" : "2012-06-15 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.3397184E12,
            "value_as_string" : "2012-06-15 00:00:00"
          }
        },
        {
          "key" : "cloud computing",
          "doc_count" : 1,
          "oldest_group_date" : {
            "value" : 1.2701664E12,
            "value_as_string" : "2010-04-02 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.2701664E12,
            "value_as_string" : "2010-04-02 00:00:00"
          }
        },
        {
          "key" : "data visualization",
          "doc_count" : 1,
          "oldest_group_date" : {
            "value" : 1.2701664E12,
            "value_as_string" : "2010-04-02 00:00:00"
          },
          "newest_group_date" : {
            "value" : 1.2701664E12,
            "value_as_string" : "2010-04-02 00:00:00"
          }
        }
      ]
    }
  }
}

```

</details>


##### group by tags and display id and date of the newest group in each bucket

```json

GET /programming-user-groups/_search
{
  "size": 0,
  "aggs": {
    "by_tags": {
      "terms": {
        "field": "tags",
        "size": 10
      },
      "aggs": {
        "latest_event": {
          "top_hits": {
            "size": 1,
            "_source": [ "_id", "created_on" ],
            "sort": [ {"created_on": {"order": "desc"}} ]
          }
        }
      }
    }
  }
}
```

<details>
  <summary>Response:</summary>

```json

{
  "took" : 55,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 5,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "by_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 6,
      "buckets" : [
        {
          "key" : "big data",
          "doc_count" : 3,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 3,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "2",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2013-03-15"
                  },
                  "sort" : [
                    1363305600000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "open source",
          "doc_count" : 3,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 3,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "3",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2012-08-07"
                  },
                  "sort" : [
                    1344297600000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "denver",
          "doc_count" : 2,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 2,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "2",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2013-03-15"
                  },
                  "sort" : [
                    1363305600000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 2,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 2,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "2",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2013-03-15"
                  },
                  "sort" : [
                    1363305600000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "lucene",
          "doc_count" : 2,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 2,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "2",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2013-03-15"
                  },
                  "sort" : [
                    1363305600000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "solr",
          "doc_count" : 2,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 2,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "2",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2013-03-15"
                  },
                  "sort" : [
                    1363305600000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "apache lucene",
          "doc_count" : 1,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 1,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "5",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2009-11-25"
                  },
                  "sort" : [
                    1259107200000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "clojure",
          "doc_count" : 1,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 1,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "1",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2012-06-15"
                  },
                  "sort" : [
                    1339718400000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "cloud computing",
          "doc_count" : 1,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 1,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "4",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2010-04-02"
                  },
                  "sort" : [
                    1270166400000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "data visualization",
          "doc_count" : 1,
          "latest_event" : {
            "hits" : {
              "total" : {
                "value" : 1,
                "relation" : "eq"
              },
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "programming-user-groups",
                  "_type" : "_doc",
                  "_id" : "4",
                  "_score" : null,
                  "_source" : {
                    "created_on" : "2010-04-02"
                  },
                  "sort" : [
                    1270166400000
                  ]
                }
              ]
            }
          }
        }
      ]
    }
  }
}

```

</details>


