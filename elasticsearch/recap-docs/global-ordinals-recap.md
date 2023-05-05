### Global Ordinals

***Cardinality***
> 
> ***Cardinality refers to the uniqueness of values stored in a particular field.***
>> High cardinality means that a field contains a large percentage of unique values.
>>
>> ***Low cardinality means that a field contains a lot of repeated values.*** 
>>

***Elasticsearch refresh interval***

> As documents are inserted into Elasticsearch, they are written into a buffer and then periodically flushed from that buffer into `segments`. This flush operation is known as a `refresh`, and newly inserted documents are only searchable after a refresh. By default refreshes occur every second, however the refresh interval is configurable.
> 

>  ***Elasticsearch merges small segments into larger segments, and those larger segments are merged into even larger segments, and so on.*** 
> 

> To support aggregations and other operations that require looking up field values on a per-document basis, Elasticsearch uses a data structure called [doc values](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/doc-values.html).
> 

> ***Term-based field types such as `keyword` store their doc values using an ordinal mapping for a more compact representation. This mapping works by assigning each term an incremental integer or ordinal based on its lexicographic order. The field’s doc values store only the ordinals for each document instead of the original terms, with a separate lookup structure to convert between ordinals and terms.***
> 

***Global ordinals***

>  Global ordinals is a data-structure that maintains an incremental numbering for each unique term for a given field. 
>> ***Global ordinals are computed on each shard.***
>>

>> Terms aggregations will rely purely on those global ordinals to efficiently perform the aggregation at the shard level. 
>>

>> ***Global ordinals are then converted  to the real term for the final reduce phase, which combines results from different shards.***
>>
 
>> If a shard is modified, then new global ordinals will need to be calculated for that shard.
>> 

***Global ordinals work by precomputing unique terms into an ordinal mapping, which essentially are two tables.***

> The first, assigns a numeric value to each unique term
> 
> ***The second assigns a numeric value, corresponding to the value assigned in the first table, to the document id of the term.*** 
> 

***Example***

> ***Create product index***
>> `PUT /products {"mappings":{"properties":{"brand":{"type":"keyword"}}}}`

> ***Inserting three doc intp the index***
>> `{"name":"Iphone","brand":"Apple"}`
>>
>> `{"name":"Macbook Pro","brand":"Apple"}`
>> 
>> `{"name":"Samsung Galaxy","brand":"Samsung"}`

> ***The first table created by the ordinal mapping assigns a numeric value to each unique term.***

>> | Ordinal |  Term   |
>> | --------| --------|
>> | 0       | Apple   |
>> | 1       | Samsung |
>> 

> ***The second table assigned the numeric value to the term in each document.***

>> | Doc     |  Ordinal |
>> | --------| ---------|
>> | N       | 0        |
>> | N + 1   | 0        |
>> | N + 2   | 1        |   
>> 

***Example***

Imagine that we have a billion documents, each of which has a `status` field. There are only three statuses: `status_pending`, `status_published`, `status_deleted`. If we were to hold the full string status in memory for every document, we would use 14 to 16 bytes per document, or about 15 GB. 

> ***Instead, we can identify the three unique strings, sort them, and number them: 0, 1, 2.*** 

>> | Ordinal  | Term            |  
>> | -------- | --------------  |  
>> | 0        | status_deleted  |   
>> | 1        | status_pending  |  
>> | 2        | status_published|  
>> |          |                 |   

> ***The original strings are stored only once in the ordinals list, and each document just uses the numbered ordinal to point to the value that it contains.*** 

>> Doc     | Ordinal  
>> --------|----------------  
>> 0       | 1  # pending  
>> 1       | 1  # pending  
>> 2       | 2  # published  
>> 3       | 0  # deleted  
>>  


> ***This reduces memory usage from 15 GB to less than 1 GB!***
> 



