
```json


```

Response:

```

```

Aggregation

SELECT COUNT(*) FROM %s", TEST_INDEX_ACCOUNT

SELECT SUM(balance) FROM %s", TEST_INDEX_ACCOUNT

SELECT MIN(age) FROM %s", TEST_INDEX_ACCOUNT)

SELECT MAX(age) FROM %s", TEST_INDEX_ACCOUNT

SELECT AVG(age) FROM %s", TEST_INDEX_ACCOUNT)

SELECT STATS(age) FROM %s", TEST_INDEX_ACCOUNT
SELECT EXTENDED_STATS(age) FROM %s", TEST_INDEX_ACCOUNT
SELECT PERCENTILES(age) FROM %s", TEST_INDEX_ACCOUNT

SELECT PERCENTILES(age,25.0,75.0) x FROM %s", TEST_INDEX_ACCOUNT

SELECT COUNT(*) AS mycount FROM %s", TEST_INDEX_ACCOUNT


SELECT COUNT(*) FROM %s GROUP BY gender", TEST_INDEX_ACCOUNT)

SELECT COUNT(*) FROM %s GROUP BY gender, terms('alias'='ageAgg','field'='age','size'=3)", TEST_INDEX_ACCOUNT)

SELECT COUNT(*) FROM %s GROUP BY terms('alias'='ageAgg','field'='age','size'=3)", TEST_INDEX_ACCOUNT

SELECT count(*) FROM %s/gotCharacters GROUP BY terms('alias'='nick','field'='nickname','missing'='no_nickname')", TEST_INDEX_GAME_OF_THRONES)

SELECT count(*) FROM %s GROUP BY terms('field'='dog_name', 'alias'='dog_name', order='desc')", TEST_INDEX_DOG));


"SELECT count(*) FROM %s GROUP BY terms('field'='dog_name', 'alias'='dog_name', order='asc')", TEST_INDEX_DOG));

SELECT COUNT(*) FROM %s/account GROUP BY age ORDER BY COUNT(*)", TEST_INDEX_ACCOUNT))


SELECT COUNT(*) FROM %s/account GROUP BY age ORDER BY COUNT(*) DESC", TEST_INDEX_ACCOUNT)

SELECT COUNT(*) FROM %s/account GROUP BY age ORDER BY COUNT(*) LIMIT 5", TEST_INDEX_ACCOUNT)



select dog_name,age from %s order by age",TEST_INDEX_DOG);

select name,house from %s",TEST_INDEX_GAME_OF_THRONES);
select name.firstname,house from %s",TEST_INDEX_GAME_OF_THRONES);
select name.firstname,name.lastname,house from %s", TEST_INDEX_GAME_OF_THRONES);
select name.firstname,house from %s",TEST_INDEX_GAME_OF_THRONES);


select c.gender , h.hname,h.words from %s c " +
                "JOIN %s h " +
                "on h.hname = c.house ",TEST_INDEX_GAME_OF_THRONES,TEST_INDEX_GAME_OF_THRONES);
                
select count(*) from %s ",TEST_INDEX_DOG);
"select avg(age) as myAlias from %s ",TEST_INDEX_DOG);
select count(*) as count, avg(age) as myAlias from %s ",TEST_INDEX_DOG);
SELECT COUNT(*) FROM %s GROUP BY gender",TEST_INDEX_ACCOUNT);
SELECT COUNT(*) FROM %s where age in (35,36) GROUP BY gender,age",TEST_INDEX_ACCOUNT);
SELECT COUNT(*) , sum(balance) FROM %s where age in (35,36) GROUP BY gender,age",TEST_INDEX_ACCOUNT);

select count(*) from %s" +
                " group by date_histogram('field'='insert_time','interval'='4d','alias'='days')",TEST_INDEX_ONLINE);
                
SELECT STATS(age) FROM %s", TEST_INDEX_ACCOUNT);
SELECT EXTENDED_STATS(age) FROM %s", TEST_INDEX_ACCOUNT);

select percentiles(age) as per from %s where age > 31", TEST_INDEX_ACCOUNT);
select age , firstname from %s where age > 31 limit 2", TEST_INDEX_ACCOUNT);
select age , firstname from %s where age > 31 order by _score desc limit 2 ", TEST_INDEX_ACCOUNT);
select age , firstname from %s where age > 31 order by _score desc limit 2 ", TEST_INDEX_ACCOUNT);
select age+1 as agePlusOne ,age , firstname from %s where age =  31 limit 1", TEST_INDEX_ACCOUNT);
select dog_name,age from %s order by age",TEST_INDEX_DOG);
select age , firstname from %s where lastname = 'Marquez' ", TEST_INDEX_ACCOUNT);
select age , firstname from %s where lastname = 'Marquez' ", TEST_INDEX_ACCOUNT);


DELETE FROM %s", TEST_INDEX_ACCOUNT_TEMP)

DELETE FROM %s WHERE phrase = 'quick fox here' ", TEST_INDEX_PHRASE),
                                


































