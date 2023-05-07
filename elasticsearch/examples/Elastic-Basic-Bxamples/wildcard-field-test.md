### You index and search a wildcard field as follows

**Create mappings**:


<details open><summary><i>Mappings</i></summary><blockquote>

```json
DELETE /my-index-000001

PUT my-index-000001
{
  "mappings": {
    "properties": {
      "my_wildcard": {
        "type": "wildcard"
      }
    }
  }
}
```

</blockquote></details>

---

***Index doc***

<details open><summary><i>Index document</i></summary><blockquote>

```json
PUT my-index-000001/_doc/1
{
  "my_wildcard" : "This string can be quite lengthy"
}
```

</blockquote></details>

---

***Search wildcard***:

<details open><summary><i>Search wildcard</i></summary><blockquote>

```json
GET my-index-000001/_search
{
  "query": {
    "wildcard": {
      "my_wildcard": {
        "value": "*quite*lengthy"
      }
    }
  }
}
```

  <details><summary><i>Response:</i></summary>

  ```json
  {
    "took" : 4,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 1.0,
      "hits" : [
        {
          "_index" : "my-index-000001",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 1.0,
          "_source" : {
            "my_wildcard" : "This string can be quite lengthy"
          }
        }
      ]
    }
  }
  ```

  </details>

</blockquote></details>

---

**Clean**:

<details open><summary><i>Clean</i></summary><blockquote>

```json
DELETE /my-index-000001
```

</blockquote></details>


