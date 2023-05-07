### Beers

From [Elasticsearch aggregations](https://github.com/russmedia/elasticsearch-aggregations)

#### Create index

<details open><summary><i>Mappings</i></summary><blockquote>

```json
PUT /beers
{
  "mappings": {
    "dynamic": false,
    "properties": {
      "name": {
        "type": "text"
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

</blockquote></details>

---

#### Load data

<details open><summary><i>Loading..</i></summary><blockquote>

```
$ python3 -m pip install elasticsearch@7.17.9
$ cd dataset
$ python3 load_beers.py

```

</blockquote></details>

---

#### Query context

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>Query DSL</i></summary>

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

  </details>

  <details open><summary><i>Query DSL</i></summary><blockquote>

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

  </details>

</blockquote></details>

---

#### Filter context

<details open><summary><i>Query DSL</i></summary><blockquote>

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
</blockquote></details>

---

####  Aggregations


##### stats

<details open><summary><i>Query DSL: aggs</i></summary><blockquote>

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

  <details><summary><i>Response</i></summary>

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

  </details>

</blockquote></details>

---

##### extended_stats

<details open><summary><i>Query DSL</i></summary><blockquote>

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

  <details><summary><i>Response</i></summary>

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

  </details>

</blockquote></details>

---

##### Percentiles

<details open><summary><i>Query DSL</i></summary><blockquote>

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

  <details><summary><i>Response</i></summary>

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

  </details>

</blockquote></details>

---

##### Buckets

###### terms

<details open><summary><i>Query DSL</i></summary><blockquote>

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

  <details><summary><i>Response</i></summary>

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

  </details>

</blockquote></details>

---

###### buckets with narrow search

<details open><summary><i>Query DSL</i></summary><blockquote>

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

  <details><summary><i>Response</i></summary>

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

  </details>

</blockquote></details>

---

###### filters

<details open><summary><i>Query DSL</i></summary><blockquote>

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

  <details><summary><i>Response</i></summary>

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

  </details>

</blockquote></details>

---

##### Nested

<details open><summary><i>Query DSL</i></summary><blockquote>

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

  <details><summary><i>Response</i></summary>

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

  </details>

</blockquote></details>

---

#### Advanced fulltext search

##### Proximity search

######


<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>With `slop=1`:</i></summary><blockquote>

  ```json
  GET /beers/_search
  {
    "query": {
      "match_phrase": {
        "name_breweries": {
          "query": "Zywiec Browar",
          "slop": 1
        }
      }
    }
  }
  ```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 2,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 0,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    }
  }
  ```

  </details>

  </blockquote></details>

  <details open><summary><i>With `slop=2`:</i></summary><blockquote>

  ```json
  GET /beers/_search
  {
    "query": {
      "match_phrase": {
        "name_breweries": {
          "query": "Zywiec Browar",
          "slop": 2
        }
      }
    }
  }
  ```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 2,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : 8.840872,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "244c6b68f6c6768c721296c8bc023615ab6587af",
          "_score" : 8.840872,
          "_source" : {
            "name" : "Porter",
            "country" : "Poland",
            "price" : 4.521201190967011,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "9c499b27ec24d095a42bf4dd51bf42d481bede12",
          "_score" : 8.840872,
          "_source" : {
            "name" : "Krakus",
            "country" : "Poland",
            "price" : 3.0919758904836714,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        }
      ]
    }
  }
  ```

  </details>

  </blockquote></details>

</blockquote></details>

---

###### 

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /beers/_search
{
  "query": {
    "multi_match": {
      "query": "Zywiec Browar",
      "fields": ["name_breweries", "name"]
    }
  }
}
```

  <details><summary>Response:</summary>

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
        "value" : 6,
        "relation" : "eq"
      },
      "max_score" : 17.032831,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "244c6b68f6c6768c721296c8bc023615ab6587af",
          "_score" : 17.032831,
          "_source" : {
            "name" : "Porter",
            "country" : "Poland",
            "price" : 4.521201190967011,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "9c499b27ec24d095a42bf4dd51bf42d481bede12",
          "_score" : 17.032831,
          "_source" : {
            "name" : "Krakus",
            "country" : "Poland",
            "price" : 3.0919758904836714,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "cabb68c777846795bd5b5bfca2535b20e2086910",
          "_score" : 7.913264,
          "_source" : {
            "name" : "O.K. Beer",
            "country" : "Poland",
            "price" : 0.030807094117204503,
            "city" : "Brzesko",
            "name_breweries" : "Browar Okocim",
            "coordinates" : "49.9622,20.6003"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "b0050545dd49f5b8809700b9c6d493a94be0d4c2",
          "_score" : 7.913264,
          "_source" : {
            "name" : "Okocim Porter",
            "country" : "Poland",
            "price" : 8.78690910474888,
            "city" : "Brzesko",
            "name_breweries" : "Browar Okocim",
            "coordinates" : "49.9622,20.6003"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "09cda3148f088f4d15692431870ef115f6346743",
          "_score" : 6.076418,
          "_source" : {
            "name" : "Porter Czarny Boss / Black BOSS Porter",
            "country" : "Poland",
            "price" : 2.99497018728464,
            "city" : "Witnica",
            "name_breweries" : "BOSS Browar Witnica S.A.",
            "coordinates" : "52.6739,14.9004"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "1a18ae6f33c34eb7e4fa87a446df0112bbf32905",
          "_score" : 6.076418,
          "_source" : {
            "name" : "Mocny BOSS / BOSS Beer",
            "country" : "Poland",
            "price" : 6.725042889806513,
            "city" : "Witnica",
            "name_breweries" : "BOSS Browar Witnica S.A.",
            "coordinates" : "52.6739,14.9004"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

######

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /beers/_search
{
  "query": {
    "multi_match": {
      "query": "Zywiec Browar",
      "fields": ["name_breweries", "name"],
      "operator": "and"
    }
  }
}
```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 2,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : 17.032831,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "244c6b68f6c6768c721296c8bc023615ab6587af",
          "_score" : 17.032831,
          "_source" : {
            "name" : "Porter",
            "country" : "Poland",
            "price" : 4.521201190967011,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "9c499b27ec24d095a42bf4dd51bf42d481bede12",
          "_score" : 17.032831,
          "_source" : {
            "name" : "Krakus",
            "country" : "Poland",
            "price" : 3.0919758904836714,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Match query

<details open><summary>Note:</summary>

Returns documents that match a provided text, number, date or boolean value. The provided text is analyzed before matching.

The match query is the standard query for performing a full-text search, including options for fuzzy matching.

</details>

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /beers/_search
{
  "query": {
    "match": {
      "name_breweries": {
        "query": "ZywieX",
        "fuzziness": 1
      }
    }
  }
}
```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 20,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : 7.5996394,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "244c6b68f6c6768c721296c8bc023615ab6587af",
          "_score" : 7.5996394,
          "_source" : {
            "name" : "Porter",
            "country" : "Poland",
            "price" : 4.521201190967011,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "9c499b27ec24d095a42bf4dd51bf42d481bede12",
          "_score" : 7.5996394,
          "_source" : {
            "name" : "Krakus",
            "country" : "Poland",
            "price" : 3.0919758904836714,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Query boost

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /beers/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "name": {
              "query": "Porter",
              "boost": 5
            }
          }
        },
        {
          "match": {
            "name_breweries": "Browar Zywiec"
          }
        }
      ],
      "must_not": [
        {
          "term": {
            "country": "United States"
          }
        }
      ]
    }
  }
}
```

  <details><summary>Response:</summary>

  ```json
  {
    "took" : 7,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : 37.596436,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "244c6b68f6c6768c721296c8bc023615ab6587af",
          "_score" : 37.596436,
          "_source" : {
            "name" : "Porter",
            "country" : "Poland",
            "price" : 4.521201190967011,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "b0050545dd49f5b8809700b9c6d493a94be0d4c2",
          "_score" : 24.970346,
          "_source" : {
            "name" : "Okocim Porter",
            "country" : "Poland",
            "price" : 8.78690910474888,
            "city" : "Brzesko",
            "name_breweries" : "Browar Okocim",
            "coordinates" : "49.9622,20.6003"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "09cda3148f088f4d15692431870ef115f6346743",
          "_score" : 21.660965,
          "_source" : {
            "name" : "Porter Czarny Boss / Black BOSS Porter",
            "country" : "Poland",
            "price" : 2.99497018728464,
            "city" : "Witnica",
            "name_breweries" : "BOSS Browar Witnica S.A.",
            "coordinates" : "52.6739,14.9004"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

***With operator:***

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /beers/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "name": {
              "query": "Porter",
              "boost": 5
            }
          }
        },
        {
          "match": {
            "name_breweries": {
              "query": "Browar Zywiec",
              "operator": "and"
            }
          }
        }
      ],
      "must_not": [
        {
          "term": {
            "country": "United States"
          }
        }
      ]
    }
  }
}

``` 

  <details><summary>Response:</summary>

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
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 37.596436,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "244c6b68f6c6768c721296c8bc023615ab6587af",
          "_score" : 37.596436,
          "_source" : {
            "name" : "Porter",
            "country" : "Poland",
            "price" : 4.521201190967011,
            "city" : "Zywiec",
            "name_breweries" : "Browar Zywiec",
            "coordinates" : "49.6622,19.1742"
          }
        }
      ]
    }
  }
  ```

  </details>  

</blockquote></details>

***Try this:***

<details open><summary><i></i></summary><blockquote>


  <details open><summary><i>1.</i></summary><blockquote>

  ```json
  GET /beers/_search
  {
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "name": {
                "query": "Porter",
                "boost": 5
              }
            }
          },
          {
            "match": {
              "name_breweries": {
                "query": "Browar Zywiex",
                "operator": "and"
              }
            }
          }
        ],
        "must_not": [
          {
            "term": {
              "country": "United States"
            }
          }
        ]
      }
    }
  }

  ```

  </details>

  <details open><summary><i>2.</i></summary><blockquote>

  ```json
  GET /beers/_search
  {
    "query": {
      "bool": {
        "must": [
          {
            "match": {
              "name": {
                "query": "Porter",
                "boost": 5
              }
            }
          },
          {
            "match": {
              "name_breweries": {
                "query": "Browar Zywiex",
                "operator": "and",
                "fuzziness": 1
              }
            }
          }
        ],
        "must_not": [
          {
            "term": {
              "country": "United States"
            }
          }
        ]
      }
    }
  }

  ```

  </details>

</blockquote></details>

---

##### Geo-search `by rectangle (Berlin coordinates)`

<!-- 

Elasticsearch supports an envelope type, which consists of coordinates for upper left and lower right points of the shape to represent a bounding rectangle in the format [[minLon, maxLat], [maxLon, minLat]]:

```json
POST /example/_doc
{
  "location" : {
    "type" : "envelope",
    "coordinates" : [ [100.0, 1.0], [101.0, 0.0] ]
  }
}
```

The following is an example of an envelope using the WKT BBOX format:

NOTE: WKT specification expects the following order: minLon, maxLon, maxLat, minLat.

```json
POST /example/_doc
{
  "location" : "BBOX (100.0, 102.0, 2.0, 0.0)"
}
```

```

upper_left: [minLon, maxLat]  bottom_right: [maxLon, minLat]

upper_left: [13.090329, 52.644465]  bottom_right: [13.732684, 52.304024]

See [bboxfinder](http://bboxfinder.com/#13.090329,13.732684,52.644465,52.304024)

See [linestrings bbox](https://linestrings.com/bbox/#13.090329,13.732684,52.644465,52.304024}

See [openstreetmap](https://www.openstreetmap.org/?minlon=-13.090329&minlat=52.304024&maxlon=13.732684&maxlat=52.644465&box=yes)

See [Geo Point Plotter](https://dwtkns.com/pointplotter/)

See [Find GPS Coordinates on Google maps](https://www.maps.ie/coordinates.html)

```

-->

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /beers/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_all": {}
        }
      ],
      "filter": [
        {
          "geo_bounding_box": {
            "coordinates": {
              "top_left": {
                "lat": 52.644465,
                "lon": 13.090329
              },
              "bottom_right": {
                "lat": 52.304024,
                "lon": 13.732684
              }
            }
          }
        }
      ]
    }
  }  
}
```

  <details><summary>Response:</summary>

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
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : 1.0,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "711c10425d199136f5857cfe08d0bff750e425a4",
          "_score" : 1.0,
          "_source" : {
            "name" : "Weisse",
            "country" : "Germany",
            "price" : 4.625438309037469,
            "city" : "Berlin",
            "name_breweries" : "Berliner Kindl Brauerei AG",
            "coordinates" : "52.4793,13.4293"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "bcb2565e1285f9f49c29654eb809690c20e36ac0",
          "_score" : 1.0,
          "_source" : {
            "name" : "Original Berliner Weisse",
            "country" : "Germany",
            "price" : 8.945223345501693,
            "city" : "Berlin",
            "name_breweries" : "Berliner-Kindl-Schultheiss-Brauerei",
            "coordinates" : "52.5234,13.4114"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Geo-search `by distance from point (Munich)`

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /beers/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_all": {}
        }
      ],
      "filter": [
        {
          "geo_distance": {
            "distance": "100km",
            "coordinates": {
              "lat": 48.135125,
              "lon": 11.569979
            }
          }
        }
      ]
    }
  },
  "size": 5
}
```

  <details><summary>Response:</summary>

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
        "value" : 58,
        "relation" : "eq"
      },
      "max_score" : 1.0,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "be7cdf0d3ab19d83fead896ac54bb7082b6f0c97",
          "_score" : 1.0,
          "_source" : {
            "name" : "Oktober Fest - MÃ¤rzen",
            "country" : "Germany",
            "price" : 7.197567541105004,
            "city" : "Aying",
            "name_breweries" : "Brauerei Aying Franz Inselkammer KG",
            "coordinates" : "47.9706,11.7808"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "1615cad4f3246fce6a20d9462e11f3563a2b6b0c",
          "_score" : 1.0,
          "_source" : {
            "name" : "Export-Hell",
            "country" : "Germany",
            "price" : 5.606740274991853,
            "city" : "Traunstein",
            "name_breweries" : "Hofbruhaus Traunstein",
            "coordinates" : "47.8691,12.650500000000001"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "aaa17181e9df1181886da5164cb9efb744962b54",
          "_score" : 1.0,
          "_source" : {
            "name" : "Original Oktoberfest",
            "country" : "Germany",
            "price" : 0.6300895179963684,
            "city" : "Mnchen",
            "name_breweries" : "Hacker-Pschorr Bru",
            "coordinates" : "48.1391,11.5802"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "bfec2200ca44f417a88631626288d7c3388d6389",
          "_score" : 1.0,
          "_source" : {
            "name" : "Hacker-Pschorr Original Oktoberfest",
            "country" : "Germany",
            "price" : 7.402009944939146,
            "city" : "Munich",
            "name_breweries" : "Paulaner",
            "coordinates" : "48.1391,11.5802"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "270e08f7f3657bf161c06b3bd5bda6a19083489e",
          "_score" : 1.0,
          "_source" : {
            "name" : "BrÃ¤u-Weisse",
            "country" : "Germany",
            "price" : 2.920831985487662,
            "city" : "Aying",
            "name_breweries" : "Brauerei Aying Franz Inselkammer KG",
            "coordinates" : "47.9706,11.7808"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Geo-search `by drawing a polygon (Bregenz - Schwarzach - Dornibirn)`

<details open><summary><i>Query DSL</i></summary><blockquote>

```json
GET /beers/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_all": {}
        }
      ],
      "filter": [
        {
          "geo_polygon": {
            "coordinates": {
              "points": [
                {
                  "lat": 47.406177,
                  "lon": 9.745112
                },
                {
                  "lat": 47.446801,
                  "lon": 9.762261
                },
                {
                  "lat": 47.501465,
                  "lon": 9.731163
                }
              ]
            }
          }
        }
      ]
    }
  }
}
```

  <details><summary>Response:</summary>

  ```json
  #! Deprecated field [geo_polygon] used, replaced by [[geo_shape] query where polygons are defined in geojson or wkt]
  {
    "took" : 2,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : 1.0,
      "hits" : [
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "7fd24f21e65fadd97f8890de5aeda7ebaa5f7506",
          "_score" : 1.0,
          "_source" : {
            "name" : "Gambrinus",
            "country" : "Austria",
            "price" : 9.955426078520752,
            "city" : "Dornbirn",
            "name_breweries" : "Mohrenbrauerei August Huber",
            "coordinates" : "47.4123,9.7443"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "c3143baba640536253596fdeed6261f9611bf033",
          "_score" : 1.0,
          "_source" : {
            "name" : "NaturtrÃ¼bes Kellerbier",
            "country" : "Austria",
            "price" : 5.9724479262167085,
            "city" : "Dornbirn",
            "name_breweries" : "Mohrenbrauerei August Huber",
            "coordinates" : "47.4123,9.7443"
          }
        },
        {
          "_index" : "beers",
          "_type" : "_doc",
          "_id" : "deab34b2dd443f59fbdb40e4a28b8920840b16cc",
          "_score" : 1.0,
          "_source" : {
            "name" : "Spezial",
            "country" : "Austria",
            "price" : 7.004672212177001,
            "city" : "Dornbirn",
            "name_breweries" : "Mohrenbrauerei August Huber",
            "coordinates" : "47.4123,9.7443"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

##### Synonyms

***1. Copy synonyms file to elasticsearch docker***

```
docker cp dataset/synonyms.txt example-02-elasticsearch-1:/usr/share/elasticsearch/config/synonyms.txt

```

***2. Create index, and configures a synonym filter***

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>Mappings:</i></summary>

  ```json
  PUT /test_synonym_graph
  {
    "settings": {
      "index": {
        "analysis": {
          "analyzer": {
            "index_analyzer": {
              "tokenizer": "standard",
              "filter": ["lowercase"]
            },
            "search_analyzer": {
              "tokenizer": "standard",
              "filter": ["lowercase", "synonym_filter"]
            }
          },
          "filter": {
            "synonym_filter": {
              "type": "synonym_graph",
              "synonyms_path": "synonyms.txt",
              "updateable": true
            }
          }
        }
      }
    },
    "mappings": {
      "properties": {
        "name": {
          "type": "text", 
          "analyzer": "index_analyzer",
          "search_analyzer": "search_analyzer"
        }
      }
    }
  }
  ```

  </details>
  
  <details open><summary><i>Mappings:</i></summary>

  ```json
  PUT /test_synonym_graph2
  {
    "settings": {
      "index": {
        "analysis": {
          "analyzer": {
            "index_analyzer": {
              "tokenizer": "standard",
              "filter": ["lowercase"]
            },
            "search_analyzer": {
              "tokenizer": "standard",
              "filter": ["lowercase", "synonym_filter"]
            }
          },
          "filter": {
            "synonym_filter": {
              "type": "synonym_graph",
              "synonyms": [
                "PS => PlayStation",
                "Play Station => PlayStation"
              ]
            }
          }
        }
      }
    },
    "mappings": {
      "properties": {
        "name": {
          "type": "text", 
          "analyzer": "index_analyzer",
          "search_analyzer": "search_analyzer"
        }
      }
    }
  }
  ```

  </details>
  
  <details open><summary><i>Mappings:</i></summary>

  ```json
  PUT /test_index2
  {
    "settings": {
      "index": {
        "analysis": {
          "analyzer": {
            "index_analyzer": {
              "tokenizer": "whitespace",
              "filter": ["synonym_filter"]
            }
          },
          "filter": {
            "synonym_filter": {
              "type": "synonym",
              "synonyms": [
                "PS => PlayStation",
                "Play Station => PlayStation"
              ]
            }
          }
        }
      }
    },
    "mappings": {
      "properties": {
        "name": {
          "type": "text", 
          "analyzer": "index_analyzer"
        }
      }
    }
  }
  ```

  </details>

</blockquote></details>

***Note:***
> Path of synonym.txt is relative to the config location.  
> 

***Note:***
> The synonym analyzer is configured with the filter. this filter tokenizes synonyms with whatever tokenizer and token filters appear before it in the chain.
> 


***To test the analyzer created in the index, we can call the _analyze endpoint:***

<details open><summary><i>Test analyzer:</i></summary><blockquote>

```json
GET /test_index2/_analyze
{
  "analyzer": "index_analyzer",
  "text": "PS 3"
}
```

***We can see that the token for “PS” is replaced with the synonym specified.***

  <details><summary>Response:</summary>

  ```json
  {
    "tokens" : [
      {
        "token" : "PlayStation",
        "start_offset" : 0,
        "end_offset" : 2,
        "type" : "SYNONYM",
        "position" : 0
      },
      {
        "token" : "3",
        "start_offset" : 3,
        "end_offset" : 4,
        "type" : "word",
        "position" : 1
      }
    ]
  }
  ```

</details>

</blockquote></details>

---

***Let’s add some documents to the index and test if it works properly in searching:***


<details open><summary><i>Indexing</i></summary><blockquote>

```json
PUT /test_synonym_graph/_doc/1
{
  "name": "PS 3"
}

PUT /test_synonym_graph/_doc/2
{
  "name": "PlayStation 4"
}


PUT /test_synonym_graph/_doc/3
{
  "name": "Play Station 5r"
}

PUT /test_synonym_graph2/_doc/1
{
  "name": "PS 3"
}

PUT /test_synonym_graph2/_doc/2
{
  "name": "PlayStation 4"
}


PUT /test_synonym_graph2/_doc/3
{
  "name": "Play Station 5r"
}


PUT /test_index2/_doc/1
{
  "name": "PS 3"
}

PUT /test_index2/_doc/2
{
  "name": "PlayStation 4"
}


PUT /test_index2/_doc/3
{
  "name": "Play Station 5r"
}
```

</blockquote></details>


***We can perform a simple search with the match keyword:***

<details open><summary><i>Query DSL</i></summary><blockquote>

  <details><summary><i>Query DSL</i></summary><blockquote>

  ```json
  GET /test_synonym_graph/_search
  {
    "query": {
      "match": {
        "name": "PS"
      }
    }  
  }
  ```

  <details><summary><i>Response</i></summary>

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
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : 1.7563686,
      "hits" : [
        {
          "_index" : "test_synonym_graph",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : 1.7563686,
          "_source" : {
            "name" : "Play Station 5r"
          }
        },
        {
          "_index" : "test_synonym_graph",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.0417082,
          "_source" : {
            "name" : "PS 3"
          }
        },
        {
          "_index" : "test_synonym_graph",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 1.0417082,
          "_source" : {
            "name" : "PlayStation 4"
          }
        }
      ]
    }
  }
  ```

  </details>

  </blockquote></details>

  <details open><summary><i>Query DSL</i></summary><blockquote>

  ```json
  GET /test_synonym_graph2/_search
  {
    "query": {
      "match": {
        "name": "PS"
      }
    }  
  }
  ```

  <details><summary><i>Response</i></summary>

  ```json
  {
    "took" : 0,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 1.0417082,
      "hits" : [
        {
          "_index" : "test_synonym_graph2",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 1.0417082,
          "_source" : {
            "name" : "PlayStation 4"
          }
        }
      ]
    }
  }
  ```

  </details>

  </blockquote></details>

  <details open><summary><i>Query DSL</i></summary><blockquote>

  ```json
  GET /test_synonym_graph2/_search
  {
    "query": {
      "match": {
        "name": "PS"
      }
    }  
  }
  ```

  <details><summary><i>Response</i></summary>

  ```json
  {
    "took" : 0,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 1.0417082,
      "hits" : [
        {
          "_index" : "test_synonym_graph2",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 1.0417082,
          "_source" : {
            "name" : "PlayStation 4"
          }
        }
      ]
    }
  }
  ```

  </details>

  </blockquote></details>

  <details open><summary><i>Query DSL</i></summary><blockquote>

  ```json
  GET /test_index2/_search
  {
    "query": {
      "match": {
        "name": "PS"
      }
    }  
  }
  ```

  <details><summary><i>Response</i></summary>

  ```json
  {
    "took" : 203,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : 0.13353139,
      "hits" : [
        {
          "_index" : "test_index2",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 0.13353139,
          "_source" : {
            "name" : "PS 3"
          }
        },
        {
          "_index" : "test_index2",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 0.13353139,
          "_source" : {
            "name" : "PlayStation 4"
          }
        },
        {
          "_index" : "test_index2",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : 0.13353139,
          "_source" : {
            "name" : "Play Station 5r"
          }
        }
      ]
    }
  }
  ```

  </details>

  </blockquote></details>

</blockquote></details>

---

***Repair test_synonym_graph2 index:***

<details open><summary><i></i></summary><blockquote>

  <details><summary><i>Mappings:</i></summary>

  ```json
  PUT /test_synonym_graph2
  {
    "settings": {
      "index": {
        "analysis": {
          "analyzer": {
            "index_analyzer": {
              "tokenizer": "standard",
              "filter": ["lowercase"]
            },
            "search_analyzer": {
              "tokenizer": "standard",
              "filter": ["lowercase", "synonym_filter"]
            }
          },
          "filter": {
            "synonym_filter": {
              "type": "synonym_graph",
              "synonyms": [
                "PS, PlayStation, Play Station"
              ]
            }
          }
        }
      }
    },
    "mappings": {
      "properties": {
        "name": {
          "type": "text", 
          "analyzer": "index_analyzer",
          "search_analyzer": "search_analyzer"
        }
      }
    }
  }
  ```

  </details>

  <details open><summary><i>Test Search</i></summary><blockquote>

  ```json
  GET /test_synonym_graph2/_search
  {
    "query": {
      "match": {
        "name": "PS"
      }
    }  
  }
  ```

  <details><summary>Response:</summary>

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
        "value" : 3,
        "relation" : "eq"
      },
      "max_score" : 1.7563686,
      "hits" : [
        {
          "_index" : "test_synonym_graph2",
          "_type" : "_doc",
          "_id" : "3",
          "_score" : 1.7563686,
          "_source" : {
            "name" : "Play Station 5r"
          }
        },
        {
          "_index" : "test_synonym_graph2",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.0417082,
          "_source" : {
            "name" : "PS 3"
          }
        },
        {
          "_index" : "test_synonym_graph2",
          "_type" : "_doc",
          "_id" : "2",
          "_score" : 1.0417082,
          "_source" : {
            "name" : "PlayStation 4"
          }
        }
      ]
    }
  }
  ```

  </details>

  </blockquote></details>

</blockquote></details>


<details open><summary><i>Note:</i></summary><blockquote>

  To change the synonyms of an existing index, we can recreate the index and reindex all the documents, which is silly and inefficient.

  A better way is to update the settings of the index. However, we need to close the index before the settings can be updated, and then re-open it so it can be accessed:

  <details open><summary><i></i></summary>

  ```json
  POST /test_synonym_graph2/_close

  PUT /test_synonym_graph2/_settings
  {
    "settings": {
      "index.analysis.filter.synonym_filter.synonyms": [
        "PS, PlayStation, Play Station"
        ]
    }
  }

  POST /test_synonym_graph2/_open
  ```

  </details>


  ***After the above commands are run, let’s test the search_analyzer with the _analyzer endpoint and see the tokens generated:***

  <details open><summary><i></i></summary><blockquote>

  ```json
  GET /test_synonym_graph2/_analyze
  {
    "analyzer": "search_analyzer",
    "text": "PS 3"
  }    
  ```

  <details><summary>Response:</summary>

  ```json
  {
    "tokens" : [
      {
        "token" : "playstation",
        "start_offset" : 0,
        "end_offset" : 2,
        "type" : "SYNONYM",
        "position" : 0,
        "positionLength" : 2
      },
      {
        "token" : "play",
        "start_offset" : 0,
        "end_offset" : 2,
        "type" : "SYNONYM",
        "position" : 0
      },
      {
        "token" : "ps",
        "start_offset" : 0,
        "end_offset" : 2,
        "type" : "<ALPHANUM>",
        "position" : 0,
        "positionLength" : 2
      },
      {
        "token" : "station",
        "start_offset" : 0,
        "end_offset" : 2,
        "type" : "SYNONYM",
        "position" : 1
      },
      {
        "token" : "3",
        "start_offset" : 3,
        "end_offset" : 4,
        "type" : "<NUM>",
        "position" : 2
      }
    ]
  }

  ```

  </detals>

  </blockquote></details>

  It shows that the “PS” search query is replaced and expanded with the tokens of the three synonyms (which is controlled by the expand option). It also proves that if equivalent synonyms are applied at index time, the size of the resultant index can be increased quite significantly.

  Then when we perform the same search again.

</blockquote></details>

---

When the synonyms have been added, we can close and open the index to make it effective. However, since we mark the synonym filter as updateable, we can reload the search analyzer to make the changes effective immediately without closing the index and thus with no downtime.

***let’s add more synonyms to the synonym file, which will then has the content as follows:***

```
# This is a comment! The file is named synonyms.txt.
PS, Play Station, PlayStation
JS => JavaScript
TS => TypeScript
Py => Python
```

***To reload the search analyzers of an index, we need to call the `_reload_search_analyzers` endpoint:***

```json
POST /test_synonym_graph/_reload_search_analyzers
```

***Now when we analyze the “JS” string, we will see the “javascript” token returned:***

<details open><summary><i>Analyze:</i></summary><blockquote>

```json
GET /test_synonym_graph/_analyze
{
  "analyzer": "search_analyzer",
  "text": "JS"
}
```

  <details><summary>Response:</summary>

  ```json
  {
    "tokens" : [
      {
        "token" : "javascript",
        "start_offset" : 0,
        "end_offset" : 2,
        "type" : "SYNONYM",
        "position" : 0
      }
    ]
  }
  ```

  </details>

  <details><summary>Note:</summary>

  Two important things should be noted here:

  - If updateable is set to true for a synonym filter, then the corresponding analyzer can only be used as a search_analyzer, and cannot be used for indexing, even if the type is synonym.

  - The updateable option can only be used when a synonym file is used with the synonym_path option, and not when the synonyms are provided directly with the synonyms option.


  </details>

</blockquote></details>

---

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

See [How to Use the Synonyms Feature Correctly in Elasticsearch](https://towardsdatascience.com/how-to-use-the-synonyms-feature-correctly-in-elasticsearch-7bdf856a94cb)