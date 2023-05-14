
## Runtime fields in search request

1. ******Define index******

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
PUT my-index-000001
```

</blockquote></details>


2. ***Ingest some data***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
POST my-index-000001/_bulk?refresh=true
{"index":{}}
{"@timestamp":1516729294000,"model_number":"QVKC92Q","measures":{"voltage":"5.2","start": "300","end":"8675309"}}
{"index":{}}
{"@timestamp":1516642894000,"model_number":"QVKC92Q","measures":{"voltage":"5.8","start": "300","end":"8675309"}}
{"index":{}}
{"@timestamp":1516556494000,"model_number":"QVKC92Q","measures":{"voltage":"5.1","start": "300","end":"8675309"}}
{"index":{}}
{"@timestamp":1516470094000,"model_number":"QVKC92Q","measures":{"voltage":"5.6","start": "300","end":"8675309"}}
{"index":{}}
{"@timestamp":1516383694000,"model_number":"HG537PU","measures":{"voltage":"4.2","start": "400","end":"8625309"}}
{"index":{}}
{"@timestamp":1516297294000,"model_number":"HG537PU","measures":{"voltage":"4.0","start": "400","end":"8625309"}}
```

<details><summary><i>with curl:</i></summary><blockquote>

```json
curl -X POST "localhost:9200/my-index-000001/_bulk?refresh=true&pretty" -H 'Content-Type: application/json' -d'
{"index":{}}
{"@timestamp":1516729294000,"model_number":"QVKC92Q","measures":{"voltage":"5.2","start": "300","end":"8675309"}}
{"index":{}}
{"@timestamp":1516642894000,"model_number":"QVKC92Q","measures":{"voltage":"5.8","start": "300","end":"8675309"}}
{"index":{}}
{"@timestamp":1516556494000,"model_number":"QVKC92Q","measures":{"voltage":"5.1","start": "300","end":"8675309"}}
{"index":{}}
{"@timestamp":1516470094000,"model_number":"QVKC92Q","measures":{"voltage":"5.6","start": "300","end":"8675309"}}
{"index":{}}
{"@timestamp":1516383694000,"model_number":"HG537PU","measures":{"voltage":"4.2","start": "400","end":"8625309"}}
{"index":{}}
{"@timestamp":1516297294000,"model_number":"HG537PU","measures":{"voltage":"4.0","start": "400","end":"8625309"}}
'
```

</details>

</blockquote></details>


3. ***Add the runtime field to the index mapping***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
PUT my-index-000001/_mapping
{
  "runtime": {
    "measures.start": {
      "type": "long"
    },
    "measures.end": {
      "type": "long"
   }
  }
}
```

<details><summary><i>with curl:</i></summary>

```json
curl -X PUT "localhost:9200/my-index-000001/_mapping?pretty" -H 'Content-Type: application/json' -d'
{
  "runtime": {
    "measures.start": {
      "type": "long"
    },
    "measures.end": {
      "type": "long"
   }
  }
}
'
```

</details>

</blockquote></details>


4. ***Show the index mapping***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
GET /my-index-000001/_mapping
```

<details><summary><i>with curl:</i></summary>

```json
curl -X GET "localhost:9200/my-index-000001/_mapping?pretty"
```

</details>

</blockquote></details>


5. ***Add aggregate based on runtime fields***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
GET my-index-000001/_search
{
  "aggs": {
    "avg_start": {
      "avg": {
        "field": "measures.start"
      }
    },
    "avg_end": {
      "avg": {
        "field": "measures.end"
      }
    }
  }
}
```

</blockquote></details>


6. ***Add duration runtime field  in search context***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
GET my-index-000001/_search
{
  "runtime_mappings": {
    "duration": {
      "type": "long",
      "script": {
        "source": """
          emit(doc['measures.end'].value - doc['measures.start'].value);
          """
      }
    }
  },
  "aggs": {
    "duration_stats": {
      "stats": {
        "field": "duration"
      }
    }
  }
}
```

</blockquote></details>


7. ***Delete the index as cleanup***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
DELETE my-index-000001
```
<details><summary><i>with curl:</i></summary>

```sh
curl -X DELETE "localhost:9200/my-index-000001" 
```

</details>

</blockquote></details>

