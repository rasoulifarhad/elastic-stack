### Index API

Recap from [Index API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docs-index_.html)

Adds a JSON document to the specified data stream or index and makes it searchable. If the target is an index and the document already exists, the request updates the document and increments its version.


You cannot use the index API to send update requests for existing documents to a data stream. See [Update documents in a data stream by query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/use-a-data-stream.html#update-docs-in-a-data-stream-by-query) and [Update or delete documents in a backing index](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/use-a-data-stream.html#update-delete-docs-in-a-backing-index).

#### Request

```json

PUT /<target>/_doc/<_id>

POST /<target>/_doc/

PUT /<target>/_create/<_id>

POST /<target>/_create/<_id>

```

You cannot add new documents to a data stream using the PUT /<target>/_doc/<_id> request format. To specify a document ID, use the PUT /<target>/_create/<_id> format instead. See [Add documents to a data stream](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/use-a-data-stream.html#add-documents-to-a-data-stream).

#### Query parameters

- if_seq_no
- if_primary_term
- op_type
- pipeline
- refresh
- routing
- timeout
- version
- version_type
- wait_for_active_shards
- require_alias

See [Query parameters](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docs-index_.html#docs-index-api-query-params)

#### Automatically create data streams and indices

```json

# Allow auto-creation of indices called my-index-000001 or index10, block the creation of indices that </br>
# match the pattern index1*, and allow creation of any other indices that match the ind* pattern.
PUT _cluster/settings
{
  "persistent": {
    "action.auto_create_index": "my-index-000001,index10,-index1*,+ind*" 
  }
}

# Disable automatic index creation entirely.
PUT _cluster/settings
{
  "persistent": {
    "action.auto_create_index": "false" 
  }
}

# Allow automatic creation of any index. This is the default.
PUT _cluster/settings
{
  "persistent": {
    "action.auto_create_index": "true" 
  }
}

```

