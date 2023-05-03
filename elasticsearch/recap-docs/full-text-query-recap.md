### Full text queries 

> 
> match query
> 
>> 
>> The standard query for performing full text queries, including fuzzy matching and phrase or proximity queries.
>> 
>> {"query":{"match":{"message":{"query":"this is a test"}}}}
>> 
>
> multi_match query
> 
>> 
>> The multi-field version of the match query.
>> 
>> {"query":{"multi_match":{"query":"this is a test","fields":["subject","message"]}}}
>> 
>
> query_string query
> 
>> 
>> Supports the compact Lucene query string syntax, allowing you to specify AND|OR|NOT conditions and multi-field search within a single query string. For expert users only.
>> 
>> {"query":{"query_string":{"query":"(new york city) OR (big apple)","default_field":"content"}}}
>> 
> 
> match_phrase query
> 
>> 
>> Like the match query but used for matching exact phrases or word proximity matches.
>> 
>> {"query":{"match_phrase":{"message":"this is a test"}}}
>> 
> 
> match_bool_prefix query
> 
> match_phrase_prefix query
> 
> simple_query_string query
> 

##### Example

> 
> ```json
> 
> POST _search
> {
>   "query": {
>     "bool" : {
>       "must" : {
>         "term" : { "user.id" : "kimchy" }
>       },
>       "filter": {
>         "term" : { "tags" : "production" }
>       },
>       "must_not" : {
>         "range" : {
>           "age" : { "gte" : 10, "lte" : 20 }
>         }
>       },
>       "should" : [
>         { "term" : { "tags" : "deployed" } }
>       ],
>       "minimum_should_match" : 1,
>       "boost" : 1.0
>     }
>   }
> }
> 
> ```
> 
