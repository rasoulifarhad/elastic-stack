### Indexing documents

1. ***Index a document in the `devoxx-france` index:***


```json
PUT devoxx-france/_doc/1
{
  "message": "Welcome to Devoxx France 2023"
}
```

2. ***Check that the document ***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /devoxx-france/_doc/1
```

<details><summary><i>Response:</i></summary>

```json
{
  "_index" : "devoxx-france",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "message" : "Welcome to Devoxx France 2023"
  }
}
```

</details>

</blockquote></details>

3. ***Update the document:***

```json
PUT /devoxx-france/_doc/1
{
  "message": "Welcome to Devoxx France 2023",
  "session": "2023-04-12"
}
```


4. ***Check that the document updated correctly***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /devoxx-france/_doc/1
```

<details><summary><i>Response:</i></summary>

```json
{
  "_index" : "devoxx-france",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 2,
  "_seq_no" : 1,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "message" : "Welcome to Devoxx France 2023",
    "session" : "2023-04-12"
  }
}
```

</details>

</blockquote></details>

5. ***Remove the document***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
DELETE /devoxx-france/_doc/1
```

<details><summary><i>Response:</i></summary>

```json
{
  "_index" : "devoxx-france",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 3,
  "result" : "deleted",
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

6. ***check that document deleted***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /devoxx-france/_doc/1
```

<details><summary><i>Response:</i></summary>

```json
{
  "_index" : "devoxx-france",
  "_type" : "_doc",
  "_id" : "1",
  "found" : false
}
```

</details>

</blockquote></details>

7. ***Create a new document***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
PUT /devoxx-france/_doc/2
{
  "message": "Welcome to Devoxx France 2023",
  "session": "Un moteur de recherche de documents d'entreprise"
}
```

<details><summary><i>Response:</i></summary>

```json
{
  "error" : {
    "root_cause" : [
      {
        "type" : "mapper_parsing_exception",
        "reason" : "failed to parse field [session] of type [date] in document with id '2'. Preview of field's value: 'Un moteur de recherche de documents d'entreprise'"
      }
    ],
    "type" : "mapper_parsing_exception",
    "reason" : "failed to parse field [session] of type [date] in document with id '2'. Preview of field's value: 'Un moteur de recherche de documents d'entreprise'",
    "caused_by" : {
      "type" : "illegal_argument_exception",
      "reason" : "failed to parse date field [Un moteur de recherche de documents d'entreprise] with format [strict_date_optional_time||epoch_millis]",
      "caused_by" : {
        "type" : "date_time_parse_exception",
        "reason" : "Failed to parse with all enclosed parsers"
      }
    }
  },
  "status" : 400
}
```

</details>

</blockquote></details>

8. ***Get mapping***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /devoxx-france/_mapping
```

<details><summary><i>Response:</i></summary>

```json
{
  "devoxx-france" : {
    "mappings" : {
      "properties" : {
        "message" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "session" : {
          "type" : "date"
        }
      }
    }
  }
}
```

</details>

</blockquote></details>

9. ***Change the mapping to use text for both message and session fields***

```json
DELETE /devoxx-france

PUT /devoxx-france
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

10. ***Reindex doc 1***

```json
PUT /devoxx-france/_doc/1
{
  "message": "Welcome to Devoxx France 2023",
  "session": "2023-04-12"
}
```

11. ***the doc 2***

```json
PUT /devoxx-france/_doc/2
{
  "message": "Welcome to Devoxx France 2023",
  "session": "Un moteur de recherche de documents d'entreprise"
}
```

12. ***Search for documents where message has "Devoxx".***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /devoxx-france/_search
{
  "query": {
    "match": {
      "message": "Devoxx"
    }
  }
}
```

<details><summary><i>Response:</i></summary>

```json
{
  "took" : 721,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 0.18232156,
    "hits" : [
      {
        "_index" : "devoxx-france",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.18232156,
        "_source" : {
          "message" : "Welcome to Devoxx France 2023",
          "session" : "2023-04-12"
        }
      },
      {
        "_index" : "devoxx-france",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 0.18232156,
        "_source" : {
          "message" : "Welcome to Devoxx France 2023",
          "session" : "Un moteur de recherche de documents d'entreprise"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

13. ***Search for documents where message has "Devoxx" or session has recherche, the more terms, the better.***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /devoxx-france/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "message": "Devoxx"
          }
        },
        {
          "match": {
            "session": "recherche"
          }
        }
      ]
    }
  }
}
```

<details><summary><i>Response:</i></summary>

```json
{
  "took" : 9,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 0.7779949,
    "hits" : [
      {
        "_index" : "devoxx-france",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 0.7779949,
        "_source" : {
          "message" : "Welcome to Devoxx France 2023",
          "session" : "Un moteur de recherche de documents d'entreprise"
        }
      },
      {
        "_index" : "devoxx-france",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.18232156,
        "_source" : {
          "message" : "Welcome to Devoxx France 2023",
          "session" : "2023-04-12"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

### Ingest Pipelines

from [lab2](https://github.com/dadoonet/DevoxxFR-2023/blob/main/labs/lab2.md)

#### Steps

Source document :

```json
{
  "content": "Welcome to Devoxx France 2023|Un moteur de recherche de documents d'entreprise|2023-04-12|4.5"
}
```

Buid a pipeline which transforms it to:

```json
{
  "message": "Welcome to Devoxx France 2023",
  "session": "Un moteur de recherche de documents d'entreprise",
  "date": "2023-01-02T00:00:00.000Z",
  "note": 4.5
}
```

#### Create ingest pipeline

--- 

1. ***Add `dissect` processor***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
PUT /_ingest/pipeline/devoxx-france-2023-ingest-pipeline
{
  "processors": [
    {
      "dissect": {
        "field": "content",
        "pattern": "%{message}|%{session}|%{date}|%{note}"
      }
    },
    {
      "remove": {
        "field": "content"
      }
    }
  ]
}
```

<details><summary><i>test pipeline</i></summary><blockquote>

```json
POST /_ingest/pipeline/_simulate
{
  "pipeline": {
    "processors": [
      {
        "dissect": {
          "field": "content",
          "pattern": "%{message}|%{session}|%{date}|%{note}"
        }
      },
      {
        "remove": {
          "field": "content"
        }
      }
    ]
  },
  "docs": [
    {
      "_source": {
        "content": "Welcome to Devoxx France 2023|Un moteur de recherche de documents d'entreprise|2023-04-12|4.5"
      }
    }
  ]
}
```

<details><summary><i>Response:</i></summary>

```json
{
  "docs" : [
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "date" : "2023-04-12",
          "note" : "4.5",
          "session" : "Un moteur de recherche de documents d'entreprise",
          "message" : "Welcome to Devoxx France 2023"
        },
        "_ingest" : {
          "timestamp" : "2023-04-24T05:03:55.484275619Z"
        }
      }
    }
  ]
}
```

</details>

</blockquote></details>

</blockquote></details>


2. ***Add `date` processor***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
PUT /_ingest/pipeline/devoxx-france-2023-ingest-pipeline
{
  "processors": [
    {
      "dissect": {
        "field": "content",
        "pattern": "%{message}|%{session}|%{date}|%{note}"
      }
    },
    {
      "remove": {
        "field": "content"
      }
    },
    {
      "date": {
        "field": "date",
        "formats": [
          "yyyy-MM-dd"
        ],
        "target_field": "date"
      }
    }
  ]
}
```

<details><summary><i>test pipeLine</i></summary><blockquote>

```json
POST /_ingest/pipeline/_simulate
{
  "pipeline": {
    "processors": [
      {
        "dissect": {
          "field": "content",
          "pattern": "%{message}|%{session}|%{date}|%{note}"
        }
      },
      {
        "remove": {
          "field": "content"
        }
      },
      {
        "date": {
          "field": "date",
          "formats": [
            "yyyy-MM-dd"
          ],
          "target_field": "date"
        }
      }
    ]
  },
  "docs": [
    {
      "_source": {
        "content": "Welcome to Devoxx France 2023|Un moteur de recherche de documents d'entreprise|2023-04-12|4.5"
      }
    }
  ]
}
```

<details><summary><i>Response:</i></summary>

```json
{
  "docs" : [
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "date" : "2023-04-12T00:00:00.000Z",
          "note" : "4.5",
          "session" : "Un moteur de recherche de documents d'entreprise",
          "message" : "Welcome to Devoxx France 2023"
        },
        "_ingest" : {
          "timestamp" : "2023-04-24T05:11:01.476550221Z"
        }
      }
    }
  ]
}
```

</details>

</blockquote></details>

</blockquote></details>


3. ***Add `convert` processor for `note` field***


<details open><summary><i>dev tools</i></summary><blockquote>

```json
PUT /_ingest/pipeline/devoxx-france-2023-ingest-pipeline
{
  "processors": [
    {
      "dissect": {
        "field": "content",
        "pattern": "%{message}|%{session}|%{date}|%{note}"
      }
    },
    {
      "remove": {
        "field": "content"
      }
    },
    {
      "date": {
        "field": "date",
        "formats": [
          "yyyy-MM-dd"
        ],
        "target_field": "date"
      }
    },
    {
      "convert": {
        "field": "note",
        "type": "float"
      }
    }
  ]
}
```

<details><summary><i>test pipeLine</i></summary><blockquote>

```json
POST /_ingest/pipeline/_simulate
{
  "pipeline": {
    "processors": [
      {
        "dissect": {
          "field": "content",
          "pattern": "%{message}|%{session}|%{date}|%{note}"
        }
      },
      {
        "remove": {
          "field": "content"
        }
      },
      {
        "date": {
          "field": "date",
          "formats": [
            "yyyy-MM-dd"
          ],
          "target_field": "date"
        }
      },
      {
        "convert": {
          "field": "note",
          "type": "float"
        }
      }
    ]
  },
  "docs": [
    {
      "_source": {
        "content": "Welcome to Devoxx France 2023|Un moteur de recherche de documents d'entreprise|2023-04-12|4.5"
      }
    }
  ]
}
```

<details><summary><i>Response:</i></summary>

```json
{
  "docs" : [
    {
      "doc" : {
        "_index" : "_index",
        "_type" : "_doc",
        "_id" : "_id",
        "_source" : {
          "date" : "2023-04-12T00:00:00.000Z",
          "note" : 4.5,
          "session" : "Un moteur de recherche de documents d'entreprise",
          "message" : "Welcome to Devoxx France 2023"
        },
        "_ingest" : {
          "timestamp" : "2023-04-24T05:13:15.81175526Z"
        }
      }
    }
  ]
}
```

</details>

</blockquote></details>

</blockquote></details>


4. ***Final pipeline***

```json
PUT /_ingest/pipeline/devoxx-france-2023-ingest-pipeline
{
  "processors": [
    {
      "dissect": {
        "field": "content",
        "pattern": "%{message}|%{session}|%{date}|%{note}"
      }
    },
    {
      "remove": {
        "field": "content"
      }
    },
    {
      "date": {
        "field": "date",
        "formats": [
          "yyyy-MM-dd"
        ],
        "target_field": "date"
      }
    },
    {
      "convert": {
        "field": "note",
        "type": "float"
      }
    }
  ]
}
```

#### Add index `devoxx-france-2023`

---

1. ***Create index***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
PUT /devoxx-france-2023
```

<details><summary><i>Response:</i></summary>

```json
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "devoxx-france-2023"
}
```

</details>

</blockquote></details>


2. ***Add ingest pipeline as the default pipeline for index `devoxx-france-2023`***

```json
PUT /devoxx-france-2023/_settings
{
  "index.default_pipeline": "devoxx-france-2023-ingest-pipeline"
}
```

3. ***Check index `devoxx-france-2023`***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /devoxx-france-2023
```

<details><summary><i>Response:</i></summary>

```json
{
  "devoxx-france-2023" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "devoxx-france-2023",
        "default_pipeline" : "devoxx-france-2023-ingest-pipeline",
        "creation_date" : "1682313721244",
        "number_of_replicas" : "1",
        "uuid" : "h4tzhKqfT7GrcGCfqQMPXg",
        "version" : {
          "created" : "7160299"
        }
      }
    }
  }
}
```

</details>

</blockquote></details>


4. ***Bulk index documents in index `devoxx-france-2023`***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
POST /devoxx-france-2023/_bulk
{"index":{}}
{"content":"Welcome to Devoxx France 2023|Un moteur de recherche de documents d'entreprise|2023-04-12|4.5"}
{"index":{}}
{"content":"Welcome to Devoxx France 2023|The Developer Portal: Open the Gate to Productivity|2023-04-13|5.0"}
```

<details><summary><i>Response:</i></summary>

```json
{
  "took" : 34,
  "ingest_took" : 0,
  "errors" : false,
  "items" : [
    {
      "index" : {
        "_index" : "devoxx-france-2023",
        "_type" : "_doc",
        "_id" : "3t2-sYcBvOKul2sKEIIG",
        "_version" : 1,
        "result" : "created",
        "_shards" : {
          "total" : 2,
          "successful" : 1,
          "failed" : 0
        },
        "_seq_no" : 0,
        "_primary_term" : 1,
        "status" : 201
      }
    },
    {
      "index" : {
        "_index" : "devoxx-france-2023",
        "_type" : "_doc",
        "_id" : "392-sYcBvOKul2sKEIIG",
        "_version" : 1,
        "result" : "created",
        "_shards" : {
          "total" : 2,
          "successful" : 1,
          "failed" : 0
        },
        "_seq_no" : 1,
        "_primary_term" : 1,
        "status" : 201
      }
    }
  ]
}
```

</details>

</blockquote></details>


5. ***Check indexed documents***

<details open><summary><i>dev tools</i></summary><blockquote>

```json
GET /devoxx-france-2023/_search
```

<details><summary><i>Response:</i></summary>

```json
{
  "took" : 186,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "devoxx-france-2023",
        "_type" : "_doc",
        "_id" : "3t2-sYcBvOKul2sKEIIG",
        "_score" : 1.0,
        "_source" : {
          "date" : "2023-04-12T00:00:00.000Z",
          "note" : 4.5,
          "session" : "Un moteur de recherche de documents d'entreprise",
          "message" : "Welcome to Devoxx France 2023"
        }
      },
      {
        "_index" : "devoxx-france-2023",
        "_type" : "_doc",
        "_id" : "392-sYcBvOKul2sKEIIG",
        "_score" : 1.0,
        "_source" : {
          "date" : "2023-04-13T00:00:00.000Z",
          "note" : 5.0,
          "session" : "The Developer Portal: Open the Gate to Productivity",
          "message" : "Welcome to Devoxx France 2023"
        }
      }
    ]
  }
}
```

</details>

</blockquote></details>

