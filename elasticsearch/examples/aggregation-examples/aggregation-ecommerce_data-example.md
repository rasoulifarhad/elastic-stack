### Aggregation Example

[base link](https://dev.to/lisahjung/beginner-s-guide-running-aggregations-with-elasticsearch-and-kibana-16bn)

1. Run Elasticsearch && Kibana 

> docker compose up -d

Open the Kibana console(AKA Dev Tools). 

2. Define index

> PUT ecommerce_data
> {
>   "mappings": {
>     "properties": {
>       "Country": {
>         "type": "keyword"
>       },
>       "CustomerID": {
>         "type": "long"
>       },
>       "Description": {
>         "type": "text"
>       },
>       "InvoiceDate": {
>         "type": "date",
>         "format": "M/d/yyyy H:m"
>       },
>       "InvoiceNo": {
>         "type": "keyword"
>       },
>       "Quantity": {
>         "type": "long"
>       },
>       "StockCode": {
>         "type": "keyword"
>       },
>       "UnitPrice": {
>         "type": "double"
>       }
>     }
>   }
> }

3. Add [e-commerce dataset](https://www.kaggle.com/carrie1/ecommerce-data) to Elasticsearch* 

The File Data Visualizer feature can be found in Kibana under the Machine Learning > Data Visualizer section.

4.  Reindex the data from the original index(ecommerce_original) to the one you just created(ecommerce_data).

> POST _reindex
> {
>   "source": {
>     "index": "ecommerce_original"
>   },
>   "dest": {
>     "index": "ecommerce_data"
>   }
> }

5. Remove the negative values from the field "UnitPrice"

> POST /ecommerce_data/_delete_by_query
> {
>   "query": {
>     "range": {
>       "UnitPrice": {
>         "lte": 0
>       }
>     }
>   }
> }

6. Remove values greater than 500 from the field "UnitPrice"

> POST /ecommerce_data/_delete_by_query
> {
>   "query": {
>     "range": {
>       "UnitPrice": {
>         "gte": 500
>       }
>     }
>   }
> }

7. Get information about documents in an index 

This will help us figure out what type of questions we could ask and identify the appropriate fields to run aggregations on to get the answers.

> GET ecommerce_data/_search

The ecommerce_data index contains transaction data from a company that operates in multiple countries.

Each document is a transaction of an item and it contains the following fields:

- Description
- Quantity    (numeric value)
- InvoiceNo
- CustomerID
- UnitPrice   (numeric value)
- Country
- InvoiceDate
- StockCode

#### Metric Aggregations 

8. Compute the sum of all unit prices in the index 

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "aggs": {
    "Name your aggregations here": {
      "sum": {
        "field": "Name the field you want to aggregate on here"
      }
    }
  }
}

> GET /ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "sum_unit_price": {
>       "sum": {
>         "field": "UnitPrice"
>       }
>     }  
>   }
> }

9. Compute the lowest(min) unit price of an item 

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "size": 0,
  "aggs": {
    "Name your aggregations here": {
      "min": {
        "field": "Name the field you want to aggregate on here"
      }
    }
  }
}

> GET /ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "lowest_unit_price": {
>      "min": {
>         "field": "UnitPrice"
>       }
>     }  
>   }
> }

10. Compute the highest(max) unit price of an item 

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "size": 0,
  "aggs": {
    "Name your aggregations here": {
      "max": {
        "field": "Name the field you want to aggregate on here"
      }
    }
  }
}

> GET /ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "max_unit_price": {
>      "max": {
>         "field": "UnitPrice"
>       }
>     }  
>   }
> }

11. Compute the average unit price of items 

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "size": 0,
  "aggs": {
    "Name your aggregations here": {
      "avg": {
        "field": "Name the field you want to aggregate on here"
      }
    }
  }
}

> GET /ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "avg_unit_price": {
>      "avg": {
>         "field": "UnitPrice"
>       }
>     }  
>   }
> }

12. Compute the count, min, max, avg, sum in one go

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "size": 0,
  "aggs": {
    "Name your aggregations here": {
      "stats": {
        "field": "Name the field you want to aggregate on here"
      }
    }
  }
}

> GET /ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "all_stats_unit_price": {
>       "stats": {
>         "field": "UnitPrice"
>       }
>     }  
>   }
> }

13. et number of unique customers in our transaction data 

Syntax:

> GET /Enter_name_of_the_index_here/_search
> {
>   "size": 0,
>   "aggs": {
>     "Name your aggregations here": {
>       "cardinality": {
>         "field": "Name the field you want to aggregate on here"
>       }
>     }  
>   }
> }

> GET /ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "number_unique_customers": {
>       "cardinality": {
>         "field": "CustomerID"
>       }
>     }  
>   }
> }

14. Calculate the average unit price of items sold in Germany.
	
Syntax:

> GET /Enter_name_of_the_index_here/_search
> {
>   "size": 0,
>   "query": {
>     "Enter match or match_phrase here": {
>       "Enter the name of the field": "Enter the value you are looking for"
>     }
>   },
>   "aggregations": {
>     "Name your aggregations here": {
>       "Specify aggregations type here": {
>         "field": "Name the field you want to aggregate here"
>       }
>     }  
>   }
> }

> GET /ecommerce_data/_search
> {
>   "size": 0,
>   "query": {
>     "match": {
>       "Country": "Germany"
>     }
>   },
>   "aggs": {
>     "germany_avg_unit_price": {
>       "avg": {
>         "field": "UnitPrice"
>       }
>     }  
>   }
> }

#### Bucket Aggregations 

Bucket aggregations group documents into several subsets of documents called buckets. All documents in a bucket share a common criteria.

There are various ways you can group documents into buckets:

- Date_histogram aggregation

  - Fixed_interval
  
  - Calendar_interval

- Histogram aggregation

- Range aggregation

- Terms aggregation

15. Create a bucket for every 8 hour interval. 

Syntax:

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "Name your aggregations here": {
>       "date_histogram": {
>         "field":"Name the field you want to aggregate on here",
>         "fixed_interval": "Specify the interval here"
>       }
>     }
>   }
> }

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "transactions_by_8_hrs": {
>       "date_histogram": {
>         "field": "InvoiceDate",
>         "fixed_interval": "8h"
>       }
>     }
>   }
> }

16. Create monthly buckets

Syntax:

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "Name your aggregations here": {
>       "date_histogram": {
>         "field":"Name the field you want to aggregate on here",
>         "calendar_interval": "Specify the interval here"
>       }
>     }
>   }
> }

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "transactions_by_8_hrs": {
>       "date_histogram": {
>         "field": "InvoiceDate",
>         "calendar_interval": "1M"
>       }
>     }
>   }
> }

Change order:

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "transactions_by_8_hrs": {
>       "date_histogram": {
>         "field": "InvoiceDate",
>         "calendar_interval": "1M"
>         , "order": {
>           "_key": "desc"
>         }
>       }
>     }
>   }
> }

17. Create buckets based on price interval of 10. 

Syntax:

> GET Enter_name_of_the_index_here/_search
> {
>   "size": 0,
>   "aggs": {
>     "Name your aggregations here": {
>       "histogram": {
>         "field":"Name the field you want to aggregate on here",
>         "interval": Specify the interval here
>       }
>     }
>   }
> }

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "transactions_per_price_interval": {
>       "histogram": {
>         "field": "UnitPrice",
>         "interval": 10
>       }
>     }
>   }
> }

Result:

> .....
> "aggregations" : {
>   "transactions_per_price_interval" : {
>     "buckets" : [
>       {
>         "key" : 0.0,
>         "doc_count" : 514354
>       },
>       {
>         "key" : 10.0,
>         "doc_count" : 20863
>       },
>       {
>         "key" : 20.0,
>         "doc_count" : 2135
>       },
>       {
>         "key" : 30.0,
>         "doc_count" : 419
>       },
>       {
>         "key" : 40.0,
>         "doc_count" : 204
>       },
>  ......   

Change order: 	

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "transactions_per_price_interval": {
>       "histogram": {
>         "field": "UnitPrice",
>         "interval": 10,
>         "order": {
>           "_key": "desc"
>         }
>       }
>     }
>   }
> }

#### Range Aggregation 

Syntax:

> GET Enter_name_of_the_index_here/_search
> {
>   "size": 0,
>   "aggs": {
>    "Name your aggregations here": {
>       "range": {
>         "field": "Name the field you want to aggregate on here",
>         "ranges": [
>           {
>             "to": x
>           },
>           {
>             "from": x,
>             "to": y
>           },
>           {
>             "from": z
>           }
>         ]
>       }
>     }
>   }
> }

18. We want to know the number of transactions for items from varying price ranges(between 0 and $50, between $50-$200, and between $200 and up)

> GET ecommerce_data/_search 
> {
>   "size": 0,
>   "aggs": {
>     "transactions_per_custom_price_ranges": {
>       "range": {
>         "field": "UnitPrice",
>         "ranges": [
>           {
>             "to": 50
>           },
>           {
>             "from": 50,
>             "to": 200
>           },
>           {
>             "from": 200
>           }
>         ]
>       }
>     }
>   }
> } 

Result: 

>   ...
>   "aggregations" : {
>     "transactions_per_custom_price_ranges" : {
>       "buckets" : [
>         {
>           "key" : "*-50.0",
>           "to" : 50.0,
>           "doc_count" : 537975
>         },
>         {
>           "key" : "50.0-200.0",
>           "from" : 50.0,
>           "to" : 200.0,
>           "doc_count" : 855
>         },
>         {
>           "key" : "200.0-*",
>           "from" : 200.0,
>           "doc_count" : 307
>         }
>    ....

#### Terms Aggregation

The terms aggregation creates a new bucket for every unique term it encounters for the specified field.

It is often used to find the most frequently found terms in a specified field of a document. 

By default, the terms aggregation sorts buckets based on the "doc_count"
values in descending order. 

Syntax:

> GET Enter_name_of_the_index_here/_search
> {
>   "aggs": {
>     "Name your aggregations here": {
>       "terms": {
>         "field": "Name the field you want to aggregate on here",
>         "size": State how many top results you want returned here
>       }
>     }
>   }
> }

19. We want to identify 5 customers with the highest number of transactions(documents). 

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "top_5_customers": {
>       "terms": {
>         "field": "CustomerID",
>         "size": 5
>       }
>     }
>   }
> }

Result: 

> ....
>   "aggregations" : {
>     "top_5_customers" : {
>       "doc_count_error_upper_bound" : 0,
>       "sum_other_doc_count" : 380293,
>       "buckets" : [
>         {
>           "key" : 17841,
>           "doc_count" : 7983
>         },
>         {
>           "key" : 14911,
>           "doc_count" : 5897
>         },
>         {
>           "key" : 14096,
>           "doc_count" : 5110
>         },
>         {
>           "key" : 12748,
>           "doc_count" : 4638
>         },
>         {
>           "key" : 14606,
>           "doc_count" : 2782
>         }
> ....

Changing sort order 

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "5_customers_with_lowest_number_of_transactions": {
>       "terms": {
>         "field": "CustomerID",
>         "size": 5,
>         "order": {
>           "_count": "asc"
>         }
>       }
>     }
>   }
> }

#### Combined Aggregations 

20.  We wanted to know the sum of revenue per day:

- Step 1: Group data into daily buckets. ( date_histogram aggregation )

- Step 2: Calculate the daily revenue.( we need to perform metric aggregations Within each bucket )

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "transactions_per_day": {
>       "date_histogram": {
>         "field": "InvoiceDate",
>         "calendar_interval": "day"
>       },
>       "aggs": {
>         "daily_revenue": {
>           "sum": {
>             "script": {
>               "source": "doc['UnitPrice'].value * doc['Quantity'].value"
>             }
>           }
>         }
>       }
>     }
>   }
> }

Result:

> ....
>   "aggregations" : {
>     "transactions_per_day" : {
>       "buckets" : [
>         {
>           "key_as_string" : "12/1/2010 0:0",
>           "key" : 1291161600000,
>           "doc_count" : 3096,
>           "daily_revenue" : {
>             "value" : 57458.3
>           }
>         },
>         {
>           "key_as_string" : "12/2/2010 0:0",
>           "key" : 1291248000000,
>           "doc_count" : 2107,
>           "daily_revenue" : {
>             "value" : 46207.28
>           }
>         },
> ....

#### Calculating multiple metrics per bucket 

21. We want to calculate the daily revenue and the number of unique customers per day

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "transactions_per_day": {
>       "date_histogram": {
>         "field": "InvoiceDate",
>         "calendar_interval": "day"
>       },
>       "aggs": {
>         "daily_revenue": {
>           "sum": {
>             "script": {
>               "source": "doc['UnitPrice'].value * doc['Quantity'].value"
>             }
>           }
>         },
>         "number_of_unique_customers_per_day": {
>           "cardinality": {
>             "field": "CustomerID"
>           }
>         }
>       }
>     }
>   }
> }

Result:

> ....
>   "aggregations" : {
>     "transactions_per_day" : {
>       "buckets" : [
>         {
>           "key_as_string" : "12/1/2010 0:0",
>           "key" : 1291161600000,
>           "doc_count" : 3096,
>           "number_of_unique_customers_per_day" : {
>             "value" : 98
>           },
>           "daily_revenue" : {
>             "value" : 57458.3
>           }
>         },
>         {
>           "key_as_string" : "12/2/2010 0:0",
>           "key" : 1291248000000,
>           "doc_count" : 2107,
>           "number_of_unique_customers_per_day" : {
>             "value" : 117
>           },
>           "daily_revenue" : {
>             "value" : 46207.28
>           }
>         },
>         {
>           "key_as_string" : "12/3/2010 0:0",
>           "key" : 1291334400000,
>           "doc_count" : 2168,
>           "number_of_unique_customers_per_day" : {
>             "value" : 55
>           },
>           "daily_revenue" : {
>             "value" : 44732.94
>           }
>         },
> ....

#### Sorting by metric value of a sub-aggregation

You do not always need to sort by time interval, numerical interval, or by doc_count! You can also sort by metric value of sub-aggregations. 

22. We wanted to find which day had the highest daily revenue!

We must sort buckets based on the metric value of "daily_revenue" in descending("desc") order.

> GET ecommerce_data/_search
> {
>   "size": 0,
>   "aggs": {
>     "transactions_per_day": {
>       "date_histogram": {
>         "field": "InvoiceDate",
>         "calendar_interval": "day",
>         "order": {
>           "daily_revenue": "desc"
>         }
>       },
>       "aggs": {
>         "daily_revenue": {
>           "sum": {
>             "script": {
>               "source": "doc['UnitPrice'].value * doc['Quantity'].value"
>             }
>           }
>         },
>         "number_of_unique_customers_per_day": {
>           "cardinality": {
>             "field": "CustomerID"
>           }
>         }
>       }
>     }
>   }
> }

Result: 

> ....
>   "aggregations" : {
>     "transactions_per_day" : {
>       "buckets" : [
>         {
>           "key_as_string" : "11/14/2011 0:0",
>           "key" : 1321228800000,
>           "doc_count" : 3580,
>           "number_of_unique_customers_per_day" : {
>             "value" : 109
>           },
>           "daily_revenue" : {
>             "value" : 111160.52
>           }
>         },
>         {
>           "key_as_string" : "9/20/2011 0:0",
>           "key" : 1316476800000,
>           "doc_count" : 1716,
>           "number_of_unique_customers_per_day" : {
>             "value" : 56
>           },
>           "daily_revenue" : {
>             "value" : 108194.0
>           }
>         },
>         {
>           "key_as_string" : "11/7/2011 0:0",
>           "key" : 1320624000000,
>           "doc_count" : 2087,
>           "number_of_unique_customers_per_day" : {
>             "value" : 90
>           },
>           "daily_revenue" : {
>             "value" : 83038.19
>           }
>         },
> ....

