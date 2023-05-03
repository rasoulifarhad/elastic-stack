### Full text queries 

> 
> ***match query***
> 
>> 
>> The standard query for performing full text queries, including fuzzy matching and phrase or proximity queries.
>> 
>> `{"query":{"match":{"message":{"query":"this is a test"}}}}`
>> 
>
> ***multi_match query***
> 
>> 
>> The multi-field version of the match query.
>> 
>> `{"query":{"multi_match":{"query":"this is a test","fields":["subject","message"]}}}`
>> 
>
> ***query_string query***
> 
>> 
>> Supports the compact Lucene query string syntax, allowing you to specify AND|OR|NOT conditions and multi-field search within a single query string. For expert users only.
>> 
>> `{"query":{"query_string":{"query":"(new york city) OR (big apple)","default_field":"content"}}}`
>> 
> 
> ***match_phrase query***
> 
>> 
>> Like the match query but used for matching exact phrases or word proximity matches.
>> 
>> `{"query":{"match_phrase":{"message":"this is a test"}}}`
>> 
> 
> ***match_phrase_prefix query***
> 
>> 
>> Like the match_phrase query, but does a wildcard search on the final word.
>> 
>> `{"query":{"match_phrase_prefix":{"message":{"query":"quick brown f"}}}}`
>> 
> 
> ***simple_query_string query***
> 
> ***match_bool_prefix query***
> 

### Match all and Match none  

> 
> [***match_all*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-match-all-query.html)
> 
>> 
>> The most simple query, which matches all documents, giving them all a `_score` of `1.0`.
>> 
>> `{"query":{"match_all":{}}}`
>> 
>
> [***match_none*** query](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl-match-all-query.html)
> 
>> 
>> This is the inverse of the match_all query, which matches no documents.
>> 
>> `{"query":{"match_none":{}}}`
>> 

