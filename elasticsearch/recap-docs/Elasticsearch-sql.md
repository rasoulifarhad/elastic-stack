### Elasticsearch SQL

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