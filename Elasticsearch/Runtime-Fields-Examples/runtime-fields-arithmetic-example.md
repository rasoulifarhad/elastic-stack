### Runtime fields arithmetic

1. 
```markdown
GET kibana_sample_data_logs\_search
{
  "runtime_mappings": {
    "ram_floor_gb": {
      "type": "long",
      "script": {
        "source": "emit(Math.floor(doc['machine.ram'].value * 9.31 * Math.pow(10,-10)).longValue())"
      }
    }
  },
  "fields": [
    "ram_floor_gb"
  ],
  "_source": false,
  "query": {
    "range": {
      "ram_floor_gb": {
        "gte": 0,
        "lte": 20
      }
    }
  }
}
```
2. 
```markdown
GET kibana_sample_data_logs\_search
{
  "runtime_mappings": {
    "ram_floor_gb": {
      "type": "long",
      "script": {
        "source": "emit(Math.floor(doc['machine.ram'].value * 9.31 * Math.pow(10,-10)).longValue())"
      }
    }
  },
  "fields": [
    "ram_floor_gb",
    "timestamp"
  ],
  "_source": false,
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "timestamp": {
              "gt": "2020-12-11"
            }
          }
        },
        {
          "range": {
            "ram_floor_gb": {
              "gte": 0,
              "lte": 20
            }
          }
        }
      ]
    }
  }
}
```
