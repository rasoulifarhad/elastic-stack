### Aggregation

The Aggregation Syntax:

> -----
> "aggs”: {
>     “name_of_aggregation”: {
>       “type_of_aggregation”: {
>         “field”: “document_field_name”
> }
> -----

- **aggs:** This keyword shows that you are using an aggregation.

- **name_of_aggregation:**T his is the name of aggregation which the user defines.

- **type_of_aggregation:** This is the type of aggregation being used.

- **field:** This is the field keyword.

- **document_field_name:** This is the column name of the document being targeted.

#### Example

The following example shows the total counts of the “clientip” address in the index “kibana_sample_data_logs.”

GET /kibana_sample_data_logs/_search
{
  "size": 0,
  "aggs": {
    "ip_count": {
      "value_count": {
        "field": "clientip"
      }
    }
  }
}

#### Key Aggregation Types

Aggregations can be divided into four groups: 

- Bucket aggregations—Bucket aggregations are a method of grouping documents. They can be used for grouping or creating data buckets. Buckets can be made on the basis of an existing field, customized filters, ranges, etc.

- Metric aggregations—This aggregation helps in calculating matrices from the fields of aggregated document values.

- Pipeline aggregations—As the name suggests, this aggregation takes input from the output results of other aggregations.

- Matrix aggregations (still in the development phase)—These aggregations work on more than one field and provide statistical results based on the documents utilized by the used fields.

**Some Important Aggregations**

- Cardinality aggregation
- Stats aggregation
- Filter aggregation
- Terms aggregation
- Nested aggregation
