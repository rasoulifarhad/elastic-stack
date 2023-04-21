source .env

DATASOURCE_DIR=$(pwd)/dataset

# download_region 95
download_region () {
    export REGION=$1
    FILE=$DATASOURCE_DIR/bano-$REGION.csv
    URL=http://bano.openstreetmap.fr/data/bano-$REGION.csv
    # We import the region from openstreet map if not available yet
    if [ ! -e $FILE ] ; then
        echo "Fetching $FILE from $URL"
        wget $URL -P $DATASOURCE_DIR
    fi
}


echo -ne '\n'
echo "#######################"
echo "### Prepare Dataset ###"
echo "#######################"
echo -ne '\n'

if [ ! -e $DATASOURCE_DIR ] ; then
    echo "Creating $DATASOURCE_DIR dir"
    mkdir $DATASOURCE_DIR
fi

# Download a CSV file
download_region 95

# Transform the X first lines to a bulk request
echo "Creating the data. Please wait..."
head -10000 bano-95.csv | while read -r line; do NOW=$(date +"%Y-%m-%dT%T") ; printf "{ \"index\" : {}}\n{\"@timestamp\":\"$NOW\", \"message\":\"$line\"}\n"; done > bulk-bano-95.ndjson

echo "Injecting the data. Please wait..."
curl -XPOST "$ELASTICSEARCH_URL/demo_csv/_bulk" -s -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/x-ndjson' --data-binary "@$DATASOURCE_DIR/bulk-bano-95.ndjson" | jq '{took: .took, errors: .errors}' ; echo
