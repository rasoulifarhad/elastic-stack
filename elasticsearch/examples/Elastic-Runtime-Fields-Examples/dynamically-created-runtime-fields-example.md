## Dynamically created runtime fields


1. ***Define index template***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
PUT _index_template/my_dynamic_index
{
  "index_patterns": [
    "my_dynamic_index-*"
  ],
  "template": {
    "mappings": {
      "dynamic": "runtime",
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
}
```

</blockquote></details>


2. ***Ingest some data***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
POST my_dynamic_index-1/_bulk
{"index":{}}
{"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-1"}
{"index":{}}
{"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-1"}
{"index":{}}
{"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-2"}
{"index":{}}
{"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-2"}
```

<details><summary><i>with curl</i></summary>

```sh
curl -X POST "localhost:9200/my_dynamic_index-1/_bulk?refresh&pretty" -H 'Content-Type: application/json' -d'
{"index":{}}
{"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-1"}
{"index":{}}
{"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-1"}
{"index":{}}
{"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-2"}
{"index":{}}
{"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-2"}
'
```

</details>

</blockquote></details>


3. ***Show the index mapping***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
GET /my_dynamic_index-1/_mapping
```

<details><summary><i>with curl</i></summary>

```sh
curl -X GET "localhost:9200/my_dynamic_index-1/_mapping?pretty"
```

</details>

</blockquote></details>


4. ***Search for  ...***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
GET my_dynamic_index-1/_search
{
  "query": {
    "match": {
      "new_tla": "data-2"
    }
  }
}
```

</blockquote></details>


5. ***Delete the index as cleanup***

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
DELETE _index_template/my_dynamic_index
```
<details><summary><i>with curl</i></summary>

```sh
curl -X DELETE "localhost:9200/_index_template/my_dynamic_index"
```

</details>

</blockquote></details>



