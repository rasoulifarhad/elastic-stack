### ElasticSearch: Zero to Hero in 12 Commands

From [ElasticSearch: Zero to Hero in 12 Commands](https://dev.to/awscommunity-asean/the-guided-elasticsearch-cheatsheet-you-need-to-get-started-with-es-54f5)

#### Setup the index

In ElasticSearch, we store our data in indexes (similar to tables in your MySQL database). We populate indexes with documents (similar to rows). We will create and set up your first index in the subsequent commands.

1. **Verify the ES cluster is accessible**

> curl -X GET "localhost:9200"

In Dev Tools

> GET /

Result:

> {
>   "name" : "elasticsearch71602",
>   "cluster_name" : "elasticsearch-cluster71602",
>   "cluster_uuid" : "YQeo4JTTQkaNij06HlD_WQ",
>   "version" : {
>     "number" : "7.16.2",
>     "build_flavor" : "default",
>     "build_type" : "docker",
>     "build_hash" : "2b937c44140b6559905130a8650c64dbd0879cfb",
>     "build_date" : "2021-12-18T19:42:46.604893745Z",
>     "build_snapshot" : false,
>     "lucene_version" : "8.10.1",
>     "minimum_wire_compatibility_version" : "6.8.0",
>     "minimum_index_compatibility_version" : "6.0.0-beta1"
>   },
>   "tagline" : "You Know, for Search"
> }

2. **Create an index**

> curl -X PUT "localhost:9200/my-index-000001?pretty"

In Dev Tools

> PUT /my-index-000001

Result:

> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true,
>   "index" : "my-index-000001"
> }

3. **Create the mapping for the index**

The index we just created has no mapping. A mapping is similar to a schema in SQL databases.

> curl -XPUT "http://localhost:9200/my-index-000001/_mapping" -H 'Content-Type: application/json' -d'
> {
>     "properties": {
>         "product_id": {
>             "type": "keyword"
>         },
>         "price": {
>             "type": "float"
>         },
>         "stocks": {
>             "type": "integer"
>         },
>         "published": {
>             "type": "boolean"
>         },
>         "title": {
>             "type": "text"
>         },
>         "sortable_title": {
>             "type": "text"
>         },
>         "tags": {
>             "type": "text"
>         }
>     }
> }'

In Dev Tools

> PUT /my-index-000001/_mapping
> {
>     "properties": {
>         "product_id": {
>             "type": "keyword"
>         },
>         "price": {
>             "type": "float"
>         },
>         "stocks": {
>             "type": "integer"
>         },
>         "published": {
>             "type": "boolean"
>         },
>         "title": {
>             "type": "text"
>         },
>         "sortable_title": {
>             "type": "text"
>         },
>         "tags": {
>             "type": "text"
>         }
>     }
> }
> 
Result: 

> {"acknowledged":true}

4. **Show the mapping of the index**

> curl -XGET "http://localhost:9200/my-index-000001/_mapping?pretty"

In Dev Tools

> GET /my-index-000001/_mapping?pretty

Result:

> {
>   "my-index-000001" : {
>     "mappings" : {
>       "properties" : {
>         "price" : {
>           "type" : "float"
>         },
>         "product_id" : {
>           "type" : "keyword"
>         },
>         "published" : {
>           "type" : "boolean"
>         },
>         "sortable_title" : {
>           "type" : "text"
>         },
>         "stocks" : {
>           "type" : "integer"
>         },
>         "tags" : {
>           "type" : "text"
>         },
>         "title" : {
>           "type" : "text"
>         }
>       }
>     }
>   }
> }

#### Data Operations with our ES Index

5. **Create data for the index**

> curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
> {
>   "product_id": "123",
>   "price": 99.75,
>   "stocks": 10,
>   "published": true,
>   "sortable_title": "Kenny Rogers Chicken Sauce",
>   "title": "Kenny Rogers Chicken Sauce",
>   "tags": "chicken sauce poultry cooked party"
> }'

Result:

> {
>   "_index" : "my-index-000001",
>   "_type" : "_doc",
>   "_id" : "i7kVdocBfrudywCYQDSY",
>   "_version" : 1,
>   "result" : "created",
>   "_shards" : {
>     "total" : 2,
>     "successful" : 1,
>     "failed" : 0
>   },
>   "_seq_no" : 1,
>   "_primary_term" : 1
> }

> curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
> {
>   "product_id": "456",
>   "price": 200.75,
>   "stocks": 0,
>   "published": true,
>   "sortable_title": "Best Selling Beer Flavor",
>   "title": "Best Selling Beer Flavor",
>   "tags": "beer best-seller party"
> }'

Result: 

> {
>   "_index" : "my-index-000001",
>   "_type" : "_doc",
>   "_id" : "jLkVdocBfrudywCY2jR4",
>   "_version" : 1,
>   "result" : "created",
>   "_shards" : {
>     "total" : 2,
>     "successful" : 1,
>     "failed" : 0
>   },
>   "_seq_no" : 1,
>   "_primary_term" : 1
> }


> curl -XPOST "http://localhost:9200/my-index-000001/_doc?pretty" -H 'Content-Type: application/json' -d'
> {
>   "product_id": "789",
>   "price": 350.5,
>   "stocks": 200,
>   "published": false,
>   "sortable_title": "Female Lotion",
>   "title": "Female Lotion",
>   "tags": "lotion female"  
> }'

Result: 

> {
>   "_index" : "my-index-000001",
>   "_type" : "_doc",
>   "_id" : "jbkXdocBfrudywCYwjQ7",
>   "_version" : 1,
>   "result" : "created",
>   "_shards" : {
>     "total" : 2,
>     "successful" : 1,
>     "failed" : 0
>   },
>   "_seq_no" : 2,
>   "_primary_term" : 1
> }

In Dev Tools

> POST /my-index-000001/_doc
> {
>   "product_id": "123",
>   "price": 99.75,
>   "stocks": 10,
>   "published": true,
>   "sortable_title": "Kenny Rogers Chicken Sauce",
>   "title": "Kenny Rogers Chicken Sauce",
>   "tags": "chicken sauce poultry cooked party"
> }

> POST /my-index-000001/_doc
> {
>   "product_id": "456",
>   "price": 200.75,
>   "stocks": 0,
>   "published": true,
>   "sortable_title": "Best Selling Beer Flavor",
>   "title": "Best Selling Beer Flavor",
>   "tags": "beer best-seller party"
> }

> POST /my-index-000001/_doc
> {
>   "product_id": "789",
>   "price": 350.5,
>   "stocks": 200,
>   "published": false,
>   "sortable_title": "Female Lotion",
>   "title": "Female Lotion",
>   "tags": "lotion female"  
> }

6. **Display all the data**

> curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
> {
>   "query": {
>     "match_all": {}
>   }
> }'

In Dev Tools

> POST /my-index-000001/_search
> {
>   "query": {
>     "match_all": {}
>   }
> }

7. **Exact search with product id**

> curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
> {
>   "query": {
>     "term": {
>       "product_id": "456"
>     }
>   }
> }'

In Dev Tools

> POST /my-index-000001/_search
> {
>   "query": {
>     "term": {
>       "product_id": "456"
>     }
>   }
> }

Result: 

> {
>   "took" : 0,
>   "timed_out" : false,
>   "_shards" : {
>     "total" : 1,
>     "successful" : 1,
>     "skipped" : 0,
>     "failed" : 0
>   },
>   "hits" : {
>     "total" : {
>       "value" : 1,
>       "relation" : "eq"
>     },
>     "max_score" : 0.9808291,
>     "hits" : [
>       {
>         "_index" : "my-index-000001",
>         "_type" : "_doc",
>         "_id" : "jLkVdocBfrudywCY2jR4",
>         "_score" : 0.9808291,
>         "_source" : {
>           "product_id" : "456",
>           "price" : 200.75,
>           "stocks" : 0,
>           "published" : true,
>           "sortable_title" : "Best Selling Beer Flavor",
>           "title" : "Best Selling Beer Flavor",
>           "tags" : "beer best-seller party"
>         }
>       }
>     ]
>   }
> }

8. **Fuzzy search with titles**

Fuzzy searches allow us to search for products by typing just a few words instead of the whole text of the field. Instead of typing the full name of the product name (i.e Incredible Tuna Mayo Jumbo 250), the customer just instead has to search for the part he recalls of the product (i.e Tuna Mayo).

> curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
> {
>   "query": {
>     "match": {
>       "title": "Beer Flavor"
>     }
>   }
> }'

In Dev Tools:

> POST /my-index-000001/_search
> {
>   "query": {
>     "match": {
>       "title": "Beer Flavor"
>     }
>   }
> }

Result:

> {
>   "took" : 2,
>   "timed_out" : false,
>   "_shards" : {
>     "total" : 1,
>     "successful" : 1,
>     "skipped" : 0,
>     "failed" : 0
>   },
>   "hits" : {
>     "total" : {
>       "value" : 1,
>       "relation" : "eq"
>     },
>     "max_score" : 1.8132977,
>     "hits" : [
>       {
>         "_index" : "my-index-000001",
>         "_type" : "_doc",
>         "_id" : "jLkVdocBfrudywCY2jR4",
>         "_score" : 1.8132977,
>         "_source" : {
>           "product_id" : "456",
>           "price" : 200.75,
>           "stocks" : 0,
>           "published" : true,
>           "sortable_title" : "Best Selling Beer Flavor",
>           "title" : "Best Selling Beer Flavor",
>           "tags" : "beer best-seller party"
>         }
>       }
>     ]
>   }
> }

In the default setting, we can get the product "Best Selling Beer Flavor" even with our incomplete query "Beer Flavor". There are other settings that allow us to tolerate misspellings or incomplete words to show results (i.e Bee Flavo)

9. **Sorted by prices**

> curl -XPOST "http://localhost:9200/my-index-000001/_search?pretty" -H 'Content-Type: application/json' -d'
> {
>   "query": {
>     "match_all": {}
>   },
>   "sort": [
>     {
>       "price": {
>         "order": "desc"
>       }
>     },
>     "_score"
>   ]
> }'

In Dev Tools

> POST /my-index-000001/_search
> {
>   "query": {
>     "match_all": {}
>   },
>   "sort": [
>     {
>       "price": {
>         "order": "desc"
>       }
>     },
>     "_score"
>   ]
> }

Result:

> {
>   "took" : 1,
>   "timed_out" : false,
>   "_shards" : {
>     "total" : 1,
>     "successful" : 1,
>     "skipped" : 0,
>     "failed" : 0
>   },
>   "hits" : {
>     "total" : {
>       "value" : 3,
>       "relation" : "eq"
>     },
>     "max_score" : null,
>     "hits" : [
>       {
>         "_index" : "my-index-000001",
>         "_type" : "_doc",
>         "_id" : "jbkXdocBfrudywCYwjQ7",
>         "_score" : 1.0,
>         "_source" : {
>           "product_id" : "789",
>           "price" : 350.5,
>           "stocks" : 200,
>           "published" : false,
>           "sortable_title" : "Female Lotion",
>           "title" : "Female Lotion",
>           "tags" : "lotion female"
>         },
>         "sort" : [
>           350.5,
>           1.0
>         ]
>       },
>       {
>         "_index" : "my-index-000001",
>         "_type" : "_doc",
>         "_id" : "jLkVdocBfrudywCY2jR4",
>         "_score" : 1.0,
>         "_source" : {
>           "product_id" : "456",
>           "price" : 200.75,
>           "stocks" : 0,
>           "published" : true,
>           "sortable_title" : "Best Selling Beer Flavor",
>           "title" : "Best Selling Beer Flavor",
>           "tags" : "beer best-seller party"
>         },
>         "sort" : [
>           200.75,
>           1.0
>         ]
>       },
>       {
>         "_index" : "my-index-000001",
>         "_type" : "_doc",
>         "_id" : "i7kVdocBfrudywCYQDSY",
>         "_score" : 1.0,
>         "_source" : {
>           "product_id" : "123",
>           "price" : 99.75,
>           "stocks" : 10,
>           "published" : true,
>           "sortable_title" : "Kenny Rogers Chicken Sauce",
>           "title" : "Kenny Rogers Chicken Sauce",
>           "tags" : "chicken sauce poultry cooked party"
>         },
>         "sort" : [
>           99.75,
>           1.0
>         ]
>       }
>     ]
>   }
> }

10. **Search for all "beer" products that are PUBLISHED, and in stock. Sorted by cheapest to most expensive**

11. **Search for all products that have at least 1 of the following tags ['poultry, 'kampai', 'best-seller'], that are PUBLISHED, and in stock. Sorted by cheapest to most expensive**

12. **Search for all products that have at least 1 of the following tags ['poultry, 'kampai', 'best-seller'], and in stock. The price should be between 0 to 300 only. Sorted by cheapest to most expensive**

