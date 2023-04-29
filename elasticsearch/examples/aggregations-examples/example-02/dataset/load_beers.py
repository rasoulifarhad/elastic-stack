# pip install elasticsearch==7.17.9
# cat open-beer-database.json  | jq -c '.[].fields' >> open-beer-database.json-cc
from datetime import datetime
from elasticsearch import Elasticsearch
import json, random
es = Elasticsearch(
   http_auth=("elastic", "G2z3UhgYh8H56kI8phcn")
)

with open('open-beer-database.json') as json_file:
    data = json.load(json_file)
    for p in data:
        try:
            fields = p['fields']   
            doc = {
                'name': fields['name'],
                'country': fields['country'],
                'price': (random.random() * 10),
                'city': fields['city'],
                'name_breweries': fields['name_breweries'],
                'coordinates': "{},{}".format(fields['coordinates'][0],fields['coordinates'][1])
            }
            es.index(index="beers", id=p['recordid'], body=doc)
        except:
            print("Could not index document")
