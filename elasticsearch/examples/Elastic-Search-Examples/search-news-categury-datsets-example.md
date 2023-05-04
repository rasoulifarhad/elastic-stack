### Search example

[base link](https://dev.to/lisahjung/beginner-s-guide-to-running-queries-with-elasticsearch-and-kibana-4kn9)

1. Run Elasticsearch && Kibana 

docker compose up -d

Open the Kibana console(AKA Dev Tools). 

2. Add [news headlines dataset](https://www.kaggle.com/rmisra/news-category-dataset) to Elasticsearch 

Import news headlines dataset to index news_headlines

3. Open the Kibana console(AKA Dev Tools).

Write query DSLs in the left panel of the Kibana console. Click on the query to make sure it is selected(dark grey bar) and click on the green arrow to send the query. 

4. Get information about documents in an index


GET news_headlines/_search

Our document contains fields called:

- date
- short_description
- @timestamp
- link
- category
- headline
- authors

#### Searching for search terms using the match query

The match query is a standard query for performing a full text search. This query retrieves documents that contain the search terms.

Syntax:

GET Enter_name_of_index_here/_search
{
  "query": {
    "match": {
      "Specify the field you want to search": {
        "query": "Enter search terms"
      }
    }
  }
}

5. We want to search for news headlines about Ed Sheeran's song "Shape of you".

GET news_headlines/_search
{
  "query": {
    "match": {
      "headline": {
        "query": "Shape of you"
      }
    }
  }
}

It asks to search for terms "Shape" or "of" or "you" in the field headline. 

When the match query is used to search for a phrase, it has high recall but low precision.

It pulls up more loosely related documents as it uses "OR" logic by default.

It pulls up documents that contains any one of the search terms in the specified field. Moreover, the order and the proximity in which the search terms are found are not taken into account. 

#### Searching for phrases using the match_phrase query

If the order and the proximity in which the search terms are found(i.e. phrases) are important in determining the relevance of your search, you should use the match_phrase query.

Syntax:

GET Enter_name_of_index_here/_search
{
  "query": {
    "match_phrase": {
      "Specify the field you want to search": {
        "query": "Enter search terms"
      }
    }
  }
}

6. We want to search for news headlines about Ed Sheeran's song "Shape of you".

GET news_headlines/_search
{
  "query": {
    "match_phrase": {
      "headline": {
        "query": "Shape of you"
      }
    }
  }
}

When the match_phrase parameter is used, all hits must meet the following criteria:

- the search terms "Shape", "of", and "you" must appear in the field headline.
- the terms must appear in that order.
- the terms must appear next to each other.

#### Running a multi_match query against multiple fields 

When designing a query, you don't always know the context of a user's search. When a user searches for "Michelle Obama", the user could be searching for statements written by Michelle Obama or articles written about her. 

To accommodate these contexts, you can write a multi_match query, which searches for terms in multiple fields.

The multi_match query runs a match query on multiple fields and calculates a score for each field. Then, it assigns the highest score among the fields to the document.

This score will determine the ranking of the document within the search results. 

Syntax:

GET Enter_the_name_of_the_index_here/_search
{
  "query": {
    "multi_match": {
      "query": "Enter search terms here",
      "fields": [
        "List the field you want to search over",
        "List the field you want to search over",
        "List the field you want to search over"
      ]
    }
  }
}

7. Search terms "Michelle" or "Obama" in the fields headline, or short_description, or authors. 

GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "Michelle Obama",
      "fields": [
        "headline",
        "short_description",
        "authors"
        ]
    }
  }
}

While the multi_match query increased the recall, it decreased the precision of the hits. 

How can we improve the precision of our search?

#### Per-field boosting 

Headlines mentioning "Michelle Obama" in the field headline are more likely to be related to our search than the headlines that mention "Michelle Obama" once or twice in the field short_description. 

To improve the precision of your search, you can designate one field to carry more weight than the others.

This can be done by boosting the score of the field headline(per-field boosting). This is notated by adding a carat(^) symbol and number 2 to the desired field as shown below.

Syntax:

GET Enter_the_name_of_the_index_here/_search
{
  "query": {
    "multi_match": {
      "query": "Enter search terms",
      "fields": [
        "List field you want to boost^2",
        "List field you want to search over",
        "List field you want to search over"
      ]
    }
  }
}

8. Search terms "Michelle" or "Obama" in the fields headline, or short_description, or authors. documents that contain the search terms in the field headline are most relevant.

GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "Michelle Obama",
      "fields": [
        "headline^2",
        "short_description",
        "authors"
        ]
    }
  }
}

9. the user remembers that she/he is throwing a party for all of her/his friends this weekend. She/He searches for news headlines regarding "party planning" to get some ideas for it. 

GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "party planning",
      "fields": [
        "headline^2",
        "short_description"
      ]
    }
  }
}

#### Improving precision with phrase type match 

We can improve the precision of a multi_match query by adding the "type":"phrase" to the query.

The phrase type performs a match_phrase query on each field and calculates a score for each field. Then, it assigns the highest score among the fields to the document.

Syntax:

GET Enter_the_name_of_the_index_here/_search
{
  "query": {
    "multi_match": {
      "query": "Enter search phrase",
      "fields": [
        "List field you want to boost^2",
        "List field you want to search over", 
        "List field you want to search over"
      ],
      "type": "phrase"
    }
  }
}

10. the user remembers that she/he is throwing a party for all of her/his friends this weekend. She/He searches for news headlines regarding "party planning" to get some ideas for it.

GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "party planning",
      "fields": [
        "headline^2",
        "short_description"
      ],
      "type": "phrase"
    }
  }
}

### Combined Queries 

There will be times when a user asks a multi-faceted question that requires multiple **queries** to answer.

For example, a user may want to find political headlines about Michelle Obama published before the year 2016.

This search is actually a combination of three queries:

- Query headlines that contain the search terms "Michelle Obama" in the field headline.
- Query "Michelle Obama" headlines from the "POLITICS" category.
- Query "Michelle Obama" headlines published before the year 2016

One of the ways you can combine these queries is through the **bool query**.

#### Bool Query 

The [bool query](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/query-dsl-bool-query.html#:~:text=Bool%20Queryedit,clause%20with%20a%20typed%20occurrence.) retrieves documents matching boolean combinations of other queries.

With the **bool query**, you can combine multiple **queries** into one request and further specify boolean clauses to narrow down your search results.

There are four clauses to choose from:

- must
- must_not
- should
- filter

You can build combinations of one or more of these clauses. Each clause can contain one or multiple **queries** that specify the criteria of each clause.

These clauses are optional and can be mixed and matched to cater to your use case. The order in which they appear does not matter either!

Syntax:

GET name_of_index/_search
{ 
  "query": {
    "bool": {
      "must": [
        {One or more queries can be specified here. A document MUST match all of these queries to be considered as a hit.}
      ],
      "must_not": [
        {A document must NOT match any of the queries specified here. It it does, it is excluded from the search results.}
      ],
      "should": [
        {A document does not have to match any queries specified here. However, it if it does match, this document is given a higher score.}
      ],
      "filter": [
        {These filters(queries) place documents in either yes or no category. Ones that fall into the yes category are included in the hits. }
      ]
    }
  }
}

##### A combination of query and aggregation request 

A bool query can help you answer multi-faceted questions. Before we go over the four clauses of the bool query, we need to first understand what type of questions we can ask about Michelle Obama.

Let's first figure out what headlines have been written about her.

One way to figure that out is by searching for categories of headlines that mention Michelle Obama.

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "query": {
    "Enter match or match_phrase here": { "Enter the name of the field": "Enter the value you are looking for" }
  },
  "aggregations": {
    "Name your aggregation here": {
      "Specify aggregation type here": {
        "field": "Name the field you want to aggregate here",
        "size": State how many buckets you want returned here
      }
    }
  }
}

11. Query all data that has the phrase "Michelle Obama" in the headline. Then, perform aggregations on the queried data and retrieve up to 100 categories that exist in the queried data.

GET news_headlines/_search
{
  "query": {
    "match_phrase": {
      "headline": {
        "query": "Michelle Obama"
      }
    }
  },
  "aggs": {
    "category_mentions": {
      "terms": {
        "field": "category",
        "size": 100
      }
    }
  }
}

##### The must clause

The **must clause** defines all **queries**(criteria) a document MUST match to be returned as hits. These criteria are expressed in the form of one or multiple **queries**.

All **queries** in the **must clause** must be satisfied for a document to be returned as a hit. As a result, having more **queries** in the **must clause** will increase the precision of your query.

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
        {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for" 
          }
        }
      ]
    }
  }
}

12. Query for political headline about "Michelle Obama" 

All hits must match the phrase "Michelle Obama" in the field headline and match the term "POLITICS" in the field category. 

GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_phrase": {
            "headline": "Michelle Obama"
          }
        },
        {
          "match": {
            "category": "POLITICS"
          }
        }
      ]
    }
  }
}

##### The must_not clause 

The **must_not** clause defines **queries**(criteria) a document MUST NOT match to be included in the search results.

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
       "must_not":[
         {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        }
      ]
    }
  }
}

13. Get all headline about "Michelle Obama" except for the ones that belong in the "WEDDINGS" category.

GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_phrase": {
            "headline": "Michelle Obama"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "category": "WEDDINGS"
          }
        }
      ]
    }
  }
}

##### The should clause

The **should clause** adds "nice to have" **queries**(criteria). The documents do not need to match the "nice to have" **queries** to be considered as hits. However, the ones that do will be given a higher score and are placed higher in the search results.

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here: {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
       "should":[
         {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        }
      ]
    }
  }

14. During the Black History Month, it is possible that the user may be looking up "Michelle Obama" in the context of "BLACK VOICES" category rather than in the context of "WEDDINGS", "TASTE", or "STYLE" categories. 

GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_phrase": {
            "headline": "Michelle Obama"
          }
        }
      ],
      "should": [
        {
          "match_phrase": {
            "category": "BLACK VOICES"
          }
        }
      ]
    }
  }
}

##### The filter clause

The **filter clause** contains filter **queries** that place documents into either "yes" or "no" category.

For example, let's say you are looking for headlines published within a certain time range. Some documents will fall within this range(yes) or do not fall within this range(no).

The **filter clause** only includes documents that fall within the yes category.

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        }
        ],
       "filter":{
          "range":{
             "date": {
               "gte": "Enter lowest value of the range here",
               "lte": "Enter highest value of the range here"
          }
        }
      }
    }
  }
}

14. Get all headlines about "Michelle Obama" which published within the date range "2014-03-25" and "2016-03-25"

GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_phrase": {
            "headline": "Michelle Obama"
          }
        }
      ],
      "filter": [
        {
          "range": {
            "date": {
              "gte": "2014-03-25",
              "lte": "2016-03-25"
            }
          }
        }
      ]
    }
  }
}

#### Fine-tuning the relevance of bool queries

There are many ways you can fine-tune the relevance of **bool queries**.

One of the ways is to add multiple queries under the **should clause**. 

##### Adding multiple queries under the should clause

This approach ensures that you maintain a high recall but also offers a way to present more precise search results at the top of your search results.

Syntax:

GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        }
      ],
      "should": [
        {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        },
        {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        },
        {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        }
      ]
    }
  }
}

15. Get all headlines about "Michelle Obama", and favor articles that mention her biography "Becoming", and terms like "women" and "empower".

GET news_headlines/_search 
{
  "query": {
    "bool": {
      "must": [
        {
          "match_phrase": {
            "headline": "Michelle Obama"
          }
        }
      ],
      "should": [
        {
          "match": {
            "headline": "Becoming"
          }
        },
        {
          "match": {
            "headline": "women"
          }
        },
        {
          "match": {
            "headline": "empower"
          }
        }
      ]
    }
  }
}



