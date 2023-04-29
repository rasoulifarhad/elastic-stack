### Search

See [elasticsearch7 relations among documents workshop](https://github.com/mtumilowicz/elasticsearch7-relations-among-documents-workshop)


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

#### Index Objects

##### Index Single 
 
##### Index Array

#### Index Nested

##### Index Single

##### Index Array

##### aggregations

#### join

##### aggregations
