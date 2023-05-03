### Boolean query 

> 
> ***must***
> 
>> 
>> The clause (query) must appear in matching documents and will contribute to the score.
>> 
> 
> ***filter***
> 
>> 
>> The clause (query) must appear in matching documents.
>> 
>>  Filter clauses are executed in filter context, meaning that scoring is ignored and clauses are considered for caching.
>>
>
> ***should***
> 
>> 
>> The clause (query) should appear in the matching document. 
>> 
>> Clauses are executed in `filter context` meaning that scoring is ignored and clauses are considered for caching.
>> 
>
> ***must_not***
> 
>> 
>> The clause (query) must not appear in the matching documents. 
>> 
>

**Note:** 

> 
> The bool query takes a `more-matches-is-better` approach, so the score from each matching must or should clause will be added together to provide the final _score for each document.
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
