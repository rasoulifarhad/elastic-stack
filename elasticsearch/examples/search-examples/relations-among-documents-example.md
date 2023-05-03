## Search

See [elasticsearch7 relations among documents workshop](https://github.com/mtumilowicz/elasticsearch7-relations-among-documents-workshop)

### Prepare Data


#### Create index jukebox && league

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

#### Index some documents

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


#### Indexing Documents

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


##### Index Single Documents

<!--
Adds a JSON document to the specified data stream or index and makes it searchable. If the target is an index and the document already exists, the request updates the document and increments its version.

> PUT /<target>/_doc/<_id>  
> 
> POST /<target>/_doc/  
> 
> PUT /<target>/_create/<_id>  
> 
> POST /<target>/_create/<_id>  
> 

-->
 
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

Response:

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

##### Index Single

##### Index Array

##### aggregations

#### join

##### aggregations
