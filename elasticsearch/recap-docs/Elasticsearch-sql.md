### Elasticsearch SQL

See [Elasticsearch SQL](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/xpack-sql.html)

#### SQL Commands

> DESCRIBE TABLE
> 
>> Describe a table.
> 
> SELECT
> 
>> Retrieve rows from zero or more tables.
> 
> SHOW CATALOGS
> 
>> List available catalogs.
> 
> SHOW COLUMNS
> 
>> List columns in table.
> 
> SHOW FUNCTIONS
> 
>> List supported functions.
> 
> SHOW TABLES
> 
>> List tables available.
> 

#### Casting

> 
> 123::LONG                                   // cast 123 to a LONG
> 
> CAST('1969-05-13T12:34:56' AS TIMESTAMP)    // cast the given string to datetime
> 
> CONVERT('10.0.0.1', IP)                     // cast '10.0.0.1' to an IP
> 

#### Single vs Double Quotes

> 
> Singlequotes are used to declare a `string literal`.
> 
>> A string literal is an arbitrary number of characters bounded by single quotes .
> 
> Double quotes are used for `identifier`s.
>
>>
>>  ```sql
>>  SELECT 
>>    "first_name" 
>>  FROM 
>>    "musicians"  
>>  WHERE 
>>    "last_name" = 'Carroll'   
>> ```


#### Comments

> 
> Single line  `--`
> 
> Multi line   `/*  */`
> 

#### SQL Translate API

>  
> ```json
> POST /_sql/translate
> {
>   "query": "SELECT * FROM library ORDER BY page_count DESC",
>   "fetch_size": 10
> }
> ```
>  

#### Paginating through a large response

1. First Request

    ```json
    POST /_sql?format=json
    {
    "query": "SELECT * FROM library ORDER BY page_count DESC",
    "fetch_size": 5
    }
    ```

2.  Response

    ```json
    {
    "columns": [
        {"name": "author",       "type": "text"},
        ......
    ],
    "rows": [
        ["Peter F. Hamilton",  "Pandora's Star",       768, "2004-03-02T00:00:00.000Z"],
        .....
    ],
    "cursor": "sDXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAAEWWWdrRlVfSS1TbDYtcW9lc1FJNmlYdw==:BAFmBmF1dGhvcgFmBG5hbWUBZgpwYWdlX2NvdW50AWYMcmVsZWFzZV9kYXRl+v///w8="
    }
    ```
3. Continue to the next page by sending back the cursor field.

    ```json
    POST /_sql?format=json
    {
    "cursor": "sDXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAAEWYUpOYklQMHhRUEtld3RsNnFtYU1hQQ==:BAFmBGRhdGUBZgVsaWtlcwFzB21lc3NhZ2UBZgR1c2Vy9f///w8="
    }
    ```

4. We’ve reached the last page when there is no cursor returned in the results. 

#### Filtering using Elasticsearch Query DSL

  ```json 
  POST /_sql?format=txt
  {
    "query": "SELECT * FROM library ORDER BY page_count DESC",
    "filter": {
      "range": {
        "page_count": {
          "gte" : 100,
          "lte" : 200
        }
      }
    },
    "fetch_size": 5
  }
  ```

#### Passing parameters to a query

```json

POST /_sql?format=txt
{
  "query": """
    SELECT 
      YEAR(release_date) AS year 
    FROM 
      library 
    WHERE 
      page_count > ? 
    AND 
      author = ? 
    GROUP BY 
      year 
    HAVING 
      COUNT(*) > ?
    """,
  "params": [
    300,
    "Frank Herbert",
    0
  ]
}

```

#### Date-Time Functions

- CURRENT_DATE/CURDATE/CURRENT_TIME/CURTIME/CURRENT_TIMESTAMP
- DATE_ADD/DATEADD/TIMESTAMP_ADD/TIMESTAMPADD
- DATE_DIFF/DATEDIFF/TIMESTAMP_DIFF/TIMESTAMPDIFF
- DATE_PARSE/DATETIME_FORMAT/DATETIME_PARSE
- DATE_PART/DATEPART/DATE_TRUNC/DATETRUNC
- DAY_OF_MONTH/DOM/DAY/DAY_OF_WEEK/DAYOFWEEK/DOW/DAY_OF_YEAR/DOY/
- DAY_NAME/DAYNAME/MONTH_OF_YEAR/MONTH/MONTH_NAME/MONTHNAME
- HOUR_OF_DAY/HOUR/MINUTE_OF_DAY/MINUTE_OF_HOUR/MINUTE/SECOND_OF_MINUTE/SECOND
- QUARTER/WEEK_OF_YEAR/WEEK/YEAR
- TIME_PARSE
- NOW

#### Operators

- Equality (=) , Null safe Equality (<=>) , Inequality (<> or !=) , Comparison (<, <=, >, >=)
- IS NULL/IS NOT NULL  , BETWEEN , IN (<value1>, <value2>, ...)
- AND , OR , NOT
- Add (+) , Subtract (infix -) , Negate (unary -) , 
- Multiply (*) , Divide (/) , Modulo or Remainder(%)
- Cast (::)

#### Aggregate Functions

- AVG
- COUNT
- COUNT(ALL)
- COUNT(DISTINCT)
- FIRST/FIRST_VALUE
- LAST/LAST_VALUE
- MAX
- MIN
- SUM

