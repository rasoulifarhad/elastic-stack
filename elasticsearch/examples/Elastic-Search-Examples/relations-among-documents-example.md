## Search

See [elasticsearch7 relations among documents workshop](https://github.com/mtumilowicz/elasticsearch7-relations-among-documents-workshop)

### Prepare Data


- Create index jukebox && league

  ```json
  PUT jukebox
  {
    "mappings": {
      "properties": {
        "artist": {
          "type": "text"
        },
        "song": {
          "type": "text"
        },
        "chosen_by": {
          "type": "keyword"
        },
        "jukebox_relations": {
          "type": "join",
          "relations": {
            "artist": "song",
            "song": "chosen_by"
          }
        }
      }
    }
  }
  ```

  ```json
  PUT league
  {
    "mappings": {
      "properties": {
        "name": {
          "type": "keyword"
        },
        "players": {
          "type": "nested",
          "properties": {
            "identity": {
              "type": "text"
            },
            "games": {
              "type": "byte"
            },
            "nationality": {
              "type": "text"
            }
          }
        }
      }
    }
  }   
  ```

- Index some documents

  ```json
  POST jukebox/_bulk
  { "create" : { "_id" : "1" } }
  {"name":"Led Zeppelin","jukebox_relations":{"name":"artist"}}
  { "create" : { "_id" : "2" } }
  {"name":"Sandy Denny","jukebox_relations":{"name":"artist"}}
  { "create" : { "_id" : "3", "_routing" : "1" } }
  {"song":"Whole lotta love","jukebox_relations":{"name":"song","parent":1}}
  { "create" : { "_id" : "4", "_routing" : "1" } }
  {"song":"Battle of Evermore","jukebox_relations":{"name":"song","parent":1}}
  { "create" : { "_id" : "5", "_routing" : "2" } }
  {"song":"Battle of Evermore","jukebox_relations":{"name":"song","parent":2}}
  { "create" : { "_id" : "u1", "_routing" : "3" } }
  {"user":"Gabriel","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "create" : { "_id" : "u2", "_routing" : "3" } }
  {"user":"Berte","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "create" : { "_id" : "u3", "_routing" : "3" } }
  {"user":"Emma","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "create" : { "_id" : "u4", "_routing" : "4" } }
  {"user":"Berte","jukebox_relations":{"name":"chosen_by","parent":4}}
  { "create" : { "_id" : "u5", "_routing" : "5" } }
  {"user":"Emma","jukebox_relations":{"name":"chosen_by","parent":5}}
  ```

  ```json
  POST league/_bulk
  { "create" : {} }
  {"name":"Team 1","players":[{"identity":"Player_1","games":30,"nationality":"FR"},{"identity":"Player_2","games":15,"nationality":"DE"},{"identity":"Player_3","games":34,"nationality":"FR"},{"identity":"Player_4","games":11,"nationality":"BR"},{"identity":"Player_5","games":4,"nationality":"BE"},{"identity":"Player_6","games":11,"nationality":"FR"}]}
  { "create" : {} }
  {"name":"Team 2","players":[{"identity":"Player_20","games":11,"nationality":"FR"},{"identity":"Player_21","games":15,"nationality":"FR"},{"identity":"Player_22","games":34,"nationality":"FR"},{"identity":"Player_23","games":30,"nationality":"FR"},{"identity":"Player_24","games":4,"nationality":"FR"},{"identity":"Player_25","games":11,"nationality":"FR"}]}
  { "create" : {} }
  {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]}
  { "create" : {} }
  {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]} 
  ```

<!--

  ```json
  POST _bulk
  { "create" : { "_index" : "jukebox", "_id" : "1" } }
  {"name":"Led Zeppelin","jukebox_relations":{"name":"artist"}}
  { "create" : { "_index" : "jukebox", "_id" : "2" } }
  {"name":"Sandy Denny","jukebox_relations":{"name":"artist"}}
  { "create" : { "_index" : "jukebox", "_id" : "3", "_routing" : "1" } }
  {"song":"Whole lotta love","jukebox_relations":{"name":"song","parent":1}}
  { "create" : { "_index" : "jukebox", "_id" : "4", "_routing" : "1" } }
  {"song":"Battle of Evermore","jukebox_relations":{"name":"song","parent":1}}
  { "create" : { "_index" : "jukebox", "_id" : "5", "_routing" : "2" } }
  {"song":"Battle of Evermore","jukebox_relations":{"name":"song","parent":2}}
  { "create" : { "_index" : "jukebox", "_id" : "u1", "_routing" : "3" } }
  {"user":"Gabriel","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "create" : { "_index" : "jukebox", "_id" : "u2", "_routing" : "3" } }
  {"user":"Berte","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "create" : { "_index" : "jukebox", "_id" : "u3", "_routing" : "3" } }
  {"user":"Emma","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "create" : { "_index" : "jukebox", "_id" : "u4", "_routing" : "4" } }
  {"user":"Berte","jukebox_relations":{"name":"chosen_by","parent":4}}
  { "create" : { "_index" : "jukebox", "_id" : "u5", "_routing" : "5" } }
  {"user":"Emma","jukebox_relations":{"name":"chosen_by","parent":5}}
  ```

  ```json
  POST _bulk
  { "index" : { "_index" : "jukebox", "_id" : "1" } }
  {"name":"Led Zeppelin","jukebox_relations":{"name":"artist"}}
  { "index" : { "_index" : "jukebox", "_id" : "2" } }
  {"name":"Sandy Denny","jukebox_relations":{"name":"artist"}}
  { "index" : { "_index" : "jukebox", "_id" : "3", "_routing" : "1" } }
  {"song":"Whole lotta love","jukebox_relations":{"name":"song","parent":1}}
  { "index" : { "_index" : "jukebox", "_id" : "4", "_routing" : "1" } }
  {"song":"Battle of Evermore","jukebox_relations":{"name":"song","parent":1}}
  { "index" : { "_index" : "jukebox", "_id" : "5", "_routing" : "2" } }
  {"song":"Battle of Evermore","jukebox_relations":{"name":"song","parent":2}}
  { "index" : { "_index" : "jukebox", "_id" : "u1", "_routing" : "3" } }
  {"user":"Gabriel","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "index" : { "_index" : "jukebox", "_id" : "u2", "_routing" : "3" } }
  {"user":"Berte","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "index" : { "_index" : "jukebox", "_id" : "u3", "_routing" : "3" } }
  {"user":"Emma","jukebox_relations":{"name":"chosen_by","parent":3}}
  { "index" : { "_index" : "jukebox", "_id" : "u4", "_routing" : "4" } }
  {"user":"Berte","jukebox_relations":{"name":"chosen_by","parent":4}}
  { "index" : { "_index" : "jukebox", "_id" : "u5", "_routing" : "5" } }
  {"user":"Emma","jukebox_relations":{"name":"chosen_by","parent":5}}
  ```

-->

<!--

  ```json
  POST _bulk
  { "create" : { "_index" : "league" } }
  {"name":"Team 1","players":[{"identity":"Player_1","games":30,"nationality":"FR"},{"identity":"Player_2","games":15,"nationality":"DE"},{"identity":"Player_3","games":34,"nationality":"FR"},{"identity":"Player_4","games":11,"nationality":"BR"},{"identity":"Player_5","games":4,"nationality":"BE"},{"identity":"Player_6","games":11,"nationality":"FR"}]}
  { "create" : { "_index" : "league" } }
  {"name":"Team 2","players":[{"identity":"Player_20","games":11,"nationality":"FR"},{"identity":"Player_21","games":15,"nationality":"FR"},{"identity":"Player_22","games":34,"nationality":"FR"},{"identity":"Player_23","games":30,"nationality":"FR"},{"identity":"Player_24","games":4,"nationality":"FR"},{"identity":"Player_25","games":11,"nationality":"FR"}]}
  { "create" : { "_index" : "league" } }
  {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]}
  { "create" : { "_index" : "league" } }
  {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]} 
  ```

  ```json
  POST _bulk
  { "index" : { "_index" : "league" } }
  {"name":"Team 1","players":[{"identity":"Player_1","games":30,"nationality":"FR"},{"identity":"Player_2","games":15,"nationality":"DE"},{"identity":"Player_3","games":34,"nationality":"FR"},{"identity":"Player_4","games":11,"nationality":"BR"},{"identity":"Player_5","games":4,"nationality":"BE"},{"identity":"Player_6","games":11,"nationality":"FR"}]}
  { "index" : { "_index" : "league" } }
  {"name":"Team 2","players":[{"identity":"Player_20","games":11,"nationality":"FR"},{"identity":"Player_21","games":15,"nationality":"FR"},{"identity":"Player_22","games":34,"nationality":"FR"},{"identity":"Player_23","games":30,"nationality":"FR"},{"identity":"Player_24","games":4,"nationality":"FR"},{"identity":"Player_25","games":11,"nationality":"FR"}]}
  { "index" : { "_index" : "league" } }
  {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]}
  { "index" : { "_index" : "league" } }
  {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]} 
  ```

-->


<!--

  OR 

  ```json
  POST /leage/_doc
  {
    "name": "Team 1",
    "players": [
      {"identity": "Player_1", "games": 30, "nationality": "FR"},
      {"identity": "Player_2", "games": 15, "nationality": "DE"},
      {"identity": "Player_3", "games": 34, "nationality": "FR"},
      {"identity": "Player_4", "games": 11, "nationality": "BR"},
      {"identity": "Player_5", "games": 4, "nationality": "BE"},
      {"identity": "Player_6", "games": 11, "nationality": "FR"}    
    ]
  }

  POST /leage/_doc
  {
    "name": "Team 2",
    "players": [
      {"identity": "Player_20", "games": 11, "nationality": "FR"},
      {"identity": "Player_21", "games": 15, "nationality": "FR"},
      {"identity": "Player_22", "games": 34, "nationality": "FR"},
      {"identity": "Player_23", "games": 30, "nationality": "FR"},
      {"identity": "Player_24", "games": 4, "nationality": "FR"},
      {"identity": "Player_25", "games": 11, "nationality": "FR"}  
    ]
  }

  POST /leage/_doc
  {
    "name": "Team 3",
    "players": [
      {"identity": "Player_30", "games": 11, "nationality": "FR"},
      {"identity": "Player_31", "games": 15, "nationality": "FR"},
      {"identity": "Player_32", "games": 12, "nationality": "FR"},
      {"identity": "Player_33", "games": 15, "nationality": "FR"},
      {"identity": "Player_34", "games": 4, "nationality": "FR"},
      {"identity": "Player_35", "games": 11, "nationality": "FR"}
    ]
  }

  POST /leage/_doc
  {
    "name": "Team 3",
    "players": [
      {"identity": "Player_30", "games": 11, "nationality": "FR"},
      {"identity": "Player_31", "games": 15, "nationality": "FR"},
      {"identity": "Player_32", "games": 12, "nationality": "FR"},
      {"identity": "Player_33", "games": 15, "nationality": "FR"},
      {"identity": "Player_34", "games": 4, "nationality": "FR"},
      {"identity": "Player_35", "games": 11, "nationality": "FR"}
    ]
  }
  ```

-->


- Indexing Documents

  ```json
  PUT /person-object
  {
    "mappings": {
      "properties": {
        "name": {
          "type": "text"
        },
        "surname": {
          "type": "text"
        },
        "age": {
          "type": "short"
        },
        "address": {
          "properties": {
            "city": { 
              "type": "text"
            },
            "street": {
              "type": "text"
            }
          }
        }
      }
    }
  }
  ```


- Index Single Documents

  <details>
  <summary>
  ***Recap***
  </summary>

  > Adds a JSON document to the specified data stream or index and makes it searchable. If the target is an index and the document already exists, the request updates the document and increments its version.
  > 
  >> PUT /<target>/_doc/<_id>  
  >>
  >> POST /<target>/_doc/  
  >> 
  >> PUT /<target>/_create/<_id>  
  >> 
  >> POST /<target>/_create/<_id>  
  >> 

  </details>
 
  ```json
  PUT /person-object/_doc/1
  {
    "name": "farhad",
    "surname": "rasouli", 
    "address": {
      "city": "tehran",
      "street": "bolvare ferdooss"
    }
  }
  ```

  <details>
  <summary>
  Response:
  </summary>

  ```json
  {
    "_index" : "person-object",
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

  </details>

  ```json
  POST /person-object/_create/2
  {
    "name": "amir",
    "surname": "ardalan", 
    "address": {
      "city": "tehran",
      "street": "shahrake gharb"
    }
  }
  ```


  ```json
  PUT /person-object/_create/3
  {
    "name": "taghi",
    "surname": "taghizadeh", 
    "address": {
      "city": "karaj",
      "street": "shahrake ghods"
    }
  }
  ```

  ```json
  POST /person-object/_doc
  {
    "name": "majid",
    "surname": "majidi", 
    "address": {
      "city": "karaj",
      "street": "mehrshahr"
    }
  }
  ```

- The following request creates a dynamic template to map string fields as runtime fields of type keyword. 

  ```json
  PUT /my-index-000001
  {
    "mappings": {
      "dynamic_templates": [
        {
          "strings_as_keywords": {
            "match_mapping_type": "string",
            "runtime": {}
          }
        }
      ]
    }
  }
  ```
   
  Index some data

  ```json
  PUT /my-index-000001/_doc/1
  {
    "name": "farhad",
    "surname": "rasouli",
    "age": 45,
    "date_of": "2023-01-02"
  }
  ```

  Mapping  of Index after index data

  ```json
  GET /my-index-000001/_mapping

  GET /my-index-000001/_mapping/field/surname

  Response: 

  {
    "my-index-000001" : {
      "mappings" : {
        "dynamic_templates" : [
          {
            "strings_as_keywords" : {
              "match_mapping_type" : "string",
              "runtime" : { }
            }
          }
        ],
        "runtime" : {
          "name" : {
            "type" : "keyword"
          },
          "surname" : {
            "type" : "keyword"
          }
        },
        "properties" : {
          "age" : {
            "type" : "long"
          },
          "date_of" : {
            "type" : "date"
          }
        }
      }
    }
  }
  ```

- It is common to have many numeric fields that you will often aggregate on but never filter on. disable indexing on those fields to save disk space and gain indexing speed: 

  ```json
  PUT /my-index-000002
  {
    "mappings": {
      "dynamic_templates": [
        {
          "strings_as_ip": {
            "match_mapping_type": "string",
            "match": "ip*",
            "runtime": {
              "type": "ip"
            }
          }
        },
        {
          "strings_as_keywords": {
            "match_mapping_type": "string",
            "runtime": {}
          }
        },
        {
          "unindexed_long": {
            "match_mapping_type": "long",
            "mapping": {
              "type": "long",
              "index": false
            }
          }
        },
        {
          "unindexed_double": {
            "match_mapping_type": "double",
            "mapping": {
              "type": "float",
              "index": false
            }
          }
        }
      ]
    }
  }
  ```

  ```json 
  PUT /my-index-000003/_doc/1
  {
    "name": "farhad",
    "surname": "rasouli",
    "age": 45,
    "date_of": "2023-01-02",
    "ipsource": "192.168.1.1",
    "ww": 56.67
    
  }
  ```

  ```json
  {
    "my-index-000003" : {
      "mappings" : {
        "dynamic_templates" : [
          {
            "strings_as_ip" : {
              "match" : "ip*",
              "match_mapping_type" : "string",
              "runtime" : {
                "type" : "ip"
              }
            }
          },
          {
            "strings_as_keywords" : {
              "match_mapping_type" : "string",
              "runtime" : { }
            }
          },
          {
            "unindexed_long" : {
              "match_mapping_type" : "long",
              "mapping" : {
                "index" : false,
                "type" : "long"
              }
            }
          },
          {
            "unindexed_double" : {
              "match_mapping_type" : "double",
              "mapping" : {
                "index" : false,
                "type" : "float"
              }
            }
          }
        ],
        "runtime" : {
          "ipsource" : {
            "type" : "ip"
          },
          "name" : {
            "type" : "keyword"
          },
          "surname" : {
            "type" : "keyword"
          }
        },
        "properties" : {
          "age" : {
            "type" : "long",
            "index" : false
          },
          "date_of" : {
            "type" : "date"
          },
          "ww" : {
            "type" : "float",
            "index" : false
          }
        }
      }
    }
  }
  ```

##### Index Array

- mappings

  ```json
  PUT /programing-groups
  {
    "mappings": {
      "properties": {
        "name": {
          "type": "text"
        },
        "events": {
          "properties": {
            "title": {
              "type": "text"
            },
            "date": {
              "type": "date"
            }
          }
        }
      }
    }
  }
  ```

- Index document

  ```json
  PUT /programing-groups/_doc/1
  {
    "name": "WJUG",
    "events": [
      {
        "title": "elasticsearch",
        "date": "2019-10-10"
      },
      {
        "title": "java",
        "date": "2018-10-10"
      }
    ]
  }
  ```

- How arrays of objects are flattened

  > 
  > Elasticsearch has no concept of inner objects. Therefore, it flattens object hierarchies into a simple list of field names and values. 
  > 

  This document :

  ```json
  {
    "name": "WJUG",
    "events": [
      {
        "title": "elasticsearch",
        "date": "2019-10-10"
      },
      {
        "title": "java",
        "date": "2018-10-10"
      }
    ]
  }
   
  ```

  Internally transformed into a document that looks more like this: 

  ```json
  {
    "name": "WJUG",
    "events.title": [ "elasticsearch", "java" ],
    "events.date": [ "2019-10-10", "2018-10-10" ]
  }
  ```
  > 
  > The `events.title` and `events.date` fields are flattened into multi-value fields, and the **association between `elasticsearch` and `2019-10-10` is lost**. 
  > 

  Now try this:

  ```json
  GET /programing-groups/_search
  {
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "events.title": "elasticsearch"
            }
          },
          {
            "match": {
              "events.date": "2018-10-10"
            }
          }
        ]
      }
    }
  }
  ```

  **Response**: ***WRONG!!!!!!!!!***

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
      "max_score" : 1.287682,
      "hits" : [
        {
          "_index" : "programing-groups",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.287682,
          "_source" : {
            "name" : "WJUG",
            "events" : [
              {
                "title" : "elasticsearch",
                "date" : "2019-10-10"
              },
              {
                "title" : "java",
                "date" : "2018-10-10"
              }
            ]
          }
        }
      ]
    }
  }
  ```

- Find all groups that:  

  - have events concerning "elasticsearch" and 

  - took place in 2018

  ```json
  GET /programing-groups/_search
  {
    "query": {
      "bool": {
        "must": [
          {
            "term": {
              "events.title": {
                "value": "elasticsearch"
              }
            }
          },
          {
            "range": {
              "events.date": {
                "gte": "2018-01-01",
                "lt": "2019-01-01"
              }
            }
          }
        ]
      }
    }
  }
  ```

#### Index Nested

> 
> Nested objects index each object in the array as a separate hidden document. 
> 
>> Meaning that each nested object can be queried independently of the others with the nested query.
>>  

- mapping

  ```json
  PUT /person-nested
  {
    "mappings": {
      "properties": {
        "name": {
          "type": "text"
        },
        "surname": {
          "type": "text"
        },
        "address": {
          "type": "nested",
          "properties": {
            "street": {
              "type": "text"
            },
            "city": {
              "type": "text"
            }
          }
        }
        
      }
    }
  }
  ```

  <details>
  <summary>
  OR:
  </summary>

  ```json
  PUT /person-nested
  {
    "mappings": {
      "properties": {
        "name": {
          "type": "text"
        },
        "surname": {
          "type": "text"
        },
        "address": {
          "type": "nested"
        }
        
      }
    }
  }  
  ```

  </details>

- Index document

  ```json
  POST person-nested/_create/1
  {
    "name": "Michal",
    "surname": "Tumilowicz",
    "address": {
      "street": "Tamka",
      "city": "Warsaw"
    }
  }
  ```

- Find by each field

  ```json
  GET /person-nested/_search
  {
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "name": "Michal"
            }
          },
          {
            "match": {
              "surname": "Tumilowicz"
            }
          },
          {
            "nested": {
              "path": "address",
              "query": {
                "bool": {
                  "must": [
                    {
                      "match": {
                        "address.city": "Warsaw"
                      }
                    },
                    {
                      "match": {
                        "address.street": "Tamka"
                      }
                    }
                  ]
                }
              }
            }
          }
        ]
      }
    }
  }
  ```

- Find by each field and show nested documents that matches the query

  ```json
  GET /person-nested/_search
  {
    "query": {
      "nested": {
        "path": "address",
        "query": {
          "bool": {
            "must": [
              {
                "match": {
                  "address.city": "Tehran"
                }
              },
              {
                "match": {
                  "address.street": "Ferdoos"
                }  
              }
            ]
          }
        },
        "inner_hits": {
          "highlight": {
            "fields": {
              "address.city": {}
            }
          }
        }
      }
    }
  }
  ```

  <details>
  <summary>
    Response: 
  </summary>

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
      "max_score" : 1.1507283,
      "hits" : [
        {
          "_index" : "person-nested",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.1507283,
          "_source" : {
            "name" : "Michal",
            "surname" : "Tumilowicz",
            "address" : {
              "street" : "Tamka",
              "city" : "Warsaw"
            }
          },
          "inner_hits" : {
            "address" : {
              "hits" : {
                "total" : {
                  "value" : 1,
                  "relation" : "eq"
                },
                "max_score" : 0.5753642,
                "hits" : [
                  {
                    "_index" : "person-nested",
                    "_type" : "_doc",
                    "_id" : "1",
                    "_nested" : {
                      "field" : "address",
                      "offset" : 0
                    },
                    "_score" : 0.5753642,
                    "_source" : {
                      "city" : "Warsaw",
                      "street" : "Tamka"
                    }
                  }
                ]
              }
            }
          }
        }
      ]
    }
  }
  ```

  </details>

##### Index nested 2

- mapping

  ```json
  PUT /programing-groups-nested
  {
    "mappings": {
      "properties": {
        "name": {
          "type": "text"
        },
        "eventTitles": {
          "type": "text"
        },
        "events": {
          "type": "nested",
          "properties": {
            "title": {
              "type": "text",
              "copy_to": "eventTitles"
            },
            "date": {
              "type": "date"
            }
          }
        }
      }
    }
  }
  ```

- Index document

  ```json
  POST /programing-groups-nested/_create/1
  {
    "name": "WJUG",
    "test": "test",
    "events": [
      {
        "title": "elasticsearch",
        "date": "2019-10-10"
      },
      {
        "title": "java",
        "date": "2018-10-10"
      }
    ]
  }
  ```

- Find all groups that have events concerning "elasticsearch" and took place in 2019

  ```json
  GET /programing-groups-nested/_search
  {
    "query": {
      "nested": {
        "path": "events",
        "query": {
          "bool": {
            "must": [
              {
                "match": {
                  "events.title": "elasticsearch"
                }
              },
              {
                "range": {
                  "events.date": {
                    "gte": "2018-01-01",
                    "lt": "2020-01-01"
                  }
                }
              }
            ]
          }
        }
      }
    },
    "fields": [
      "eventTitles"
    ]
  }
  ```

  <details>
  <summary>
    Response: 
  </summary>

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
      "max_score" : 1.6931472,
      "hits" : [
        {
          "_index" : "programing-groups-nested",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.6931472,
          "_source" : {
            "name" : "WJUG",
            "test" : "test",
            "events" : [
              {
                "title" : "elasticsearch",
                "date" : "2019-10-10"
              },
              {
                "title" : "java",
                "date" : "2018-10-10"
              }
            ]
          },
          "fields" : {
            "eventTitles" : [
              "elasticsearch",
              "java"
            ]
          }
        }
      ]
    }
  }
  ```

  </details>

- Find all groups that have events with title java and elasticsearch

  ```json
  GET /programing-groups-nested/_search
  {
    "query": {
      "bool": {
        "must": [
          {
            "term": {
              "eventTitles": {
                "value": "elasticsearch"
              }
            }
          },
          {
            "term": {
              "eventTitles": {
                "value": "java"
              }
            }
          }
        ]
      }
    },
    "fields": [
      "eventTitles"
    ]
  }
  ```

  <details>
  <summary>
    Response: 
  </summary>

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
      "max_score" : 0.5753642,
      "hits" : [
        {
          "_index" : "programing-groups-nested",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 0.5753642,
          "_source" : {
            "name" : "WJUG",
            "test" : "test",
            "events" : [
              {
                "title" : "elasticsearch",
                "date" : "2019-10-10"
              },
              {
                "title" : "java",
                "date" : "2018-10-10"
              }
            ]
          },
          "fields" : {
            "eventTitles" : [
              "elasticsearch",
              "java"
            ]
          }
        }
      ]
    }
  }
  ```

  </details>

#### aggregations

- count players that played at least 30 games for each team.

  ```json
  GET /leage/_search
  {
    "size": 0,
    "aggs": {
      "by_team": {
        "terms": {
          "field": "name"
        },
        "aggs": {
          "at_least_30_games": {
            "nested": {
              "path": "players"
            },
            "aggs": {
              "count_players": {
                "filter": {
                  "range": {
                    "players.games": {
                      "gte": 30
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  ```

  <details>
  <summary>
    Response: 
  </summary>

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
        "value" : 4,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "by_team" : {
        "doc_count_error_upper_bound" : 0,
        "sum_other_doc_count" : 0,
        "buckets" : [
          {
            "key" : "Team 3",
            "doc_count" : 2,
            "at_least_30_games" : {
              "doc_count" : 12,
              "count_players" : {
                "doc_count" : 0
              }
            }
          },
          {
            "key" : "Team 1",
            "doc_count" : 1,
            "at_least_30_games" : {
              "doc_count" : 6,
              "count_players" : {
                "doc_count" : 2
              }
            }
          },
          {
            "key" : "Team 2",
            "doc_count" : 1,
            "at_least_30_games" : {
              "doc_count" : 6,
              "count_players" : {
                "doc_count" : 2
              }
            }
          }
        ]
      }
    }
  }
  ```

  </details>

- count teams with at least one player who played at least 30 games

  ```json
  GET /leage/_search
  {
    "size": 0,
    "aggs": {
      "by_team": {
        "terms": {
          "field": "name"
        },
        "aggs": {
          "at_least_30_games": {
            "nested": {
              "path": "players"
            },
            "aggs": {
              "count_players": {
                "filter": {
                  "range": {
                    "players.games": {
                      "gte": 30
                    }
                  }
                },
                "aggs": {
                  "team_has_players_at_least_30_games": {
                    "reverse_nested": {}
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  ```

  <details>
  <summary>
    Response: 
  </summary>

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
        "value" : 4,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "by_team" : {
        "doc_count_error_upper_bound" : 0,
        "sum_other_doc_count" : 0,
        "buckets" : [
          {
            "key" : "Team 3",
            "doc_count" : 2,
            "at_least_30_games" : {
              "doc_count" : 12,
              "count_players" : {
                "doc_count" : 0,
                "team_has_players_at_least_30_games" : {
                  "doc_count" : 0
                }
              }
            }
          },
          {
            "key" : "Team 1",
            "doc_count" : 1,
            "at_least_30_games" : {
              "doc_count" : 6,
              "count_players" : {
                "doc_count" : 2,
                "team_has_players_at_least_30_games" : {
                  "doc_count" : 1
                }
              }
            }
          },
          {
            "key" : "Team 2",
            "doc_count" : 1,
            "at_least_30_games" : {
              "doc_count" : 6,
              "count_players" : {
                "doc_count" : 2,
                "team_has_players_at_least_30_games" : {
                  "doc_count" : 1
                }
              }
            }
          }
        ]
      }
    }
  }
  ```

  </details>

#### join

- Index setup

  ```json
  PUT jukebox

  PUT jukebox
  {
    "mappings": {
      "properties": {
        "artist": {
          "type": "text"
        },
        "song": {
          "type": "text"
        },
        "chosen_by": {
          "type": "keyword"
        },
        "jukebox_relations": {
          "type": "join",
          "relations": {
            "artist": "song",
            "song": "chosen_by"
          }
        }
      }
    }
  }
  ```

- Ingest data

  ```json
  POST jukebox/_create/1
  {
    "name": "Led Zeppelin",
    "jukebox_relations": {
      "name": "artist"
    }
  }

  POST jukebox/_create/2
  {
    "name": "Sandy Denny",
    "jukebox_relations": {
      "name": "artist"
    }
  }

  POST jukebox/_doc/3?routing=1 
  {
    "song": "Whole lotta love",
    "jukebox_relations": {
      "name": "song",
      "parent": 1
    }
  }

  POST jukebox/_doc/4?routing=1 
  {
    "song": "Battle of Evermore",
    "jukebox_relations": {
      "name": "song",
      "parent": 1
    }
  }

  POST jukebox/_doc/5?routing=2 
  {
    "song": "Battle of Evermore",
    "jukebox_relations": {
      "name": "song",
      "parent": 2
    }
  }

  POST jukebox/_create/u1?routing=3 
  {
    "user": "Gabriel",
    "jukebox_relations": {
      "name": "chosen_by",
      "parent": 3
    }
  }

  POST jukebox/_create/u2?routing=3 
  {
    "user": "Berte",
    "jukebox_relations": {
      "name": "chosen_by",
      "parent": 3
    }
  }

  POST jukebox/_create/u3?routing=3 
  {
    "user": "Emma",
    "jukebox_relations": {
      "name": "chosen_by",
      "parent": 3
    }
  }

  POST jukebox/_create/u4?routing=4 
  {
    "user": "Berte",
    "jukebox_relations": {
      "name": "chosen_by",
      "parent": 4
    }
  }

  POST jukebox/_create/u5?routing=5 
  {
    "user": "Emma",
    "jukebox_relations": {
      "name": "chosen_by",
      "parent": 5
    }
  }
  ```

- Update document 3

  ```json
  POST jukebox/_update/3?routing=1
  {
    "doc": {
      "song": "Whole Lotta Love"
    }
  }

  GET jukebox/_doc/3?routing=1

  Response:

  {
    "_index" : "jukebox",
    "_type" : "_doc",
    "_id" : "3",
    "_version" : 2,
    "_seq_no" : 10,
    "_primary_term" : 1,
    "_routing" : "1",
    "found" : true,
    "_source" : {
      "song" : "Whole Lotta Love",
      "jukebox_relations" : {
        "name" : "song",
        "parent" : 1
      }
    }
  }
  ```

- Find all songs of an artist Led Zeppelin


- Find all users that liked a song

- Find all artists that have at least one song

- Count user likes for given song and show users that liked that song

