### Example: Detect threats with EQL

See [Example: Detect threats with EQL](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/eql-ex-threat-detection.html)
See [EQL syntax reference](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/eql-syntax.html)

#### Setup

To get started:

1. Create an [index template](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/index-templates.html) with [data stream enabled](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/set-up-a-data-stream.html#create-index-template)

```json

PUT /_index_template/my-data-stream-template
{
  "index_patterns": [ "my-data-stream*" ],
  "data_stream": { },
  "priority": 500
}

```

2. Use the [bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docs-bulk.html) to index the data to a matching stream:

```json

curl -H "Content-Type: application/json" -XPOST "localhost:9200/my-data-stream/_bulk?pretty&refresh" --data-binary "@dataset/normalized-T1117-AtomicRed-regsvr32.json"

```

3. Use the [cat indices API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/cat-indices.html) to verify the data was indexed:

```json

GET /_cat/indices/my-data-stream?v=true&h=health,status,index,docs.count

```

#### Get a count of regsvr32 events

```json

GET /my-data-stream/_eql/search?filter_path=-hits.events    
{
  "query": """
    any where process.name == "regsvr32.exe"                
  """,
  "size": 200                                               
}

```

