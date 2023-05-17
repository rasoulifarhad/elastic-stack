
<details><summary><i>Show the Person dataset</i></summary>

```json
GET /demo-ingest-person/_search?size=1
```

</details>



<details><summary><i>We have a list of french regions in demo-ingest-regions</i></summary>

```json
GET /demo-ingest-regions/_search?size=1
```

</details>



<details><summary><i> Define an enrich policy. It reads from demo-ingest-regions index And tries to geo match on the location field</i></summary>

```json
PUT /_enrich/policy/demo-ingest-regions-policy
{
  "geo_match": {
    "indices": "demo-ingest-regions",
    "match_field": "location",
    "enrich_fields": [ "region", "name" ]
  }
}
```

</details>

<details><summary><i>We need to execute this policy</i></summary>

```json
POST /_enrich/policy/demo-ingest-regions-policy/_execute
```

</details>


<details><summary><i>Define an ingest pipeline:</i></summary><blockquote>

We can define an ingest pipeline (using the REST API here). It will:
- Enrich the dataset by using our demo-ingest-regions-policy Policy
- Rename the region number and region name fields
- Remove the non needed fields

<details open><summary><i>Ingest pipeline:</i></summary>

```json
PUT /_ingest/pipeline/demo-ingest-enrich
{
  "description": "Enrich French Regions",
  "processors": [
    {
      "enrich": {
        "policy_name": "demo-ingest-regions-policy",
        "field": "geo_location",
        "target_field": "geo_data",
        "shape_relation": "INTERSECTS"
      }
    },
    {
      "rename": {
        "field": "geo_data.region",
        "target_field": "region"
      }
    },
    {
      "rename": {
        "field": "geo_data.name",
        "target_field": "region_name"
      }
    },
    {
      "remove": {
        "field": "geo_data"
      }
    }
  ]
}
```

</details>

</blockquote></details>

<details><summary><i>We can simulate this (optionally with ?verbose)</i></summary>

```json
POST /_ingest/pipeline/demo-ingest-enrich/_simulate
{
  "docs": [
    {
        "_index" : "demo-ingest-person",
        "_type" : "_doc",
        "_id" : "KvRXRngBphqu6E4nbA6w",
        "_score" : 1.0,
        "_source" : {
          "name" : "Gabin William",
          "dateofbirth" : "1969-12-16",
          "country" : "France",
          "geo_location" : "POINT (-1.6160727494218965 47.184827144381984)"
        }
      }
  ]
}
```

</details>

<details><summary><i>We can reindex our existing dataset to enrich it with our pipeline</i></summary>

```json
POST /_reindex
{
  "source": {
    "index": "demo-ingest-person"
  },
  "dest": {
    "index": "demo-ingest-person-new",
    "pipeline": "demo-ingest-enrich"
  }
}
```

</details>

<details><summary><i>Compare the source index and the destination index</i></summary><blockquote>

<details open><summary><i></i></summary>

```json
GET /demo-ingest-person/_search?size=1
```

</details>


<details open><summary><i></i></summary>

```json
GET /demo-ingest-person-new/_search?size=1
{
  "aggs": {
    "regions": {
      "terms": {
        "field": "region_name"
      }
    }
  }
}
```

</details>

</blockquote>