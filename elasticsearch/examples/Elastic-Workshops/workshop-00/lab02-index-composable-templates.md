### Index composable templates

##### Create composable (index) templates

```json
PUT _index_template/orders_template
{
  "index_patterns": [
    "*orders"
  ],
  "priority": 300,
  "template": {
    "mappings": {
      "properties": {
        "order_date": {
          "type": "date",
          "format": "dd-MM-yyyy"
        }
      }
    },
    "settings": {
      "number_of_shards": 5,
      "number_of_replicas": 2
    },
    "aliases": {
      "all_orders": {}
    }
  }
}
```

##### Retrieve persisted template

```json
GET _index_template/orders_template 

{
  "index_templates" : [
    {
      "name" : "orders_template",
      "index_template" : {
        "index_patterns" : [
          "*orders"
        ],
        "template" : {
          "settings" : {
            "index" : {
              "number_of_shards" : "5",
              "number_of_replicas" : "2"
            }
          },
          "mappings" : {
            "properties" : {
              "order_date" : {
                "format" : "dd-MM-yyyy",
                "type" : "date"
              }
            }
          },
          "aliases" : {
            "all_orders" : { }
          }
        },
        "composed_of" : [ ],
        "priority" : 300
      }
    }
  ]
}
```

##### Creating an index with the template

<details open><summary><i>Create index</i></summary><blockquote>

```json
PUT blackfriday_orders
```

<details open><summary><i>Response:</i></summary>

```json
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "blackfriday_orders"
}
``` 

</details>

<blockquote></details>


<details open><summary><i>Get index </i></summary><blockquote>

```json
GET blackfriday_orders
```

<details open><summary><i>Response:</i></summary>

```json
{
  "blackfriday_orders" : {
    "aliases" : {
      "all_orders" : { }
    },
    "mappings" : {
      "properties" : {
        "order_date" : {
          "type" : "date",
          "format" : "dd-MM-yyyy"
        }
      }
    },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "5",
        "provided_name" : "blackfriday_orders",
        "creation_date" : "1681997307416",
        "number_of_replicas" : "2",
        "uuid" : "rbDnFv0yT7qGXqSGi4Yn_w",
        "version" : {
          "created" : "7160299"
        }
      }
    }
  }
}
```

</details>

<blockquote></details>


##### Indices that will successfully inherit the templated configuration

> PUT blackfriday_orders
> 
> PUT americaorders
> 
> PUT cancelled--orders
> 
> PUT undefined101orders
> 

##### Indices will not be inheriting the configuration as the name will not match with the pattern

> PUT blackfriday_orders2
> 
> PUT open_orders_
> 
> PUT allorders_total


##### all the indices derived from a template have the same alias – all_orders – in this case. There is an advantage of having such alias – we can simply query on this single alias rather than multiple indices.

> GET blackfriday_orders,americaorders,undefined101orders/_search
> 

<details open><summary><i>Query on alias </i></summary><blockquote>

```json
GET all_orders/_search
{
  "query": {
    "range": {
      "order_date": {
        "gte": "01-12-2021",
        "lte": "31-12-2021"
      }
    }
  }
}
```

<blockquote></details>

### Creating component templates


##### Settings template

```json
PUT _component_template/settings_component_template
{
  "template": {
    "settings": {
      "number_of_shards": 5, 
      "number_of_replicas": 2
    }
  }
}
```

##### Mappings template

```json
PUT _component_template/mappings_component_template
{
  "template": {
    "mappings": {
      "properties": {
        "order_date": {
          "type": "date",
          "format": ["dd-MM-yyyy"]
        }
      }
    }
  }
}
```

##### Aliases template (orders)

```json
PUT _component_template/aliases_component_template
{
  "template": {
    "aliases": {
      "all_orders": {},
      "sales_orders": {}
    }
  }
}
```

##### Composable index template (orders)

```json
PUT _index_template/composed_orders_template
{
  "index_patterns": [
    "*orders"
  ],
  "priority": 500,
  "composed_of": [
    "settings_component_template",
    "mappings_component_template",
    "aliases_component_template"
  ]
}
```

##### Aliases template (customers)

```json
PUT _component_template/aliases_component_template2
{
  "template": {
    "aliases": {
      "all_customers": {}
    }
  }
}
```

##### Composable index template (customers)

```json
PUT _index_template/composed_customers_template
{
  "index_patterns": [
    "*customers*"
  ],
  "priority": 200,
  "composed_of": [
    "settings_component_template",
    "aliases_component_template2"
  ]
}
```

##### Template priority 

> When you have multiple templates matching the indices that are being created, Elasticsearch applies all the configurations from all matching templates but overrides anything that has higher priority.
> 

```json
PUT _index_template/my_orders_template_1
{
  "index_patterns": ["*orders"],
  "priority": 1000,
  "template": { ... }
}

PUT _index_template/my_orders_template2
{
  "index_patterns": ["*orders"],
  "priority": 300,
  "template": { ... }
}
```

##### Precedence of templates

> ***Does the configuration defined in the component template override the one defined on the main index template itself? Or the other way around? Well, there are some rules:***

>> An index created with configurations explicitly takes precedence over everything – this means if you create an index with explicit configuration, don’t expect them to be overridden by the templates.

>> Legacy templates (templates created before version 7.8) carry a lower priority than the composable templates.


##### Summary

> ***An index contains mappings, settings and aliases: the mappings define the fields schema, settings set the index parameters such as number of shards and replicas, and aliases give alternate names to the index.***

> ***Templates allow us to create indices with predefined configurations. Naming an index with a name that matches the index-pattern defined in a specific template will automatically configure that index according to the template.***

> ***Elasticsearch introduced composable index templates in version 7.8. Composable index templates allow modularity and versioning of templates.***
 
> ***The composable templates consist of none or more component templates.*** 

> ***An index template can have its own configuration defined too.*** 

> ***A component template is a reusable template with predefined configuration, just like a composable index template.*** 

> ***However, component templates are expected to be part of an index template; They are useless if they are not “composed” into an index template.*** 

> ***Component templates have no index pattern defined in them – which is another reason they are “expected” to be part of an index template.***

> ***Each of the templates has a priority – a positive number. The higher the number, the greater the precedence for that template to be applied.***

