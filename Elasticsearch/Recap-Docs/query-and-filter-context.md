### Query and filter context

> 
> ***Query context***
> 
>> 
>> In the query context, a query clause answers the question `“How well does this document match this query clause?”` 
>> 
>> Query clause calculates a relevance score in the `_score` metadata field.
>> 
> 
> ***Filter context***
> 
>> 
>> In a filter context, a query clause answers the question `“Does this document match this query clause?”` 
>> 
>> The answer is a simple Yes or No — no scores are calculated. 
>>
>> Note: Frequently used filters will be cached automatically by Elasticsearch, to speed up performance.
>> 


