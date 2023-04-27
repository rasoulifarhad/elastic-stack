### Data stream

[FROM](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#ilm-gs-create-policy)

To automate rollover and management of a data stream with ILM, you:

1. [Create a lifecycle policy](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#ilm-gs-create-policy) that defines the appropriate phases and actions.

2. [Create an index template](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#ilm-gs-apply-policy) to create the data stream and apply the ILM policy and the indices settings and mappings configurations for the backing indices.

3. [Verify indices are moving through the lifecycle phases](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#ilm-gs-check-progress) as expected.


#### Create a lifecycle policy

You can create the policy through Kibana or with the []create or update policy API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/ilm-put-lifecycle.html). 
To create the policy from Kibana, open the menu and go to **Stack Management > Index Lifecycle Policies**. Click **Create policy**.

![Create policy](create-policy.png)

```json

PUT _ilm/policy/timeseries_policy
{
  "policy": {
    "phases": {
      "hot": {                                
        "actions": {
          "rollover": {
            "max_primary_shard_size": "50GB", 
            "max_age": "30d"
          }
        }
      },
      "delete": {
        "min_age": "90d",                     
        "actions": {
          "delete": {}                        
        }
      }
    }
  }
}

```

#### Create an index template to create the data stream and apply the lifecycle policy

To enable the ILM to manage the data stream, the template configures one ILM setting:

- index.lifecycle.name specifies the name of the lifecycle policy to apply to the data stream.

You can use the Kibana Create template wizard to add the template. From Kibana, open the menu and go to **Stack Management > Index Management** . In the **Index Templates** tab, click **Create template**.

![Create template](create-index-template.png)

```json

PUT _index_template/timeseries_template
{
  "index_patterns": ["timeseries"],                   
  "data_stream": { },
  "template": {
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 1,
      "index.lifecycle.name": "timeseries_policy"     
    }
  }
}

```

#### Create the data stream

```json

POST timeseries/_doc
{
  "message": "logged the request",
  "@timestamp": "1591890611"
}

```

#### Check lifecycle progress

his lets you find out things like:

- What phase an index is in and when it entered that phase.
- The current action and what step is being performed.
- If any errors have occurred or progress is blocked.

```json

GET .ds-timeseries-*/_ilm/explain

```

