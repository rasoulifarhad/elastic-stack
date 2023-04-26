## Elasticsearch SQL
https://github.com/NLPchina/elasticsearch-sql/tree/master/src/test/java/org/nlpcn/es4sql

### Book Library documets

##### Index Books

```json

POST /library/_bulk
{"index":{"_id": "Leviathan Wakes"}}
{"name": "Leviathan Wakes", "author": "James S.A. Corey", "release_date": "2011-06-02", "page_count": 561}
{"index":{"_id": "Hyperion"}}
{"name": "Hyperion", "author": "Dan Simmons", "release_date": "1989-05-26", "page_count": 482}
{"index":{"_id": "Dune"}}
{"name": "Dune", "author": "Frank Herbert", "release_date": "1965-06-01", "page_count": 604}

```

#### SQL 

**Using** [SQL search API](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/sql-search-api.html)

```json

POST /_sql?format=txt
{
  "query": "SELECT * FROM library WHERE release_date < '2000-01-01'"
}

Response:

    author     |     name      |  page_count   |      release_date      
---------------+---------------+---------------+------------------------
Dan Simmons    |Hyperion       |482            |1989-05-26T00:00:00.000Z
Frank Herbert  |Dune           |604            |1965-06-01T00:00:00.000Z

```

**Using** [SQL CLI](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/sql-cli.html)

```

$ ./bin/elasticsearch-sql-cli

sql> SELECT * FROM library WHERE release_date < '2000-01-01';

Response:

    author     |     name      |  page_count   |      release_date      
---------------+---------------+---------------+------------------------
Dan Simmons    |Hyperion       |482            |1989-05-26T00:00:00.000Z
Frank Herbert  |Dune           |604            |1965-06-01T00:00:00.000Z

```

### Dogs documets 


##### Index Dogs

```json

POST /dogs/_bulk
{"index":{"_id":"1"}}
{"dog_name":"rex","holdersName":"Daenerys","age":2}
{"index":{"_id":"6"}}
{"dog_name":"snoopy","holdersName":"Hattie","age":4}

```

##### SQL

1. 

```json

POST /_sql?format=txt
{
  "query": """
      SELECT dog_name,age FROM dogs
  """
}

   dog_name    |      age      
---------------+---------------
rex            |2              
snoopy         |4              

```

2. 

```json

POST /_sql?format=txt
{
  "query": """
      SELECT dog_name,age FROM dogs order by age desc
  """
}

   dog_name    |      age      
---------------+---------------
snoopy         |4              
rex            |2              

```

3. 

```json

POST /_sql?format=txt
{
  "query": """
      SELECT COUNT(*) FROM dogs
  """
}

   COUNT(*)    
---------------
2              

```

4. 

```json

POST /_sql?format=txt
{
  "query": """
      SELECT avg(age) as myAlias  FROM dogs
  """
}


    myAlias    
---------------
3.0            

```

5. 

```json

POST /_sql?format=txt
{
  "query": """
      SELECT count(*) as count, avg(age) as myAlias  FROM dogs
  """
}


     count     |    myAlias    
---------------+---------------
2              |3.0            

```

6. 

```json

POST /_sql?format=txt
{
  "query": "SELECT dog_name, count(*) as count FROM dogs GROUP BY  dog_name  order by dog_name asc"
}


   dog_name    |     count     
---------------+---------------
rex            |1              
snoopy         |1              

```

### Accounts documets 

##### Index Accounts

##### SQL

1. 

2. 

3. 


### Locations documets 

##### Index locations

##### SQL

1. 

2. 

3. 


### Peoples documets 

##### Index peoples

##### SQL

1. 

2. 

3. 


### Phrases documets 

##### Index phrases

##### SQL

1. 

2. 

3. 


### Systems documets 

##### Index systems

##### SQL

1. 

2. 

3. 


### Onlines documets 

##### Index onlines

##### SQL

1. 

2. 

3. 


### Nested Objects documets 

##### Index nested objects

##### SQL

1. 

2. 

3. 


### Game of Thrones documets 

##### Index documents

##### SQL

1. 

2. 

3. 


