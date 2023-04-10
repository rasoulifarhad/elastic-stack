### Dynamically created runtime fields

1. Define index template

> PUT _index_template/my_dynamic_index
> {
>   "index_patterns": [
>     "my_dynamic_index-*"
>   ],
>   "template": {
>     "mappings": {
>       "dynamic": "runtime",
>       "properties": {
>         "timestamp": {
>           "type": "date",
>           "format": "yyyy-MM-dd"
>         },
>         "response_code": {
>           "type": "integer"
>         }
>       }
>     }
>   }
> }

2. Ingest some data

with DevTools:

> POST my_dynamic_index-1/_bulk
> {"index":{}}
> {"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-1"}
> {"index":{}}
> {"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-1"}
> {"index":{}}
> {"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-2"}
> {"index":{}}
> {"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-2"}

with curl: 

> curl -X POST "localhost:9200/my_dynamic_index-1/_bulk?refresh&pretty" -H 'Content-Type: application/json' -d'
> {"index":{}}
> {"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-1"}
> {"index":{}}
> {"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-1"}
> {"index":{}}
> {"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-2"}
> {"index":{}}
> {"timestamp": "2021-01-01", "response_code": 200, "new_tla": "data-2"}
> '

3. Show the index mapping

> GET /my_dynamic_index-1
> GET /my_dynamic_index-1/_mapping

with curl: 

> curl -X GET "localhost:9200/my_dynamic_index-1?pretty"
> curl -X GET "localhost:9200/my_dynamic_index-1/_mapping?pretty"

4. Search for  ...

> GET my_dynamic_index-1/_search
> {
>   "query": {
>     "match": {
>       "new_tla": "data-2"
>     }
>   }
> }

5. Delete the index as cleanup

> DELETE my_dynamic_index-1
> DELETE _index_template/my_dynamic_index

with curl: 

> curl -X DELETE "localhost:9200/_index_template" 
> curl -X DELETE "localhost:9200/_index_template/my_dynamic_index"


