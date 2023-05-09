## Elasticsearch queries


### Index creation

<details><summary><i>Create an index with a given mapping that contains a geo_point type</i></summary>

```json
PUT workshop_test
{
  "settings": {
    "number_of_replicas": 1,
    "number_of_shards": 1
  },
  "mappings":{
    "properties": {
      "location": {
        "type": "geo_point"
      },
      "category": {
        "type": "keyword"
      },
      "title": {
        "type": "text"
      }
    }
  }
}
```

</details>

---

### Inserting points

For geospatial data there are a number of different ways to specify the coordinates.

<details><summary><i>As a string: latitude, longitude</i></summary>

```json
POST workshop_test/_doc/1
{
  "location": "41.12,-71.34",
  "category": "place name",
  "title": "Null Island"
}
```

</details>

<details><summary><i>As a geohash:</i></summary>

```json
POST workshop_test/_doc/2
{
  "location": "drm3btev3e86",
  "category": "place name 2",
  "title": "Somewhere"
}
```

</details>

<details><summary><i>As an array: longitude, latitude</i></summary>

```json
POST workshop_test/_doc/3
{
  "location": [ -71.34, 41.12 ] ,
  "category": "place name 3",
  "title": "Somewhere 3"
}
```

</details>

<details><summary><i>As an object:</i></summary>

```json
POST workshop_test/_doc/4
{
  "location": {
      "lat": 41.12,
      "lon": -71.34
  } ,
  "category": "place name 4",
  "title": "Somewhere 4"
}
```

</details>

---

### Bulk insertion

***Define a new index***

<details><summary><i>mapping</i></summary>

```json
PUT airports
{
    "mappings": {
        "properties": {
            "coords": {
                "type": "geo_point"
            },
            "abbrev": {
                "type": "keyword"
            },
            "name": {
                "type": "text"
            },
            "type": {
                "type": "keyword"
            }
        }
    }
}
```

</details>

***Insert more than one document in a single `_bulk` request***

<details><summary><i>bulk request</i></summary>

```json
PUT _bulk
{ "index" : { "_index" : "airports", "_id" : "1" } }
{"coords":[75.9570722,30.8503599],"name":"Sahnewal","abbrev":"LUH","type":"small"}
{ "index" : { "_index" : "airports", "_id" : "2" } }
{"coords":[75.9330598,17.6254152],"name":"Solapur","abbrev":"SSE","type":"mid"}
{ "index" : { "_index" : "airports", "_id" : "3" } }
{"coords":[85.323597,23.3177246],"name":"Birsa Munda","abbrev":"IXR","type":"mid"}
{ "index" : { "_index" : "airports", "_id" : "4" } }
{"coords":[48.7471065,31.3431586],"name":"Ahwaz","abbrev":"AWZ","type":"mid"}
{ "index" : { "_index" : "airports", "_id" : "5" } }
{"coords":[78.2172187,26.2854877],"name":"Gwalior","abbrev":"GWL","type":"mid and military"}
{ "index" : { "_index" : "airports", "_id" : "6" } }
{"coords":[42.9710963,14.7552534],"name":"Hodeidah Int'l","abbrev":"HOD","type":"mid"}
{ "index" : { "_index" : "airports", "_id" : "7" } }
{"coords":[75.8092915,22.7277492],"name":"Devi Ahilyabai Holkar Int'l","abbrev":"IDR","type":"mid"}
{ "index" : { "_index" : "airports", "_id" : "8" } }
{"coords":[73.8105675,19.9660206],"name":"Gandhinagar","abbrev":"ISK","type":"mid"}
{ "index" : { "_index" : "airports", "_id" : "9" } }
{"coords":[76.8017261,30.6707249],"name":"Chandigarh Int'l","abbrev":"IXC","type":"major and military"}
{ "index" : { "_index" : "airports", "_id" : "10" } }
{"coords":[75.3958433,19.867297],"name":"Aurangabad","abbrev":"IXU","type":"mid"}
```

</details>

---

### Querying


<details><summary><i>Filter by value, get only a number of columns and order the results</i></summary>

```json
GET flight_tracking*/_search
{
  "size": 5,
  "_source": ["timePosition", "callsign", "location", "velocity"],
  "query":{
    "bool": {
      "filter": {
        "term": {
          "originCountry": "China"
        }
      }
    }
  },
  "sort": [
    {
      "timePosition": "desc"
    }
  ]
}
```

</details>

---

<details><summary><i>Just get the number of results using _count instead of _search using a bool query with a filter.</i></summary>

```json
GET flight_tracking*/_count
{
  "query":{
    "bool": {
      "filter": {
        "term": {
          "originCountry": "China"
        }
      }
    }
  }
}
```

</details>

---

<details><summary><i>A more complex query_string query using wildcards and operators</i></summary>

```json
GET flight_tracking*/_search
{
  "query": {
    "query_string": {
            "query" : "RYR* OR ACA*",
            "default_field" : "callsign"
    }
  }
}
```

</details>

---

<details><summary><i>Combining queries with filters using the bool compounded query.</i></summary>

```json
GET flight_tracking*/_search
{
  "_source": [ "callsign", "timePosition", "onGround" ],
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "RYR*",
            "default_field": "callsign"
          }
        }
      ],
      "filter": [
        { "term": { "onGround": "true" } },
        { "range": { "timePosition": { "gte": "now-1d/h" } } }
      ]
    }
  }
}
```

</details>

---

### Aggregations

Get some aggregations (metrics and histogram buckets) for positions that are not on the ground, for the last 30 minutes, and with positive altitudes.

<details><summary><i>aggs</i></summary>

```json
GET flight_tracking*/_search
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        { "term": { "onGround": "false" } },
        { "range": { "timePosition": { "gte": "now-30m/m" } } },
        { "range": { "geoAltitude": { "gte": 0 } } }
      ]
    }
  },
  "aggs": {
    "avg_speed": { "avg": { "field": "velocity" } },
    "geoAltitude_stats": { "stats": { "field": "geoAltitude" } },
    "altitude_percentiles": {
      "percentiles": {
        "field": "geoAltitude",
        "percents": [ 0, 5, 10, 25, 50, 75, 90, 95, 100 ]
      }
    },
    "positions_over_time": {
      "date_histogram": {
        "field": "timePosition",
        "fixed_interval": "10m"
      }
    },
    "speed_histogram": {
      "histogram": {
        "field": "velocity",
        "interval": 50
      }
    }
  }
}
```

</details>

---

### Geospatial Queries

Find documents in your index using geospatial conditions.

***Note***: 
> Use the website http://bboxfinder.com to get coordinates and bounding boxes.  
> You can get quickly a polygon representation using [this tool](https://boundingbox.klokantech.com/) and getting the GeoJSON output.  


<!-- Point and radius query -->

<details><summary><i>With the geo_distance query type get the positions near Barajas airport:</i></summary>

```json
GET flight_tracking*/_search
{
  "query":{
    "geo_distance": {
      "distance": "5km",
      "location":{
        "lat": 40.469674,
        "lon":  -3.559828
      } 
    } 
  } 
}
```

</details>

---



<!-- Bounding box query -->

<details><summary><i>Get the locations in the approximate bounding box of the JFK airport:</i></summary>

```json
GET flight_tracking*/_search
{
  "query": {
    "bool": {
      "must": [ { "match_all": {} } ],
      "filter": {
        "geo_bounding_box": {
          "location": {
            "top_left": { "lat": 40.666, "lon": -73.824 },
            "bottom_right": { "lat": 40.620, "lon": -73.744 }
          } 
        } 
      } 
    } 
  } 
}
```

</details>

---


<!-- Shape query -->

<details><summary><i>Let's find how many positions go over a polygon that covers the city of Wuhan.</i></summary>

```json
GET flight_tracking*/_count
{
  "query": {
    "bool": {
      "must": [
        {
          "match_all": {}
        }
      ],
      "filter": {
        "geo_shape": {
          "location": {
            "shape": """POLYGON((
              114.52 30.35,
              114.19 30.38,
              114.05 30.50,
              114.05 30.61,
              114.22 30.77,
              114.54 30.81,
              114.65 30.69,
              114.69 30.53,
              114.52 30.35))
            """
          } 
        } 
      } 
    } 
  } 
}
```

</details>

---


<!-- Metric aggregations -->
<!-- By bounding box -->

<details><summary><i>Let's find the bounding box of all positions where countryOrigin is Monaco using the geo_bounds aggregation.</i></summary>

```json
GET flight_tracking*/_search
{
  "size": 0, 
  "query": {
    "match": {
      "originCountry": "Italy"
    }
  },
  "aggs": {
    "viewport": {
      "geo_bounds": {
        "field": "location",
        "wrap_longitude": true
      }
    }
  }
}
```

</details>

---


<!-- Centroid -->
<!-- [Centroid](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/search-aggregations-metrics-geocentroid-aggregation.html) -->

<details><summary><i>Get the centroids of the top 5 Ryanair flights with more positions.</i></summary>

```json
GET flight_tracking*/_search
{
  "size": 0, 
  "query": {
    "query_string": { "default_field": "callsign", "query": "RYR*" }
  },
  "aggs": {
    "centroids_by_callsign":{
      "terms": { "field": "callsign.keyword", "size": 5 },
      "aggs": {
        "cetroid": {
          "geo_centroid": { "field": "location" }
        } 
      } 
    } 
  } 
}
```


<!--

Geoline aggregation
This aggregation takes a group of points and returns the line that connects them given a sorting field. You usually want this aggregation to be combined with a filter or a terms aggregation to retrieve lines that connect the locations of a particular asset or grouped by an identifier like an airplane callsign field.

In this example we filter the last 15 minutes data for the airplane JST574, and the request the line aggregation representation using the timePosition field.

IMPORTANT: You need to adapt the callsign and the date filter values to your own data, using Discover or Maps.

GET flight_tracking_*/_search
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        {
          "range": { "timePosition": { "gte": "now-15m" }}
        },
        {
          "match_phrase": { "callsign": "JST574" }
        }
      ]
    }
  },
  "aggs": {
    "line": {
      "geo_line": {
        "point": {"field": "location"},
        "sort": {"field": "timePosition"}
      }
    }
  }
}
Bucket aggregations
Group your query results using geospatial aggregations.

Buffers
Group positions around CDG airport in rings (also known as buffers in the geospatial world) of 10, 20, and 30 kilometers and return results using an object instead of an array:

GET flight_tracking*/_search
{
  "size": 0,
  "query": { "match_all": {} },
  "aggs": {
    "rings_around_cdg": {
      "geo_distance": {
        "field": "location",
        "origin": [ 2.561, 49.01 ],
        "unit": "km",
        "keyed": true,
        "ranges": [
          { "to": 10, "key": "<10km" },
          { "from": 10, "to": 20, "key": "10-20km" },
          { "from": 20, "to": 30, "key": "20-30km" }
        ]
      } } } }
Tile grid
In the geospatial industry there is a common way to bucket the Earth using the square grid many online maps use. This schema uses a Z/X/Y notation that Elasticsearch can use to return your buckets.

Let's find the zoom level 6 buckets for positions in mainland France.

GET flight_tracking*/_search
{
  "size": 0,
  "query": { "match_all": {} },
  "aggregations": {
    "europe": {
      "filter": {
        "geo_shape": {
          "location": {
            "shape": { 
            "type": "Polygon",
            "coordinates": [[ 
              [ 3.315, 42.207 ],[ -2.332, 43.607 ],
              [ -5.166, 48.439 ],[ -1.98, 49.749 ],
              [ 1.975, 51.244 ],[ 8.478, 49.077 ],
              [ 6.567, 46.765 ],[ 7.973, 43.384 ],
              [ 3.315, 42.207 ]
              ]]
            }
          }
        }
      },
      "aggregations": {
        "zoom6": {
          "geotile_grid": {
            "field": "location",
            "precision": 6
          } } } } } }
IMPORTANT: Be careful with the precision parameter, a high value can potentially return millions of buckets, so you should only ask for high-precision results in a very small bounding box, or for small datasets.

TIP: You can get quickly a polygon representation using this tool and getting the GeoJSON output.

Hex grid
You can perform a similar query to the previous but instead of getting back buckets in the Z/X/Y schema, you get hexagons with the Uber's h3 cell identifier. Same note about the precision parameter applies to this aggregation.

TIP: You may find this viewer useful to render the location of a given h3 cell id.

GET flight_tracking*/_search
{
  "size": 0,
  "query": { "match_all": {} },
  "aggregations": {
    "europe": {
      "filter": {
        "geo_shape": {
          "location": {
            "shape": { 
            "type": "Polygon",
            "coordinates": [[ 
              [ 3.315, 42.207 ],[ -2.332, 43.607 ],
              [ -5.166, 48.439 ],[ -1.98, 49.749 ],
              [ 1.975, 51.244 ],[ 8.478, 49.077 ],
              [ 6.567, 46.765 ],[ 7.973, 43.384 ],
              [ 3.315, 42.207 ]
              ]]
            }
          }
        }
      },
      "aggregations": {
        "h3_z3": {
          "geohex_grid": {
            "field": "location",
            "precision": 3
          } } } } } }
          
          
-->

</details>

---


<!-- Point and radius query -->

<details><summary><i>Combining queries with filters using the bool compounded query.</i></summary>

```json

```

</details>

---


<!-- Point and radius query -->

<details><summary><i>Combining queries with filters using the bool compounded query.</i></summary>

```json

```

</details>

---


<!-- Point and radius query -->

<details><summary><i>Combining queries with filters using the bool compounded query.</i></summary>

```json

```

</details>

---




