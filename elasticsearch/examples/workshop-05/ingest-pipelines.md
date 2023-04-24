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

1. Add `dissect` processor

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

Response:

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
 
2. Add `date` processor

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

Response:

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

3. Add `convert` processor for `note` field


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

Response:

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
