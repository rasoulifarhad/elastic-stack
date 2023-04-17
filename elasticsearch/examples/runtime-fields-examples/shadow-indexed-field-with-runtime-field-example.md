### Shadow an indexed field with a runtime field to fix errors

1. Create an index template which we will use to create multiple indices
```markdown
PUT _index_template/dur_log
{
  "index_patterns": [
    "dur_log-*"
  ],
  "template": {
    "mappings": {
    "properties": {
      "timestamp": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss"
      },
      "browser": {
        "type": "keyword"
      },
      "duration": {
        "type": "double"
      }
    }
  }
  }
}
```
2. Laod a few documents, Firefox erroneously entered in ms instead of sec
```markdown
POST dur_log-1/_bulk
{"index":{}}
{"timestamp": "2021-01-25 10:01:12", "browser": "Chrome", "duration": 1.176}
{"index":{}}
{"timestamp": "2021-01-25 10:01:13", "browser": "Safari", "duration": 1.246}
{"index":{}}
{"timestamp": "2021-01-26 10:02:11", "browser": "Edge", "duration": 0.993}
{"index":{}}
{"timestamp": "2021-01-26 10:02:15", "browser": "Firefox", "duration": 1342}
{"index":{}}
{"timestamp": "2021-01-26 10:01:23", "browser": "Chrome", "duration": 1.151}
{"index":{}}
{"timestamp": "2021-01-27 10:01:54", "browser": "Chrome", "duration": 1.141}
{"index":{}}
{"timestamp": "2021-01-28 10:01:32", "browser": "Firefox", "duration": 984}
{"index":{}}
{"timestamp": "2021-01-29 10:01:21", "browser": "Edge", "duration": 1.233}
{"index":{}}
{"timestamp": "2021-01-30 10:02:07", "browser": "Safari", "duration": 1.312}
{"index":{}}
{"timestamp": "2021-01-30 10:01:19", "browser": "Chrome", "duration": 1.231}
```
3. Aggregate for average duration per browser
```markdown
GET dur_log-1/_search
{
  "size": 0,
  "aggs": {
    "terms": {
      "terms": {
        "field": "browser"
      },
      "aggs": {
        "average duration": {
          "avg": {
            "field": "duration"
          }
        }
      }
    }
  }
}
```
4. Load a few documents to a new index. The mistake has been fixed in the data of the new documents.
```markdown
POST dur_log-2/_bulk
{"index":{}}
{"timestamp": "2021-01-25 10:01:12", "browser": "Chrome", "duration": 1.256}
{"index":{}}
{"timestamp": "2021-01-26 10:02:15", "browser": "Firefox", "duration": 1.293}
```
5. Create a runtime field to shadow the indexed field and have the Firefox duration divided by 1000
```markdown
GET dur_log-1/_search
{
  "runtime_mappings": {
    "duration": {
      "type": "double",
      "script": {
        "source": """if(doc['browser'].value == "Firefox")
        {emit(params._source['duration'] / 1000.0)}
        else {emit(params._source['duration'])}"""
      }
    }
  },
  "size": 0,
  "aggs": {
    "terms": {
      "terms": {
        "field": "browser"
      },
      "aggs": {
        "average duration": {
          "avg": {
            "field": "duration"
          }
        }
      }
    }
  }
}
```
6. Add the runtime field to the mapping so all can use it
```markdown
PUT dur_log-1/_mapping
{
  "runtime": {
    "duration": {
      "type": "double",
      "script": {
        "source": """if(doc['browser'].value == "Firefox")
        {emit(params._source['duration'] / 1000.0)}
        else {emit(params._source['duration'])}"""
      }
    }
  }
}
```
7. Aggregate on duration and return all fields
```markdown
GET dur_log-*/_search
{
  "fields": ["*"],
  "_source": false,
  "aggs": {
    "terms": {
      "terms": {
        "field": "browser"
      },
      "aggs": {
        "average duration": {
          "avg": {
            "field": "duration"
          }
        }
      }
    }
  }
}
```
8. clean up
```markdown
DELETE dur_log-*
DELETE _index_template/dur_log
```
