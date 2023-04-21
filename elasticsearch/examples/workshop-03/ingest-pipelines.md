### Ingest Pipelines


#### Dataset


#### Setup

##### Run Elastic Stack

```

docker-compose down -v
docker compose up -d

```
##### download person region

Person data is in `dataset/persons.json`.

```json
{"name":"Gabin William","dateofbirth":"1969-12-16","gender":"male","children":1,"marketing":{"cars":82,"shoes":null,"toys":null,"fashion":null,"music":null,"garden":null,"electronic":471,"hifi":320,"food":1013},"address":{"country":"France","zipcode":"44000","city":"Nantes","countrycode":"FR","location":{"lon":-1.6160727494218965,"lat":47.184827144381984}}}

```

##### create person bulk file

```

cat dataset/persons.json | jq --slurp -c '.[] | select( .address.country == "France" ) | { index : {  }}, { name: .name, dateofbirth: .dateofbirth, country: .address.country, geo_location: ("POINT (" + (.address.location.lon | tostring)  + " " + (.address.location.lat | tostring) + ")") }' > dataset/bulk-persons.ndjson
 
```
##### Create Person mappings

Person mapping is in `mappings/demo-ingest-person.mappings.json` file:

```json

{
  "mappings": {
    "properties": {
      "name": {
        "type": "text"
      },
      "dateofbirth": {
        "type": "date"
      },
      "region": {
        "type": "keyword"
      },
      "region_name": {
        "type": "keyword"
      },
      "country": {
        "type": "keyword"
      },
      "geo_location": {
        "type": "geo_shape"
      }
    }
  }
}

```

Create mapping:

```json

curl -s -XDELETE "localhost:9200/demo-ingest-person"  -u elastic:$ELASTIC_PASSWORD  | jq '.'

curl -s -XDELETE "localhost:9200/demo-ingest-person-new"  -u elastic:$ELASTIC_PASSWORD  | jq '.'

curl -s -XPUT "localhost:9200/demo-ingest-person" -u elastic:$ELASTIC_PASSWORD -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d"@mappings/demo-ingest-person.mappings.json" ; echo

curl -s -XPUT "localhost:9200/demo-ingest-person-new" -u elastic:$ELASTIC_PASSWORD -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d"@mappings/demo-ingest-person.mappings.json" ; echo 

```
##### ingest person documents

```

curl -XPOST "localhost:9200/demo-ingest-person/_bulk" -s -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/x-ndjson' --data-binary "@dataset/bulk-persons.ndjson" | jq '{took: .took, errors: .errors}' ; echo

```

##### download enricher data

We have a list of french regions from "https://vector.maps.elastic.co/files/france_departments_v7.geo.json" url.

```json

wget https://vector.maps.elastic.co/files/france_departments_v7.geo.json -O dataset/france_departments_v7.geo.json.gz
cd dataset
gunzip france_departments_v7.geo.json.gz
cd -

```

##### create enricher data bulk file

```

cat dataset/france_departments_v7.geo.json | jq -c '.features | .[] | [{ index : { _id: .properties.insee }}, { region: .properties.insee, name: .properties.label_fr, location: .geometry }] | .[]' > dataset/bulk.regions.ndjson

```

##### Create enricher data mappings

Enricher mapping is in `dataset/demo-ingest-regions.mappings.json` file:

```json

{
  "mappings": {
    "properties": {
      "name": {
        "type": "keyword"
      },
      "region": {
        "type": "keyword"
      },
      "location": {
        "type": "geo_shape"
      }
    }
  }
}

```

Create mapping:

```json
curl -s -XDELETE "localhost:9200/demo-ingest-regions"  -u elastic:$ELASTIC_PASSWORD | jq '.'

curl -s -XPUT "localhost:9200/demo-ingest-regions" -u elastic:$ELASTIC_PASSWORD -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d"@mappings/demo-ingest-regions.mappings.json" ; echo 

```

##### ingest enricher data documents

```

curl -XPOST "localhost:9200/demo-ingest-regions/_bulk" -s -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/x-ndjson' --data-binary "@dataset/bulk.regions.ndjson" | jq '{took: .took, errors: .errors}' ; echo
 
```

##### Test ingested documents

```json

GET /demo-ingest-person/_count

{
  "count" : 240,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  }
}
 
```

```json

GET /demo-ingest-person/_search
{
  "query": {
    "match_all": {}
  },
  "from": 0,
  "size": 1
}

OR 

GET /demo-ingest-person/_search?size=1

Response:

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
      "value" : 240,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "demo-ingest-person",
        "_type" : "_doc",
        "_id" : "ZqCpoocBNkfUZn8jdMaX",
        "_score" : 1.0,
        "_source" : {
          "name" : "Gabin William",
          "dateofbirth" : "1969-12-16",
          "country" : "France",
          "geo_location" : "POINT (-1.6160727494218965 47.184827144381984)"
        }
      }
    ]
  }
}

```

```json

GET /demo-ingest-regions/_count

Response:

{
  "count" : 96,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  }
}

```


```json

GET /demo-ingest-regions/_search
{
  "query": {
    "match_all": {}
  },
  "from": 0,
  "size": 1
}

OR 

GET /demo-ingest-regions/_search?size=1

Response:

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
      "value" : 96,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "demo-ingest-regions",
        "_type" : "_doc",
        "_id" : "30",
        "_score" : 1.0,
        "_source" : {
          "region" : "30",
          "name" : "Gard",
          "location" : {
            "type" : "MultiPolygon",
            "coordinates" : [
              [
                [
                  [
                    3.971236,
                    44.165601
                  ],
                  [
                    3.971236,
                    44.173361
                  ],
                  [
                    3.965394,
                    44.171809
                  ],
                  [
                    3.965394,
                    44.174913
                  ],
                  [
                    3.965394,
                    44.176465
                  ],
  ........
  
```


```json
```


```json
```

#### Create ingest pipeline

Create pipeline `demo-ingest-circle`.

1. Add a `Circle` processor on `location` field with a `Geo-shape` Shape type.

```json

PUT /_ingest/pipeline/demo-ingest-circle
{
  "processors": [
    {
      "circle": {
        "field": "location",
        "error_distance": "1",
        "shape_type": "geo_shape"
      }
    }
  ]
}

```

Test docs:

```json

  {
    "_source": {
      "location": "CIRCLE (30 10 40)"
    }
  }
  
  {
    "_source": {
      "location": {
        "type": "circle",
        "radius": "40m",
        "coordinates": [
          30,
          10
        ]
      }
    }
  }

```

Test pipeline:

```json

POST /_ingest/pipeline/demo-ingest-circle/_simulate
{
  "docs": [
    {
      "_source": {
        "location": "CIRCLE (30 10 40)"
      }
    },
    {
      "_source": {
        "location": {
          "type": "circle",
          "radius": "40m",
          "coordinates": [
            30,
            10
          ]
        }
      }
    }
  ]
}

```

Adjust the Error distance to `100` and show the effect when running again the test.

2. Add Enrich Ingest Processor

We have an existing person dataset. It contains the name, the date of birth, the country and the geo location point.

```json
{
  "name" : "Gabin William",
  "dateofbirth" : "1969-12-16",
  "country" : "France",
  "geo_location" : "POINT (-1.6160727494218965 47.184827144381984)"
}
```

We also have a regions dataset. It contains all the french regions (or departments) with the region number, name and the polygons which represents the shape of the region.

```json
{
  "region" : "75",
  "name" : "Paris",
  "location" : {
    "type" : "MultiPolygon",
    "coordinates" : [
      [
        [
          [ 2.318133, 48.90077 ],
          [ 2.283084, 48.886802],
          [ 2.277243, 48.87749],
          // ...
          [ 2.318133, 48.90077]
        ]
      ]
    ]
  }
}
```

We can define an enrich policy. It reads from demo-ingest-regions index and tries to geo match on the location field.

```json

PUT /_enrich/policy/demo-ingest-regions-policy
{
  "geo_match": {
    "indices": "demo-ingest-regions",
    "match_field": "location",
    "enrich_fields": ["region", "name"]
  }
}

```

We need to execute this policy

```json

PUT _enrich/policy/demo-ingest-regions-policy/_execute

{
  "status" : {
    "phase" : "COMPLETE"
  }
}

```

```json

PUT /_ingest/pipeline/demo-ingest-circle
{
  "processors": [
    {
      "enrich": {
        "policy_name": "demo-ingest-regions-policy",
        "field": "geo_location",
        "target_field": "geo_data",
        "shape_relation": "INTERSECTS"
      }
    }
  ]
}

```

Test pipeline:

```json

POST /_ingest/pipeline/demo-ingest-circle/_simulate
{
  "docs": [
    {
      "_source": {
        "name": "Gabin William",
        "dateofbirth": "1969-12-16",
        "country": "France",
        "geo_location": "POINT (-1.6160727494218965 47.184827144381984)"
      }
    },
    {
      "_source": {
        "name": "Kenzo Kadidia",
        "dateofbirth": "1985-04-21",
        "country": "France",
        "geo_location": "POINT (-1.5855725030181889 47.24825076292245)"
      }
    }
  ]
}


Response:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "dateofbirth" : "1969-12-16",
          "country" : "France",
          "geo_location" : "POINT (-1.6160727494218965 47.184827144381984)",
          "name" : "Gabin William",
          "geo_data" : {
            "name" : "Loire-Atlantique",
            "region" : "44",
            "location" : {
              "coordinates" : [
                [
                  [
                    [-2.454254,47.448093],
                    [-2.448412,47.434125],
                    [-1.280142,47.077163],
                    // ....
                    [-2.454254,47.448093]
                  ]
                ]
              ],
              "type" : "MultiPolygon"
            }
          }
        },
        "_ingest" : {
          "timestamp" : "2023-04-21T22:27:30.220252096Z"
        }
      }
    }
  ]
}

```

3. Rename the region number field to `region`. 

```json

PUT /_ingest/pipeline/demo-ingest-circle
{
  "processors": [
    {
      "enrich": {
        "policy_name": "demo-ingest-regions-policy",
        "field": "geo_location",
        "target_field": "geo_data",
        "shape_relation": "INTERSECTS"
      }
    },
    {
      "rename": {
        "field": "geo_data.region",
        "target_field": "region"
      }
    }
  ]
}

```

Test pipeline:

```json

POST /_ingest/pipeline/demo-ingest-circle/_simulate
{
  "docs": [
    {
      "_source": {
        "name": "Gabin William",
        "dateofbirth": "1969-12-16",
        "country": "France",
        "geo_location": "POINT (-1.6160727494218965 47.184827144381984)"
      }
    },
    {
      "_source": {
        "name": "Kenzo Kadidia",
        "dateofbirth": "1985-04-21",
        "country": "France",
        "geo_location": "POINT (-1.5855725030181889 47.24825076292245)"
      }
    }
  ]
}


Response:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "dateofbirth" : "1969-12-16",
          "country" : "France",
          "geo_location" : "POINT (-1.6160727494218965 47.184827144381984)",
          "name" : "Gabin William",
          "geo_data" : {
            "name" : "Loire-Atlantique",
            "location" : {
              "coordinates": [...],
              "type" : "MultiPolygon"
            }
          },
          "region" : "44"
        },
        "_ingest" : {
          "timestamp" : "2023-04-21T22:40:23.560946136Z"
        }
      }
    },
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "dateofbirth" : "1985-04-21",
          "country" : "France",
          "geo_location" : "POINT (-1.5855725030181889 47.24825076292245)",
          "name" : "Kenzo Kadidia",
          "geo_data" : {
            "name" : "Loire-Atlantique",
            "location" : {
              "coordinates": [...],
              "type" : "MultiPolygon"
            }
          },
          "region" : "44"
        },
        "_ingest" : {
          "timestamp" : "2023-04-21T22:40:23.560956235Z"
        }
      }
    }
  ]
}

```

4. Rename the region name field to `region_name`.

```json

PUT /_ingest/pipeline/demo-ingest-circle
{
  "processors": [
    {
      "enrich": {
        "policy_name": "demo-ingest-regions-policy",
        "field": "geo_location",
        "target_field": "geo_data",
        "shape_relation": "INTERSECTS"
      }
    },
    {
      "rename": {
        "field": "geo_data.region",
        "target_field": "region",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "geo_data.name",
        "target_field": "region_name",
        "ignore_missing": true
      }
    }
  ]
}

```

Test pipeline:

```json

POST /_ingest/pipeline/demo-ingest-circle/_simulate
{
  "docs": [
    {
      "_source": {
        "name": "Gabin William",
        "dateofbirth": "1969-12-16",
        "country": "France",
        "geo_location": "POINT (-1.6160727494218965 47.184827144381984)"
      }
    },
    {
      "_source": {
        "name": "Kenzo Kadidia",
        "dateofbirth": "1985-04-21",
        "country": "France",
        "geo_location": "POINT (-1.5855725030181889 47.24825076292245)"
      }
    }
  ]
}

Response:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "dateofbirth" : "1969-12-16",
          "country" : "France",
          "geo_location" : "POINT (-1.6160727494218965 47.184827144381984)",
          "name" : "Gabin William",
          "geo_data" : {
            "name" : "Loire-Atlantique",
            "location" : {
              "coordinates" : [...],
              "type" : "MultiPolygon"
            }
          }
        },
        "_ingest" : {
          "timestamp" : "2023-04-21T22:48:09.312881982Z"
        }
      }
    },
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "dateofbirth" : "1985-04-21",
          "country" : "France",
          "geo_location" : "POINT (-1.5855725030181889 47.24825076292245)",
          "name" : "Kenzo Kadidia",
          "geo_data" : {
            "name" : "Loire-Atlantique",
            "location" : {
              "coordinates" : [...],
              "type" : "MultiPolygon"
            }
          }
        },
        "_ingest" : {
          "timestamp" : "2023-04-21T22:48:09.312892412Z"
        }
      }
    }
  ]
}

```

5. Remove the non needed fields (`geo_data`)

```json

PUT /_ingest/pipeline/demo-ingest-circle
{
  "processors": [
    {
      "enrich": {
        "policy_name": "demo-ingest-regions-policy",
        "field": "geo_location",
        "target_field": "geo_data",
        "shape_relation": "INTERSECTS"
      }
    },
    {
      "rename": {
        "field": "geo_data.region",
        "target_field": "region",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "geo_data.name",
        "target_field": "region_name",
        "ignore_missing": true
      }
    },
    {
      "remove": {
        "field": "geo_data"
      }
    }
  ]
}

```

Test pipeline:

```json

POST /_ingest/pipeline/demo-ingest-circle/_simulate
{
  "docs": [
    {
      "_source": {
        "name": "Gabin William",
        "dateofbirth": "1969-12-16",
        "country": "France",
        "geo_location": "POINT (-1.6160727494218965 47.184827144381984)"
      }
    },
    {
      "_source": {
        "name": "Kenzo Kadidia",
        "dateofbirth": "1985-04-21",
        "country": "France",
        "geo_location": "POINT (-1.5855725030181889 47.24825076292245)"
      }
    }
  ]
}

Response:

{
  "docs" : [
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "dateofbirth" : "1969-12-16",
          "country" : "France",
          "geo_location" : "POINT (-1.6160727494218965 47.184827144381984)",
          "name" : "Gabin William",
          "region_name" : "Loire-Atlantique",
          "region" : "44"
        },
        "_ingest" : {
          "timestamp" : "2023-04-21T23:02:47.736584429Z"
        }
      }
    },
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "dateofbirth" : "1985-04-21",
          "country" : "France",
          "geo_location" : "POINT (-1.5855725030181889 47.24825076292245)",
          "name" : "Kenzo Kadidia",
          "region_name" : "Loire-Atlantique",
          "region" : "44"
        },
        "_ingest" : {
          "timestamp" : "2023-04-21T23:02:47.736592715Z"
        }
      }
    }
  ]
}

```

6. Final pipeline

```json

PUT /_ingest/pipeline/demo-ingest-circle
{
  "processors": [
    {
      "enrich": {
        "policy_name": "demo-ingest-regions-policy",
        "field": "geo_location",
        "target_field": "geo_data",
        "shape_relation": "INTERSECTS"
      }
    },
    {
      "rename": {
        "field": "geo_data.region",
        "target_field": "region",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "geo_data.name",
        "target_field": "region_name",
        "ignore_missing": true
      }
    },
    {
      "remove": {
        "field": "geo_data"
      }
    }
  ]
}

```

#### reindex demo-ingest-person index to demo-ingest-person-new index using pipeline created

```json

POST /_reindex?wait_for_completion=true
{
  "source": {
    "index": "demo-ingest-person"
  },
  "dest": {
    "index": "demo-ingest-person-new",
    "pipeline": "demo-ingest-circle"
  }
}

```

```json

GET /demo-ingest-person-new/_search?size=2

Response:

{
  "took" : 121,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 240,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "demo-ingest-person-new",
        "_type" : "_doc",
        "_id" : "iqAXpocBNkfUZn8jd8hh",
        "_score" : 1.0,
        "_source" : {
          "dateofbirth" : "1969-12-16",
          "country" : "France",
          "geo_location" : "POINT (-1.6160727494218965 47.184827144381984)",
          "name" : "Gabin William",
          "region_name" : "Loire-Atlantique",
          "region" : "44"
        }
      },
      {
        "_index" : "demo-ingest-person-new",
        "_type" : "_doc",
        "_id" : "i6AXpocBNkfUZn8jd8hh",
        "_score" : 1.0,
        "_source" : {
          "dateofbirth" : "1985-04-21",
          "country" : "France",
          "geo_location" : "POINT (-1.5855725030181889 47.24825076292245)",
          "name" : "Kenzo Kadidia",
          "region_name" : "Loire-Atlantique",
          "region" : "44"
        }
      }
    ]
  }
}

```
#### Circle processor

```json

PUT circles
{
  "mappings": {
    "properties": {
      "circle": {
        "type": "geo_shape"
      }
    }
  }
}

```

```json

PUT _ingest/pipeline/polygonize_circles
{
  "description": "translate circle to polygon",
  "processors": [
    {
      "circle": {
        "field": "circle",
        "error_distance": 28.0,
        "shape_type": "geo_shape"
      }
    }
  ]
}

```

##### Example: Circle defined in Well Known Text

```json

PUT circles/_doc/1?pipeline=polygonize_circles
{
  "circle": "CIRCLE (30 10 40)"
}

{
  "_index" : "circles",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}

```

```json

GET /circles/_doc/1

{
  "_index" : "circles",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "circle" : "POLYGON ((30.000365257263184 10.0, 30.000111397193788 10.00034284530941, 29.999706043744222 10.000213571721195, 29.999706043744222 9.999786428278805, 30.000111397193788 9.99965715469059, 30.000365257263184 10.0))"
  }
}

```

##### Example: Circle defined in GeoJSON

```json

PUT /circles/_doc/2?pipeline=polygonize_circles
{
  "circle": {
    "type": "circle",
    "radius": "40m",
    "coordinates": [30, 10]
  }
}

```

```json

GET circles/_doc/2

Response:

{
  "_index" : "circles",
  "_type" : "_doc",
  "_id" : "2",
  "_version" : 1,
  "_seq_no" : 1,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "circle" : {
      "type" : "Polygon",
      "coordinates" : [
        [
          [
            30.000365257263184,
            10.0
          ],
          [
            30.000111397193788,
            10.00034284530941
          ],
          [
            29.999706043744222,
            10.000213571721195
          ],
          [
            29.999706043744222,
            9.999786428278805
          ],
          [
            30.000111397193788,
            9.99965715469059
          ],
          [
            30.000365257263184,
            10.0
          ]
        ]
      ]
    }
  }
}

```

##### Notes on Accuracy

Accuracy of the polygon that represents the circle is defined as error_distance. The smaller this difference is, the closer to a perfect circle the polygon is.

##### Note on Geoshape field type

The geo_shape data type facilitates the indexing of and searching with arbitrary geoshapes such as rectangles and polygons. It should be used when either the data being indexed or the queries being executed contain shapes other than just points.

We can query documents using this type using a [geo_shape query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-geo-shape-query.html).

```json

PUT /example
{
  "mappings": {
    "properties": {
      "location": {
        "type": "geo_shape"
      }
    }
  }
}

```

Input Structure : Shapes can be represented using either the [GeoJSON](http://geojson.org/) or [Well-Known Text](https://docs.opengeospatial.org/is/12-063r5/12-063r5.html) (WKT) format.

- Point: A point is a single geographic coordinate, such as the location of a building or the current position given by a smartphone’s Geolocation API.  

Point in GeoJSON:

```json

POST /example/_doc
{
  "location": {
    "type": "Point",
    "coordinates": [
      -77.03653,
      38.897676
    ]
  }
}

```

Point in WKT:

```json

POST /example/_doc
{
  "location" : "POINT (-77.03653 38.897676)"
}

```

- LineString: A linestring defined by an array of two or more positions. By specifying only two points, the linestring will represent a straight line. Specifying more than two points creates an arbitrary path. 

LineString in GeoJSON:

```json

POST /example/_doc
{
  "location": {
    "type": "LineString",
    "coordinates": [
      [
        -77.03653,
        38.897676
      ],
      [
        -77.009051,
        38.889939
      ]
    ]
  }
}

```

LineString in WKT:

```json

POST /example/_doc
{
  "location" : "POINT (-77.03653 38.897676)"
}

```

- Polygon: A polygon is defined by a list of a list of points. The first and last points in each (outer) list must be the same (the polygon must be closed).

Polygon in GeoJSON:

```json

POST /example/_doc
{
  "location" : {
    "type" : "Polygon",
    "coordinates" : [
      [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
    ]
  }
}

```

Polygon in WKT:

```json

POST /example/_doc
{
  "location" : "POLYGON ((100.0 0.0, 101.0 0.0, 101.0 1.0, 100.0 1.0, 100.0 0.0))"
}

```

The first array represents the outer boundary of the polygon, the other arrays represent the interior shapes ("holes"). 

The following is a GeoJSON example of a polygon with a hole:

```json

POST /example/_doc
{
  "location" : {
    "type" : "Polygon",
    "coordinates" : [
      [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
      [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
    ]
  }
}

```

The following is an example of a polygon with a hole in WKT:

```json

POST /example/_doc
{
  "location" : "POLYGON ((100.0 0.0, 101.0 0.0, 101.0 1.0, 100.0 1.0, 100.0 0.0), (100.2 0.2, 100.8 0.2, 100.8 0.8, 100.2 0.8, 100.2 0.2))"
}

```

**Polygon orientation**: A polygon’s orientation indicates the order of its vertices: `RIGHT` (counterclockwise) or `LEFT` (clockwise). A polygon’s orientation indicates the order of its vertices: RIGHT (counterclockwise) or LEFT (clockwise).

You can set a default orientation for WKT polygons using the orientation mapping parameter. This is because the WKT specification doesn’t specify or enforce a default orientation.

GeoJSON polygons use a default orientation of RIGHT, regardless of orientation mapping parameter’s value. This is because the GeoJSON specification mandates that an outer polygon use a counterclockwise orientation and interior shapes use a clockwise orientation.

You can override the default orientation for GeoJSON polygons using the document-level orientation parameter. 

- MultiPoint

The following is an example of a list of GeoJSON points:

```json

POST /example/_doc
{
  "location" : {
    "type" : "MultiPoint",
    "coordinates" : [
      [102.0, 2.0], [103.0, 2.0]
    ]
  }
}

```

The following is an example of a list of WKT points:

```json

POST /example/_doc
{
  "location" : "MULTIPOINT (102.0 2.0, 103.0 2.0)"
}

```

- MultiLineString

The following is an example of a list of GeoJSON linestrings:

```json

POST /example/_doc
{
  "location" : {
    "type" : "MultiLineString",
    "coordinates" : [
      [ [102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0] ],
      [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0] ],
      [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8] ]
    ]
  }
}

```

The following is an example of a list of WKT linestrings:

```json

POST /example/_doc
{
  "location" : "MULTILINESTRING ((102.0 2.0, 103.0 2.0, 103.0 3.0, 102.0 3.0), (100.0 0.0, 101.0 0.0, 101.0 1.0, 100.0 1.0), (100.2 0.2, 100.8 0.2, 100.8 0.8, 100.2 0.8))"
}

```

- MultiPolygon

The following is an example of a list of GeoJSON polygons (second polygon contains a hole):

```json

POST /example/_doc
{
  "location" : {
    "type" : "MultiPolygon",
    "coordinates" : [
      [ [[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]] ],
      [ [[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
        [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]] ]
    ]
  }
}

```

The following is an example of a list of WKT polygons (second polygon contains a hole):

```json

POST /example/_doc
{
  "location" : "MULTIPOLYGON (((102.0 2.0, 103.0 2.0, 103.0 3.0, 102.0 3.0, 102.0 2.0)), ((100.0 0.0, 101.0 0.0, 101.0 1.0, 100.0 1.0, 100.0 0.0), (100.2 0.2, 100.8 0.2, 100.8 0.8, 100.2 0.8, 100.2 0.2)))"
}

```

- Geometry Collection

The following is an example of a collection of GeoJSON geometry objects:

```json

POST /example/_doc
{
  "location" : {
    "type": "GeometryCollection",
    "geometries": [
      {
        "type": "Point",
        "coordinates": [100.0, 0.0]
      },
      {
        "type": "LineString",
        "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
      }
    ]
  }
}

```

The following is an example of a collection of WKT geometry objects:

```json

POST /example/_doc
{
  "location" : "GEOMETRYCOLLECTION (POINT (100.0 0.0), LINESTRING (101.0 0.0, 102.0 1.0))"
}

```

- Envelope: Elasticsearch supports an envelope type, which consists of coordinates for upper left and lower right points of the shape to represent a bounding rectangle in the format [[minLon, maxLat], [maxLon, minLat]]:


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

- Circle: Elasticsearch supports a circle type, which consists of a center point with a radius.

You cannot index the circle type using the default BKD tree indexing approach. Instead, use a circle ingest processor to approximate the circle as a polygon.

The circle type requires a geo_shape field mapping with the deprecated recursive Prefix Tree strategy.

```json

PUT /circle-example
{
  "mappings": {
    "properties": {
      "location": {
        "type": "geo_shape",
        "strategy": "recursive"
      }
    }
  }
}

```

The following request indexes a circle geo-shape.

```json

POST /circle-example/_doc
{
  "location": {
    "type": "circle",
    "coordinates": [
      101,
      1
    ],
    "radius": "100m"
  }
}

```

Note: The inner radius field is required. If not specified, then the units of the radius will default to METERS.

NOTE: Neither GeoJSON or WKT support a point-radius circle type.
