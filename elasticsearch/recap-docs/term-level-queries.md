### Types of term-level queries

> 
> [***term query***](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-term-query.html)
> 
>> 
>> Returns documents that contain an exact term in a provided field.
>> 
>> `{"query":{"match":{"message":{"query":"this is a test"}}}}`
>> 
>
> ***terms query***
> 
>> 
>> Returns documents that contain one or more exact terms in a provided field.
>> 
>> `{"query":{"multi_match":{"query":"this is a test","fields":["subject","message"]}}}`
>> 
>
> ***range query***
> 
>> 
>> Returns documents that contain terms within a provided range.
>> 
>> `{"query":{"query_string":{"query":"(new york city) OR (big apple)","default_field":"content"}}}`
>> 
> 
> ***exists query***
> 
>> 
>> Returns documents that contain any indexed value for a field.
>> 
>> `{"query":{"match_phrase":{"message":"this is a test"}}}`
>> 
> 
> ***wildcard query***
> 
> ***fuzzy query***
> 
> ***ids query***
> 
> ***prefix query***
> 
> ***regexp query***
> 
> ***type query***
> 
> ***terms_set query***
> 

- [exists query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-exists-query.html)
    Returns documents that contain any indexed value for a field.
- [fuzzy query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-fuzzy-query.html)
    Returns documents that contain terms similar to the search term. Elasticsearch measures similarity, or fuzziness, using a Levenshtein edit distance.
- [ids query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-ids-query.html)
    Returns documents based on their document IDs.
- [prefix query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-prefix-query.html)
    Returns documents that contain a specific prefix in a provided field.
- [range query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-range-query.html)
    Returns documents that contain terms within a provided range.
- [regexp query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-regexp-query.html)
    Returns documents that contain terms matching a regular expression.
- [term query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-term-query.html)
    Returns documents that contain an exact term in a provided field.
- [terms query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-terms-query.html)
    Returns documents that contain one or more exact terms in a provided field.
- [terms_set query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-terms-set-query.html)
    Returns documents that contain a minimum number of exact terms in a provided field. You can define the minimum number of matching  terms using a field or script.
- [type query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-type-query.html)
    Returns documents of the specified type.
- [wildcard query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-wildcard-query.html)
    Returns documents that contain terms matching a wildcard pattern. 
