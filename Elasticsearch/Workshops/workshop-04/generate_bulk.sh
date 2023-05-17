#!/bin/bash
#
# 
# airports.ldjson content:
# 
# {"coords":[75.9570722,30.8503599],"name":"Sahnewal","abbrev":"LUH","type":"small"}
# {"coords":[75.9330598,17.6254152],"name":"Solapur","abbrev":"SSE","type":"mid"}
# ....
#
# Generated bulk file content: 
#  
# { "index" : { "_index" : "airports", "_id" : "1" } }
# {"coords":[75.9570722,30.8503599],"name":"Sahnewal","abbrev":"LUH","type":"small"}
# { "index" : { "_index" : "airports", "_id" : "2" } }
# {"coords":[75.9330598,17.6254152],"name":"Solapur","abbrev":"SSE","type":"mid"}
# ....
#
#
count=1
input="airports.ldjson"
output_bulk="airports.bulk.ndjson"
INDEX_NAME="workshop_airports"

while IFS= read -r line
do
    echo "{ \"index\" : { \"_index\" : \"$INDEX_NAME\", \"_id\" : \"${count}\" } }" >> $output_bulk
    echo "$line" >> $output_bulk
    (( count++ ))
done < "$input"
