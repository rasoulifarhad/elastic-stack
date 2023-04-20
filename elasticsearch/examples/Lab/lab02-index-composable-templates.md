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

```json
PUT blackfriday_orders

{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "blackfriday_orders"
}

``` 

```json
GET blackfriday_orders

Result:

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

##### Indices that will successfully inherit the templated configuration

```json

PUT blackfriday_orders

PUT americaorders

PUT cancelled--orders

PUT undefined101orders

```

##### Indices will not be inheriting the configuration as the name will not match with the pattern

```json

PUT blackfriday_orders2

PUT open_orders_

PUT allorders_total

```

##### all the indices derived from a template have the same alias – all_orders – in this case. There is an advantage of having such alias – we can simply query on this single alias rather than multiple indices.

```json

GET blackfriday_orders,americaorders,undefined101orders/_search

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
