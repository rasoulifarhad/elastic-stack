1. if we have the following index:
```markdown
PUT my_index
 {
   "mappings": {
       "address": {
         "type": "ip"},
       "port": {
         "type": "long"
       }
     }
   } 
 }
 ```
2. And load a few documents into it:
```markdown
 POST my_index/_bulk
 {"index":{"_id":"1"}}
 {"address":"1.2.3.4","port":"80"}
 {"index":{"_id":"2"}}
 {"address":"1.2.3.4","port":"8080"}
 {"index":{"_id":"3"}}
 {"address":"2.4.8.16","port":"80"}
```
3. We can create the concatenation of two fields with a static string as follows:
```markdown
GET my_index/_search
{
  "runtime_mappings": {
    "socket": {
      "type": "keyword",
      "script": {
        "source": "emit(doc['address'].value + ':' + doc['port'].value)"
      }
    }
  },
  "fields": [
    "socket"
  ],
  "query": {
    "match": {
      "socket": "1.2.3.4:8080"
    }
  }
}
``` 
4. if we find that socket is a field that we want to use in multiple queries without having to define it per query, we can simply add it to the mapping by making the call:
```markdown 
PUT my_index/_mapping
{
  "runtime": {
    "socket": {
      "type": "keyword",
      "script": {
        "source": "emit(doc['address'].value + ':' + doc['port'].value)"
      }
    } 
  } 
}
``` 
5. And then the query does not have to include the definition of the field, for example:
```markdown
GET my_index/_search
{
  "fields": [
    "socket"
 ],
  "query": {
    "match": {
      "socket": "1.2.3.4:8080"
    }
  }
}
``` 
**Override field values at query time**
 
Here’s a simple example to make this more concrete. 
 
1. Let’s say we have an index with a message field and an address field:
```markdown
PUT my_raw_index 
{
  "mappings": {
    "properties": {
      "raw_message": {
        "type": "keyword"
      },
      "address": {
        "type": "ip"
      }
    }
  }
}
```
2. And let’s load a document into it:
```markdown
POST my_raw_index/_doc/1
{
  "raw_message": "199.72.81.55 - - [01/Jul/1995:00:00:01 -0400] GET /history/apollo/ HTTP/1.0 200 6245",
  "address": "1.2.3.4"
}
```
3. Shadowing the indexed field with a runtime field

Alas, the document contains a wrong IP address in the address field. The correct IP address exists in the message but somehow the wrong address was parsed out in the document that was sent to be ingested into Elasticsearch and indexed. 

For a single document, that’s not a problem, but what if we discover after a month that 10% of our documents contain a wrong address? Fixing it for new documents is not a big deal, but reindexing the documents that were already ingested is frequently operationally complex. With runtime fields, it can be fixed immediately, by shadowing the indexed field with a runtime field. Here is how you would do it in a query:
```markdown
GET my_raw_index/_search
{
  "runtime_mappings": {
    "address": {
      "type": "ip",
      "script": "Matcher m = /\\d+\\.\\d+\\.\\d+\\.\\d+/.matcher(doc[\"raw_message\"].value);if (m.find()) emit(m.group());"
    }
  },
  "fields": [ 
    "address"
  ]
}
```
4. Changing a field from runtime to indexed
```markdown
PUT my_index-1
{
  "mappings": {
    "dynamic": "runtime",
    "properties": {
      "timestamp": {
        "type": "date",
        "format": "yyyy-MM-dd"
      }
    }
  }
}
```
5. Let’s index a document to see the advantages of these settings:
```markdown
POST my_index-1/_doc/1
{
  "timestamp": "2021-01-01",
  "message": "my message",
  "voltage": "12"
}
```
6. Now that we have an indexed timestamp field and two runtime fields (message and voltage), we can view the index mapping:
```markdown
GET my_index-1/_mapping
```
The runtime section includes message and voltage. These fields are not indexed, but we can still query them exactly as if they were indexed fields.
```markdown
{
  "my_index-1" : {
    "mappings" : {
      "dynamic" : "runtime",
      "runtime" : {
        "message" : {
          "type" : "keyword"
        },
        "voltage" : {
          "type" : "keyword"
        }
      },
      "properties" : {
        "timestamp" : {
          "type" : "date",
          "format" : "yyyy-MM-dd"
        }
      }
    }
  }
}
```
7. We’ll create a simple search request that queries on the message field:
```markdown
GET my_index-1/_search
{
  "query": {
    "match": {
      "message": "my message"
    }
  } 
}
```
The response includes the following hits:
```markdown
... 
"hits" : [
      {
        "_index" : "my_index-1", 
        "_type" : "_doc", 
        "_id" : "1", 
        "_score" : 1.0, 
        "_source" : { 
          "timestamp" : "2021-01-01", 
          "message" : "my message", 
          "voltage" : "12" 
        } 
      } 
    ]
…
```
8. Looking at this response, we notice a problem: we didn’t specify that voltage is a number! Because voltage is a runtime field, that’s easy to fix by updating the field definition in the runtime section of the mapping:
```markdown
PUT my_index-1/_mapping
{
  "runtime":{
    "voltage":{
      "type": "long"
    }
  }
}
```
9. The previous request changes voltage to a type of long, which immediately takes effect for documents that were already indexed. To test that behavior, we construct a simple query for all documents with a voltage between 11 and 13:
```markdown
GET my_index-1/_search
{
  "query": {
    "range": {
      "voltage": {
        "gt": 11,
        "lt": 13
      }
    }
  }
}
```
Because our voltage was 12, the query returns our document in my_index-1. If we view the mapping again, we’ll see that voltage is now a runtime field of type long, even for documents that were ingested into Elasticsearch before we updated the field type in the mapping:
```markdown
...
{
  "my_index-1" : {
    "mappings" : {
      "dynamic" : "runtime",
      "runtime" : {
        "message" : {
          "type" : "keyword"
        },
        "voltage" : {
          "type" : "long"
        }
      },
      "properties" : {
        "timestamp" : {
          "type" : "date",
          "format" : "yyyy-MM-dd"
        }
      }
    }
  }
}
…
```
10. Later, we might decide that voltage is useful in aggregations and we want to index it into the next index that's created in a data stream. We create a new index (my_index-2) that matches the index template for the data stream and define voltage as an integer, knowing which data type we want after experimenting with runtime fields.

11. Ideally, we would update the index template itself so that changes take effect on the next rollover. You can run queries on the voltage field in any index matching the my_index* pattern, even though the field is a runtime field in one index and an indexed field in another.
```markdown
PUT my_index-2
{
  "mappings": {
    "dynamic": "runtime",
    "properties": {
      "timestamp": {
        "type": "date",
        "format": "yyyy-MM-dd"
      },
      "voltage":
      {
        "type": "integer"
      }
    }
  }
}
```
With runtime fields, we have therefore introduced a new field lifecycle workflow. In this workflow, a field can automatically be generated as a runtime field without impacting resource consumption and without risking mapping explosion, allowing users to immediately start working with the data. The field’s mapping can be refined on real data while it is still a runtime field, and due to the flexibility of runtime fields, the changes take effect on documents that were already ingested into Elasticsearch. When it is clear that the field is useful, the template can be changed so that in the indexes that will be created from that point on (after the next rollover), the field will be indexed for optimal performance.

