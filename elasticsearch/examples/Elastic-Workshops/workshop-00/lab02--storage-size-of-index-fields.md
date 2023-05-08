### Storage size of index fields with _disk_usage API

from [elasticsearch-field-size-calculating-storage-size-of-index-fields](https://opster.com/guides/elasticsearch/data-architecture/elasticsearch-field-size-calculating-storage-size-of-index-fields/)

####  Create indices

> The _disk_usage API is available since ES 7.15 and provides an analysis of the disk usage of each field of an index or data stream.
> 

##### Creating an index that includes all fields

<details><summary><i>Define Index</i></summary>

```json
PUT all_fields_idx
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ngram_analyzer": {
          "tokenizer": "my_tokenizer"
        }
      },
      "tokenizer": {
        "my_tokenizer": {
          "type": "ngram",
          "min_gram": 1,
          "max_gram": 10,
          "token_chars": [
            "letter",
            "digit"
          ]
        }
      }
    },
    "max_ngram_diff": 25
  },
  "mappings": {
    "properties": {
      "first_name": {
        "type": "text",
        "analyzer": "ngram_analyzer"
      }
    }
  }
}
```

</details>

##### Bulk Index Documents 

<details><summary><i>Bulk ingest data</i></summary>

```json
POST all_fields_idx/_bulk
{ "index": {}}
{ "name": "Nelson Mandela","first_name": "Nelson"}
{ "index": {}}
{ "name": "Pope Francis","first_name": "Pope"}
{ "index": {}}
{ "name": "Elon Musk","first_name": "Elon"}
{ "index": {}}
{ "name": "Mahatma Gandhi","first_name": "Mahatma"}
{ "index": {}}
{ "name": "Bill Gates","first_name": "Bill"}
{ "index": {}}
{ "name": "Barack Obama","first_name": "Barack"}
{ "index": {}}
{ "name": "Richard Branson","first_name": "Richard"}
{ "index": {}}
{ "name": "Steve Jobs","first_name": "Steve"}
{ "index": {}}
{ "name": "Mohammad Yunus","first_name": "Mohammad"}
{ "index": {}}
{ "name": "Narendra Modi","first_name": "Narendra"}
{ "index": {}}
{ "name": "Abraham Lincoln","first_name": "Abraham"}
{ "index": {}}
{ "name": "Coco Chanel","first_name": "Coco"}
{ "index": {}}
{ "name": "Anne Frank","first_name": "Anne"}
{ "index": {}}
{ "name": "Albert Einstein","first_name": "Albert"}
{ "index": {}}
{ "name": "Walt Disney","first_name": "Walt"}
{ "index": {}}
{ "name": "Sachin Tendulkar","first_name": "Sachin"}
{ "index": {}}
{ "name": "Michael Jackson","first_name": "Michael"}
{ "index": {}}
{ "name": "Marilyn Monroe","first_name": "Marilyn"}
{ "index": {}}
{ "name": "Kalpana Chawla ","first_name": "Kalpana"}
{ "index": {}}
{ "name": "Rosa Parks","first_name": "Rosa"}
```

</details>

##### Creating an index that includes only first_name field

```json
PUT first_name_idx
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ngram_analyzer": {
          "tokenizer": "my_tokenizer"
        }
      },
      "tokenizer": {
        "my_tokenizer": {
          "type": "ngram",
          "min_gram": 1,
          "max_gram": 10,
          "token_chars": [
            "letter",
            "digit"
          ]
        }
      }
    },
    "max_ngram_diff": 25
  },
  "mappings": {
    "dynamic": "false",
    "properties": {
      "first_name": {
        "type": "text",
        "analyzer": "ngram_analyzer"
      }
    }
  }
}
```

##### index the documents from all_fields_idx to first_name_idx

```json
POST _reindex
{
  "source": {
    "index": "all_fields_idx"
  },
  "dest": {
    "index": "first_name_idx"
  }
}
```

<details open><summary><i>Test analyzer</i></summary><blockquote>

```json
GET /first_name_idx/_analyze
{
  "analyzer": "ngram_analyzer",
  "text": "Anne Frank"
}
```

<details><summary><i>Response:</i></summary>

```json
{
  "tokens" : [
    {
      "token" : "A",
      "start_offset" : 0,
      "end_offset" : 1,
      "type" : "word",
      "position" : 0
    },
    {
      "token" : "An",
      "start_offset" : 0,
      "end_offset" : 2,
      "type" : "word",
      "position" : 1
    },
    {
      "token" : "Ann",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "word",
      "position" : 2
    },
    {
      "token" : "Anne",
      "start_offset" : 0,
      "end_offset" : 4,
      "type" : "word",
      "position" : 3
    },
    {
      "token" : "n",
      "start_offset" : 1,
      "end_offset" : 2,
      "type" : "word",
      "position" : 4
    },
    {
      "token" : "nn",
      "start_offset" : 1,
      "end_offset" : 3,
      "type" : "word",
      "position" : 5
    },
    {
      "token" : "nne",
      "start_offset" : 1,
      "end_offset" : 4,
      "type" : "word",
      "position" : 6
    },
    {
      "token" : "n",
      "start_offset" : 2,
      "end_offset" : 3,
      "type" : "word",
      "position" : 7
    },
    {
      "token" : "ne",
      "start_offset" : 2,
      "end_offset" : 4,
      "type" : "word",
      "position" : 8
    },
    {
      "token" : "e",
      "start_offset" : 3,
      "end_offset" : 4,
      "type" : "word",
      "position" : 9
    },
    {
      "token" : "F",
      "start_offset" : 5,
      "end_offset" : 6,
      "type" : "word",
      "position" : 10
    },
    {
      "token" : "Fr",
      "start_offset" : 5,
      "end_offset" : 7,
      "type" : "word",
      "position" : 11
    },
    {
      "token" : "Fra",
      "start_offset" : 5,
      "end_offset" : 8,
      "type" : "word",
      "position" : 12
    },
    {
      "token" : "Fran",
      "start_offset" : 5,
      "end_offset" : 9,
      "type" : "word",
      "position" : 13
    },
    {
      "token" : "Frank",
      "start_offset" : 5,
      "end_offset" : 10,
      "type" : "word",
      "position" : 14
    },
    {
      "token" : "r",
      "start_offset" : 6,
      "end_offset" : 7,
      "type" : "word",
      "position" : 15
    },
    {
      "token" : "ra",
      "start_offset" : 6,
      "end_offset" : 8,
      "type" : "word",
      "position" : 16
    },
    {
      "token" : "ran",
      "start_offset" : 6,
      "end_offset" : 9,
      "type" : "word",
      "position" : 17
    },
    {
      "token" : "rank",
      "start_offset" : 6,
      "end_offset" : 10,
      "type" : "word",
      "position" : 18
    },
    {
      "token" : "a",
      "start_offset" : 7,
      "end_offset" : 8,
      "type" : "word",
      "position" : 19
    },
    {
      "token" : "an",
      "start_offset" : 7,
      "end_offset" : 9,
      "type" : "word",
      "position" : 20
    },
    {
      "token" : "ank",
      "start_offset" : 7,
      "end_offset" : 10,
      "type" : "word",
      "position" : 21
    },
    {
      "token" : "n",
      "start_offset" : 8,
      "end_offset" : 9,
      "type" : "word",
      "position" : 22
    },
    {
      "token" : "nk",
      "start_offset" : 8,
      "end_offset" : 10,
      "type" : "word",
      "position" : 23
    },
    {
      "token" : "k",
      "start_offset" : 9,
      "end_offset" : 10,
      "type" : "word",
      "position" : 24
    }
  ]
}
```

</details>

<blockquote></details>

##### Creating an index that includes only name field

```json
PUT name_idx
{
  "mappings": {
    "dynamic": "false",
    "properties": {
      "name": {
        "type": "text"
      }
    }
  }
}
```

##### index the documents from all_fields_idx to  name_idx

```json
POST _reindex
{
  "source": {
    "index": "all_fields_idx"
  },
  "dest": {
    "index": "name_idx"
  }
}
```

##### Creating an index that includes only name field of keyword type

```json
PUT name_keyword_idx
{
  "mappings": {
    "dynamic": "false",
    "properties": {
      "name": {
        "type": "keyword"
      }
    }
  }
}
```

##### index the documents from all_fields_idx to  name_keyword_idx

```json
POST /_reindex
{
  "source": {
    "index": "all_fields_idx"
  },
  "dest": {
    "index": "name_keyword_idx"
  }
}
```

#### Comparing the storage size between the indices

> We can check the primary storage size of each index using the CAT indices API:
> 

<details open><summary><i>cat api</i></summary><blockquote>

```json
GET _cat/indices/*_idx?v
```
<details><summary><i>Response:</i></summary>

```
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   first_name_idx   mSMi8utPTYOCA9OWeaEDVw   1   1         20            0      7.1kb          7.1kb
yellow open   name_idx         Ip3gFo3MSci7LfJrXyuIqA   1   1         20            0      4.9kb          4.9kb
yellow open   all_fields_idx   ijYgMSvjRaWoVxMYrWawPA   1   1         20            0      8.6kb          8.6kb
yellow open   name_keyword_idx XIFC4-UERpuuHa39HNTUQg   1   1         20            0        5kb            5kb
```

</details>

</blockquote></details>

#### Comparing the storage size between the indices with _disk_usage

<details open><summary><i>Analyze index disk usage API</i></summary><blockquote>

```json
POST /*_idx/_disk_usage?run_expensive_tasks=true&filter_path=*.store_size,*.all_fields
```

<details><summary><i>Response:</i></summary>

```json
{
  "all_fields_idx" : {
    "store_size" : "8.6kb",
    "all_fields" : {
      "total" : "4.6kb",
      "total_in_bytes" : 4802,
      "inverted_index" : {
        "total" : "3.5kb",
        "total_in_bytes" : 3653
      },
      "stored_fields" : "747b",
      "stored_fields_in_bytes" : 747,
      "doc_values" : "310b",
      "doc_values_in_bytes" : 310,
      ....
    }
  },
  "first_name_idx" : {
    "store_size" : "7.1kb",
    "all_fields" : {
      "total" : "3.7kb",
      "total_in_bytes" : 3804,
      "inverted_index" : {
        "total" : "2.8kb",
        "total_in_bytes" : 2945
      },
      "stored_fields" : "747b",
      "stored_fields_in_bytes" : 747,
      "doc_values" : "20b",
      "doc_values_in_bytes" : 20,
      ....
    }
  },
  "name_idx" : {
    "store_size" : "4.9kb",
    "all_fields" : {
      "total" : "1.5kb",
      "total_in_bytes" : 1570,
      "inverted_index" : {
        "total" : "731b",
        "total_in_bytes" : 731
      },
      "stored_fields" : "747b",
      "stored_fields_in_bytes" : 747,
      "doc_values" : "20b",
      "doc_values_in_bytes" : 20,
      ....
    }
  },
  "name_keyword_idx" : {
    "store_size" : "5kb",
    "all_fields" : {
      "total" : "1.7kb",
      "total_in_bytes" : 1761,
      "inverted_index" : {
        "total" : "632b",
        "total_in_bytes" : 632
      },
      "stored_fields" : "747b",
      "stored_fields_in_bytes" : 747,
      "doc_values" : "310b",
      "doc_values_in_bytes" : 310,
      ....
    }
  }
}
```

</details>

</blockquote></details>

