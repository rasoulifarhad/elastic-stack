### Runtime field example

#### Runtime field in index mapping

1. Define index

PUT date_to_day
{
  "mappings": {
    "properties": {
      "timestamp": {
        "type": "date",
        "format": "yyyy-MM-dd"
      },
      "response_code": {
        "type": "integer"
      }
    }
  }
}

2. Ingest some data

with DevTools:

POST date_to_day/_bulk
{"index":{}}
{"response_code": 200, "timestamp": "2021-01-01"}
{"index":{}}
{"response_code": 300, "timestamp": "2021-01-03"}
{"index":{}}
{"response_code": 200, "timestamp": "2021-01-04"}
{"index":{}}
{"response_code": 400, "timestamp": "2021-01-01"}
{"index":{}}
{"response_code": 300, "timestamp": "2021-01-05"}
{"index":{}}
{"response_code": 200, "timestamp": "2020-12-21"}
{"index":{}}
{"response_code": 200, "timestamp": "2021-01-02"}
{"index":{}}
{"response_code": 200, "timestamp": "2021-01-08"}
{"index":{}}
{"response_code": 300, "timestamp": "2021-01-09"}
{"index":{}}
{"response_code": 400, "timestamp": "2021-01-09"}

with curl: 

curl -X POST "localhost:9200/date_to_day/_bulk?refresh&pretty" -H 'Content-Type: application/json' -d'
{"index":{}}
{"response_code": 200, "timestamp": "2021-01-01"}
{"index":{}}
{"response_code": 300, "timestamp": "2021-01-03"}
{"index":{}}
{"response_code": 200, "timestamp": "2021-01-04"}
{"index":{}}
{"response_code": 400, "timestamp": "2021-01-01"}
{"index":{}}
{"response_code": 300, "timestamp": "2021-01-05"}
{"index":{}}
{"response_code": 200, "timestamp": "2020-12-21"}
{"index":{}}
{"response_code": 200, "timestamp": "2021-01-02"}
{"index":{}}
{"response_code": 200, "timestamp": "2021-01-08"}
{"index":{}}
{"response_code": 300, "timestamp": "2021-01-09"}
{"index":{}}
{"response_code": 400, "timestamp": "2021-01-09"}
'

3. Show the index mapping

GET /date_to_day
GET /date_to_day/_mapping

with curl: 

curl -X GET "localhost:9200/date_to_day?pretty"
curl -X GET "localhost:9200/date_to_day/_mapping?pretty"


4. Create an ephemeral runtime field for day of week and aggregate on it

GET date_to_day/_search
{
  "runtime_mappings": {
    "day_of_week": {
      "type": "keyword",
      "script": {
        "source": """emit(doc['timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.SHORT, Locale.ROOT))"""
      }
    }
  },
  "size": 0,
  "aggs": {
    "terms": {
      "terms": {
        "field": "day_of_week"
      }
    }
  }
}


with curl: 

curl -X GET "localhost:9200/date_to_day/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "runtime_mappings": {
    "day_of_week": {
      "type": "keyword",
      "script": {
        "source": """emit(doc['timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.SHORT, Locale.ROOT))"""
      }
    }
  },
  "size": 0,
  "aggs": {
    "terms": {
      "terms": {
        "field": "day_of_week"
      }
    }
  }
}
'

5. Add the runtime field to the index mapping

PUT date_to_day/_mapping
{
  "runtime": {
    "day_of_week": {
      "type": "keyword",
      "script": {
        "source": """emit(doc['timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.SHORT, Locale.ROOT))"""
      }
    }
  }
}

with curl: 

curl -X GET "localhost:9200/date_to_day/_mapping" -H 'Content-Type: application/json' -d'
{
  "runtime": {
    "day_of_week": {
      "type": "keyword",
      "script": {
        "source": """emit(doc['timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.SHORT, Locale.ROOT))"""
      }
    }
  }
}
'

6. Examine the mapping to see that the runtime field was added

GET /date_to_day/_mapping

with curl: 

curl -X GET "localhost:9200/date_to_day/_mapping?pretty"

7. using day_of_week runtime field for aggregation

GET date_to_day/_search
{
  "size": 0,
  "aggs": {
    "terms": {
      "terms": {
        "field": "day_of_week"
      }
    }
  }
}

with curl: 

curl -X GET "localhost:9200/date_to_day/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "size": 0,
  "aggs": {
    "terms": {
      "terms": {
        "field": "day_of_week"
      }
    }
  }
}
'

8. Delete the index as cleanup

DELETE date_to_day

with curl: 

curl -X DELETE "localhost:9200/date_to_day" 

