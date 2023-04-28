### Term vectors API

Retrieves information and statistics for terms in the fields of a particular document. You can retrieve term vectors for documents stored in the index or for artificial documents passed in the body of the request. You can specify the fields you are interested in through the `fields` parameter, or by adding the fields to the request body.

```json

GET /<index>/_termvectors/<_id>

GET /my-index-000001/_termvectors/1

GET /my-index-000001/_termvectors/1?fields=message

```

You can request three types of values: `term information`, `term statistics` and `field statistics`. 

#### Term information

- term frequency in the field (always returned)
- term positions (`positions` : true)
- start and end offsets (`offsets` : true)
- term payloads (`payloads` : true), as base64 encoded bytes

#### Term statistics

Setting `term_statistics` to `true` (default is `false`) will return:

- total term frequency (how often a term occurs in all documents)
- document frequency (the number of documents containing the current term)

#### field statistics

Setting `field_statistics` to `false` (default is `true`) will omit :

- document count (how many documents contain this field)
- sum of document frequencies (the sum of document frequencies for all terms in this field)
- sum of total term frequencies (the sum of total term frequencies of each term in this field)

#### Example

First, we create an index that stores term vectors, payloads etc. :

```json
PUT /my-index-000001
{ "mappings": {
    "properties": {
      "text": {
        "type": "text",
        "term_vector": "with_positions_offsets_payloads",
        "store" : true,
        "analyzer" : "fulltext_analyzer"
       },
       "fullname": {
        "type": "text",
        "term_vector": "with_positions_offsets_payloads",
        "analyzer" : "fulltext_analyzer"
      }
    }
  },
  "settings" : {
    "index" : {
      "number_of_shards" : 1,
      "number_of_replicas" : 0
    },
    "analysis": {
      "analyzer": {
        "fulltext_analyzer": {
          "type": "custom",
          "tokenizer": "whitespace",
          "filter": [
            "lowercase",
            "type_as_payload"
          ]
        }
      }
    }
  }
}
```

Second, we add some documents:

```json

PUT /my-index-000001/_doc/1
{
  "fullname" : "John Doe",
  "text" : "test test test "
}

PUT /my-index-000001/_doc/2?refresh=wait_for
{
  "fullname" : "Jane Doe",
  "text" : "Another test ..."
}
```

The following request returns all information and statistics for field text in document 1 (John Doe):

```json

GET /my-index-000001/_termvectors/1
{
  "fields" : ["text"],
  "offsets" : true,
  "payloads" : true,
  "positions" : true,
  "term_statistics" : true,
  "field_statistics" : true
}
```

Response:

```json

{
  "_index" : "my-index-000001",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "took" : 7,
  "term_vectors" : {
    "text" : {
      "field_statistics" : {
        "sum_doc_freq" : 4,
        "doc_count" : 2,
        "sum_ttf" : 6
      },
      "terms" : {
        "test" : {
          "doc_freq" : 2,
          "ttf" : 4,
          "term_freq" : 3,
          "tokens" : [
            {
              "position" : 0,
              "start_offset" : 0,
              "end_offset" : 4,
              "payload" : "d29yZA=="
            },
            {
              "position" : 1,
              "start_offset" : 5,
              "end_offset" : 9,
              "payload" : "d29yZA=="
            },
            {
              "position" : 2,
              "start_offset" : 10,
              "end_offset" : 14,
              "payload" : "d29yZA=="
            }
          ]
        }
      }
    }
  }
}
```

