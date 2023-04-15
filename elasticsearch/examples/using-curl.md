### Using curl

> curl -X <VERB> <URL> -d <BODY>
> 
> OR
> 
> curl -X <VERB> <URL> -d @<FILE>

1. Create match-all-query.json:

> cat > match-all-query.json <<EOF
> {
>  "query": {
>  "match_all": {}
>  }
> }
> EOF

2. Query elasticsearch

> curl -X GET localhost:9200/_count?pretty -H 'Content-Type: application/json' -d @match-all-query.json 
>
> OR
>
> curl -X GET localhost:9200/_count?pretty -H 'Content-Type: application/json' -d'
> {
>  "query": {
>  "match_all": {}
>  }
> }
> '

