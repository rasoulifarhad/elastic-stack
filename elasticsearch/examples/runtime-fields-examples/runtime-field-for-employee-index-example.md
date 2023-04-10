
1. Creating sample employee index:

> PUT employee
> {
>   "mappings": {
>     "dynamic": "runtime",
>     "properties": {
>       "name": {
>         "type": "text",
>         "fields": {
>           "raw": {
>             "type": "keyword"
>           }
>         }
>       },
>       "dob": {
>         "type": "date",
>         "format": "yyyy-MM-dd"
>       }
>     }
>   }
> }

2. Check the employee mapping

> GET employee/_mapping

3.  Insert a couple of sample documents into the employee index.

> PUT employee/_doc/1
> {
>   "name":"Kiran Sangita",
>   "dob":"1980-04-01",
>   "fullname":"kiran appaji sangita",
>   "age":"45"
> }

> PUT employee/_doc/2
> {
>   "name":"Kartheek Gummaluri",
>   "dob":"1991-12-28",
>   "fullname":"Sai Srinivasa Kartheek Gummaluri",
>   "age":"29"
> }

> PUT employee/_doc/3
> {
>   "name":"Pavan Kumar",
>   "dob":"1980-12-28",
>   "fullname":"Pavan Arya",
>   "age":"34"
> }

4. check mapping again and we will see age, full name as runtime fields.

> GET employee/_mapping
> 
> {
>   "employee" : {
>     "mappings" : {
>       "dynamic" : "runtime",
>       "runtime" : {
>         "age" : {
>           "type" : "keyword"
>         },
>         "fullname" : {
>           "type" : "keyword"
>         }
>       },
>       "properties" : {
>         "dob" : {
>           "type" : "date",
>           "format" : "yyyy-MM-dd"
>         },
>         "name" : {
>           "type" : "text",
>           "fields" : {
>             "raw" : {
>               "type" : "keyword"
>             }
>           }
>         }
>       }
>     }
>   }
> }

5.  Write a small query to search documents having an age greater than 29.

> GET employee/_search
> {
>   "query": {
>     "range": {
>       "age": {
>         "gt": 29
>       }
>     }
>   }
> }

Result: 

> {
>   "took" : 884,
>   "timed_out" : false,
>   "_shards" : {
>     "total" : 1,
>     "successful" : 1,
>     "skipped" : 0,
>     "failed" : 0
>   },
>   "hits" : {
>     "total" : {
>       "value" : 2,
>       "relation" : "eq"
>     },
>     "max_score" : 1.0,
>     "hits" : [
>       {
>         "_index" : "employee",
>         "_type" : "_doc",
>         "_id" : "1",
>         "_score" : 1.0,
>         "_source" : {
>           "name" : "Kiran Sangita",
>           "dob" : "1980-04-01",
>           "fullname" : "kiran appaji sangita",
>           "age" : "45"
>         }
>       },
>       {
>         "_index" : "employee",
>         "_type" : "_doc",
>         "_id" : "3",
>         "_score" : 1.0,
>         "_source" : {
>           "name" : "Pavan Kumar",
>           "dob" : "1980-12-28",
>           "fullname" : "Pavan Arya",
>           "age" : "34"
>         }
>       }
>     ]
>   }
> }

6. Create the concatenation of two fields with a static string as follows:

> GET employee/_search
> {
>   "runtime_mappings": {
>     "concatenated_field": {
>       "type": "keyword",
>       "script": {
>         "source": "emit(doc['fullname'].value + '_' +  doc['age'].value.toString())"
>       }
>     }
>   },
>   "fields": [
>     "concatenated_field"
>   ],
>   "query": {
>     "match": {
>       "concatenated_field": "kiran appaji sangita_45"
>     }
>   }
> }

Result: 

> {
>   "took" : 123,
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
>     "max_score" : 1.0,
>     "hits" : [
>       {
>         "_index" : "employee",
>         "_type" : "_doc",
>         "_id" : "1",
>         "_score" : 1.0,
>         "_source" : {
>           "name" : "Kiran Sangita",
>           "dob" : "1980-04-01",
>           "fullname" : "kiran appaji sangita",
>           "age" : "45"
>         },
>         "fields" : {
>           "concatenated_field" : [
>             "kiran appaji sangita_45"
>           ]
>         }
>       }
>     ]
>   }
> }

**Note:** 

If we find that concatenated_field is a field that we want to use in multiple queries without having to define it per query, we can simply add it to the mapping by making the call:

> PUT employee/_mapping
> {
>   "runtime": {
>     "concatenated_field": {
>       "type": "keyword",
>        "script": {
>        "source": "emit(doc['fullname'].value + '_' +  doc['age'].value.toString())"
>      }
>     } 
>   } 
> }

Now we will again check the mappings of the employee index, this time you will see concatenated_field will be added in the mapping.

**Output**

> {
>   "employee" : {
>     "mappings" : {
>       "dynamic" : "runtime",
>       "runtime" : {
>         "age" : {
>           "type" : "keyword"
>         },
>         "concatenated_field" : {
>           "type" : "keyword",
>           "script" : {
>             "source" : "emit(doc['fullname'].value + '_' +  doc['age'].value.toString())",
>             "lang" : "painless"
>           }
>         },
>         "fullname" : {
>           "type" : "keyword"
>         }
>       },
>       "properties" : {
>         "dob" : {
>           "type" : "date",
>           "format" : "yyyy-MM-dd"
>         },
>         "name" : {
>           "type" : "text",
>           "fields" : {
>             "raw" : {
>               "type" : "keyword"
>             }
>           }
>         }
>       }
>     }
>   }
> }

And then the query does not have to include the definition of the field, for example:

> GET employee/_search
> {
>   "query": {
>     "match": {
>       "concatenated_field": "kiran appaji sangita_45"
>     }
>   }
> }

Now let’s see the result as I mentioned earlier we will not see concatenated_field in the source document.

**Output**

> {
>   "took" : 3,
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
>     "max_score" : 1.0,
>     "hits" : [
>       {
>         "_index" : "employee",
>         "_type" : "_doc",
>         "_id" : "1",
>         "_score" : 1.0,
>         "_source" : {
>           "name" : "Kiran Sangita",
>           "dob" : "1980-04-01",
>           "fullname" : "kiran appaji sangita",
>           "age" : "45"
>         }
>       }
>     ]
>   }
> }

If we want to see concatenated_field then we need to specify implicitly in the fields section.

> GET employee/_search
> {
>   "fields": [
>     "concatenated_field"
>   ],
>   "query": {
>     "match": {
>       "concatenated_field": "kiran appaji sangita_45"
>     }
>   }
> }

6. clean up

> DELETE employee


