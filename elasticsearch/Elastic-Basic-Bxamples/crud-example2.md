### CRUD operatrions

***1. add a document***

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>dev tools:</i></summary>
  
  ```json
  POST /person/_doc/1
  {
    "name": "Farhad",
    "job_description": "Software Engineer"
  }
  ```

  </details>

  <details><summary><i>curl:</i></summary>

  ```json
  curl -XPOST "http://localhost:9200/person/_doc/1?pretty" -H 'Content-Type: application/json' -d'
  {
    "name": "Farhad",
    "job_description": "Software Engineer"
  }'
  ```

  </details>

  <details><summary><i>Response:</i></summary>

  ```json
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

  </details>

</blockquote></details>


***2. fetch a document from Elasticsearch***

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>dev tools:</i></summary>
  
  ```json
  GET /person/_doc/1
  ```

  </details>

  <details><summary><i>curl:</i></summary>

  ```json
  curl -XGET "http://localhost:9200/person/_doc/1?pretty"
  ```

  </details>

  <details><summary><i>Response:</i></summary>

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
      "name" : "Farhad",
      "job_description" : "Software Engineer"
    }
  }
  ```

  </details>

</blockquote></details>


***3. Update part of a document***

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>dev tools:</i></summary>
  
  ```json
  POST /person/_update/1
  {
    "doc": {
      "job_description": "Senior Software Engineer"
    }
  }
  ```

  </details>

  <details><summary><i>curl:</i></summary>

  ```json
  curl -XPOST "http://localhost:9200/person/_update/1?pretty" -H 'Content-Type: application/json' -d'
  {
    "doc": {
      "job_description": "Senior Software Engineer"
    }
  }'
  ```

  </details>

  <details><summary><i>Response:</i></summary>

  ```json
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

  </details>

</blockquote></details>


***5. Update part of a document with script***

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>dev tools:</i></summary>
  
  ```json
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
  ```
  
  </details>

  <details><summary><i>curl:</i></summary>

  ```json
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

  </details>

  <details><summary><i>Response:</i></summary>

  ```json
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

  </details>

</blockquote></details>


***6. Update part of a document - rename field***

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>dev tools:</i></summary>
  
  ```json
  POST /person/_update/1
  {
    "script": {
      "source": "ctx._source.fullname = ctx._source.name;ctx._source.remove('name');"
    }
  }
  ```
  
  </details>

  <details><summary><i>curl:</i></summary>

  ```json
  curl -XPOST "http://localhost:9200/person/_update/1?pretty" -H 'Content-Type: application/json' -d'
  {
    "script": {
      "source": "ctx._source.fullname = ctx._source.name;ctx._source.remove('\''name'\'');"
    }
  }'
  ```

  </details>

  <details><summary><i>Response:</i></summary>

  ```json
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

  </details>

</blockquote></details>


***7. Get updated document***

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>dev tools:</i></summary>
  
  ```json
  GET /person/_doc/1
  ```
  
  </details>

  <details><summary><i>curl:</i></summary>

  ```json
  curl -XGET "http://localhost:9200/person/_doc/1?pretty"
  ```

  </details>

  <details><summary><i>Response:</i></summary>

  ```json
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

  </details>

</blockquote></details>


***8. Upsert / Scripted upsert / Doc as upsert***


***9. delete a record***

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>dev tools:</i></summary>
  
  ```json
  DELETE /person/_doc/1
  ```
  
  </details>

  <details><summary><i>curl:</i></summary>

  ```json
  curl -XDELETE "http://localhost:9200/person/_doc/1?pretty"
  ```

  </details>

  <details><summary><i>Response:</i></summary>

  ```json
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

  </details>

</blockquote></details>

