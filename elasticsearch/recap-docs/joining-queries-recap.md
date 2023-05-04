### Joining queries

> See [Joining queries](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/joining-queries.html#joining-queries)
> 

Elasticsearch offers two forms of join:

> 
> [***nested*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-nested-query.html)
> 
>> 
>> Documents may contain fields of type [nested](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/nested.html). These fields are used to index arrays of objects.
>> 
>> Each object can be queried (with the nested query) as an independent document.
>> 
>> ***Index setup*** `{"mappings":{"properties":{"obj1":{"type":"nested"}}}}`
>> 
>> ***Example query*** `{"query":{"nested":{"path":"obj1","query":{"bool":{"must":[{"match":{"obj1.name":"blue"}}]}}}}}	`
>> 
>
> [***has_child***](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-has-child-query.html) **and** [***has_parent***](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-has-parent-query.html) **queries**
> 
>> 
>> A [***join*** field relationship](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/parent-join.html) can exist between documents within a single index. 
>> 
>> The `has_child` query returns parent documents whose child documents match the specified query,
>> 
>> ***Index setup*** `{"mappings":{"properties":{"my-join-field":{"type":"join","relations":{"parent":"child"}}}}}`
>> 
>> ***Example query*** `{"query":{"has_child":{"type":"child","query":{"match_all":{}},"max_children":10,"min_children":2,"score_mode":"min"}}}`
>>
>> The `has_parent` query returns child documents whose parent document matches the specified query.
>> 
>> ***Index setup*** `{"mappings":{"properties":{"my-join-field":{"type":"join","relations":{"parent":"child"}},"tag":{"type":"keyword"}}}}`
>> 
>> ***Example query*** `{"query":{"has_parent":{"parent_type":"parent","query":{"term":{"tag":{"value":"Elasticsearch"}}}}}}`
>> 

> 
> See the [terms-lookup mechanism](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-terms-query.html#query-dsl-terms-lookup) in the terms query, which allows you to build a terms query from values contained in another document.
> 

