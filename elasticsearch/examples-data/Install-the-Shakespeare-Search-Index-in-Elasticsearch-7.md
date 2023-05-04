### Install the Shakespeare Search Index in Elasticsearch 7

#### Download index mapping and Create index

```

wget http://media.sundog-soft.com/es7/shakes-mapping.json

curl -s -XPUT 127.0.0.1:9200/shakespeare  -H 'Content-Type: application/json' --data-binary @shakes-mapping.json
 
```

#### Download documents and bulk index that

```

wget http://media.sundog-soft.com/es7/shakespeare_7.0.json

curl -s -XPOST 'localhost:9200/shakespeare/_bulk?pretty' -H 'Content-Type: application/json' --data-binary @shakespeare_7.0.json

```

#### Test index

```json

curl -s -XGET 'localhost:9200/shakespeare/_search?pretty' -H 'Content-Type: application/json' -d'
{
  "query" : {
    "match_phrase" : {
      "text_entry" : "to be or not to be"
    }
  }
}'

```
