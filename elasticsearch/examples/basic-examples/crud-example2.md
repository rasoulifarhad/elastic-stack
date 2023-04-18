### CRUD operatrions

1. add a document

```markdown
POST /person/_doc/1
{
  "name": "Farhad",
  "job_description": "Software Engineer"
}

curl -XPOST "http://localhost:9200/person/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "Farhad",
  "job_description": "Software Engineer"
}'
```
Response after creating a document is

```markdown
{
  "_index" : "person",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}
```

2. fetch a document from Elasticsearch

```markdown
GET /person/_doc/1

curl -XGET "http://localhost:9200/person/_doc/1?pretty"
```

Response after fetching a document with Id is

```markdown
{
  "_index" : "person",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "name" : "Farhad",
    "job_description" : "Software Engineer"
  }
}
```

3. Update part of a document

```markdown
POST /person/_update/1
{
  "doc": {
    "job_description": "Senior Software Engineer"
  }
}

curl -XPOST "http://localhost:9200/person/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
  "doc": {
    "job_description": "Senior Software Engineer"
  }
}'
```

Response after updating the record

```markdown
{
  "_index" : "person",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 2,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 1,
  "_primary_term" : 1
}
```

5. Update part of a document with script

```markdown
POST /person/_update/1
{
  "script": {
    "source": "ctx._source.name = params.updatedName", 
    "lang": "painless",
    "params": {
      "updatedName": "Farhad Rasouli"
    }
  }
}

curl -XPOST "http://localhost:9200/person/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
  "script": {
    "source": "ctx._source.name = params.updatedName", 
    "lang": "painless",
    "params": {
      "updatedName": "Farhad Rasouli"
    }
  }
}'
```

Response after updating the record

```markdown
{
  "_index" : "person",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 3,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 2,
  "_primary_term" : 1
}

```

6. Update part of a document - rename field

```markdown
POST /person/_update/1
{
  "script": {
    "source": "ctx._source.fullname = ctx._source.name;ctx._source.remove('name');"
  }
}

curl -XPOST "http://localhost:9200/person/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
  "script": {
    "source": "ctx._source.fullname = ctx._source.name;ctx._source.remove('\''name'\'');"
  }
}'
```

Response after updating the record

```markdown
{
  "_index" : "person",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 4,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 3,
  "_primary_term" : 1
}
```

Get updated document

```markdown
GET /person/_doc/1

curl -XGET "http://localhost:9200/person/_doc/1?pretty"
```

Response after getting a document

```markdown
{
  "_index" : "person",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 4,
  "_seq_no" : 3,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "job_description" : "Senior Software Engineer",
    "fullname" : "Farhad Rasouli"
  }
}
```
7. Upsert / Scripted upsert / Doc as upsert


8. delete a record

```markdown
DELETE /person/_doc/1

curl -XDELETE "http://localhost:9200/person/_doc/1?pretty"
```

Response after deleting a record 

```markdown
{
  "_index" : "person",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 5,
  "result" : "deleted",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 4,
  "_primary_term" : 1
}
```
