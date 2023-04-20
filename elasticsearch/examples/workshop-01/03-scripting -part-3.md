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

The regex implementation in Painless is the same as in Java.[Documentation](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html)
