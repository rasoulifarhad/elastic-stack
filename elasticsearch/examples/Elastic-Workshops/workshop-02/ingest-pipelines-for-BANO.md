## Ingest Pipelines Workshop


### Dataset?

***BANO***: The Open National Address Database, by OpenStreetMap France


> A document describes a postal address in France. It looks like this:

```json
# demo_csv index
{
  "@timestamp":"2023-04-21T01:05:47", 
  "message":"950020003K-1,1,Rue du Carrefour,95450,Ableiges,C+O,49.069446,1.968904"
}
```

> We should instead index our documents using the following format:

```json
# demo_csv_bano index
{
  "location": {
    "lon": 1.968904,
    "lat": 49.069446
  },
  "address": {
    "zipcode": "95450",
    "number": "1",
    "city": "Ableiges",
    "street_name": "Rue du Carrefour"
  },
  "source": "C+O"
}
```

> ***And we could also use the first column as the `_id`: `950020003K-1`.***

---

#### Run Elastic Stack

```
docker-compose down -v
docker compose up -d
```

#### Download region

```
wget http://bano.openstreetmap.fr/data/bano-95.csv -P $(pwd)/dataset
```

#### Create bulk file

```
head -10000 bano-95.csv | 
while read -r line; do \
  NOW=$(date +"%Y-%m-%dT%T") \
  printf "{ \"index\" : {}}\n{\"@timestamp\":\"$NOW\", \"message\":\"$line\"}\n" \
done >$(pwd)/dataset/bulk-bano-95.ndjson
```

#### Ingest documents

```
curl -s -XPOST "localhost/demo_csv/_bulk" \
  -u elastic:changeme \
  -H 'Content-Type: application/x-ndjson' \
  --data-binary "@dataset/bulk-bano-95.ndjson" \
  | jq '{took: .took, errors: .errors}' ; echo
```

#### Test ingested documents

- ***Get count of documents***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /demo_csv/_count
```

<details><summary><i>Response:</i></summary>

```json
{
  "count" : 10000,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET -s -u elastic:changeme "localhost:9200/demo_csv/_count" -H 'Content-Type: application/json' | jq '.'
```

</details>

</blockquote></details>

- ***Search documents***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /demo_csv/_search
{
  "query": {
    "match_all": {}
  },
  "from": 0,
  "size": 1
}
```

<details><summary><i>Response:</i></summary>

```json
{
  "took": 1,
  "timed_out": false,
  "_shards": {
    "total": 1,
    "successful": 1,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 10000,
      "relation": "eq"
    },
    "max_score": 1,
    "hits": [
      {
        "_index": "demo_csv",
        "_type": "_doc",
        "_id": "tADOoIcBBqhY4y1YvAvg",
        "_score": 1,
        "_source": {
          "@timestamp": "2023-04-21T01:05:47",
          "message": "950020003K-1,1,Rue du Carrefour,95450,Ableiges,C+O,49.069446,1.968904"
        }
      }
    ]
  }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET -s -u elastic:changeme "localhost:9200/demo_csv/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_all": {}
  },
  "from": 0,
  "size": 1
}' | jq '.'
```

</details>

</blockquote></details>

- ***Check indec definition***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /demo_csv
```

<details><summary><i>Response:</i></summary>

```json
{
  "demo_csv" : {
    "aliases" : { },
    "mappings" : {
      "properties" : {
        "@timestamp" : {
          "type" : "date"
        },
        "message" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        }
      }
    },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "demo_csv",
        "creation_date" : "1682030115993",
        "number_of_replicas" : "1",
        "uuid" : "QPFt3WyhR9u559E1NEVmHQ",
        "version" : {
          "created" : "7160299"
        }
      }
    }
  }
}
```

</details>

<details><summary><i>curl:</i></summary>

```json
curl -XGET -s -u elastic:changeme "localhost:9200/demo_csv" | jq '.'
```

</details>

</blockquote></details>

---

### Create ingest pipeline

1. ***Add the CSV Processor***

> `message` field converted to  
>> `_id`  
>> `address.number`  
>> `address.street_name`  
>> `address.zipcode`  
>> `address.city`  
>> `source`  
>> `location.lat`  
>> `location.lon`  
>>  


```json
PUT _ingest/pipeline/bano
{
  "description": "bano",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "_id",
          "address.number",
          "address.street_name",
          "address.zipcode",
          "address.city",
          "source",
          "location.lat",
          "location.lon"
        ]
      }
    }
  ]
}
```    

2. ***Add Remove Processor***
  
> remove non needed fields: `@timestamp` and `message`.  
  
```json
PUT _ingest/pipeline/bano
{
  "description": "bano",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "_id",
          "address.number",
          "address.street_name",
          "address.zipcode",
          "address.city",
          "source",
          "location.lat",
          "location.lon"
        ]
      }
    },
    {
      "remove": {
        "field": [
          "@timestamp",
          "message"
        ]
      }
    }
  ]
}
```    
  
3. ***Add Convert lat to float***

> `location.lat`  field converted to `float` type  

```json
PUT _ingest/pipeline/bano
{
  "description": "bano",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "_id",
          "address.number",
          "address.street_name",
          "address.zipcode",
          "address.city",
          "source",
          "location.lat",
          "location.lon"
        ]
      }
    },
    {
      "remove": {
        "field": [
          "@timestamp",
          "message"
        ]
      }
    },
    {
      "convert": {
        "field": "location.lat",
        "type": "float",
        "ignore_missing": true
      }
    }
  ]
}
```

4. ***Add Convert lon to float***
   
> `location.lon` converted to `float` type  

```json
PUT _ingest/pipeline/bano
{
  "description": "bano",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "_id",
          "address.number",
          "address.street_name",
          "address.zipcode",
          "address.city",
          "source",
          "location.lat",
          "location.lon"
        ]
      }
    },
    {
      "remove": {
        "field": [
          "@timestamp",
          "message"
        ]
      }
    },
    {
      "convert": {
        "field": "location.lat",
        "type": "float",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "location.lon",
        "type": "float",
        "ignore_missing": true
      }
    }
  ]
}
```

5. ***Add Failure Processor***

> set the value of `ignore` to `"can not extract data"`  

```json
PUT _ingest/pipeline/bano
{
  "description": "bano",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "_id",
          "address.number",
          "address.street_name",
          "address.zipcode",
          "address.city",
          "source",
          "location.lat",
          "location.lon"
        ]
      }
    },
    {
      "remove": {
        "field": [
          "@timestamp",
          "message"
        ]
      }
    },
    {
      "convert": {
        "field": "location.lat",
        "type": "float"
      }
    },
    {
      "convert": {
        "field": "location.lon",
        "type": "float"
      }
    }
  ],
  "on_failure": [
    {
      "set": {
        "field": "error",
        "value": "Can not extract data"
      }
    },
    {
      "remove": {
        "field": "address",
        "ignore_missing": true
      }
    }
  ]
}
```

6. ***Final pipeline***

```json
PUT _ingest/pipeline/bano
{
  "description": "bano",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "_id",
          "address.number",
          "address.street_name",
          "address.zipcode",
          "address.city",
          "source",
          "location.lat",
          "location.lon"
        ]
      }
    },
    {
      "remove": {
        "field": [
          "@timestamp",
          "message"
        ]
      }
    },
    {
      "convert": {
        "field": "location.lat",
        "type": "float"
      }
    },
    {
      "convert": {
        "field": "location.lon",
        "type": "float"
      }
    }
  ],
  "on_failure": [
    {
      "set": {
        "field": "error",
        "value": "Can not extract data"
      }
    },
    {
      "remove": {
        "field": "address",
        "ignore_missing": true
      }
    }
  ]
}
```

---

### Test pipeline

> reindex `demo_csv` index to `demo_csv_bano` index using ***pipeline** created  

```json
POST /_reindex?wait_for_completion=true
{
  "source": {
    "index": "demo_csv"
  },
  "dest": {
    "index": "demo_csv_bano",
    "pipeline": "bano"
  }
}
```

> check `demo_csv_bano` index  

<details open><summary><i>Check index</i></summary><blockquote>

```json
GET /demo_csv_bano/_search
```

<details><summary><i>Response:</i></summary>

```json
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 10000,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "demo_csv_bano",
        "_type" : "_doc",
        "_id" : "950020003K-1",
        "_score" : 1.0,
        "_source" : {
          "address" : {
            "zipcode" : "95450",
            "number" : "1",
            "city" : "Ableiges",
            "street_name" : "Rue du Carrefour"
          },
          "location" : {
            "lon" : 1.968904,
            "lat" : 49.069447
          },
          "source" : "C+O"
        }
      },
      {
        "_index" : "demo_csv_bano",
        "_type" : "_doc",
        "_id" : "950020004L-1",
        "_score" : 1.0,
        "_source" : {
          "address" : {
            "zipcode" : "95450",
            "number" : "1",
            "city" : "Ableiges",
            "street_name" : "Rue du Clos Saint-Martin"
          },
          "location" : {
            "lon" : 1.969323,
            "lat" : 49.06789
          },
          "source" : "OSM"
        }
      },
      .....
```

</details>

</blockquote></details>


