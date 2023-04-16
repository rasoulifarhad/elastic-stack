#!/bin/bash
#
content=$(curl -sS https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson)
echo $content | jq -c  '.features[]' > all_month.geojson.ndjson
sed -i 's/^/{"index":{}}\n/'  all_month.geojson.ndjson
curl -s -H "Content-Type: application/x-ndjson" -XPOST "localhost:9200/earthquakes/_bulk?pipeline=earthquake_data_pipeline" --data-binary "@all_month.geojson.ndjson"; echo
rm -rf all_month.geojson.ndjson

