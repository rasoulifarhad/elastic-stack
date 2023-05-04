### Person Data 

1. Create index

```json

PUT person

```

2. Index Some data

```json

PUT /person/_doc/1
{
  "name": "John",
  "lastname": "Doe",
  "job_description": "Systems administrator and Linux specialit"
}

PUT /person/_doc/2
{
  "name": "John",
  "lastname": "Smith",
  "job_description": "Systems administrator"
}


```

3. Update some document

```json

POST /person/_update/1
{
  "doc": {
    "job_description" : "Systems administrator and Linux specialist"
  }
}

```

4. Check Data

```json

GET /person/_doc/1

```

Response:

```json

{
  "_index" : "person",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "name" : "John",
    "lastname" : "Doe",
    "job_description" : "Systems administrator and Linux specialit"
  }
}

```

```json

GET /person/_search?q=john

GET /person/_search?q=job_description:john

GET /person/_search?q=job_description:linux

DELETE /person/_doc/1

```
