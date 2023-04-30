#!/bin/bash

es_url=my-es-host:9200
index=my-index

response=$(curl -s $es_url/$index/_search?scroll=1m -d @query.json)
scroll_id=$(echo $response | jq -r ._scroll_id)
hits_count=$(echo $response | jq -r '.hits.hits | length')
hits_so_far=hits_count
echo Got initial response with $hits_count hits and scroll ID $scroll_id

# TODO process first page of results here

while [ "$hits_count" != "0" ]; do
  response=$(curl -s $es_url/_search/scroll -d "{ \"scroll\": \"1m\", \"scroll_id\": \"$scroll_id\" }")
  scroll_id=$(echo $response | jq -r ._scroll_id)
  hits_count=$(echo $response | jq -r '.hits.hits | length')
  hits_so_far=$((hits_so_far + hits_count))
  echo "Got response with $hits_count hits (hits so far: $hits_so_far), new scroll ID $scroll_id"
  
  # TODO process page of results
done

echo Done!
