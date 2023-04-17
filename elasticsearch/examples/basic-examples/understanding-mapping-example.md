### Mapping

#### Mapping Exercise

**Project**: Build an app for a client who manages a produce warehouse

**This app must enable users to:**

search for produce name, country of origin and description

identify top countries of origin with the most frequent purchase history

sort produce by produce type(Fruit or Vegetable)

get the summary of monthly expense

**Sample data**

```markdown
{
  "name": "Pineapple",
  "botanical_name": "Ananas comosus",
  "produce_type": "Fruit",
  "country_of_origin": "New Zealand",
  "date_purchased": "2020-06-02T12:15:35",
  "quantity": 200,
  "unit_price": 3.11,
  "description": "a large juicy tropical fruit consisting of aromatic edible yellow flesh surrounded by a tough segmented skin and topped with a tuft of stiff leaves.These pineapples are sourced from New Zealand.",
  "vendor_details": {
    "vendor": "Tropical Fruit Growers of New Zealand",
    "main_contact": "Hugh Rose",
    "vendor_location": "Whangarei, New Zealand",
    "preferred_vendor": true
  }
}
```

#### Defining your own mapping

##### Rules

1. If you do not define a mapping ahead of time, Elasticsearch dynamically creates the mapping for you.

2. If you do decide to define your own mapping, you can do so at index creation.

3. ONE mapping is defined per index. Once the index has been created, we can only add new fields to a mapping. We CANNOT change the mapping of an existing field.

4. If you must change the type of an existing field, you must create a new index with the desired mapping, then reindex all documents into the new index.

##### Step 1: Index a sample document into a test index.

The sample document must contain the fields that you want to define. These fields must also contain values that map closely to the field types you want.

Syntax:

```markdown
POST Name-of-test-index/_doc
{
  "field": "value"
}
```

Example:

```markdown
POST test_index/_doc
{
  "name": "Pineapple",
  "botanical_name": "Ananas comosus",
  "produce_type": "Fruit",
  "country_of_origin": "New Zealand",
  "date_purchased": "2020-06-02T12:15:35",
  "quantity": 200,
  "unit_price": 3.11,
  "description": "a large juicy tropical fruit consisting of aromatic edible yellow flesh surrounded by a tough segmented skin and topped with a tuft of stiff leaves.These pineapples are sourced from New Zealand.",
  "vendor_details": {
    "vendor": "Tropical Fruit Growers of New Zealand",
    "main_contact": "Hugh Rose",
    "vendor_location": "Whangarei, New Zealand",
    "preferred_vendor": true
  }
}
```

##### Step 2: View the dynamic mapping

Syntax:

```markdown
GET Name-the-index-whose-mapping-you-want-to-view/_mapping
```

Example:

```markdown
GET test_index/_mapping
```

##### Step 3: Edit the mapping

Copy and paste the mapping from step 2 into the Kibana console. From the pasted results, remove the "test_index" along with its opening and closing brackets. Then, edit the mapping to satisfy the requirements outlined in the figure below.

The optimized mapping should look like the following:
```markdown
{
  "mappings": {
    "properties": {
      "botanical_name": {
        "enabled": false
      },
      "country_of_origin": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "date_purchased": {
        "type": "date"
      },
      "description": {
        "type": "text"
      },
      "name": {
        "type": "text"
      },
      "produce_type": {
        "type": "keyword"
      },
      "quantity": {
        "type": "long"
      },
      "unit_price": {
        "type": "float"
      },
      "vendor_details": {
        "enabled": false
      }
    }
  }
}
```

##### Step 4: Create a new index with the optimized mapping from step 3.

Syntax:

```markdown
PUT Name-of-your-final-index
{
  copy and paste your edited mapping here
}
```

Example:

```markdown
PUT produce_index
{
  "mappings": {
    "properties": {
      "botanical_name": {
        "enabled": false
      },
      "country_of_origin": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "date_purchased": {
        "type": "date"
      },
      "description": {
        "type": "text"
      },
      "name": {
        "type": "text"
      },
      "produce_type": {
        "type": "keyword"
      },
      "quantity": {
        "type": "long"
      },
      "unit_price": {
        "type": "float"
      },
      "vendor_details": {
        "enabled": false
      }
    }
  }
}
```

##### Step 5: Check the mapping of the new index to make sure the all the fields have been mapped correctly

Syntax:

```markdown
GET Name-of-test-index/_mapping
```

Example:

```markdown
GET produce_index/_mapping
```

##### Step 6: Index your dataset into the new index

For simplicity's sake, we will index two documents.

Index the first document

```markdown
POST produce_index/_doc
{
  "name": "Pineapple",
  "botanical_name": "Ananas comosus",
  "produce_type": "Fruit",
  "country_of_origin": "New Zealand",
  "date_purchased": "2020-06-02T12:15:35",
  "quantity": 200,
  "unit_price": 3.11,
  "description": "a large juicy tropical fruit consisting of aromatic edible yellow flesh surrounded by a tough segmented skin and topped with a tuft of stiff leaves.These pineapples are sourced from New Zealand.",
  "vendor_details": {
    "vendor": "Tropical Fruit Growers of New Zealand",
    "main_contact": "Hugh Rose",
    "vendor_location": "Whangarei, New Zealand",
    "preferred_vendor": true
  }
}
```
Index the second document

The second document has almost identical fields as the first document except that it has an extra field called "organic" set to true!

```markdown
POST produce_index/_doc
{
  "name": "Mango",
  "botanical_name": "Harum Manis",
  "produce_type": "Fruit",
  "country_of_origin": "Indonesia",
  "organic": true,
  "date_purchased": "2020-05-02T07:15:35",
  "quantity": 500,
  "unit_price": 1.5,
  "description": "Mango Arumanis or Harum Manis is originated from East Java. Arumanis means harum dan manis or fragrant and sweet just like its taste. The ripe Mango Arumanis has dark green skin coated with thin grayish natural wax. The flesh is deep yellow, thick, and soft with little to no fiber. Mango Arumanis is best eaten when ripe.",
  "vendor_details": {
    "vendor": "Ayra Shezan Trading",
    "main_contact": "Suharto",
    "vendor_location": "Binjai, Indonesia",
    "preferred_vendor": true
  }
}
```

Let's see what happens to the mapping by sending this request below:

```markdown
GET produce_index/_mapping
```

#### What if you do need to make changes to the mapping of an existing field?

Let's say your client changed his mind. He wants to run only full text search on the field "botanical_name" we disabled earlier.

Remember, you CANNOT change the mapping of an existing field. If you do need to make changes to an existing field, you must create a new index with the desired mapping, then reindex all documents into the new index.

##### STEP 1: Create a new index(produce_v2) with the latest mapping.

We removed the "enabled" parameter from the field "botanical_name" and changed its type to "text".

Example:

```markdown
PUT produce_v2
{
  "mappings": {
    "properties": {
      "botanical_name": {
        "type": "text"
      },
      "country_of_origin": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "date_purchased": {
        "type": "date"
      },
      "description": {
        "type": "text"
      },
      "name": {
        "type": "text"
      },
      "organic": {
        "type": "boolean"
      },
      "produce_type": {
        "type": "keyword"
      },
      "quantity": {
        "type": "long"
      },
      "unit_price": {
        "type": "float"
      },
      "vendor_details": {
        "type": "object",
        "enabled": false
      }
    }
  }
}
```

##### View the mapping of produce_v2:

```markdown
GET produce_v2/_mapping
```

##### STEP 2: Reindex the data from the original index(produce_index) to the one you just created(produce_v2).

```markdown
POST _reindex
{
  "source": {
    "index": "produce_index"
  },
  "dest": {
    "index": "produce_v2"
  }
}
```

#### Runtime Field

##### Step 1: Create a runtime field and add it to the mapping of the existing index.

Syntax:

```markdown
PUT Enter-name-of-index/_mapping
{
  "runtime": {
    "Name-your-runtime-field-here": {
      "type": "Specify-field-type-here",
      "script": {
        "source": "Specify the formula you want executed"
      }
    }
  }
}
```

Example:

```markdown
PUT produce_v2/_mapping
{
  "runtime": {
    "total": {
      "type": "double",
      "script": {
        "source": "emit(doc['unit_price'].value* doc['quantity'].value)"
      }
    }
  }
}
```
##### Step 2: Check the mapping:

```markdown
GET produce_v2/_mapping
```

Note that the runtime field is not listed under "properties" object which includes the fields in our documents. This is because the runtime field "total" is not indexed!

##### Step 3: Run a request on the runtime field to see it perform its magic!

Please note that the following request does not aggregate the monthly expense here. We are running a simple aggregation request to demonstrate how runtime field works!

The following request runs a sum aggregation against the runtime field total of all documents in our index.

Syntax:

```markdown
GET Enter_name_of_the_index_here/_search
{
  "size": 0,
  "aggs": {
    "Name your aggregations here": {
      "Specify the aggregation type here": {
        "field": "Name the field you want to aggregate on here"
      }
    }
  }
}
```

Example:

```markdown
GET produce_v2/_search
{
  "size": 0,
  "aggs": {
    "total_expense": {
      "sum": {
        "field": "total"
      }
    }
  }
}
```
When this request is sent, a runtime field called "total" is created and calculated for documents within the scope of our request(entire index). Then, the sum aggregation is ran on the field "total" over all documents in our index.

The runtime field is only created and calculated when a request made on the runtime field is being executed. Runtime fields are not indexed so these do not take up disk space.
