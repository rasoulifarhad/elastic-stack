#### Map a runtime fieldedit

You map runtime fields by adding a runtime section under the mapping definition and defining a Painless script. This script has access to the entire context of a document, including the original _source and any mapped fields plus their values. At query time, the script runs and generates values for each scripted field that is required for the query.
```markdown
PUT my-index-000001/
{
  "mappings": {
    "runtime": {
      "day_of_week": {
        "type": "keyword",
        "script": {
          "source": "emit(doc['@timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.FULL, Locale.ROOT))"
        }
      }
    },
    "properties": {
      "@timestamp": {"type": "date"}
    }
  }
}
```
The runtime section can be any of these data types:

- boolean
- composite
- date
- double
- geo_point
- ip
- keyword
- long

#### Define runtime fields without a scriptedit
```markdown
PUT my-index-000001/
{
  "mappings": {
    "runtime": {
      "day_of_week": {
        "type": "keyword"
      }
    }
  }
}
```
When no script is provided, Elasticsearch implicitly looks in _source at query time for a field with the same name as the runtime field, and returns a value if one exists. If a field with the same name doesn’t exist, the response doesn’t include any values for that runtime field.

In most cases, retrieve field values through doc_values whenever possible. Accessing doc_values with a runtime field is faster than retrieving values from _source because of how data is loaded from Lucene.

#### Ignoring script errors on runtime fieldsedit

Scripts can throw errors at runtime, e.g. on accessing missing or invalid values in documents or because of performing invalid operations. The on_script_error parameter can be used to control error behaviour when this happens. Setting this parameter to continue will have the effect of silently ignoring all errors on this runtime field. The default fail value will cause a shard failure which gets reported in the search response.

#### Updating and removing runtime fieldsedit
```markdown
PUT my-index-000001/_mapping
{
 "runtime": {
   "day_of_week": null
 }
}
```
#### Define runtime fields in a search request
```markdown
GET my-index-000001/_search
{
  "runtime_mappings": {
    "day_of_week": {
      "type": "keyword",
      "script": {
        "source": "emit(doc['@timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.FULL, Locale.ROOT))"
      }
    }
  },
  "aggs": {
    "day_of_week": {
      "terms": {
        "field": "day_of_week"
      }
    }
  }
}
```
#### Retrieve a runtime field

Use the fields parameter on the _search API to retrieve the values of runtime fields. Runtime fields won’t display in _source, but the fields API works for all fields, even those that were not sent as part of the original _source.

**Define a runtime field to calculate the day of week**

For example, the following request adds a runtime field called day_of_week. The runtime field includes a script that calculates the day of the week based on the value of the @timestamp field. We’ll include "dynamic":"runtime" in the request so that new fields are added to the mapping as runtime fields.
```markdown
PUT my-index-000001/
{
  "mappings": {
    "dynamic": "runtime",
    "runtime": {
      "day_of_week": {
        "type": "keyword",
        "script": {
          "source": "emit(doc['@timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.FULL, Locale.ROOT))"
        }
      }
    },
    "properties": {
      "@timestamp": {"type": "date"}
    }
  }
}
```
#### Index a runtime fieldedit

Runtime fields are defined by the context where they run. For example, you can define runtime fields in the context of a search query or within the runtime section of an index mapping. If you decide to index a runtime field for greater performance, just move the full runtime field definition (including the script) to the context of an index mapping. Elasticsearch automatically uses these indexed fields to drive queries, resulting in a fast response time. This capability means you can write a script only once, and apply it to any context that supports runtime fields.
