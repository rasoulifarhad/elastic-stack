### Search example

[base link](https://dev.to/lisahjung/beginner-s-guide-to-running-queries-with-elasticsearch-and-kibana-4kn9)

1. Run Elasticsearch && Kibana 

> docker compose up -d

Open the Kibana console(AKA Dev Tools). 

2. Add [news headlines dataset](https://www.kaggle.com/rmisra/news-category-dataset) to Elasticsearch 

Import news headlines dataset to index news_headlines

3. Open the Kibana console(AKA Dev Tools).

Write query DSLs in the left panel of the Kibana console. Click on the query to make sure it is selected(dark grey bar) and click on the green arrow to send the query. 

4. Get information about documents in an index


> GET news_headlines/_search

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

> GET Enter_name_of_index_here/_search
> {
>   "query": {
>     "match": {
>       "Specify the field you want to search": {
>         "query": "Enter search terms"
>       }
>     }
>   }
> }

5. We want to search for news headlines about Ed Sheeran's song "Shape of you".

> GET news_headlines/_search
> {
>   "query": {
>     "match": {
>       "headline": {
>         "query": "Shape of you"
>       }
>     }
>   }
> }

It asks to search for terms "Shape" or "of" or "you" in the field headline. 

When the match query is used to search for a phrase, it has high recall but low precision.

It pulls up more loosely related documents as it uses "OR" logic by default.

It pulls up documents that contains any one of the search terms in the specified field. Moreover, the order and the proximity in which the search terms are found are not taken into account. 

#### Searching for phrases using the match_phrase query

If the order and the proximity in which the search terms are found(i.e. phrases) are important in determining the relevance of your search, you should use the match_phrase query.

Syntax:

> GET Enter_name_of_index_here/_search
> {
>   "query": {
>     "match_phrase": {
>       "Specify the field you want to search": {
>         "query": "Enter search terms"
>       }
>     }
>   }
> }

6. We want to search for news headlines about Ed Sheeran's song "Shape of you".

> GET news_headlines/_search
> {
>   "query": {
>     "match_phrase": {
>       "headline": {
>         "query": "Shape of you"
>       }
>     }
>   }
> }

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

> GET Enter_the_name_of_the_index_here/_search
> {
>   "query": {
>     "multi_match": {
>       "query": "Enter search terms here",
>       "fields": [
>         "List the field you want to search over",
>         "List the field you want to search over",
>         "List the field you want to search over"
>       ]
>     }
>   }
> }

7. Search terms "Michelle" or "Obama" in the fields headline, or short_description, or authors. 

> GET news_headlines/_search
> {
>   "query": {
>     "multi_match": {
>       "query": "Michelle Obama",
>       "fields": [
>         "headline",
>         "short_description",
>         "authors"
>         ]
>     }
>   }
> }

While the multi_match query increased the recall, it decreased the precision of the hits. 

How can we improve the precision of our search?

#### Per-field boosting 

Headlines mentioning "Michelle Obama" in the field headline are more likely to be related to our search than the headlines that mention "Michelle Obama" once or twice in the field short_description. 

To improve the precision of your search, you can designate one field to carry more weight than the others.

This can be done by boosting the score of the field headline(per-field boosting). This is notated by adding a carat(^) symbol and number 2 to the desired field as shown below.

Syntax:

> GET Enter_the_name_of_the_index_here/_search
> {
>   "query": {
>     "multi_match": {
>       "query": "Enter search terms",
>       "fields": [
>         "List field you want to boost^2",
>         "List field you want to search over",
>         "List field you want to search over"
>       ]
>     }
>   }
> }

8. Search terms "Michelle" or "Obama" in the fields headline, or short_description, or authors. documents that contain the search terms in the field headline are most relevant.

> GET news_headlines/_search
> {
>   "query": {
>     "multi_match": {
>       "query": "Michelle Obama",
>       "fields": [
>         "headline^2",
>         "short_description",
>         "authors"
>         ]
>     }
>   }
> }

9. the user remembers that she/he is throwing a party for all of her/his friends this weekend. She/He searches for news headlines regarding "party planning" to get some ideas for it. 

> GET news_headlines/_search
> {
>   "query": {
>     "multi_match": {
>       "query": "party planning",
>       "fields": [
>         "headline^2",
>         "short_description"
>       ]
>     }
>   }
> }

#### Improving precision with phrase type match 

We can improve the precision of a multi_match query by adding the "type":"phrase" to the query.

The phrase type performs a match_phrase query on each field and calculates a score for each field. Then, it assigns the highest score among the fields to the document.

Syntax:

> GET Enter_the_name_of_the_index_here/_search
> {
>   "query": {
>     "multi_match": {
>       "query": "Enter search phrase",
>       "fields": [
>         "List field you want to boost^2",
>         "List field you want to search over", 
>         "List field you want to search over"
>       ],
>       "type": "phrase"
>     }
>   }
> }

10. the user remembers that she/he is throwing a party for all of her/his friends this weekend. She/He searches for news headlines regarding "party planning" to get some ideas for it.

> GET news_headlines/_search
> {
>   "query": {
>     "multi_match": {
>       "query": "party planning",
>       "fields": [
>         "headline^2",
>         "short_description"
>       ],
>       "type": "phrase"
>     }
>   }
> }

#### Combined Queries 
