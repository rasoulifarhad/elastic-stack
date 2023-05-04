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

**Query parameters:**

```json

POST /_sql?format=txt
{
	"query": "SELECT YEAR(release_date) AS year FROM library WHERE page_count > 300 AND author = 'Frank Herbert' GROUP BY year HAVING COUNT(*) > 0"
}

```

```json

POST /_sql?format=txt
{
	"query": "SELECT YEAR(release_date) AS year FROM library WHERE page_count > ? AND author = ? GROUP BY year HAVING COUNT(*) > ?",
	"params": [300, "Frank Herbert", 0]
}

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

**1.** 

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

**2.** 

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

**3.** 

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

**4.** 

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

**5.** 

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

**6.** 

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

**7.** 

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

**1.** 

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
 
**2.** 

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

**3.** 

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

**4.** 

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

**5.** 

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

**6.** 

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

**7.** 

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

**8.** 

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

```json

curl -XPOST "localhost:9200/accounts/_bulk" -s -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/x-ndjson'  --data-binary "@dataset/accounts.json"; echo

```

##### SQL

**1.** 

```json

POST /_sql?format=txt
{
  "query": "DESCRIBE accounts"
}

```

Respoinse:

```
     column      |     type      |    mapping    
-----------------+---------------+---------------
account_number   |BIGINT         |long           
address          |VARCHAR        |text           
address.keyword  |VARCHAR        |keyword        
age              |BIGINT         |long           
balance          |BIGINT         |long           
city             |VARCHAR        |text           
city.keyword     |VARCHAR        |keyword        
email            |VARCHAR        |text           
email.keyword    |VARCHAR        |keyword        
employer         |VARCHAR        |text           
employer.keyword |VARCHAR        |keyword        
firstname        |VARCHAR        |text           
firstname.keyword|VARCHAR        |keyword        
gender           |VARCHAR        |text           
gender.keyword   |VARCHAR        |keyword        
lastname         |VARCHAR        |text           
lastname.keyword |VARCHAR        |keyword        
state            |VARCHAR        |text           
state.keyword    |VARCHAR        |keyword        

```

**2.** 

```jsoj

POST /_sql?format=txt
{
  "query": "SELECT SUM(balance) FROM accounts"
}

```

Response:

```
 SUM(balance)  
---------------
25714837       

```

**3.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT MAX(age), MIN(age), AVG(age) FROM accounts"
}

```

Response:

```
   MAX(age)    |   MIN(age)    |   AVG(age)    
---------------+---------------+---------------
40             |20             |30.171         

```

**4.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT PERCENTILE(age, 95) AS \"95th\" FROM accounts"
}

```

Response:

```
     95th      
---------------
39.0           

```

**5.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT gender , count(*)  FROM accounts  GROUP BY gender"
}

```

Response:

```

    gender     |   count(*)    
---------------+---------------
F              |493            
M              |507            

```

**6.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT gender, age, COUNT(*), SUM(balance) FROM accounts WHERE age IN (35,36) GROUP BY gender,age"
}

```

Response:

```

    gender     |      age      |   COUNT(*)    | SUM(balance)  
---------------+---------------+---------------+---------------
F              |35             |24             |472771         
F              |36             |21             |505660         
M              |35             |28             |678337         
M              |36             |31             |647425         

```

### Peoples documets 

##### Index peoples

```json

source .env
curl -XPOST "localhost:9200/peoples/_bulk" -s -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/x-ndjson'  --data-binary "@dataset/peoples.json" | jq '{took: .took, errors: .errors}' ; echo

```

##### SQL

**1.** 
 
```json

POST /_sql?format=txt
{
  "query": "DESCRIBE peoples"
}

```

Response:

```

     column      |     type      |    mapping    
-----------------+---------------+---------------
account_number   |BIGINT         |long           
address          |VARCHAR        |text           
address.keyword  |VARCHAR        |keyword        
age              |BIGINT         |long           
balance          |BIGINT         |long           
city             |VARCHAR        |text           
city.keyword     |VARCHAR        |keyword        
email            |VARCHAR        |text           
email.keyword    |VARCHAR        |keyword        
employer         |VARCHAR        |text           
employer.keyword |VARCHAR        |keyword        
firstname        |VARCHAR        |text           
firstname.keyword|VARCHAR        |keyword        
gender           |VARCHAR        |text           
gender.keyword   |VARCHAR        |keyword        
lastname         |VARCHAR        |text           
lastname.keyword |VARCHAR        |keyword        
state            |VARCHAR        |text           
state.keyword    |VARCHAR        |keyword        

```

**2.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT * FROM peoples WHERE age > 25 LIMIT 1000"
}

```

Response:

```

account_number |      address       |      age      |    balance    |     city      |            email            |   employer    |   firstname   |    gender     |   lastname    |     state     
---------------+--------------------+---------------+---------------+---------------+-----------------------------+---------------+---------------+---------------+---------------+---------------
1              |880 Holmes Lane     |32             |39225          |Brogan         |amberduke@pyrami.com         |Pyrami         |Daenerys       |M              |Targaryen      |IL             
6              |671 Bristol Street  |36             |5686           |Dante          |hattiebond@netagy.com        |Netagy         |Hattie         |M              |Bond           |TN             
13             |789 Madison Street  |28             |32838          |Nogal          |nanettebates@quility.com     |Quility        |Nanette        |F              |Bates          |VA             
18             |467 Hutchinson Court|33             |4180           |Orick          |daleadams@boink.com          |Boink          |Dale           |M              |Adams          |MD             
20             |282 Kings Place     |36             |16418          |Ribera         |elinorratliff@scentric.com   |Scentric       |Elinor         |M              |Ratliff        |WA             
25             |171 Putnam Avenue   |39             |40540          |Nicholson      |virginiaayala@filodyne.com   |Filodyne       |Virginia       |F              |Ayala          |PA             
32             |702 Quentin Street  |34             |48086          |Veguita        |dillardmcpherson@quailcom.com|Quailcom       |Dillard        |F              |Mcpherson      |IN             
37             |826 Fillmore Place  |39             |18612          |Tooleville     |mcgeemooney@reversus.com     |Reversus       |Mcgee          |M              |Mooney         |OK             
44             |502 Baycliff Terrace|37             |34487          |Yardville      |aureliaharding@orbalix.com   |Orbalix        |Aurelia        |M              |Harding        |DE             
51             |334 River Street    |31             |14097          |Jacksonburg    |burtonmeyers@bezal.com       |Bezal          |Burton         |F              |Meyers         |MO             
56             |857 Tabor Court     |32             |14992          |Sunnyside      |josienelson@emtrac.com       |Emtrac         |Josie          |M              |Nelson         |UT             

```

**3.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT * FROM peoples WHERE firstname LIKE 'Da%'  LIMIT 1000"
}

```

Response:

```

account_number |      address       |      age      |    balance    |     city      |       email        |   employer    |   firstname   |    gender     |   lastname    |     state     
---------------+--------------------+---------------+---------------+---------------+--------------------+---------------+---------------+---------------+---------------+---------------
1              |880 Holmes Lane     |32             |39225          |Brogan         |amberduke@pyrami.com|Pyrami         |Daenerys       |M              |Targaryen      |IL             
18             |467 Hutchinson Court|33             |4180           |Orick          |daleadams@boink.com |Boink          |Dale           |M              |Adams          |MD             

```

**4.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT * FROM peoples WHERE firstname NOT LIKE 'Da%'  LIMIT 1000"
}

```

**5.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT * FROM peoples WHERE age=32 AND gender='M' LIMIT 1000"
}

```

Response:

```

account_number |    address    |      age      |    balance    |     city      |        email         |   employer    |   firstname   |    gender     |   lastname    |     state     
---------------+---------------+---------------+---------------+---------------+----------------------+---------------+---------------+---------------+---------------+---------------
1              |880 Holmes Lane|32             |39225          |Brogan         |amberduke@pyrami.com  |Pyrami         |Daenerys       |M              |Targaryen      |IL             
56             |857 Tabor Court|32             |14992          |Sunnyside      |josienelson@emtrac.com|Emtrac         |Josie          |M              |Nelson         |UT             

```

**6.** 

```json

POST /_sql?format=txt
{
  "query": "SELECT firstname, lastname, age FROM peoples WHERE age BETWEEN 35 AND 40 LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT firstname, lastname, age FROM peoples WHERE age NOT BETWEEN 35 AND 40 LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT firstname, lastname, age FROM peoples WHERE age IN (39, 36) LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT firstname, lastname, age FROM peoples WHERE age NOT IN (39, 36) LIMIT 1000"
}

```

Null safe Equality (<=>)edit

```json

POST /_sql?format=txt
{
  "query": "SELECT 'elastic' <=> null AS equals"
}

```

Response: 

```

    equals     
---------------
false          

```

```json

POST /_sql?format=txt
{
  "query": "SELECT null <=> null AS equals"
}

```

Response:

```

    equals     
---------------
true           

```

```json

POST /_sql?format=txt
{
  "query": "SELECT SUM(account_number+age) AS sum FROM peoples  LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT first(age) AS childest, last(age) AS oldest FROM peoples  LIMIT 1000"
}

```

Response:

```

   childest    |    oldest     
---------------+---------------
23             |39             

```

```json

POST /_sql?format=txt
{
  "query": "SELECT gender, first(age)  FROM peoples GROUP by gender ORDER BY gender LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT count(ALL age) count_all, count(DISTINCT age) count_distinct FROM peoples  LIMIT 1000"
}

```

```json

# Quantify the shape of the distribution of input values in the field age.
POST /_sql?format=txt
{
  "query": "SELECT MIN(age), MAX(age), KURTOSIS(age) FROM peoples  LIMIT 1000"
}

# Quantify the shape of the distribution of input values in the field balance.
POST /_sql?format=txt
{
  "query": "SELECT MIN(balance), MAX(balance), KURTOSIS(balance) FROM peoples  LIMIT 1000"
}

```

```json

# Measure the variability of the input values in the field age.
POST /_sql?format=txt
{
  "query": "SELECT MIN(age), MAX(age), AVG(age), MAD(age) FROM peoples  LIMIT 1000"
}

# Measure the variability of the input values in the field balance.
POST /_sql?format=txt
{
  "query": "SELECT MIN(balance), MAX(balance), AVG(balance), MAD(balance) FROM peoples  LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT gender, PERCENTILE(balance, 95) FROM peoples GROUP BY gender LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT gender, PERCENTILE(balance, 95), PERCENTILE(age, 95)  FROM peoples GROUP BY gender LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT CONCAT(firstname, lastname) AS name, gender, age, balance FROM peoples ORDER BY balance desc LIMIT 1000"
}

```

```json

POST /_sql?format=txt
{
  "query": "SELECT gender, PERCENTILE_RANK(balance, 40000) AS rank  FROM peoples GROUP BY gender ORDER BY rank asc LIMIT 1000"
}

```

<!--

### Locations documets 

##### Index locations

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

-->

