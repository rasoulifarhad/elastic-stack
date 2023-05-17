### Using curl
```markdown
curl -X <VERB<URL-d <BODY>
```
OR
```markdown
curl -X <VERB<URL-d @<FILE>
```
1. Create match-all-query.json:
```markdown
cat match-all-query.json <<EOF
{
 "query": {
 "match_all": {}
 }
}
EOF
```
2. Query elasticsearch
```markdown
curl -X GET localhost:9200/_count?pretty -H 'Content-Type: application/json' -d @match-all-query.json 
```
OR
```markdown
curl -X GET localhost:9200/_count?pretty -H 'Content-Type: application/json' -d'
{
 "query": {
 "match_all": {}
 }
}
'
```
