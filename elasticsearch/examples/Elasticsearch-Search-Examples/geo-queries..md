### Geo queries

#### Recap

Elasticsearch supports two types of geo data: [geo_point](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/geo-point.html) fields which support lat/lon pairs, and [geo_shape](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/geo-shape.html) fields, which support points, lines, circles, polygons, multi-polygons, etc.

The queries in this group are:

- [geo_bounding_box](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-geo-bounding-box-query.html) query

  Finds documents with geopoints that fall into the specified rectangle.

- [geo_distance](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-geo-distance-query.html) query

  Finds documents with geopoints within the specified distance of a central point.

- [geo_polygon](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-geo-polygon-query.html) query

  Find documents with geopoints within the specified polygon.

- [geo_shape](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-geo-shape-query.html) query

  Finds documents with:

   - Geoshapes which either intersect, are contained by, or do not intersect with the specified geoshape
   - Geopoints which intersect the specified geoshape

See [Geo queries](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/geo-queries.html)

###### Useful links

See [geo-queries](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/geo-queries.html)

See [Find GPS Coordinates on Google maps](https://www.maps.ie/coordinates.html)

See [Geo Point Plotter](https://dwtkns.com/pointplotter/)

See [linestrings](https://linestrings.com/bbox/#-74.1,40.73,-71.12,40.01)

See [openstreetmap](https://www.openstreetmap.org/?minlon=-74.1&minlat=40.73&maxlon=-71.12&maxlat=40.01&box=yes)

See [geojson.io](http://geojson.io/#map=2/0/20)

See [mapper.acme](https://mapper.acme.com/)

See [osm.duschmarke](https://osm.duschmarke.de/bbox.html)

See [norbertrenner](https://norbertrenner.de/osm/bbox.html)

###### Envelope

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

#### Run Elasticsearch && Kibana 

```
docker compose up -d

```

#### 1. Geo-bounding box

###### Index data

1. 

```json

PUT /my_location
{
  "mappings": {
    "properties": {
      "pin": {
        "properties": {
          "location": {
            "type": "geo_point"
          }
        }
      }
    }
  }
}

PUT /my_location/_doc/1
{
  "pin": {
    "location": {
      "lat": 40.12,
      "lon": -71.34
    }
  }
}

```

```json

PUT /my_geoshapes
{
  "mappings": {
    "properties": {
      "pin": {
        "properties": {
          "location": {
            "type": "geo_shape"
          }
        }
      }
    }
  }
}

PUT /my_geoshapes/_doc/1
{
  "pin": {
    "location": {
      "type": "polygon",
      "coordinates": [
        [
          [
            13,
            51.5
          ],
          [
            15,
            51.5
          ],
          [
            15,
            54
          ],
          [
            13,
            54
          ],
          [
            13,
            51.5
          ]
        ]
      ]
    }
  }
}

```

###### Search data

Use a `geo_bounding_box` filter to match `geo_point` values that intersect a bounding box. To define the box, provide geopoint values for two opposite corners.

```json

Lat Lon As Properties

GET /my_location/_search
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
            "pin.location": {
              "top_left": {
                "lat": 40.73,
                "lon": -74.1
              },
              "bottom_right": {
                "lat": 40.01,
                "lon": -71.12
              }
            }
          }
        }
      ]
    }
  }
}

OR: Lat Lon As Array

GET /my_location/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": [-74.1, 40.73] ,
            "bottom_right":[-71.12, 40.01] 
          }
        }
      }
    }
  }
}

OR: Lat Lon As String

GET /my_location/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": "-74.1, 40.73" ,
            "bottom_right": "-71.12, 40.01" 
          }
        }
      }
    }
  }
}

OR: Bounding Box as Well-Known Text (WKT)

GET /my_location/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "wkt": "BBOX (-74.1, -71.12, 40.73, 40.01)"
          }
        }
      }
    }
  }
}

OR: Geohash

GET /my_location/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": "dr5r9ydj2y73" ,
            "bottom_right": "drj7teegpus6" 
          }
        }
      }
    }
  }
}
	
```

<details>
<summary>Response:</summary>

```json

{
  "took" : 11,
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
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "my_location",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "pin" : {
            "location" : {
              "lat" : 40.12,
              "lon" : -71.34
            }
          }
        }
      }
    ]
  }
}

```

</details>

2. 

```json

Lat Lon As Properties

GET /my_geoshapes/_search
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
            "pin.location": {
              "top_left": {
                "lat": 40.73,
                "lon": -74.1
              },
              "bottom_right": {
                "lat": 40.01,
                "lon": -71.12
              }
            }
          }
        }
      ]
    }
  }
}

OR: Lat Lon As Array

GET /my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": [-74.1, 40.73] ,
            "bottom_right":[-71.12, 40.01] 
          }
        }
      }
    }
  }
}

OR: Lat Lon As String

GET /my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": "-74.1, 40.73" ,
            "bottom_right": "-71.12, 40.01" 
          }
        }
      }
    }
  }
}

OR: Bounding Box as Well-Known Text (WKT)

GET /my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "wkt": "BBOX (-74.1, -71.12, 40.73, 40.01)"
          }
        }
      }
    }
  }
}

OR: Geohash

GET /my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": "dr5r9ydj2y73" ,
            "bottom_right": "drj7teegpus6" 
          }
        }
      }
    }
  }
}

``` 

<details>
<summary>Response:</summary>

```json

{
  "took" : 23,
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

3. 

```json

Lat Lon As Properties

GET /my_location,my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": {
              "lat": 40.73,
              "lon": -74.1
            },
            "bottom_right": {
              "lat": 40.01,
              "lon": -71.12
            }
          }
        }
      }
    }
  }
}

OR: Lat Lon As Array

GET /my_location,my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": [-74.1, 40.73] ,
            "bottom_right":[-71.12, 40.01] 
          }
        }
      }
    }
  }
}

OR: Lat Lon As String

GET /my_location,my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": "-74.1, 40.73" ,
            "bottom_right": "-71.12, 40.01" 
          }
        }
      }
    }
  }
}

OR: Bounding Box as Well-Known Text (WKT)

GET /my_location,my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "wkt": "BBOX (-74.1, -71.12, 40.73, 40.01)"
          }
        }
      }
    }
  }
}

OR: Geohash

GET /my_location,my_geoshapes/_search
{
  "query": {
    "bool": {
      "must": {
        "match_all": {}
      },
      "filter": {
        "geo_bounding_box": {
          "pin.location": {
            "top_left": "dr5r9ydj2y73" ,
            "bottom_right": "drj7teegpus6" 
          }
        }
      }
    }
  }
}

``` 

<details>
<summary>Response:</summary>

```json

{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 2,
    "successful" : 2,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "my_location",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "pin" : {
            "location" : {
              "lat" : 40.12,
              "lon" : -71.34
            }
          }
        }
      }
    ]
  }
}

```

</details>

###### Clean

```json

DELETE /my_location
DELETE /my_geoshapes

```
