## Elasticsearch SQL

[from](https://github.com/NLPchina/elasticsearch-sql/tree/master/src/test/java/org/nlpcn/es4sql)

### Book Library

##### Bulk Index Books

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

```

Response:

```

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

```json

POST /_sql?format=txt
{
  "query": "Select 1 + 1 as result"
}

```

```
    result     
---------------
2              

```

### Dogs


##### Bulk Index Dogs

```json

POST /dogs/_bulk
{"index":{"_id":"1"}}
{"dog_name":"rex","holdersName":"Daenerys","age":2}
{"index":{"_id":"6"}}
{"dog_name":"snoopy","holdersName":"Hattie","age":4}

```

```json

POST /_sql?format=txt
{
  "query": "DESCRIBE dogs"
}

```

Response:

```

      column       |     type      |    mapping    
-------------------+---------------+---------------
age                |BIGINT         |long           
dog_name           |VARCHAR        |text           
dog_name.keyword   |VARCHAR        |keyword        
holdersName        |VARCHAR        |text           
holdersName.keyword|VARCHAR        |keyword        

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

```

Response:

```

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

```

Response:

```

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

```

Response:

```

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

```

Response:

```

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

```

Response:

```

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

```

Response:

```

   dog_name    |     count     
---------------+---------------
rex            |1              
snoopy         |1              

```

7. 

```json

POST /_sql?format=txt
{
  "query": """
      SELECT dog_name,age FROM dogs WHERE age =2
  """
}

```

Response:

```
   dog_name    |      age      
---------------+---------------
rex            |2              

```

### Game of Thrones documets 

##### Bulk Index documents

```json

POST /game_of_thrones/_bulk
{"index":{"_id":"1"}}
{"name":{"firstname":"Daenerys","lastname":"Targaryen","ofHerName":1},"nickname":"Daenerys \"Stormborn\"","house":"Targaryen","gender":"F","parents":{"father":"Aerys","mother":"Rhaella"},"titles":["motherOfDragons","queenOfTheAndals","breakerOfChains","Khaleesi"]}
{"index":{"_id":"2"}}
{"name":{"firstname":"Eddard","lastname":"Stark","ofHisName":1},"house":"Stark","parents":{"father":"Rickard","mother":"Lyarra"},"gender":"M","titles":["lordOfWinterfell","wardenOfTheNorth","handOfTheKing"]}
{"index":{"_id":"3"}}
{"name":{"firstname":"Brandon","lastname":"Stark","ofHisName":4},"house":"Stark","parents":{"father":"Eddard","mother":"Catelyn"},"gender":"M","titles":["princeOfWinterfell"],"@wolf":"Summer"}
{"index":{"_id":"4"}}
{"name":{"firstname":"Jaime","lastname":"Lannister","ofHisName":1},"gender":"M","house":"Lannister","parents":{"father":"Tywin","mother":"Joanna"},"titles":["kingSlayer","lordCommanderOfTheKingsguard","Ser"]}
{"index":{"_id":"5"}}
{"words":"fireAndBlood","hname":"Targaryen","sigil":"Dragon","seat":"Dragonstone"}
{"index":{"_id":"6"}}
{"words":"winterIsComing","hname":"Stark","sigil":"direwolf","seat":"Winterfell"}
{"index":{"_id":"7"}}
{"words":"hearMeRoar","hname":"Lannister","sigil":"lion","seat":"CasterlyRock"}

```

##### SQL

1. 

```json

POST /_sql?format=txt
{
  "query": "DESCRIBE game_of_thrones"
}

```

Response:

```
        column        |     type      |    mapping    
----------------------+---------------+---------------
@wolf                 |VARCHAR        |text           
@wolf.keyword         |VARCHAR        |keyword        
gender                |VARCHAR        |text           
gender.keyword        |VARCHAR        |keyword        
hname                 |VARCHAR        |text           
hname.keyword         |VARCHAR        |keyword        
house                 |VARCHAR        |text           
house.keyword         |VARCHAR        |keyword        
name                  |STRUCT         |object         
name.firstname        |VARCHAR        |text           
name.firstname.keyword|VARCHAR        |keyword        
name.lastname         |VARCHAR        |text           
name.lastname.keyword |VARCHAR        |keyword        
name.ofHerName        |BIGINT         |long           
name.ofHisName        |BIGINT         |long           
nickname              |VARCHAR        |text           
nickname.keyword      |VARCHAR        |keyword        
parents               |STRUCT         |object         
parents.father        |VARCHAR        |text           
parents.father.keyword|VARCHAR        |keyword        
parents.mother        |VARCHAR        |text           
parents.mother.keyword|VARCHAR        |keyword        
seat                  |VARCHAR        |text           
seat.keyword          |VARCHAR        |keyword        
sigil                 |VARCHAR        |text           
sigil.keyword         |VARCHAR        |keyword        
titles                |VARCHAR        |text           
titles.keyword        |VARCHAR        |keyword        
words                 |VARCHAR        |text           
words.keyword         |VARCHAR        |keyword        

```
 
2. 

```json

POST /_sql?format=txt
{
  "query": "SELECT name.*, house FROM game_of_thrones"
}

```

Response:

```
name.firstname | name.lastname |name.ofHerName |name.ofHisName |     house     
---------------+---------------+---------------+---------------+---------------
Daenerys       |Targaryen      |1              |null           |Targaryen      
Eddard         |Stark          |null           |1              |Stark          
Brandon        |Stark          |null           |4              |Stark          
Jaime          |Lannister      |null           |1              |Lannister      
null           |null           |null           |null           |null           
null           |null           |null           |null           |null           
null           |null           |null           |null           |null           

```

3. 

```json

POST /_sql?format=txt
{
  "query": "SELECT TOP 2  name.*, house FROM game_of_thrones"
}

```

Response:

```
name.firstname | name.lastname |name.ofHerName |name.ofHisName |     house     
---------------+---------------+---------------+---------------+---------------
Daenerys       |Targaryen      |1              |null           |Targaryen      
Eddard         |Stark          |null           |1              |Stark          

```

4. 

```json

POST /_sql?format=txt
{
  "query": "SELECT name.*, house FROM game_of_thrones LIMIT 1"
}

```

Response:

```
name.firstname | name.lastname |name.ofHerName |name.ofHisName |     house     
---------------+---------------+---------------+---------------+---------------
Daenerys       |Targaryen      |1              |null           |Targaryen      

```

5. 

```json

POST /_sql?format=txt
{
  "query": "SELECT name.firstname as firstname, house FROM game_of_thrones "
}

```

Response:

```

   firstname   |     house     
---------------+---------------
Daenerys       |Targaryen      
Eddard         |Stark          
Brandon        |Stark          
Jaime          |Lannister      
null           |null           
null           |null           
null           |null           

```

6. 

```json

POST /_sql?format=txt
{
  "query": "SHOW COLUMNS IN game_of_thrones"
}

```

Response:

```
        column        |     type      |    mapping    
----------------------+---------------+---------------
@wolf                 |VARCHAR        |text           
@wolf.keyword         |VARCHAR        |keyword        
gender                |VARCHAR        |text           
gender.keyword        |VARCHAR        |keyword        
hname                 |VARCHAR        |text           
hname.keyword         |VARCHAR        |keyword        
house                 |VARCHAR        |text           
house.keyword         |VARCHAR        |keyword        
name                  |STRUCT         |object         
name.firstname        |VARCHAR        |text           
name.firstname.keyword|VARCHAR        |keyword        
name.lastname         |VARCHAR        |text           
name.lastname.keyword |VARCHAR        |keyword        
name.ofHerName        |BIGINT         |long           
name.ofHisName        |BIGINT         |long           
nickname              |VARCHAR        |text           
nickname.keyword      |VARCHAR        |keyword        
parents               |STRUCT         |object         
parents.father        |VARCHAR        |text           
parents.father.keyword|VARCHAR        |keyword        
parents.mother        |VARCHAR        |text           
parents.mother.keyword|VARCHAR        |keyword        
seat                  |VARCHAR        |text           
seat.keyword          |VARCHAR        |keyword        
sigil                 |VARCHAR        |text           
sigil.keyword         |VARCHAR        |keyword        
titles                |VARCHAR        |text           
titles.keyword        |VARCHAR        |keyword        
words                 |VARCHAR        |text           
words.keyword         |VARCHAR        |keyword        

```

7. 

```json

POST /_sql?format=txt
{
  "query": "SHOW FUNCTIONS"
}

```

Response:

```
      name       |     type      
-----------------+---------------
AVG              |AGGREGATE      
COUNT            |AGGREGATE      
FIRST            |AGGREGATE      
FIRST_VALUE      |AGGREGATE      
LAST             |AGGREGATE      
LAST_VALUE       |AGGREGATE      
MAX              |AGGREGATE      
MIN              |AGGREGATE      
SUM              |AGGREGATE      
KURTOSIS         |AGGREGATE      
MAD              |AGGREGATE      
PERCENTILE       |AGGREGATE      
PERCENTILE_RANK  |AGGREGATE      
SKEWNESS         |AGGREGATE      
STDDEV_POP       |AGGREGATE      
STDDEV_SAMP      |AGGREGATE      
SUM_OF_SQUARES   |AGGREGATE      
VAR_POP          |AGGREGATE      
VAR_SAMP         |AGGREGATE      
HISTOGRAM        |GROUPING       
CASE             |CONDITIONAL    
COALESCE         |CONDITIONAL    
GREATEST         |CONDITIONAL    
IFNULL           |CONDITIONAL    
IIF              |CONDITIONAL    
ISNULL           |CONDITIONAL    
LEAST            |CONDITIONAL    
NULLIF           |CONDITIONAL    
NVL              |CONDITIONAL    
     ....

```

8. 

```json
POST /_sql?format=txt
{
  "query": "SHOW FUNCTIONS LIKE 'A%'"
}

```

Response:

```
     name      |     type      
---------------+---------------
AVG            |AGGREGATE      
ABS            |SCALAR         
ACOS           |SCALAR         
ASIN           |SCALAR         
ATAN           |SCALAR         
ATAN2          |SCALAR         
ASCII          |SCALAR         

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



