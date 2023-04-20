### Index documents

##### Index a first document

```json
PUT /devoxxfr/_doc/1
{
  "message": "Welcome to Devoxx France 2023"
}
```

##### Check that the document has been correctly indexed

```json
GET /devoxxfr/_doc/1
```

##### Update the document

```json
PUT /devoxxfr/_doc/1
{
  "message": "Welcome to Devoxx France 2023",
  "session": "2023-04-12"
}
```

##### Check that the document has been correctly updated

```json
GET /devoxxfr/_doc/1
```

##### Remove the document

```json
DELETE /devoxxfr/_doc/1
```

##### Check that the document has been correctly removed

```json
GET /devoxxfr/_doc/1
```

##### Create a new document

```json
PUT /devoxxfr/_doc/2
{
  "message": "Welcome to Devoxx France 2023",
  "session": "Un moteur de recherche de documents d'entreprise"
}
```

##### Get the mapping

```json
GET /devoxxfr/_mapping
```

##### Change the mapping to use `text` for both `message` and `session` fields'

```json
DELETE /devoxxfr
PUT /devoxxfr
{
  "mappings": {
    "properties": {
      "message": {
        "type": "text"
      },
      "session": {
        "type": "text"
      }
    }
  }
}
```

##### Reindex doc 1

```json
PUT /devoxxfr/_doc/1
{
  "message": "Welcome to Devoxx France 2023",
  "session": "2023-04-12"
}
```

##### Then doc 2

```json
PUT /devoxxfr/_doc/2
{
  "message": "Welcome to Devoxx France 2023",
  "session": "Un moteur de recherche de documents d'entreprise"
}
```

##### Search for documents where `message` has `"Devoxx"`.

```json
GET /devoxxfr/_search
{
  "query": {
    "match": {
      "message": "Devoxx"
    }
  }
}
```

##### Search for documents where `message` has `"Devoxx"` or `session` has `recherche`, the more terms, the better.
	
```json
GET /devoxxfr/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "message": "Devoxx"
          }
        },        {
          "match": {
            "session": "recherche"
          }
        }
      ]
    }
  }
}
```

