### Regex and pattern matching

From [Ingest Pipelines](https://cdax.ch/2022/01/30/elastic-workshop-2-ingest-pipelines/)

#### Preparation

You enable regex by adding the following parameter elasticsearch.yml on every node in the cluster. The cluster needs a restart:

```
script.painless.regex.enabled: true
```

We need to make sure, that your cluster can run regexes. If the following query returns limited or false, you will not be able to run the workshop properly:

```json
GET _cluster/settings?pretty&include_defaults&filter_path=defaults.script.painless.regex

Result:

{
  "defaults" : {
    "script" : {
      "painless" : {
        "regex" : {
          "enabled" : "true",
          "limit-factor" : "6"
        }
      }
    }
  }
}
```

#### Data

```json
PUT companies/_doc/1
{
  "ticker_symbol": "ESTC",
  "market_cap": "8B",
  "share_price": 85.41
}
```

The field “market_cap” is comfortable to read but bad for calculations. With regexes, we will convert this field to a value of long datatype.

#### Regexes

The regex implementation in Painless is the same as in Java. [Documentation](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html)

Matches the “8B” of the “Market_cap” field:

```json
GET companies/_search
{
  "script_fields": {
    "market_cap_factor": {
      "script": {
        "source": """
          long market_cap_factor ;
          if (doc['market_cap.keyword'].value =~ /B$/) {
            market_cap_factor = 1000000000L;
          }
          return(market_cap_factor);
        """ 
      }
    }
  }
}

{
  "took" : 2,
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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "market_cap_factor" : [
            1000000000
          ]
        }
      }
    ]
  }
}
```

The “=~” matches substrings, t’s called the find operator. While the “==~” needs to match the whole string, it’s called the match operator. If we want to use the match operator, the regex would be:

```json
GET companies/_search
{
  "script_fields": {
    "market_cap_factor": {
      "script": {
        "source": """
          long market_cap_factor ;
          if (doc['market_cap.keyword'].value ==~ /^8B$/) {
            market_cap_factor = 1000000000L;
          }
          return(market_cap_factor);
        """ 
      }
    }
  }
}

{
  "took" : 6,
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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "market_cap_factor" : [
            1000000000
          ]
        }
      }
    ]
  }
}
```

#### The Java Matcher Class

The [Java Matcher Class](https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-api-reference-shared-java-util-regex.html) provides everything you need for pattern matching.

```json
GET companies/_search
{
  "query": {
    "match_all": {}
  },
  "script_fields": {
    "match": {
      "script": {
        "source": """
          String market_cap_string = doc['market_cap.keyword'].value;
          Pattern p = /([0-9]+)([A-za-z]+)$/;
          def result = p.matcher(market_cap_string).matches();
          return (result);
        """
      }
    }
  }
}

result:

{
  "took" : 5,
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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "match" : [
            true
          ]
        }
      }
    ]
  }
}
```

```json
GET companies/_search
{
  "query": {
    "match_all": {}
  },
  "script_fields": {
    "match": {
      "script": {
        "source": """
          String market_cap_string = doc['market_cap.keyword'].value;
          Pattern p = /([0-9]+)([A-za-z]+)$/;
          def result = p.matcher(market_cap_string).group(1);
          return (result);
        """
      }
    }
  }
}

{
  "error" : {
    "root_cause" : [
      {
        "type" : "script_exception",
        "reason" : "runtime error",
        "script_stack" : [
          "java.base/java.util.regex.Matcher.group(Matcher.java:644)",
          "result = p.matcher(market_cap_string).group(1);\n          ",
          "                                     ^---- HERE"
        ],
        "script" : " ...",
        "lang" : "painless",
        "position" : {
          "offset" : 168,
          "start" : 131,
          "end" : 189
        }
      }
    ],
    "type" : "search_phase_execution_exception",
    "reason" : "all shards failed",
    "phase" : "query",
    "grouped" : true,
    "failed_shards" : [
      {
        "shard" : 0,
        "index" : "companies",
        "node" : "XcecSOW_R0Ck2HnwBo7rNg",
        "reason" : {
          "type" : "script_exception",
          "reason" : "runtime error",
          "script_stack" : [
            "java.base/java.util.regex.Matcher.group(Matcher.java:644)",
            "result = p.matcher(market_cap_string).group(1);\n          ",
            "                                     ^---- HERE"
          ],
          "script" : " ...",
          "lang" : "painless",
          "position" : {
            "offset" : 168,
            "start" : 131,
            "end" : 189
          },
          "caused_by" : {
            "type" : "illegal_state_exception",
            "reason" : "No match found"
          }
        }
      }
    ]
  },
  "status" : 400
}
```


```json
GET companies/_search
{
  "query": {
    "match_all": {}
  },
  "script_fields": {
    "match": {
      "script": {
        "source": """
          String market_cap_string = doc['market_cap.keyword'].value;
          Pattern p = /([A-za-z]+)$/;
          def result = p.matcher(market_cap_string).replaceAll('');
          return (result);
        """
      }
    }
  }
}

Result:

{
  "took" : 5,
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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "match" : [
            "8"
          ]
        }
      }
    ]
  }
}
```
```json
GET companies/_search
{
  "query": {
    "match_all": {}
  },
  "script_fields": {
    "market_cap_in_billions": {
      "script": {
        "source": """
          String market_cap_string = doc['market_cap.keyword'].value;
          Pattern p = /([0-9]+)([A-za-z]+)$/;
          def market_cap = p.matcher(market_cap_string).replaceAll('$1');
          return (market_cap);
        """
      }
    }
  }
}

Result:

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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "market_cap_in_billions" : [
            "8"
          ]
        }
      }
    ]
  }
}
```

#### String contains() Method

```json
GET companies/_search
{
  "query": {
    "match_all": {}
  },
  "script_fields": {
    "market_cap": {
      "script": {
        "source": """
          long market_cap, mc_long;
          String mc_long_as_string ;
          String market_cap_string = doc['market_cap.keyword'].value;
          if(market_cap_string.contains("B")) {
            mc_long_as_string = market_cap_string.replace('B', '');
            mc_long = (long)Integer.parseInt(mc_long_as_string);
            market_cap = mc_long * 1000000000;
          }
          return (market_cap);
        """
      }
    }
  }
}

Result:

{
  "took" : 7,
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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "market_cap" : [
            8000000000
          ]
        }
      }
    ]
  }
}
```

#### String endWith method

```json
GET companies/_search
{
  "query": {
    "match_all": {}
  },
  "script_fields": {
    "market_cap": {
      "script": {
        "source": """
          long market_cap, mc_long;
          String mc_long_as_string ;
          String market_cap_string = doc['market_cap.keyword'].value;
          if(market_cap_string.endsWith("B")) {
            mc_long_as_string = market_cap_string.replace('B', '');
            mc_long = (long)Integer.parseInt(mc_long_as_string);
            market_cap = mc_long * 1000000000;
          }
          return (market_cap);
        """
      }
    }
  }
}

Result:

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
        "_index" : "companies",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "market_cap" : [
            8000000000
          ]
        }
      }
    ]
  }
}
```
