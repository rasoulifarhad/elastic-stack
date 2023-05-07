### Joining two indices 

<details open><summary><i></i></summary><blockquote>

  <details open><summary><i>dev tools:</i></summary>

  ```json
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
  ```

  </details>

  <details><summary><i>curl:</i></summary>

  ```json
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

  </details>

</blockquote></details>

---

***Note:***

***Get a list of your cluster’s aliases***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET _alias
```

</blockquote></details>

---

***Get a list of your index’s aliases***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET {index}/_alias
```

</blockquote></details>

---

***Get a list of indices that have this alias***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET _alias/{alias}
```

</blockquote></details>

---

***Remove alias***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
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

</blockquote></details>

