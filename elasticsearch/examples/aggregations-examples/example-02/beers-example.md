### Beers

See [Elasticsearch aggregations](https://github.com/russmedia/elasticsearch-aggregations)

#### Create index

```json

PUT /beers
{
  "mappings": {
    "dynamic": false,
    "properties": {
      "name": {
        "type": "text"python3 load_beers.py
      },
      "country": {
        "type": "keyword"
      },
      "price": {
        "type": "float"
      },
      "city": {
        "type": "keyword"
      },
      "name_breweries": {
        "type": "text"
      },
      "coordinates": { 
        "type": "geo_point"
      }
    }
  }
}

```

#### Load data

```

$ python3 -m pip install elasticsearch@7.17.9
$ cd dataset
$ python3 load_beers.py

```

#### Query context

```json

GET /beers/_search
{
  "query": {
    "match": {
      "name": "Porter"
    }
  }
}

```

```json

GET /beers/_explain/64df95ea31ef345e49b17212c1a25a56af8304db
{
  "query": {
    "match": {
      "name": "Porter"
    }
  }
}

```

#### Filter context

```json

GET /beers/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "country": "Poland"
          }
        }
      ]
    }
  }
}

```

####  Aggregations

##### stats

```json

GET /beers/_search
{
  "size": 0,
  "aggs": {
    "price_stats": {
      "stats": {
        "field": "price"
      }
    }
  }
}

```

Response:

```json

{
  "took" : 14,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 5745,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "price_stats" : {
      "count" : 5745,
      "min" : 9.145146468654275E-4,
      "max" : 9.99954605102539,
      "avg" : 5.029514939119019,
      "sum" : 28894.563325238763
    }
  }
}

```

##### extended_stats

```json

GET /beers/_search
{
  "size": 0,
  "aggs": {
    "price_stats": {
      "extended_stats": {
        "field": "price"
      }
    }
  }
}

```

Response:

```json

{
  "took" : 5,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 5745,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "price_stats" : {
      "count" : 5745,
      "min" : 9.145146468654275E-4,
      "max" : 9.99954605102539,
      "avg" : 5.029514939119019,
      "sum" : 28894.563325238763,
      "sum_of_squares" : 192551.22757202818,
      "variance" : 8.220294111126075,
      "variance_population" : 8.220294111126075,
      "variance_sampling" : 8.221725220825087,
      "std_deviation" : 2.867105528425153,
      "std_deviation_population" : 2.867105528425153,
      "std_deviation_sampling" : 2.867355091512924,
      "std_deviation_bounds" : {
        "upper" : 10.763725995969324,
        "lower" : -0.7046961177312872,
        "upper_population" : 10.763725995969324,
        "lower_population" : -0.7046961177312872,
        "upper_sampling" : 10.764225122144866,
        "lower_sampling" : -0.7051952439068288
      }
    }
  }
}

```

##### Percentiles


##### Buckets

##### Nested

#### Advanced fulltext search

##### Proximity search

##### Fuzzyness


##### Query boost


##### Geo-search


##### Synonyms


#### Useful commands

##### Get indices:

```json

GET http://localhost:9200/_cat/indices?v

```

##### Index description:

```json

GET http://localhost:9200/beers

```

##### Index mappings:

```json

http://localhost:9200/beers/_mapping

```

##### Delete index:

```json

DELETE http://localhost:9200/beers

```
