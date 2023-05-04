### Reverse nested aggregation

 Aggregation on nested documents in two scenarios - applied to nested documents and applied to parent documents.

#### Test data

- mapping 

    ```json

    PUT /club
    {
    "settings": {
        "number_of_replicas": 0,
        "number_of_shards": 1
    },
    "mappings": {
        "properties": {
        "name": {
            "type": "keyword"
        },
        "players": {
            "type": "nested",
            "properties": {
            "identity": {
                "type": "keyword"
            },
            "games": {
                "type": "integer"
            },
            "nationality": {
                "type": "keyword"
            }
            }
        }
        }
    }
    }

    ```

- Bulk ingest data

    ``` json

    POST _bulk
    {"index":{"_index":"club"}}
    {"name":"Team 1","players":[{"identity":"Player_1","games":30,"nationality":"FR"},{"identity":"Player_2","games":15,"nationality":"DE"},{"identity":"Player_3","games":34,"nationality":"FR"},{"identity":"Player_4","games":11,"nationality":"BR"},{"identity":"Player_5","games":4,"nationality":"BE"},{"identity":"Player_6","games":11,"nationality":"FR"}]}
    {"index":{"_index":"club"}}
    {"name":"Team 2","players":[{"identity":"Player_20","games":11,"nationality":"FR"},{"identity":"Player_21","games":15,"nationality":"FR"},{"identity":"Player_22","games":34,"nationality":"FR"},{"identity":"Player_23","games":30,"nationality":"FR"},{"identity":"Player_24","games":4,"nationality":"FR"},{"identity":"Player_25","games":11,"nationality":"FR"}]}
    {"index":{"_index":"club"}}
    {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]}
    {"index":{"_index":"club"}}
    {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]} 

    ```

    OR: 

    ```json

    POST /club/_bulk
    {"index":{}}
    {"name":"Team 1","players":[{"identity":"Player_1","games":30,"nationality":"FR"},{"identity":"Player_2","games":15,"nationality":"DE"},{"identity":"Player_3","games":34,"nationality":"FR"},{"identity":"Player_4","games":11,"nationality":"BR"},{"identity":"Player_5","games":4,"nationality":"BE"},{"identity":"Player_6","games":11,"nationality":"FR"}]}
    {"index":{}}
    {"name":"Team 2","players":[{"identity":"Player_20","games":11,"nationality":"FR"},{"identity":"Player_21","games":15,"nationality":"FR"},{"identity":"Player_22","games":34,"nationality":"FR"},{"identity":"Player_23","games":30,"nationality":"FR"},{"identity":"Player_24","games":4,"nationality":"FR"},{"identity":"Player_25","games":11,"nationality":"FR"}]}
    {"index":{}}
    {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]}
    {"index":{}}
    {"name":"Team 3","players":[{"identity":"Player_30","games":11,"nationality":"FR"},{"identity":"Player_31","games":15,"nationality":"FR"},{"identity":"Player_32","games":12,"nationality":"FR"},{"identity":"Player_33","games":15,"nationality":"FR"},{"identity":"Player_34","games":4,"nationality":"FR"},{"identity":"Player_35","games":11,"nationality":"FR"}]} 

    ```
####  played games for each players.

```json

GET /club/_search
{
  "size": 0,
  "aggs": {
    "by_team": {
      "terms": {
        "field": "name",
        "size": 10
      },
      "aggs": {
        "at_least_30_games": {
          "nested": {
            "path": "players"
          },
          "aggs": {
            "count_games_docs": {
              "terms": {
                "field": "players.identity",
                "size": 100
              },
              "aggs": {
                "sum_games": {
                  "sum": {
                    "field": "players.games"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

```

#### How many players in each team played in at least 30 games. 

Two step: 

1.  First the query uses terms filter to group documents by teams. 

    ```json

    GET /club/_search
    {
    "size": 0,
    "aggs": {
        "by_team": {
        "terms": {
            "field": "name",
            "size": 10
        }
        }
    }
    }

    ```

    Response:

    ```json

    {
    "took" : 1,
    "timed_out" : false,
    "_shards" : {
        "total" : 1,
        "successful" : 1,
        "skipped" : 0,
        "failed" : 0
    },
    "hits" : {
        "total" : {
        "value" : 4,
        "relation" : "eq"
        },
        "max_score" : null,
        "hits" : [ ]
    },
    "aggregations" : {
        "by_team" : {
        "doc_count_error_upper_bound" : 0,
        "sum_other_doc_count" : 0,
        "buckets" : [
            {
            "key" : "Team 3",
            "doc_count" : 2
            },
            {
            "key" : "Team 1",
            "doc_count" : 1
            },
            {
            "key" : "Team 2",
            "doc_count" : 1
            }
        ]
        }
    }
    }

    ```

2. Then nested aggregation with filter aggregation to count the number of players with at least 30 games.

    ```json

    GET /club/_search
    {
    "size": 0,
    "aggs": {
        "by_team": {
        "terms": {
            "field": "name"
        },
        "aggs": {
            "at_least_30_games": {
            "nested": {
                "path": "players"
            },
            "aggs": {
                "count_games": {
                "filter": {
                    "range": {
                    "players.games": {
                        "gte": 30
                    }
                    }
                }
                }
            }
            }
        }
        }
    }
    }

    ```

    - Response

    ```json

    {
    "took" : 1,
    "timed_out" : false,
    "_shards" : {
        "total" : 1,
        "successful" : 1,
        "skipped" : 0,
        "failed" : 0
    },
    "hits" : {
        "total" : {
        "value" : 4,
        "relation" : "eq"
        },
        "max_score" : null,
        "hits" : [ ]
    },
    "aggregations" : {
        "by_team" : {
        "doc_count_error_upper_bound" : 0,
        "sum_other_doc_count" : 0,
        "buckets" : [
            {
            "key" : "Team 3",
            "doc_count" : 2,
            "at_least_30_games" : {
                "doc_count" : 12,
                "count_games" : {
                "doc_count" : 0
                }
            }
            },
            {
            "key" : "Team 1",
            "doc_count" : 1,
            "at_least_30_games" : {
                "doc_count" : 6,
                "count_games" : {
                "doc_count" : 2
                }
            }
            },
            {
            "key" : "Team 2",
            "doc_count" : 1,
            "at_least_30_games" : {
                "doc_count" : 6,
                "count_games" : {
                "doc_count" : 2
                }
            }
            }
        ]
        }
    }
    }

    ```