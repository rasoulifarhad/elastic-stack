### Introducing – Join Datatype

<!--

https://www.factweavers.com/blog/join-in-elasticsearch/
https://www.factweavers.com/blog/
https://marcobonzanini.com/2015/02/09/phrase-match-and-proximity-search-in-elasticsearch/

Suppose there are training sessions by different technology trainers and there are students enrolled under each trainer. In this scenario, assuming that there is no student who is enrolled under more than one trainer, this can be thought of as a one to many relationship. 

So here we establish the parent class to be the trainers and the children to be the trainees under each trainer.

```
parent = trainers
children = student
```
#### create index

```json
curl -X PUT "localhost:9200/test-index" -H 'Content-Type: application/json' -d'{
    "settings" : {
        "index" : {
            "number_of_shards" : 1, 
            "number_of_replicas" : 1 
        }
    },
  "mappings": {
    "_doc": {
      "properties": {
        "joinField": { 
          "type": "join",
          "relations": {
            "trainer": "student" 
          }
        }
      }
    }
  }
}'
```

“joinField”
This field, is a custom field, where we are going to specify the relation. Under the mapping of the “joinField” , it is specified as the “type” as “join”, to let elasticsearch understand that the parent child relations for the documents will be specified in this field for the individual document.

“relations”

This field under the “joinField” specifies, helps elasticsearch map the parent and child document. Under this field, the specification is to write like this “parent identifier”:”child identifier”. Here in our case it is “trainer”:”student”

#### Sample Documents indexing

Parent Document

```json
curl -X PUT "localhost:9200/test-index/_doc/1?refresh" -H 'Content-Type: application/json' -d'{
  "technology": "elasticsearch",
  "trainer": "Vineeth Mohan",
  "location": "India",
  "category": "bigdata",
  "joinField": {
    "name": "trainer"
  }
}'
```
Child Document

```json
curl -X PUT "localhost:9200/test-index/_doc/10?routing=1&refresh" -H 'Content-Type: application/json' -d'
{
  "name": "Arun Mohan",
  "age": 32,
  "joinField": {
    "name": "student",
    "parent": "1"
  }
}'
```

1. Simple relational query

 finding the children documents under a parent document. 
 
```json
 {
  "query": {
    "parent_id": {
      "type": "trainer",
      "id": "1"
    }
  }
}
```
2. Has_Child query

We want to know that under how many (which all ) trainers there are students enrolled with the name “arun”. 

```json
{
  "query": {
    "has_child": {
      "type": "student",
      "query": {
        "term": {
          "name": "arun"
        }
      }
    }
  }
}
```
3. Has_parent query

Consider the use case of searching for the students who have enrolled in the bigdata course category. The student documents does not have such a field and only the parent documents have the field called category which mentions the type of course. Now this requirement can be met using the has_parent query like below:

```json

{
  "query": {
    "has_parent": {
      "parent_type": "trainer",
      "query": {
        "term": {
          "category": "bigdata"
        }
      }
    }
  }
}
```
4. Children aggregations

Children aggregations are used to get a split level information of the combined data of parent and children documents. Suppose, if we want to take the split wise bucket information regarding the course category in the above section, we can use the normal terms aggregation on the field “category” which exists in the parent document. The problem here is that, while it gives the bucket level information on the categories offered, it does not give the split details of the students involved. Now to solve this issue, we can use the children aggregation like below:

```json
{
  "aggs": {
    "categories": {
      "terms": {
        "field": "category.keyword",
        "size": 10
      },
      "aggs": {
        "trainee": {
          "children": {
            "type": "student"
          },
          "aggs": {
            "student": {
              "terms": {
                "field": "name.keyword",
                "size": 10
              }
            }
          }
        }
      }
    }
  }
}
```
-->
