## Elasticsearch SQL

### Import Dataset

import kibana sample data flights

### Query
 
#### Simple Query

##### In SQL  

```json
GET /_sql
{
  "query": """
    SELECT 
        *
    FROM  
        kibana_sample_data_flights
    LIMIT
        5
  """
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "columns" : [
    {
      "name" : "AvgTicketPrice",
      "type" : "float"
    },
    {
      "name" : "Cancelled",
      "type" : "boolean"
    },
    {
      "name" : "Carrier",
      "type" : "keyword"
    },
    {
      "name" : "Dest",
      "type" : "keyword"
    },
    {
      "name" : "DestAirportID",
      "type" : "keyword"
    },
    {
      "name" : "DestCityName",
      "type" : "keyword"
    },
    {
      "name" : "DestCountry",
      "type" : "keyword"
    },
    {
      "name" : "DestLocation",
      "type" : "geo_point"
    },
    {
      "name" : "DestRegion",
      "type" : "keyword"
    },
    {
      "name" : "DestWeather",
      "type" : "keyword"
    },
    {
      "name" : "DistanceKilometers",
      "type" : "float"
    },
    {
      "name" : "DistanceMiles",
      "type" : "float"
    },
    {
      "name" : "FlightDelay",
      "type" : "boolean"
    },
    {
      "name" : "FlightDelayMin",
      "type" : "integer"
    },
    {
      "name" : "FlightDelayType",
      "type" : "keyword"
    },
    {
      "name" : "FlightNum",
      "type" : "keyword"
    },
    {
      "name" : "FlightTimeHour",
      "type" : "keyword"
    },
    {
      "name" : "FlightTimeMin",
      "type" : "float"
    },
    {
      "name" : "Origin",
      "type" : "keyword"
    },
    {
      "name" : "OriginAirportID",
      "type" : "keyword"
    },
    {
      "name" : "OriginCityName",
      "type" : "keyword"
    },
    {
      "name" : "OriginCountry",
      "type" : "keyword"
    },
    {
      "name" : "OriginLocation",
      "type" : "geo_point"
    },
    {
      "name" : "OriginRegion",
      "type" : "keyword"
    },
    {
      "name" : "OriginWeather",
      "type" : "keyword"
    },
    {
      "name" : "dayOfWeek",
      "type" : "integer"
    },
    {
      "name" : "timestamp",
      "type" : "datetime"
    }
  ],
  "rows" : [
    [
      841.2656,
      false,
      "Kibana Airlines",
      "Sydney Kingsford Smith International Airport",
      "SYD",
      "Sydney",
      "AU",
      "POINT (151.177002 -33.94609833)",
      "SE-BD",
      "Rain",
      16492.326,
      10247.856,
      false,
      0,
      "No Delay",
      "9HY9SWR",
      "17.179506930998397",
      1030.7704,
      "Frankfurt am Main Airport",
      "FRA",
      "Frankfurt am Main",
      "DE",
      "POINT (8.570556 50.033333)",
      "DE-HE",
      "Sunny",
      0,
      "2023-04-24T00:00:00.000Z"
    ],
    [
      882.98267,
      false,
      "Logstash Airways",
      "Venice Marco Polo Airport",
      "VE05",
      "Venice",
      "IT",
      "POINT (12.3519 45.505299)",
      "IT-34",
      "Sunny",
      8823.4,
      5482.6064,
      false,
      0,
      "No Delay",
      "X98CCZO",
      "7.73982468459836",
      464.3895,
      "Cape Town International Airport",
      "CPT",
      "Cape Town",
      "ZA",
      "POINT (18.60169983 -33.96480179)",
      "SE-BD",
      "Clear",
      0,
      "2023-04-24T18:27:00.000Z"
    ],
    [
      190.6369,
      false,
      "Logstash Airways",
      "Venice Marco Polo Airport",
      "VE05",
      "Venice",
      "IT",
      "POINT (12.3519 45.505299)",
      "IT-34",
      "Cloudy",
      0.0,
      0.0,
      false,
      0,
      "No Delay",
      "UFK2WIZ",
      "0",
      0.0,
      "Venice Marco Polo Airport",
      "VE05",
      "Venice",
      "IT",
      "POINT (12.3519 45.505299)",
      "IT-34",
      "Rain",
      0,
      "2023-04-24T17:11:14.000Z"
    ],
    [
      181.69421,
      true,
      "Kibana Airlines",
      "Treviso-Sant'Angelo Airport",
      "TV01",
      "Treviso",
      "IT",
      "POINT (12.1944 45.648399)",
      "IT-34",
      "Clear",
      555.7378,
      345.31943,
      true,
      180,
      "Weather Delay",
      "EAYQW69",
      "3.712484316503239",
      222.74905,
      "Naples International Airport",
      "NA01",
      "Naples",
      "IT",
      "POINT (14.2908 40.886002)",
      "IT-72",
      "Thunder & Lightning",
      0,
      "2023-04-24T10:33:28.000Z"
    ],
    [
      730.04175,
      false,
      "Kibana Airlines",
      "Xi'an Xianyang International Airport",
      "XIY",
      "Xi'an",
      "CN",
      "POINT (108.751999 34.447102)",
      "SE-BD",
      "Clear",
      13358.244,
      8300.428,
      false,
      0,
      "No Delay",
      "58U013N",
      "13.096317843002314",
      785.77905,
      "Licenciado Benito Juarez International Airport",
      "AICM",
      "Mexico City",
      "MX",
      "POINT (-99.072098 19.4363)",
      "MX-DIF",
      "Damaging Wind",
      0,
      "2023-04-24T05:13:00.000Z"
    ]
  ]
}
```

</details>

##### Translate to Query DSL

```json
GET /_sql/translate
{
  "query": """
    SELECT 
        *
    FROM  
        kibana_sample_data_flights
    LIMIT
        5
  """
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "size" : 5,
  "_source" : false,
  "fields" : [
    {
      "field" : "AvgTicketPrice"
    },
    {
      "field" : "Cancelled"
    },
    {
      "field" : "Carrier"
    },
    {
      "field" : "Dest"
    },
    {
      "field" : "DestAirportID"
    },
    {
      "field" : "DestCityName"
    },
    {
      "field" : "DestCountry"
    },
    {
      "field" : "DestLocation"
    },
    {
      "field" : "DestRegion"
    },
    {
      "field" : "DestWeather"
    },
    {
      "field" : "DistanceKilometers"
    },
    {
      "field" : "DistanceMiles"
    },
    {
      "field" : "FlightDelay"
    },
    {
      "field" : "FlightDelayMin"
    },
    {
      "field" : "FlightDelayType"
    },
    {
      "field" : "FlightNum"
    },
    {
      "field" : "FlightTimeHour"
    },
    {
      "field" : "FlightTimeMin"
    },
    {
      "field" : "Origin"
    },
    {
      "field" : "OriginAirportID"
    },
    {
      "field" : "OriginCityName"
    },
    {
      "field" : "OriginCountry"
    },
    {
      "field" : "OriginLocation"
    },
    {
      "field" : "OriginRegion"
    },
    {
      "field" : "OriginWeather"
    },
    {
      "field" : "dayOfWeek"
    },
    {
      "field" : "timestamp",
      "format" : "strict_date_optional_time_nanos"
    }
  ],
  "sort" : [
    {
      "_doc" : {
        "order" : "asc"
      }
    }
  ]
}
```

</details>

##### IN Query DSL

```json
GET /kibana_sample_data_flights/_search
{
  "size": 5,
  "_source": false,
  "fields": ["*"],
  "sort": [
    {
      "_doc": {
        "order": "asc"
      }
    }
  ]
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "took" : 3,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 10000,
      "relation" : "gte"
    },
    "max_score" : null,
    "hits" : [
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "PSif3IcB-Y6qIH7VG9d5",
        "_score" : null,
        "fields" : {
          "FlightNum" : [
            "9HY9SWR"
          ],
          "Origin" : [
            "Frankfurt am Main Airport"
          ],
          "OriginLocation" : [
            {
              "coordinates" : [
                8.570556,
                50.033333
              ],
              "type" : "Point"
            }
          ],
          "DestLocation" : [
            {
              "coordinates" : [
                151.177002,
                -33.94609833
              ],
              "type" : "Point"
            }
          ],
          "FlightDelay" : [
            false
          ],
          "DistanceMiles" : [
            10247.856
          ],
          "FlightTimeMin" : [
            1030.7704
          ],
          "OriginWeather" : [
            "Sunny"
          ],
          "dayOfWeek" : [
            0
          ],
          "AvgTicketPrice" : [
            841.2656
          ],
          "Carrier" : [
            "Kibana Airlines"
          ],
          "FlightDelayMin" : [
            0
          ],
          "OriginRegion" : [
            "DE-HE"
          ],
          "DestAirportID" : [
            "SYD"
          ],
          "FlightDelayType" : [
            "No Delay"
          ],
          "timestamp" : [
            "2023-04-24T00:00:00.000Z"
          ],
          "Dest" : [
            "Sydney Kingsford Smith International Airport"
          ],
          "FlightTimeHour" : [
            "17.179506930998397"
          ],
          "Cancelled" : [
            false
          ],
          "DistanceKilometers" : [
            16492.326
          ],
          "OriginCityName" : [
            "Frankfurt am Main"
          ],
          "DestWeather" : [
            "Rain"
          ],
          "OriginCountry" : [
            "DE"
          ],
          "DestCountry" : [
            "AU"
          ],
          "DestRegion" : [
            "SE-BD"
          ],
          "DestCityName" : [
            "Sydney"
          ],
          "OriginAirportID" : [
            "FRA"
          ]
        },
        "sort" : [
          0
        ]
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "Piif3IcB-Y6qIH7VG9d5",
        "_score" : null,
        "fields" : {
          "FlightNum" : [
            "X98CCZO"
          ],
          "Origin" : [
            "Cape Town International Airport"
          ],
          "OriginLocation" : [
            {
              "coordinates" : [
                18.60169983,
                -33.96480179
              ],
              "type" : "Point"
            }
          ],
          "DestLocation" : [
            {
              "coordinates" : [
                12.3519,
                45.505299
              ],
              "type" : "Point"
            }
          ],
          "FlightDelay" : [
            false
          ],
          "DistanceMiles" : [
            5482.6064
          ],
          "FlightTimeMin" : [
            464.3895
          ],
          "OriginWeather" : [
            "Clear"
          ],
          "dayOfWeek" : [
            0
          ],
          "AvgTicketPrice" : [
            882.98267
          ],
          "Carrier" : [
            "Logstash Airways"
          ],
          "FlightDelayMin" : [
            0
          ],
          "OriginRegion" : [
            "SE-BD"
          ],
          "DestAirportID" : [
            "VE05"
          ],
          "FlightDelayType" : [
            "No Delay"
          ],
          "timestamp" : [
            "2023-04-24T18:27:00.000Z"
          ],
          "Dest" : [
            "Venice Marco Polo Airport"
          ],
          "FlightTimeHour" : [
            "7.73982468459836"
          ],
          "Cancelled" : [
            false
          ],
          "DistanceKilometers" : [
            8823.4
          ],
          "OriginCityName" : [
            "Cape Town"
          ],
          "DestWeather" : [
            "Sunny"
          ],
          "OriginCountry" : [
            "ZA"
          ],
          "DestCountry" : [
            "IT"
          ],
          "DestRegion" : [
            "IT-34"
          ],
          "DestCityName" : [
            "Venice"
          ],
          "OriginAirportID" : [
            "CPT"
          ]
        },
        "sort" : [
          1
        ]
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "Pyif3IcB-Y6qIH7VG9d5",
        "_score" : null,
        "fields" : {
          "FlightNum" : [
            "UFK2WIZ"
          ],
          "Origin" : [
            "Venice Marco Polo Airport"
          ],
          "OriginLocation" : [
            {
              "coordinates" : [
                12.3519,
                45.505299
              ],
              "type" : "Point"
            }
          ],
          "DestLocation" : [
            {
              "coordinates" : [
                12.3519,
                45.505299
              ],
              "type" : "Point"
            }
          ],
          "FlightDelay" : [
            false
          ],
          "DistanceMiles" : [
            0.0
          ],
          "FlightTimeMin" : [
            0.0
          ],
          "OriginWeather" : [
            "Rain"
          ],
          "dayOfWeek" : [
            0
          ],
          "AvgTicketPrice" : [
            190.6369
          ],
          "Carrier" : [
            "Logstash Airways"
          ],
          "FlightDelayMin" : [
            0
          ],
          "OriginRegion" : [
            "IT-34"
          ],
          "DestAirportID" : [
            "VE05"
          ],
          "FlightDelayType" : [
            "No Delay"
          ],
          "timestamp" : [
            "2023-04-24T17:11:14.000Z"
          ],
          "Dest" : [
            "Venice Marco Polo Airport"
          ],
          "FlightTimeHour" : [
            "0"
          ],
          "Cancelled" : [
            false
          ],
          "DistanceKilometers" : [
            0.0
          ],
          "OriginCityName" : [
            "Venice"
          ],
          "DestWeather" : [
            "Cloudy"
          ],
          "OriginCountry" : [
            "IT"
          ],
          "DestCountry" : [
            "IT"
          ],
          "DestRegion" : [
            "IT-34"
          ],
          "DestCityName" : [
            "Venice"
          ],
          "OriginAirportID" : [
            "VE05"
          ]
        },
        "sort" : [
          2
        ]
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "QCif3IcB-Y6qIH7VG9d5",
        "_score" : null,
        "fields" : {
          "FlightNum" : [
            "EAYQW69"
          ],
          "Origin" : [
            "Naples International Airport"
          ],
          "OriginLocation" : [
            {
              "coordinates" : [
                14.2908,
                40.886002
              ],
              "type" : "Point"
            }
          ],
          "DestLocation" : [
            {
              "coordinates" : [
                12.1944,
                45.648399
              ],
              "type" : "Point"
            }
          ],
          "FlightDelay" : [
            true
          ],
          "DistanceMiles" : [
            345.31943
          ],
          "FlightTimeMin" : [
            222.74905
          ],
          "OriginWeather" : [
            "Thunder & Lightning"
          ],
          "dayOfWeek" : [
            0
          ],
          "AvgTicketPrice" : [
            181.69421
          ],
          "Carrier" : [
            "Kibana Airlines"
          ],
          "FlightDelayMin" : [
            180
          ],
          "OriginRegion" : [
            "IT-72"
          ],
          "DestAirportID" : [
            "TV01"
          ],
          "FlightDelayType" : [
            "Weather Delay"
          ],
          "timestamp" : [
            "2023-04-24T10:33:28.000Z"
          ],
          "Dest" : [
            "Treviso-Sant'Angelo Airport"
          ],
          "FlightTimeHour" : [
            "3.712484316503239"
          ],
          "Cancelled" : [
            true
          ],
          "DistanceKilometers" : [
            555.7378
          ],
          "OriginCityName" : [
            "Naples"
          ],
          "DestWeather" : [
            "Clear"
          ],
          "OriginCountry" : [
            "IT"
          ],
          "DestCountry" : [
            "IT"
          ],
          "DestRegion" : [
            "IT-34"
          ],
          "DestCityName" : [
            "Treviso"
          ],
          "OriginAirportID" : [
            "NA01"
          ]
        },
        "sort" : [
          3
        ]
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "QSif3IcB-Y6qIH7VG9d5",
        "_score" : null,
        "fields" : {
          "FlightNum" : [
            "58U013N"
          ],
          "Origin" : [
            "Licenciado Benito Juarez International Airport"
          ],
          "OriginLocation" : [
            {
              "coordinates" : [
                -99.072098,
                19.4363
              ],
              "type" : "Point"
            }
          ],
          "DestLocation" : [
            {
              "coordinates" : [
                108.751999,
                34.447102
              ],
              "type" : "Point"
            }
          ],
          "FlightDelay" : [
            false
          ],
          "DistanceMiles" : [
            8300.428
          ],
          "FlightTimeMin" : [
            785.77905
          ],
          "OriginWeather" : [
            "Damaging Wind"
          ],
          "dayOfWeek" : [
            0
          ],
          "AvgTicketPrice" : [
            730.04175
          ],
          "Carrier" : [
            "Kibana Airlines"
          ],
          "FlightDelayMin" : [
            0
          ],
          "OriginRegion" : [
            "MX-DIF"
          ],
          "DestAirportID" : [
            "XIY"
          ],
          "FlightDelayType" : [
            "No Delay"
          ],
          "timestamp" : [
            "2023-04-24T05:13:00.000Z"
          ],
          "Dest" : [
            "Xi'an Xianyang International Airport"
          ],
          "FlightTimeHour" : [
            "13.096317843002314"
          ],
          "Cancelled" : [
            false
          ],
          "DistanceKilometers" : [
            13358.244
          ],
          "OriginCityName" : [
            "Mexico City"
          ],
          "DestWeather" : [
            "Clear"
          ],
          "OriginCountry" : [
            "MX"
          ],
          "DestCountry" : [
            "CN"
          ],
          "DestRegion" : [
            "SE-BD"
          ],
          "DestCityName" : [
            "Xi'an"
          ],
          "OriginAirportID" : [
            "AICM"
          ]
        },
        "sort" : [
          4
        ]
      }
    ]
  }
}
```

</details>


#### Query with filter

##### In SQL

```json
GET /_sql?format=txt
{
  "query": """
    SELECT 
        FlightNum as FlightNumber,
        OriginCountry,
        Origin,
        DestCountry as DestinationCountry,
        Dest as Destination
    FROM  
        kibana_sample_data_flights
    WHERE 
        FlightNum = '9HY9SWR'
  """
}
``` 

<details>
<summary>Response:</summary>

```
 FlightNumber  | OriginCountry |         Origin          |DestinationCountry|                Destination                 
---------------+---------------+-------------------------+------------------+--------------------------------------------
9HY9SWR        |DE             |Frankfurt am Main Airport|AU                |Sydney Kingsford Smith International Airport

```

</details>

##### Translate to Query DSL

```json
GET /_sql/translate
{
  "query": """
    SELECT 
        FlightNum as FlightNumber,
        OriginCountry,
        Origin,
        DestCountry as DestinationCountry,
        Dest as Destination
    FROM  
        kibana_sample_data_flights
    WHERE 
        FlightNum = '9HY9SWR'
  """
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "size" : 1000,
  "query" : {
    "term" : {
      "FlightNum" : {
        "value" : "9HY9SWR",
        "boost" : 1.0
      }
    }
  },
  "_source" : false,
  "fields" : [
    {
      "field" : "FlightNum"
    },
    {
      "field" : "OriginCountry"
    },
    {
      "field" : "Origin"
    },
    {
      "field" : "DestCountry"
    },
    {
      "field" : "Dest"
    }
  ],
  "sort" : [
    {
      "_doc" : {
        "order" : "asc"
      }
    }
  ]
}
```

</details>

##### IN Query DSL

```json
GET /kibana_sample_data_flights/_search
{
  "size" : 1000,
  "query" : {
    "term" : {
      "FlightNum" : {
        "value" : "9HY9SWR",
        "boost" : 1.0
      }
    }
  },
  "_source" : false,
  "fields" : ["FlightNum", "OriginCountry", "Origin", "DestCountry", "Dest"],
  "sort" : [
    {
      "_doc" : {
        "order" : "asc"
      }
    }
  ]
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "PSif3IcB-Y6qIH7VG9d5",
        "_score" : null,
        "fields" : {
          "FlightNum" : [
            "9HY9SWR"
          ],
          "Origin" : [
            "Frankfurt am Main Airport"
          ],
          "Dest" : [
            "Sydney Kingsford Smith International Airport"
          ],
          "OriginCountry" : [
            "DE"
          ],
          "DestCountry" : [
            "AU"
          ]
        },
        "sort" : [
          0
        ]
      }
    ]
  }
}
```

</details>



#### Uing wildcard

##### In SQL

```json
GET /_sql?format=txt
{
  "query": """
    SELECT 
        FlightNum as FlightNumber,
        OriginCountry,
        Origin,
        Dest as DestinationAirport
    FROM  
        "*flights*"
    WHERE 
        FlightNum = '9HY9SWR'
  """
}
``` 

<details>
<summary>Response:</summary>

```
 FlightNumber  | OriginCountry |         Origin          |             DestinationAirport             
---------------+---------------+-------------------------+--------------------------------------------
9HY9SWR        |DE             |Frankfurt am Main Airport|Sydney Kingsford Smith International Airport

```

</details>

##### Translate to Query DSL

```json
GET /_sql/translate
{
  "query": """
    SELECT 
        FlightNum as FlightNumber,
        OriginCountry,
        Origin,
        Dest as DestinationAirport
    FROM  
        "*flights*"
    WHERE 
        FlightNum = '9HY9SWR'
  """
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "size" : 1000,
  "query" : {
    "term" : {
      "FlightNum" : {
        "value" : "9HY9SWR",
        "boost" : 1.0
      }
    }
  },
  "_source" : false,
  "fields" : [
    {
      "field" : "FlightNum"
    },
    {
      "field" : "OriginCountry"
    },
    {
      "field" : "Origin"
    },
    {
      "field" : "Dest"
    }
  ],
  "sort" : [
    {
      "_doc" : {
        "order" : "asc"
      }
    }
  ]
}
```

</details>

##### IN Query DSL

```json
GET /*flights*/_search
{
  "size" : 1000,
  "query" : {
    "term" : {
      "FlightNum" : {
        "value" : "9HY9SWR",
        "boost" : 1.0
      }
    }
  },
  "_source" : false,
  "fields" : ["FlightNum", "OriginCountry", "Origin", "Dest"],
  "sort" : [
    {
      "_doc" : {
        "order" : "asc"
      }
    }
  ]
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "PSif3IcB-Y6qIH7VG9d5",
        "_score" : null,
        "fields" : {
          "FlightNum" : [
            "9HY9SWR"
          ],
          "Origin" : [
            "Frankfurt am Main Airport"
          ],
          "Dest" : [
            "Sydney Kingsford Smith International Airport"
          ],
          "OriginCountry" : [
            "DE"
          ]
        },
        "sort" : [
          0
        ]
      }
    ]
  }
}
```

</details>



#### Example 1

##### In SQL

```json
GET /_sql
{
  "query": """
    SELECT 
      MIN(DistanceMiles) AS MinDistance,
      MAX(DistanceMiles) AS MaxDistance,
      AVG(DistanceMiles) AS AverageDistance
    FROM 
      kibana_sample_data_flights
    WHERE 
        OriginCountry = 'US'
    LIMIT 10
  """
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "columns" : [
    {
      "name" : "MinDistance",
      "type" : "float"
    },
    {
      "name" : "MaxDistance",
      "type" : "float"
    },
    {
      "name" : "AverageDistance",
      "type" : "double"
    }
  ],
  "rows" : [
    [
      0.0,
      10556.7587890625,
      4511.919892461225
    ]
  ]
}
```

</details>

##### Translate to Query DSL

```json
GET /_sql/translate
{
  "query": """
    SELECT 
      MIN(DistanceMiles) AS MinDistance,
      MAX(DistanceMiles) AS MaxDistance,
      AVG(DistanceMiles) AS AverageDistance
    FROM 
      kibana_sample_data_flights
    WHERE 
        OriginCountry = 'US'
    LIMIT 10
  """
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "size" : 0,
  "query" : {
    "term" : {
      "OriginCountry" : {
        "value" : "US",
        "boost" : 1.0
      }
    }
  },
  "_source" : false,
  "aggregations" : {
    "groupby" : {
      "filters" : {
        "filters" : [
          {
            "match_all" : {
              "boost" : 1.0
            }
          }
        ],
        "other_bucket" : false,
        "other_bucket_key" : "_other_"
      },
      "aggregations" : {
        "6368e806" : {
          "stats" : {
            "field" : "DistanceMiles"
          }
        }
      }
    }
  }
}
```

</details>

##### IN Query DSL

```json
GET /kibana_sample_data_flights/_search
{
  "size" : 0,
  "query" : {
    "term" : {
      "OriginCountry" : {
        "value" : "US"
      }
    }
  },
  "_source" : false,
  "aggs": {
    "stats_aggs": {
      "stats": {
        "field": "DistanceMiles"
      }
    }
  }
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2001,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  },
  "aggregations" : {
    "stats_aggs" : {
      "count" : 2001,
      "min" : 0.0,
      "max" : 10556.7587890625,
      "avg" : 4511.919892461225,
      "sum" : 9028351.70481491
    }
  }
}
```

</details>



#### Example 1

##### In SQL

```json
GET /_sql?format=txt
{
  "query": """
    SELECT 
      DAY_OF_WEEK(timestamp) AS WeekDayNum,
      DAY_NAME(timestamp) AS WeekDay,
      COUNT(*) AS Flights
    FROM 
      kibana_sample_data_flights
    GROUP BY
      WeekDayNum, WeekDay
    ORDER BY 
      WeekDayNum
  """
}
``` 

<details>
<summary>Response:</summary>

```json
  WeekDayNum   |    WeekDay    |    Flights    
---------------+---------------+---------------
1              |Sunday         |1314           
2              |Monday         |2033           
3              |Tuesday        |1934           
4              |Wednesday      |1948           
5              |Thursday       |1914           
6              |Friday         |2001           
7              |Saturday       |1915           

```

</details>

##### Translate to Query DSL

```json
GET /_sql/translate
{
  "query": """
    SELECT 
      DAY_OF_WEEK(timestamp) AS WeekDayNum,
      DAY_NAME(timestamp) AS WeekDay,
      COUNT(*) AS Flights
    FROM 
      kibana_sample_data_flights
    GROUP BY
      WeekDayNum, WeekDay
    ORDER BY 
      WeekDayNum
  """
}
``` 

<details>
<summary>Response:</summary>

```json
{
  "size" : 0,
  "_source" : false,
  "aggregations" : {
    "groupby" : {
      "composite" : {
        "size" : 1000,
        "sources" : [
          {
            "6d53abe9" : {
              "terms" : {
                "script" : {
                  "source" : "InternalSqlScriptUtils.dayOfWeek(InternalQlScriptUtils.docValue(doc,params.v0), params.v1)",
                  "lang" : "painless",
                  "params" : {
                    "v0" : "timestamp",
                    "v1" : "Z"
                  }
                },
                "missing_bucket" : true,
                "value_type" : "long",
                "order" : "asc"
              }
            }
          },
          {
            "e609ec01" : {
              "terms" : {
                "script" : {
                  "source" : "InternalSqlScriptUtils.dayName(InternalQlScriptUtils.docValue(doc,params.v0), params.v1)",
                  "lang" : "painless",
                  "params" : {
                    "v0" : "timestamp",
                    "v1" : "Z"
                  }
                },
                "missing_bucket" : true,
                "value_type" : "string",
                "order" : "asc"
              }
            }
          }
        ]
      }
    }
  }
}
```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>



#### Example 1

##### In SQL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### Translate to Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>

##### IN Query DSL

```json

``` 

<details>
<summary>Response:</summary>

```json

```

</details>




