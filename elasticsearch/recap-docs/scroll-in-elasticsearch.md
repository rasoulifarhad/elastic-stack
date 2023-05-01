### Scroll in elasticsearch

**Note**: From [Scroll API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/scroll-api.html)

> We no longer recommend using the scroll API for deep pagination.  
> 
> If you need to preserve the index state while paging through more  
> 
> than 10,000 hits, use the search_after parameter with a point in  
> 
> time (PIT). </br>

#### Request

> GET /_search/scroll </br>
> 
> POST /_search/scroll </br>

The scroll API requires a scroll ID. To get a scroll ID, submit a [search API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/search-search.html) request that includes an argument for the [scroll query parameter](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/search-search.html#search-api-scroll-query-param). The scroll parameter indicates how long Elasticsearch should retain the [search context](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/paginate-search-results.html#scroll-search-context) for the request.

The search response returns a scroll ID in the _scroll_id response body parameter. You can then use the scroll ID with the scroll API to retrieve the next batch of results for the request.

You can also use the scroll API to specify a new scroll parameter that extends or shortens the retention period for the search context.

Example:

```json
GET /_search/scroll
{
  "scroll_id" : "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ=="
}
```

#### Clear scroll API

Clears the search context and results for a [scrolling search](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/paginate-search-results.html#scroll-search-results).

```json


DELETE /_search/scroll
{
  "scroll_id" : "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ=="
}

DELETE /_search/scroll

```

#### Example

```json

GET /kibana_sample_data_flights/_search?scroll=5m
{
  "size": 100, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}

```

The response from the request above should include a scroll_id which we can use with Scroll API and the first 100 documents matching the specified query.

```json

GET /_search/scroll
{
  "scroll": "5m",
  "scroll_id": "FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFnpVck5vZlUxU3B1WTB5V3Z4cFpES0EAAAAAAAAEFBZ5amFpSXRjNFNSU3RwamZjYjRSOWVn"
}

```

##### Clear scroll

DELETE /_search/scroll
{
  "scroll_id": "FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFnpVck5vZlUxU3B1WTB5V3Z4cFpES0EAAAAAAAAEFBZ5amFpSXRjNFNSU3RwamZjYjRSOWVn"
}

