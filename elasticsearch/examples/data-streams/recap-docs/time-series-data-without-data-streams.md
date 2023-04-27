### Manage time series data without data streams

From [Tutorial: Automate rollover with ILM](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#manage-time-series-data-without-data-streams)

To automate rollover and management of time series indices with ILM using an index alias, you:

1. Create a lifecycle policy that defines the appropriate phases and actions. See [Create a lifecycle policy](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#ilm-gs-create-policy) above.

2. [Create an index template](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#ilm-gs-alias-apply-policy) to apply the policy to each new index.

3. [Bootstrap an index](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#ilm-gs-alias-bootstrap) as the initial write index.

4. [Verify indices are moving through the lifecycle phases](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/getting-started-index-lifecycle-management.html#ilm-gs-alias-check-progress) as expected.

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

#### Create an index template to apply the lifecycle policy

To enable automatic rollover, the template configures two ILM settings:

- index.lifecycle.name specifies the name of the lifecycle policy to apply to new indices that match the index pattern.
- index.lifecycle.rollover_alias specifies the index alias to be rolled over when the rollover action is triggered for an index.

You can use the Kibana Create template wizard to add the template. To access the wizard, open the menu and go to **Stack Management > Index Management**. In the **Index Templates** tab, click **Create template**.

![Create template](create-template-wizard.png)

```json
PUT _index_template/timeseries_template
{
  "index_patterns": ["timeseries-*"],                 
  "template": {
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 1,
      "index.lifecycle.name": "timeseries_policy",      
      "index.lifecycle.rollover_alias": "timeseries"    
    }
  }
}

```

#### Bootstrap the initial time series index with a write index alias

```json

PUT timeseries-000001
{
  "aliases": {
    "timeseries": {
      "is_write_index": true
    }
  }
}

```

#### Check lifecycle progress

```json

GET timeseries-*/_ilm/explain

```

