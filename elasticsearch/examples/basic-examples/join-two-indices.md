### Joining two indices 

```markdown
POST /_aliases
{
  "actions": [
    {
      "add": {
        "index": "index_1",
        "alias": "new_index_alias"
      }
    },
    {
      "add": {
        "index": "index_2",
        "alias": "new_index_alias"
      }
    }
  ]
}

curl -XPOST "http://localhost:9200/_aliases?pretty" -H 'Content-Type: application/json' -d'
{
  "actions": [
    {
      "add": {
        "index": "index_1",
        "alias": "new_index_alias"
      }
    },
    {
      "add": {
        "index": "index_2",
        "alias": "new_index_alias"
      }
    }
  ]
}'
```

**Note:**

```
# Get a list of your cluster’s aliases
GET _alias
# Get a list of your index’s aliases
GET {index}/_alias
# Get a list of indices that have this alias
GET _alias/{alias}
# Remove alias
POST _aliases
{
  "actions": [
    {
      "remove": {
        "index": "index_1",
        "alias": "new_index_alias"
      }
    },
    {
      "remove": {
        "index": "index_2",
        "alias": "new_index_alias"
      }
    }
  ]
}
```

