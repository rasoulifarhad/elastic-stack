### scroll-elasticsearch

See [scroll-elasticsearch](https://linuxhint.com/scroll-elasticsearch/)

#### Recap

**Note**: From [Scroll API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/scroll-api.html)

> We no longer recommend using the scroll API for deep pagination. </br>
> If you need to preserve the index state while paging through more </br>
> than 10,000 hits, use the search_after parameter with a point in </br>
> time (PIT). </br>

##### Request

> GET /_search/scroll </br>
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

##### Clear scroll API

Clears the search context and results for a [scrolling search](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/paginate-search-results.html#scroll-search-results).

```json


DELETE /_search/scroll
{
  "scroll_id" : "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ=="
}

DELETE /_search/scroll

```

#### Basic 

We will use the kibana_sample_data_flights sample data.

Get the number of flights where the ticket price was greater than 500 and less than 1000.

```json

GET /kibana_sample_data_flights/_search
{
 "query": {
   "range": {
     "A": {
       "gte": 500,
       "lte": 1000,
       "boost": 2
     }
   }
 }
}

```

Response:

```json

```

If only want to view one record at a time instead of the entire records.

```json

GET /kibana_sample_data_flights/_search
{
 "from": 0,
 "size": 1,
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

Response:

```json

```

To scroll to the next document:

```json

GET /kibana_sample_data_flights/_search
{
 "from": 1,
 "size": 1,
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

Response:

```json

```

**Elasticsearch will limit you to only 10,000 documents**.


#### The Scroll API

The first step is to fetch the scroll_id:

> By passing the scroll parameter followed by the duration of the search context. </br>

```json

POST /kibana_sample_data_flights/_search?scroll=10m
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

Response: 

```json

```

The response from the request above should include a scroll_id which we can use with Scroll API and the first 100 documents matching the specified query.

```json

GET /_search/scroll
{
 "scroll": "10m",
 "scroll_id": "FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFko5WGQ3VTBOUzVlW"
}

```

In the request above, we specify that we want to use the scroll API followed by the search context. This tells Elasticsearch to refresh the search context and keep it alive for 10 minutes. Next, we pass the scroll_id we get from the previous request and retrieve the subsequent 100 documents.


