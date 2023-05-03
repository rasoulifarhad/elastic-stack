### Types of term-level queries

> 
> [***term*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-term-query.html)
> 
>> 
>> Returns documents that contain an exact term in a provided field.
>> 
>> `{"query":{"term":{"user.id":{"value":"kimchy","boost":1}}}}`
>> 
>
> [***terms*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-terms-query.html)
> 
>> 
>> Returns documents that contain one or more exact terms in a provided field.
>> 
>> `{"query":{"terms":{"user.id":["kimchy","elkbee"],"boost":1}}}`
>> 
>
> [***range*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-range-query.html)
> 
>> 
>> Returns documents that contain terms within a provided range.
>> 
>> `{"query":{"range":{"age":{"gte":10,"lte":20,"boost":2}}}}`
>> 
> 
> [***exists*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-exists-query.html)
> 
>> 
>> Returns documents that contain any indexed value for a field.
>> 
>> `{"query":{"exists":{"field":"user"}}}`
>> 
>> `{"query":{"bool":{"must_not":{"exists":{"field":"user.id"}}}}}`
>> 

<!--

> 
> [***wildcard*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-wildcard-query.html)
> 
> [***fuzzy*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-fuzzy-query.html)
> 
> [***ids*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-ids-query.html)
> 
> [***prefix*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-prefix-query.html)
> 
> [***regexp*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-regexp-query.html)
> 
> [***type*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-type-query.html)
> 
> [***terms_set*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-terms-set-query.html)
> 

-->
