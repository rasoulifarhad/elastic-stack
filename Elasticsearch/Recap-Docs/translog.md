### Translog

> Changes to Lucene are only persisted to disk during a ***Lucene commit***.


> In elasticsearch each shard copy also writes operations into its ***transaction log*** known as the `translog`.(Index and delete operations) 
> 
>> ***After being processed by the internal Lucene index but before they are acknowledged.***
 

> Operations that have been acknowledged but not yet included in the last Lucene commit are instead ***recovered from the translog when the shard recovers***. 


> An Elasticsearch [flush](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/indices-flush.html) is the process of performing a ***Lucene commit*** and starting a new ***translog*** generation.
> 
> ***Translog is persisted to disk when `fsynced` and committed***. 
> 

**Note**:
> 
> By default, `index.translog.durability` is set to `request` meaning that Elasticsearch will only report success of an index, delete, update, or bulk request to the client after the translog has been successfully `fsync`ed and committed on the primary and on every allocated replica. If `index.translog.durability` is set to `async` then Elasticsearch `fsync`s and commits the translog only every `index.translog.sync_interval` which means that any operations that were performed just before a crash may be lost when the node recovers.
> 


**Making Changes Persistent**

***1. New documents are added to the in-memory buffer and appended to the transaction log***

![New documents are added to the in-memory buffer and appended to the transaction log](images/translog-01.png)

***2. After a refresh, the buffer is cleared but the transaction log is not***

![After a refresh, the buffer is cleared but the transaction log is not](images/translog-02.png)

***3. The transaction log keeps accumulating documents***

![The transaction log keeps accumulating documents](images/translog-03.png)

***4. After a flush, the segments are fully commited and the transaction log is cleared***

![After a flush, the segments are fully commited and the transaction log is cleared](images/translog-04.png)

**Translog settings**
> 
> ***index.translog.sync_interval***
> 
> ***index.translog.durability***
> 
>> *request* (default)
>> 
>> *async*
> 
> ***index.translog.flush_threshold_size***
> 

***Example***

> PUT /my-index-000001/_settings `{"index":{"translog":{"durability":"async"}}}`
>
> PUT /my-index-000001/_settings `{"index.translog.durability":"request"}
`
<!--

```json
PUT /my_index/_settings
{
    "index.translog.durability": "async",
    "index.translog.sync_interval": "5s"
}
```

***Flush API***

> POST /<target>/_flush
> 
> GET /<target>/_flush
> 
> POST /_flush
> 
> GET /_flush

-->
