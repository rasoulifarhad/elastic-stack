### Reverse nested aggregation

- [Nested aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/search-aggregations-bucket-nested-aggregation.html)

    > A special single bucket aggregation that enables aggregating nested documents.
    > 

- [Reverse nested aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/search-aggregations-bucket-reverse-nested-aggregation.html)
 
    > A special single bucket aggregation that enables aggregating on parent docs from nested documents.
    >

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

    ```json

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

> Aggregations on nested documents
> 

Two step: 

1.  First the query uses terms filter to group documents by teams. 

- Request

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

- Response:

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

- Request

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
        "took" : 0,
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

#### How many teams have players who played in at least 30 games. 

> Nested aggregation applied to root document
> 

From [previous part](#how-many-players-in-each-team-played-in-at-least-30-games), we can comparing `count_players` to `0`. But we can do this in another way, by allowing Elasticsearch to put `0` if given team doesn't have this kind of players, or `1` if it has them. It's achieved thanks to `reverse_nested` aggregation.

- Request

    ```json

    GET /club/_search
    {
        "query": {
            "match_all": {}
        },
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
                    "count_players": {
                    "filter": {
                        "range": {
                        "players.games": {
                            "gte": 30
                        }
                        }
                    },
                    "aggs": {
                        "team_has_players_at_least_30_games": {
                        "reverse_nested": {}
                        }
                    }
                    }
                }
                }
            }
            }
        },
        "size": 0
    }

    ```

- Response

    ```json

    {
        "took" : 12,
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
                    "count_players" : {
                    "doc_count" : 0,
                    "team_has_players_at_least_30_games" : {
                        "doc_count" : 0
                    }
                    }
                }
                },
                {
                "key" : "Team 1",
                "doc_count" : 1,
                "at_least_30_games" : {
                    "doc_count" : 6,
                    "count_players" : {
                    "doc_count" : 2,
                    "team_has_players_at_least_30_games" : {
                        "doc_count" : 1
                    }
                    }
                }
                },
                {
                "key" : "Team 2",
                "doc_count" : 1,
                "at_least_30_games" : {
                    "doc_count" : 6,
                    "count_players" : {
                    "doc_count" : 2,
                    "team_has_players_at_least_30_games" : {
                        "doc_count" : 1
                    }
                    }
                }
                }
            ]
            }
        }
    }

    ```
<!--

### Examples From Elsticsearch Documentation

#### Nested aggregation

- Index data

    Resellers is an array that holds nested documents.

    ```json

    PUT /products
    {
    "mappings": {
        "properties": {
        "resellers": { 
            "type": "nested",
            "properties": {
            "reseller": {
                "type": "keyword"
            },
            "price": {
                "type": "double"
            }
            }
        }
        }
    }
    }

    ```

    Adding a product with two resellers:

    ```json

    PUT /products/_doc/1
    {
    "name": "LED TV",
    "resellers": [
        {
        "reseller": "companyA",
        "price": 350
        },
        {
        "reseller": "companyB",
        "price": 500
        }
    ]
    }

    ```

- Find the minimum price a product can be purchased for.

    ```json

    GET /products/_search
    {
    "query": {
        "match": {
        "name": "led tv"
        }
    },
    "aggs": {
        "resellers": {
        "nested": {
            "path": "resellers"
        },
        "aggs": {
            "min_price": {
            "min": {
                "field": "resellers.price"
            }
            }
        }
        }
    }
    }

    ```

    <details>

    <summary>Rersponse</summary>

    ```json

    {
    "took" : 869,
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
        "max_score" : 0.5753642,
        "hits" : [
        {
            "_index" : "products",
            "_type" : "_doc",
            "_id" : "1",
            "_score" : 0.5753642,
            "_source" : {
            "name" : "LED TV",
            "resellers" : [
                {
                "reseller" : "companyA",
                "price" : 350
                },
                {
                "reseller" : "companyB",
                "price" : 500
                }
            ]
            }
        }
        ]
    },
    "aggregations" : {
        "resellers" : {
        "doc_count" : 2,
        "min_price" : {
            "value" : 350.0
        }
        }
    }
    }

    ```

    </details>

    Use [filter](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/search-aggregations-bucket-filter-aggregation.html) sub-aggregation to return results for a specific reseller.

    ```json

    GET /products/_search
    {
    "query": {
        "match": {
        "name": "led tv"
        }
    },
    "aggs": {
        "resellers": {
        "nested": {
            "path": "resellers"
        },
        "aggs": {
            "filter_resellers": {
            "filter": {
                "bool": {
                "filter": [ 
                    {
                    "term": {
                        "resellers.reseller": "companyB"
                    }
                    }
                ]
                }
            },
            "aggs": {
                "min_price": {
                "min": {
                    "field": "resellers.price"
                }
                }
            }
            }
        }
        }
    }
    }

    ```

    <details>

    <summary>Rersponse</summary>

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
        "value" : 1,
        "relation" : "eq"
        },
        "max_score" : 0.5753642,
        "hits" : [
        {
            "_index" : "products",
            "_type" : "_doc",
            "_id" : "1",
            "_score" : 0.5753642,
            "_source" : {
            "name" : "LED TV",
            "resellers" : [
                {
                "reseller" : "companyA",
                "price" : 350
                },
                {
                "reseller" : "companyB",
                "price" : 500
                }
            ]
            }
        }
        ]
    },
    "aggregations" : {
        "resellers" : {
        "doc_count" : 2,
        "filter_resellers" : {
            "doc_count" : 1,
            "min_price" : {
            "value" : 500.0
            }
        }
        }
    }
    }

    ```

    </details>

#### Reverse nested aggregation

Example, we have an index for a ticket system with issues and comments. The comments are inlined into the issue documents as nested documents.

- Index data

    ```json

    PUT /issues
    {
    "mappings": {
        "properties": {
        "tags": {
            "type": "keyword"
        },
        "comments": {
            "type": "nested",
            "properties": {
            "username": {
                "type": "keyword"
            },
            "comment": {
                "type": "text"
            }
            }
        }
        }
    }
    }

    ```

- Find the top commenters' username that have commented and per top commenter the top tags of the issues the user has commented on.

    ```json

    GET /issues/_search
    {
    "query": {
        "match_all": {}
    },
    "aggs": {
        "comments": {
        "nested": {
            "path": "comments"
        },
        "aggs": {
            "top_usernames": {
            "terms": {
                "field": "comments.username"
            },
            "aggs": {
                "comment_to_issue": {
                "reverse_nested": {}, 
                "aggs": {
                    "top_tags_per_comment": {
                    "terms": {
                        "field": "tags"
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

-->