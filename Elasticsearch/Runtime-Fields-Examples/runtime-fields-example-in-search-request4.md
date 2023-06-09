## Runtime field examples

1. 

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
PUT my-index-000001/
{
  "mappings": {
    "properties": {
      "timestamp": {
        "type": "date"
      },
      "temperature": {
        "type": "long"
      },
      "voltage": {
        "type": "double"
      },
      "node": {
        "type": "keyword"
      }
    }
  }
}
```

<details><summary><i>with DevTools:</i></summary>

```json
curl -X PUT "localhost:9200/my-index-000001/?pretty" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "properties": {
      "timestamp": {
        "type": "date"
      },
      "temperature": {
        "type": "long"
      },
      "voltage": {
        "type": "double"
      },
      "node": {
        "type": "keyword"
      }
    }
  }
}
'
```

</details>

</blockquote></details>


2. 

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
POST my-index-000001/_bulk?refresh=true
{"index":{}}
{"timestamp": 1516729294000, "temperature": 200, "voltage": 5.2, "node": "a"}
{"index":{}}
{"timestamp": 1516642894000, "temperature": 201, "voltage": 5.8, "node": "b"}
{"index":{}}
{"timestamp": 1516556494000, "temperature": 202, "voltage": 5.1, "node": "a"}
{"index":{}}
{"timestamp": 1516470094000, "temperature": 198, "voltage": 5.6, "node": "b"}
{"index":{}}
{"timestamp": 1516383694000, "temperature": 200, "voltage": 4.2, "node": "c"}
{"index":{}}
{"timestamp": 1516297294000, "temperature": 202, "voltage": 4.0, "node": "c"}
```

<details><summary><i>with DevTools:</i></summary>

```json
curl -X POST "localhost:9200/my-index-000001/_bulk?refresh=true&pretty" -H 'Content-Type: application/json' -d'
{"index":{}}
{"timestamp": 1516729294000, "temperature": 200, "voltage": 5.2, "node": "a"}
{"index":{}}
{"timestamp": 1516642894000, "temperature": 201, "voltage": 5.8, "node": "b"}
{"index":{}}
{"timestamp": 1516556494000, "temperature": 202, "voltage": 5.1, "node": "a"}
{"index":{}}
{"timestamp": 1516470094000, "temperature": 198, "voltage": 5.6, "node": "b"}
{"index":{}}
{"timestamp": 1516383694000, "temperature": 200, "voltage": 4.2, "node": "c"}
{"index":{}}
{"timestamp": 1516297294000, "temperature": 202, "voltage": 4.0, "node": "c"}
'
```

</details>

</blockquote></details>


3. 

```json
PUT my-index-000001/_mapping
{
  "runtime": {
    "voltage_corrected": {
      "type": "double",
      "script": {
        "source": """
        emit(doc['voltage'].value * params['multiplier'])
        """,
        "params": {
          "multiplier": 2
        }
      }
    }
  }
}
```

4. 

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
GET my-index-000001/_search
{
  "fields": [
    "voltage_corrected",
    "node"
  ],
  "size": 2
}
```

<details><summary><i>with DevTools:</i></summary>

```json
curl -X GET "localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "fields": [
    "voltage_corrected",
    "node"
  ],
  "size": 2
}
'
```

</details>

</blockquote></details>


5. 

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
GET my-index-000001/_search
{
  "fields": [
    "voltage_corrected",
    "node"
  ],
  "size": 2
}
```

<details><summary><i>with DevTools:</i></summary>

```json
curl -X PUT "localhost:9200/my-index-000001/_mapping?pretty" -H 'Content-Type: application/json' -d'
{
  "runtime": {
    "voltage_corrected": {
      "type": "double",
      "script": {
        "source": "emit(doc[\u0027voltage\u0027].value * params[\u0027multiplier\u0027])",
        "params": {
          "multiplier": 2
        }
      }
    }
  }
}
'
```

</details>

</blockquote></details>


1. 

 "on_script_error": "fail": Causes the entire document to be rejected if the script throws an error at index time. Setting the value to ignore will register the field in the document’s _ignored metadata field and continue indexing.

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
PUT my-index-000001/
{
  "mappings": {
    "properties": {
      "timestamp": {
        "type": "date"
      },
      "temperature": {
        "type": "long"
      },
      "voltage": {
        "type": "double"
      },
      "node": {
        "type": "keyword"
      },
      "voltage_corrected": {
        "type": "double",
        "on_script_error": "fail", 
        "script": {
          "source": """
        emit(doc['voltage'].value * params['multiplier'])
        """,
          "params": {
            "multiplier": 4
          }
        }
      }
    }
  }
}
```

<details><summary><i>with curl</i></summary>

```json
curl -X PUT "localhost:9200/my-index-000001/?pretty" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "properties": {
      "timestamp": {
        "type": "date"
      },
      "temperature": {
        "type": "long"
      },
      "voltage": {
        "type": "double"
      },
      "node": {
        "type": "keyword"
      },
      "voltage_corrected": {
        "type": "double",
        "on_script_error": "fail", 
        "script": {
          "source": "emit(doc[\u0027voltage\u0027].value * params[\u0027multiplier\u0027])",
          "params": {
            "multiplier": 4
          }
        }
      }
    }
  }
}
'
```

</details>

</blockquote></details>


2. 

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
POST my-index-000001/_bulk?refresh=true
{ "index": {}}
{ "timestamp": 1516729294000, "temperature": 200, "voltage": 5.2, "node": "a"}
{ "index": {}}
{ "timestamp": 1516642894000, "temperature": 201, "voltage": 5.8, "node": "b"}
{ "index": {}}
{ "timestamp": 1516556494000, "temperature": 202, "voltage": 5.1, "node": "a"}
{ "index": {}}
{ "timestamp": 1516470094000, "temperature": 198, "voltage": 5.6, "node": "b"}
{ "index": {}}
{ "timestamp": 1516383694000, "temperature": 200, "voltage": 4.2, "node": "c"}
{ "index": {}}
{ "timestamp": 1516297294000, "temperature": 202, "voltage": 4.0, "node": "c"}
```

<details><summary><i>with curl</i></summary>

```sh
curl -X POST "localhost:9200/my-index-000001/_bulk?refresh=true&pretty" -H 'Content-Type: application/json' -d'
{ "index": {}}
{ "timestamp": 1516729294000, "temperature": 200, "voltage": 5.2, "node": "a"}
{ "index": {}}
{ "timestamp": 1516642894000, "temperature": 201, "voltage": 5.8, "node": "b"}
{ "index": {}}
{ "timestamp": 1516556494000, "temperature": 202, "voltage": 5.1, "node": "a"}
{ "index": {}}
{ "timestamp": 1516470094000, "temperature": 198, "voltage": 5.6, "node": "b"}
{ "index": {}}
{ "timestamp": 1516383694000, "temperature": 200, "voltage": 4.2, "node": "c"}
{ "index": {}}
{ "timestamp": 1516297294000, "temperature": 202, "voltage": 4.0, "node": "c"}
'
```

</details>

</blockquote></details>


3. 

<details open><summary><i>with DevTools:</i></summary><blockquote>

```json
POST my-index-000001/_search
{
  "query": {
    "range": {
      "voltage_corrected": {
        "gte": 16,
        "lte": 20,
        "boost": 1.0
      }
    }
  },
  "fields": [
    "voltage_corrected", "node"]
}
```

<details><summary><i>with curl</i></summary>

```sh
curl -X POST "localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "range": {
      "voltage_corrected": {
        "gte": 16,
        "lte": 20,
        "boost": 1.0
      }
    }
  },
  "fields": [
    "voltage_corrected", "node"]
}
'
```

</details>

</blockquote></details>

