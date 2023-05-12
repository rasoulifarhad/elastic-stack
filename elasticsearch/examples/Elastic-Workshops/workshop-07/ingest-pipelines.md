## Ingest Pipelines

### Run Elastic Stack

```
docker-compose down -v
docker compose up -d

```

### Download opensky states

The script makes a request to ***OpenSky API*** and appends to a ***CSV file*** the contents. Once the file is generate it will ***use ogr2ogr to convert the CSV into a GeoJSON file***.

<details><summary><i><b>Script</b></i></summary>

```sh
# add csv header to file
cat > dataset/data_header.csv <<EOF
icao24,callsign,country,timePosition,lastContact,longitude,latitude,baroAltitude,onGround,velocity,heading,verticalRate,_,geoAltitude,transponderCode,spi,positionSource
EOF

filename_base=flight_tracking_$(date "+%Y-%m-%d_%H_%M")

csv_file="${filename_base}.csv"
geojson_file="${filename_base}.geojson"

cat dataset/data_header.csv > dataset/${csv_file}
curl -sL "https://opensky-network.org/api/states/all" \
      | jq -c ".states[]" \
      | sed -e 's/^\[//g' -e 's/\]$//g' \
      >> dataset/${csv_file}

ogr2ogr -f GeoJSON dataset/${geojson_file} \
  -oo "X_POSSIBLE_NAMES=Lon*" \
  -oo "Y_POSSIBLE_NAMES=Lat*" \
  -oo KEEP_GEOM_COLUMNS=NO \
  dataset/${csv_file}
```

</details>

### Create bulk file

<details><summary><i><b>Script</b></i></summary>

```sh
cat dataset/${csv_file} | \
while read -r line; do \
  NOW=$(date +"%Y-%m-%dT%T") ; \
  printf "{ \"index\" : {}}\n{\"@timestamp\":\"$NOW\", \"message\":\"$line\"}\n"; \
done > dataset/"${filename_base}".ndjson
```

```sh
cat dataset/flight_tracking_2023-04-22_20_42.csv | \
while read -r line; do \
  NOW=$(date +"%Y-%m-%dT%T") ; \
  printf "{ \"index\" : {}}\n{\"@timestamp\":\"$NOW\", \"message\":\"$line\"}\n"; \
done > dataset/flight_tracking_2023-04-22_20_42.ndjson
```

</details>

### Bulk insert documents

<details><summary><i><b>Script</b></i></summary>

```sh
curl -XPOST "localhost:9200/flight_tracking/_bulk" \
     -s -u elastic:changeme \
     -H 'Content-Type: application/x-ndjson' \
     --data-binary "@dataset/${filename_base}.ndjson" \
     | jq '{took: .took, errors: .errors}' ; echo
```

```sh
curl -XPOST "localhost:9200/flight_tracking/_bulk" \
     -s -u elastic:changeme \
     -H 'Content-Type: application/x-ndjson' \
     --data-binary "@dataset/flight_tracking_2023-04-22_20_42.ndjson" \
     | jq '{took: .took, errors: .errors}' ; echo
```

</details>

### Create flight tracking mappings

- `flight_tracking`  mapping is in `mappings/flight-tracking.mappings.json` file:

<details><summary><i><b>Mappings</b></i></summary>

```json
{
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "baroAltitude": {
        "type": "double"
      },
      "callsign": {
        "type": "keyword"
      },
      "country": {
        "type": "keyword"
      },
      "geoAltitude": {
        "type": "double"
      },
      "heading": {
        "type": "double"
      },
      "icao24": {
        "type": "keyword"
      },
      "lastContact": {
        "type": "date",
        "format": "epoch_second"
      },
      "timePosition": {
        "type": "date",
        "format": "epoch_second"
      },
      "onGround": {
        "type": "boolean"
      },
      "positionSource": {
        "type": "keyword"
      },
      "spi": {
        "type": "boolean"
      },
      "transponderCode": {
        "type": "keyword"
      },
      "velocity": {
        "type": "double"
      },
      "verticalRate": {
        "type": "double"
      },
      "location": {
        "type": "geo_point"
      }
    }
  }
}
```

</details>

- Create mapping:

<details><summary><i><b>Create mapping</b></i></summary>

```sh
curl -XPUT "localhost:9200/flight_tracking" \
     -s -u elastic:$ELASTIC_PASSWORD \
     -H 'Content-Type: application/json' \
     -d"@mappings/flight-tracking.mappings.json" ; echo
```

</details>

### Create ingest pipeline

1. Add the CSV Processor (Extracts fields from `message`)


<details><summary><i><b>Pipeline</b></i></summary>

```json
PUT _ingest/pipeline/flight-tracking-ingest-pipeline
{
  "description": "sads",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "icao24",
          "callsign",
          "country",
          "timePosition",
          "lastContact",
          "longitude",
          "latitude",
          "baroAltitude",
          "onGround",
          "velocity",
          "heading",
          "verticalRate",
          "_",
          "geoAltitude",
          "transponderCode",
          "spi",
          "positionSource"
        ],
        "trim":true,
        "ignore_missing": false
      }
    }
  ]
}
```

</details>

2. Add date processor 

<details><summary><i><b>Pipeline</b></i></summary>

```json
PUT _ingest/pipeline/flight-tracking-ingest-pipeline
{
  "description": "sads",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "icao24",
          "callsign",
          "country",
          "timePosition",
          "lastContact",
          "longitude",
          "latitude",
          "baroAltitude",
          "onGround",
          "velocity",
          "heading",
          "verticalRate",
          "_",
          "geoAltitude",
          "transponderCode",
          "spi",
          "positionSource"
        ],
        "trim":true,
        "ignore_missing": false
      }
    },
    {
      "date": {
        "field": "timePosition",
        "formats": [
          "UNIX"
        ]
      }
    }
  ]
}
```

</details>

3. Convert `baroAltitude`, `geoAltitude`, `heading`, `latitude`, `longitude`, `velocity`, `verticalRate` fields to `double` type.

<details><summary><i><b>Pipeline</b></i></summary>

```json
PUT _ingest/pipeline/flight-tracking-ingest-pipeline
{
  "description": "sads",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "icao24",
          "callsign",
          "country",
          "timePosition",
          "lastContact",
          "longitude",
          "latitude",
          "baroAltitude",
          "onGround",
          "velocity",
          "heading",
          "verticalRate",
          "_",
          "geoAltitude",
          "transponderCode",
          "spi",
          "positionSource"
        ],
        "trim":true,
        "ignore_missing": false
      }
    },
    {
      "date": {
        "field": "timePosition",
        "formats": [
          "UNIX"
        ]
      }
    },
    {
      "convert": {
        "field": "baroAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "geoAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "heading",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "latitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "longitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "velocity",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "verticalRate",
        "type": "double",
        "ignore_missing": true
      }
    }
  ]
}
```

</details>

4. Add date processor 

<details><summary><i><b>Pipeline</b></i></summary>

```json
PUT _ingest/pipeline/flight-tracking-ingest-pipeline
{
  "description": "sads",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "icao24",
          "callsign",
          "country",
          "timePosition",
          "lastContact",
          "longitude",
          "latitude",
          "baroAltitude",
          "onGround",
          "velocity",
          "heading",
          "verticalRate",
          "_",
          "geoAltitude",
          "transponderCode",
          "spi",
          "positionSource"
        ],
        "trim":true,
        "ignore_missing": false
      }
    },
    {
      "date": {
        "field": "timePosition",
        "formats": [
          "UNIX"
        ]
      }
    },
    {
      "convert": {
        "field": "baroAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "geoAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "heading",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "latitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "longitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "velocity",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "verticalRate",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "date": {
        "field": "lastContact",
        "formats": [ "UNIX" ]
      }
    }
  ]
}
```

</details>

5. Convert `onGround`, `spi` fields to `boolean` type.

<details><summary><i><b>Pipeline</b></i></summary>

```json
PUT _ingest/pipeline/flight-tracking-ingest-pipeline
{
  "description": "sads",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "icao24",
          "callsign",
          "country",
          "timePosition",
          "lastContact",
          "longitude",
          "latitude",
          "baroAltitude",
          "onGround",
          "velocity",
          "heading",
          "verticalRate",
          "_",
          "geoAltitude",
          "transponderCode",
          "spi",
          "positionSource"
        ],
        "trim":true,
        "ignore_missing": false
      }
    },
    {
      "date": {
        "field": "timePosition",
        "formats": [
          "UNIX"
        ]
      }
    },
    {
      "convert": {
        "field": "baroAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "geoAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "heading",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "latitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "longitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "velocity",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "verticalRate",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "date": {
        "field": "lastContact",
        "formats": [ "UNIX" ]
      }
    },
    {
      "convert": {
        "field": "onGround",
        "type": "boolean",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "spi",
        "type": "boolean",
        "ignore_missing": true
      }
    }
  ]
}
```

</details>

6. Add location field

<details><summary><i><b>Pipeline</b></i></summary>

```json
PUT _ingest/pipeline/flight-tracking-ingest-pipeline
{
  "description": "sads",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "icao24",
          "callsign",
          "country",
          "timePosition",
          "lastContact",
          "longitude",
          "latitude",
          "baroAltitude",
          "onGround",
          "velocity",
          "heading",
          "verticalRate",
          "_",
          "geoAltitude",
          "transponderCode",
          "spi",
          "positionSource"
        ],
        "trim":true,
        "ignore_missing": false
      }
    },
    {
      "date": {
        "field": "timePosition",
        "formats": [
          "UNIX"
        ]
      }
    },
    {
      "convert": {
        "field": "baroAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "geoAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "heading",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "latitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "longitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "velocity",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "verticalRate",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "date": {
        "field": "lastContact",
        "formats": [ "UNIX" ]
      }
    },
    {
      "convert": {
        "field": "onGround",
        "type": "boolean",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "spi",
        "type": "boolean",
        "ignore_missing": true
      }
    },
    {
      "set": {
        "field": "location",
        "value": "{{latitude}},{{longitude}}"
      }
    }
  ]
}
```

</details>

7. Remove `message`, `_`, `latitude`, `longitude` fields

<details><summary><i><b>Pipeline</b></i></summary>

```json
PUT _ingest/pipeline/flight-tracking-ingest-pipeline
{
  "description": "sads",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "icao24",
          "callsign",
          "country",
          "timePosition",
          "lastContact",
          "longitude",
          "latitude",
          "baroAltitude",
          "onGround",
          "velocity",
          "heading",
          "verticalRate",
          "_",
          "geoAltitude",
          "transponderCode",
          "spi",
          "positionSource"
        ],
        "trim":true,
        "ignore_missing": false
      }
    },
    {
      "date": {
        "field": "timePosition",
        "formats": [
          "UNIX"
        ]
      }
    },
    {
      "convert": {
        "field": "baroAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "geoAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "heading",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "latitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "longitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "velocity",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "verticalRate",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "date": {
        "field": "lastContact",
        "formats": [ "UNIX" ]
      }
    },
    {
      "convert": {
        "field": "onGround",
        "type": "boolean",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "spi",
        "type": "boolean",
        "ignore_missing": true
      }
    },
    {
      "set": {
        "field": "location",
        "value": "{{latitude}},{{longitude}}"
      }
    },
    {
      "remove": {
        "field": [ "message", "_", "latitude", "longitude" ]
      }
    }
  ]
}
```

</details>

8. Final

<details><summary><i><b>Pipeline</b></i></summary>

```json
PUT _ingest/pipeline/flight-tracking-ingest-pipeline
{
  "description": "sads",
  "processors": [
    {
      "csv": {
        "field": "message",
        "target_fields": [
          "icao24",
          "callsign",
          "country",
          "timePosition",
          "lastContact",
          "longitude",
          "latitude",
          "baroAltitude",
          "onGround",
          "velocity",
          "heading",
          "verticalRate",
          "_",
          "geoAltitude",
          "transponderCode",
          "spi",
          "positionSource"
        ],
        "trim":true,
        "ignore_missing": false
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "icao24",
        "if": "ctx?.icao24 == null || ctx?.icao24 == '' || ctx?.icao24 == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "callsign",
        "if": "ctx?.callsign == null || ctx?.callsign == '' || ctx?.callsign == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "country",
        "if": "ctx?.country == null || ctx?.country == '' || ctx?.country == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "timePosition",
        "if": "ctx?.timePosition == null || ctx?.timePosition == '' || ctx?.timePosition == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "lastContact",
        "if": "ctx?.lastContact == null || ctx?.lastContact == '' || ctx?.lastContact == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "longitude",
        "if": "ctx?.longitude == null || ctx?.longitude == '' || ctx?.longitude == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "latitude",
        "if": "ctx?.latitude == null || ctx?.latitude == '' || ctx?.latitude == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "baroAltitude",
        "if": "ctx?.baroAltitude == null || ctx?.baroAltitude == '' || ctx?.baroAltitude == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "onGround",
        "if": "ctx?.onGround == null || ctx?.onGround == '' || ctx?.onGround == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "velocity",
        "if": "ctx?.velocity == null || ctx?.velocity == '' || ctx?.velocity == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "heading",
        "if": "ctx?.heading == null || ctx?.heading == '' || ctx?.heading == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "verticalRate",
        "if": "ctx?.verticalRate == null || ctx?.verticalRate == '' || ctx?.verticalRate == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "geoAltitude",
        "if": "ctx?.geoAltitude == null || ctx?.geoAltitude == '' || ctx?.geoAltitude == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "transponderCode",
        "if": "ctx?.transponderCode == null || ctx?.transponderCode == '' || ctx?.transponderCode == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "spi",
        "if": "ctx?.spi == null || ctx?.spi == '' || ctx?.spi == 'null'"
      }
    },
    {
      "remove": {
        "ignore_missing": true,
        "field": "positionSource",
        "if": "ctx?.positionSource == null || ctx?.positionSource == '' || ctx?.positionSource == 'null'"
      }
    },
    {
      "date": {
        "field": "timePosition",
        "formats": [
          "UNIX"
        ]
      }
    },
    {
      "convert": {
        "field": "baroAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "geoAltitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "heading",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "latitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "longitude",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "velocity",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "verticalRate",
        "type": "double",
        "ignore_missing": true
      }
    },
    {
      "date": {
        "field": "lastContact",
        "formats": [
          "UNIX"
        ]
      }
    },
    {
      "convert": {
        "field": "onGround",
        "type": "boolean",
        "ignore_missing": true
      }
    },
    {
      "convert": {
        "field": "spi",
        "type": "boolean",
        "ignore_missing": true
      }
    },
    {
      "set": {
        "field": "location",
        "value": "{{latitude}},{{longitude}}"
      }
    },
    {
      "remove": {
        "field": [
          "message",
          "_",
          "latitude",
          "longitude"
        ]
      }
    }
  ],
 "on_failure": [
    {
      "set": {
        "description": "Index document to 'failed-<index>'",
        "field": "_index",
        "value": "failed-{{{ _index }}}"
      }
    },
    {
      "set": {
        "description": "Record error information",
        "field": "error_information",
        "value": "Processor {{ _ingest.on_failure_processor_type }} with tag {{ _ingest.on_failure_processor_tag }} in pipeline {{ _ingest.on_failure_pipeline }} failed with message {{ _ingest.on_failure_message }}"
      }      
    }
  ]  
}
```

</details>

9. simulate

```json
POST /_ingest/pipeline/flight-tracking-ingest-pipeline/_simulate
{
  "docs": [
    {
        "_source" : {
          "message" : "\"4b1815\",\"EDW58T  \",\"Switzerland\",1682183916,1682183916,3.4247,39.7982,3131.82,false,145.51,195.17,-8.45,null,3246.12,\"3053\",false,0"
        }
      }
  ]
}
```

