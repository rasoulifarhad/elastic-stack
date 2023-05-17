## Runtime Fields Example

1. ***Define index and runtime fields***

```json
PUT my-index-000001/
{
  "mappings": {
    "dynamic": "runtime",
    "runtime": {
      "day_of_week": {
        "type": "keyword",
        "script": {
          "source": """
             emit(doc['@timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.FULL, Locale.ROOT))
          """
        }
      }
    },
    "properties": {
      "@timestamp": {"type": "date"}
    }
  }
}
```

2. ***Ingest some data***

```json
POST /my-index-000001/_bulk?refresh
{"index": {}}
{"@timestamp": "2020-06-21T15:00:01-05:00", "message" : "211.11.9.0 - - [2020-06-21T15:00:01-05:00] \"GET /english/index.html HTTP/1.0\" 304 0"}
{"index": {}}
{"@timestamp": "2020-06-21T15:00:01-05:00", "message" : "211.11.9.0 - - [2020-06-21T15:00:01-05:00] \"GET /english/index.html HTTP/1.0\" 304 0"}
{"index": {}}
{"@timestamp": "2020-04-30T14:30:17-05:00", "message" : "40.135.0.0 - - [2020-04-30T14:30:17-05:00] \"GET /images/hm_bg.jpg HTTP/1.0\" 200 24736"}
{"index": {}}
{"@timestamp": "2020-04-30T14:30:53-05:00", "message" : "232.0.0.0 - - [2020-04-30T14:30:53-05:00] \"GET /images/hm_bg.jpg HTTP/1.0\" 200 24736"}
{"index": {}}
{"@timestamp": "2020-04-30T14:31:12-05:00", "message" : "26.1.0.0 - - [2020-04-30T14:31:12-05:00] \"GET /images/hm_bg.jpg HTTP/1.0\" 200 24736"}
{"index": {}}
{"@timestamp": "2020-04-30T14:31:19-05:00", "message" : "247.37.0.0 - - [2020-04-30T14:31:19-05:00] \"GET /french/splash_inet.html HTTP/1.0\" 200 3781"}
{"index": {}}
{"@timestamp": "2020-04-30T14:31:27-05:00", "message" : "252.0.0.0 - - [2020-04-30T14:31:27-05:00] \"GET /images/hm_bg.jpg HTTP/1.0\" 200 24736"}
{"index": {}}
{"@timestamp": "2020-04-30T14:31:29-05:00", "message" : "247.37.0.0 - - [2020-04-30T14:31:29-05:00] \"GET /images/hm_brdl.gif HTTP/1.0\" 304 0"}
{"index": {}}
{"@timestamp": "2020-04-30T14:31:29-05:00", "message" : "247.37.0.0 - - [2020-04-30T14:31:29-05:00] \"GET /images/hm_arw.gif HTTP/1.0\" 304 0"}
{"index": {}}
{"@timestamp": "2020-04-30T14:31:32-05:00", "message" : "247.37.0.0 - - [2020-04-30T14:31:32-05:00] \"GET /images/nav_bg_top.gif HTTP/1.0\" 200 929"}
{"index": {}}
{"@timestamp": "2020-04-30T14:31:43-05:00", "message" : "247.37.0.0 - - [2020-04-30T14:31:43-05:00] \"GET /french/images/nav_venue_off.gif HTTP/1.0\" 304 0"}
```

3. ***Search index***

```json
GET my-index-000001/_search
{
  "fields": [
    "@timestamp",
    "day_of_week"
  ],
  "_source": false
}
```

4. ***Add another runtime field (client_ip)***

```json
PUT /my-index-000001/_mapping
{
  "runtime": {
    "client_ip": {
      "type": "ip",
      "script" : {
      "source" : """
        String m = doc[\"message\"].value; int end = m.indexOf(\" \"); emit(m.substring(0, end));
      """
      }
    }
  }
}
```

5. ***Search index based on runtime field***

```json
GET my-index-000001/_search
{
  "size": 1,
  "query": {
    "match": {
      "client_ip": "211.11.9.0"
    }
  },
  "fields" : ["*"]
}
```

6. ***Clean***

```json
DELETE my-index-000001
```

