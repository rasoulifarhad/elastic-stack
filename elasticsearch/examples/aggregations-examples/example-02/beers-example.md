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

```json

GET /beers/_search
{
  "size": 0,
  "aggs": {
    "price_buckets": {
      "percentiles": {
        "field": "price",
        "keyed": false,
        "percents": [
          20,
          40,
          60,
          80
        ]
      }
    }
  }
}

```

Response:

```json

{
  "took" : 12,
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
    "price_buckets" : {
      "values" : [
        {
          "key" : 20.0,
          "value" : 2.0875760673900734
        },
        {
          "key" : 40.0,
          "value" : 4.037840286701443
        },
        {
          "key" : 60.0,
          "value" : 6.0116843727443285
        },
        {
          "key" : 80.0,
          "value" : 8.026191552565747
        }
      ]
    }
  }
}

```

##### Buckets

###### terms

```json

GET /beers/_search
{
  "size": 0,
  "aggs": {
    "country_beers_bucket": {
      "terms": {
        "field": "country",
        "size": 10
      }
    }
  }
}

```

Response:

```json

{
  "took" : 3,
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
    "country_beers_bucket" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 160,
      "buckets" : [
        {
          "key" : "United States",
          "doc_count" : 4554
        },
        {
          "key" : "Belgium",
          "doc_count" : 319
        },
        {
          "key" : "Germany",
          "doc_count" : 254
        },
        {
          "key" : "United Kingdom",
          "doc_count" : 191
        },
        {
          "key" : "Canada",
          "doc_count" : 153
        },
        {
          "key" : "Austria",
          "doc_count" : 25
        },
        {
          "key" : "Netherlands",
          "doc_count" : 25
        },
        {
          "key" : "Switzerland",
          "doc_count" : 25
        },
        {
          "key" : "Australia",
          "doc_count" : 22
        },
        {
          "key" : "France",
          "doc_count" : 17
        }
      ]
    }
  }
}

```

###### buckets with narrow search

```json

GET /beers/_search
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "country": "Germany"
          }
        }
      ]
    }
  }, 
  "aggs": {
    "city_beers_bucket": {
      "terms": {
        "field": "city",
        "size": 10
      }
    }
  }
}

```

Response:

```json

{
  "took" : 3,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 254,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "city_beers_bucket" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 140,
      "buckets" : [
        {
          "key" : "Bamberg",
          "doc_count" : 34
        },
        {
          "key" : "Kulmbach",
          "doc_count" : 13
        },
        {
          "key" : "Konstanz",
          "doc_count" : 12
        },
        {
          "key" : "Munich",
          "doc_count" : 12
        },
        {
          "key" : "Dsseldorf",
          "doc_count" : 11
        },
        {
          "key" : "Bremen",
          "doc_count" : 7
        },
        {
          "key" : "Kelheim",
          "doc_count" : 7
        },
        {
          "key" : "Aying",
          "doc_count" : 6
        },
        {
          "key" : "Freising",
          "doc_count" : 6
        },
        {
          "key" : "Kempten",
          "doc_count" : 6
        }
      ]
    }
  }
}

```

###### filters

```json

GET /beers/_search
{
  "size": 0,
  "aggs": {
    "country_beers": {
      "filters": {
        "filters": 
        {
          "Austria": {
            "match": {
              "country": "Austria"
            }
          },
          "Czech": {
            "match": {
              "country": "Czech"
            }
          },
          "Germany": {
            "match": {
              "country": "Germany"
            }
          },
          "Hungary": {
            "match": {
              "country": "Hungary"
            }
          },
          "Poland": {
            "match": {
              "country": "Poland"
            }
          }
        }
      }
    }
  }
}

```

Response:

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
      "value" : 5745,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "country_beers" : {
      "meta" : { },
      "buckets" : {
        "Austria" : {
          "doc_count" : 25
        },
        "Czech" : {
          "doc_count" : 0
        },
        "Germany" : {
          "doc_count" : 254
        },
        "Hungary" : {
          "doc_count" : 2
        },
        "Poland" : {
          "doc_count" : 6
        }
      }
    }
  }
}

```

##### Nested

```json

GET /beers/_search
{
  "size": 0,
  "aggs": {
    "country_beers": {
      "filters": {
        "filters": {
          "Austria": {
            "match": {
              "country": "Austria"
            }
          },
          "Czech": {
            "match": {
              "country": "Czech"
            }
          },
          "Germany": {
            "match": {
              "country": "Germany"
            }
          },
          "Hungary": {
            "match": {
              "country": "Hungary"
            }
          },
          "Poland": {
            "match": {
              "country": "Poland"
            }
          }
        }
      },
      "aggs": {
        "price_stats": {
          "stats": {
            "field": "price"
          }
        }
      }
    },
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
    "country_beers" : {
      "meta" : { },
      "buckets" : {
        "Austria" : {
          "doc_count" : 25,
          "price_stats" : {
            "count" : 25,
            "min" : 0.540674090385437,
            "max" : 9.012656211853027,
            "avg" : 4.409108197689056,
            "sum" : 110.22770494222641
          }
        },
        "Czech" : {
          "doc_count" : 0,
          "price_stats" : {
            "count" : 0,
            "min" : null,
            "max" : null,
            "avg" : null,
            "sum" : 0.0
          }
        },
        "Germany" : {
          "doc_count" : 254,
          "price_stats" : {
            "count" : 254,
            "min" : 0.03262186422944069,
            "max" : 9.968053817749023,
            "avg" : 5.347151345932695,
            "sum" : 1358.1764418669045
          }
        },
        "Hungary" : {
          "doc_count" : 2,
          "price_stats" : {
            "count" : 2,
            "min" : 4.4082231521606445,
            "max" : 7.311609745025635,
            "avg" : 5.85991644859314,
            "sum" : 11.71983289718628
          }
        },
        "Poland" : {
          "doc_count" : 6,
          "price_stats" : {
            "count" : 6,
            "min" : 0.1493198722600937,
            "max" : 7.175299644470215,
            "avg" : 4.26553022613128,
            "sum" : 25.59318135678768
          }
        }
      }
    },
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
