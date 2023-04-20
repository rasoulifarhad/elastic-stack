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
