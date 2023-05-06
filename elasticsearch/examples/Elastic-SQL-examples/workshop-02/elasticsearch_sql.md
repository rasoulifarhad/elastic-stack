## Elasticsearch SQL



#### Import Dataset

---
> ***Import kibana*** [Sample data flights](https://github.com/rasoulifarhad/elastic-stack/blob/main/kibana/add-sample-data.md#sample-flight-data)
>  

#### Simple Query
---

<details>
<summary>In SQL</summary>

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

  </details> 
   
  <details>
  <summary>Translate to Query DSL</summary>

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

  </details>
   
  <details>
  <summary>IN Query DSL</summary>
  
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

   </details>
   
#### Query with filter
---

  <details>
  <summary>In SQL</summary>

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

  </details>
   
  <details>
  <summary>Translate to Query DSL</summary>

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
  
  </details>

  <details>
  <summary>IN Query DSL</summary>

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

  </details>

#### Using wildcard
---

  <details>
  <summary>In SQL</summary>

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

  </details>

  <details>
  <summary>Translate to Query DSL</summary>

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

  </details>

  <details>
  <summary>IN Query DSL</summary>

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

  </details>

#### Using `min`, `max` and `avg` functions
---

  <details>
  <summary>In SQL</summary>

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

  </details>
   
  <details>
  <summary>Translate to Query DSL</summary>

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

  </details>
   
  <details>
  <summary>IN Query DSL</summary>

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

  </details>

#### Group by on functions
---

  <details>
  <summary>In SQL</summary>

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

  </details>

  <details>
  <summary>Translate to Query DSL</summary>

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

  </details>

  <details>
  <summary>IN Query DSL</summary>

  ```json
  GET /kibana_sample_data_flights/_search
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

  <details>
  <summary>Response:</summary>

  ```json
  {
    "took" : 18,
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
      "hits" : [ ]
    },
    "aggregations" : {
      "groupby" : {
        "after_key" : {
          "6d53abe9" : 7,
          "e609ec01" : "Saturday"
        },
        "buckets" : [
          {
            "key" : {
              "6d53abe9" : 1,
              "e609ec01" : "Sunday"
            },
            "doc_count" : 1314
          },
          {
            "key" : {
              "6d53abe9" : 2,
              "e609ec01" : "Monday"
            },
            "doc_count" : 2033
          },
          {
            "key" : {
              "6d53abe9" : 3,
              "e609ec01" : "Tuesday"
            },
            "doc_count" : 1934
          },
          {
            "key" : {
              "6d53abe9" : 4,
              "e609ec01" : "Wednesday"
            },
            "doc_count" : 1948
          },
          {
            "key" : {
              "6d53abe9" : 5,
              "e609ec01" : "Thursday"
            },
            "doc_count" : 1914
          },
          {
            "key" : {
              "6d53abe9" : 6,
              "e609ec01" : "Friday"
            },
            "doc_count" : 2001
          },
          {
            "key" : {
              "6d53abe9" : 7,
              "e609ec01" : "Saturday"
            },
            "doc_count" : 1915
          }
        ]
      }
    }
  }
  ```

  </details>

  </details>
  
#### Conditional select
---

  <details open>
  <summary>In SQL</summary>

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT 
        CASE WHEN DAY_OF_WEEK(timestamp) = 1 THEN 7
             ELSE DAY_OF_WEEK(timestamp) - 1 
        END AS WeekDayNum,
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
  1              |Monday         |2033           
  2              |Tuesday        |1934           
  3              |Wednesday      |1948           
  4              |Thursday       |1914           
  5              |Friday         |2001           
  6              |Saturday       |1915           
  7              |Sunday         |1314           

  ```

  </details>

  </details>
  
  <details>
  <summary>Translate to Query DSL</summary>

  ```json
  GET /_sql/translate
  {
    "query": """
      SELECT 
        CASE WHEN DAY_OF_WEEK(timestamp) = 1 THEN 7
             ELSE DAY_OF_WEEK(timestamp) - 1 
        END AS WeekDayNum,
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
              "f10a0f42" : {
                "terms" : {
                  "script" : {
                    "source" : "InternalQlScriptUtils.nullSafeFilter(InternalQlScriptUtils.eq(InternalSqlScriptUtils.dayOfWeek(InternalQlScriptUtils.docValue(doc,params.v0), params.v1),params.v2)) ? params.v3 : InternalSqlScriptUtils.sub(InternalSqlScriptUtils.dayOfWeek(InternalQlScriptUtils.docValue(doc,params.v4), params.v5),params.v6)",
                    "lang" : "painless",
                    "params" : {
                      "v0" : "timestamp",
                      "v1" : "Z",
                      "v2" : 1,
                      "v3" : 7,
                      "v4" : "timestamp",
                      "v5" : "Z",
                      "v6" : 1
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

  </details>

  <details>
  <summary>IN Query DSL</summary>

  ```json
  GET /kibana_sample_data_flights/_search
  {
    "size" : 0,
    "_source" : false,
    "aggregations" : {
      "groupby" : {
        "composite" : {
          "size" : 1000,
          "sources" : [
            {
              "f10a0f42" : {
                "terms" : {
                  "script" : {
                    "source" : "InternalQlScriptUtils.nullSafeFilter(InternalQlScriptUtils.eq(InternalSqlScriptUtils.dayOfWeek(InternalQlScriptUtils.docValue(doc,params.v0), params.v1),params.v2)) ? params.v3 : InternalSqlScriptUtils.sub(InternalSqlScriptUtils.dayOfWeek(InternalQlScriptUtils.docValue(doc,params.v4), params.v5),params.v6)",
                    "lang" : "painless",
                    "params" : {
                      "v0" : "timestamp",
                      "v1" : "Z",
                      "v2" : 1,
                      "v3" : 7,
                      "v4" : "timestamp",
                      "v5" : "Z",
                      "v6" : 1
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

  <details>
  <summary>Response:</summary>

  ```json
  {
    "took" : 9,
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
      "hits" : [ ]
    },
    "aggregations" : {
      "groupby" : {
        "after_key" : {
          "f10a0f42" : 7,
          "e609ec01" : "Sunday"
        },
        "buckets" : [
          {
            "key" : {
              "f10a0f42" : 1,
              "e609ec01" : "Monday"
            },
            "doc_count" : 2033
          },
          {
            "key" : {
              "f10a0f42" : 2,
              "e609ec01" : "Tuesday"
            },
            "doc_count" : 1934
          },
          {
            "key" : {
              "f10a0f42" : 3,
              "e609ec01" : "Wednesday"
            },
            "doc_count" : 1948
          },
          {
            "key" : {
              "f10a0f42" : 4,
              "e609ec01" : "Thursday"
            },
            "doc_count" : 1914
          },
          {
            "key" : {
              "f10a0f42" : 5,
              "e609ec01" : "Friday"
            },
            "doc_count" : 2001
          },
          {
            "key" : {
              "f10a0f42" : 6,
              "e609ec01" : "Saturday"
            },
            "doc_count" : 1915
          },
          {
            "key" : {
              "f10a0f42" : 7,
              "e609ec01" : "Sunday"
            },
            "doc_count" : 1314
          }
        ]
      }
    }
  }
  ```

  </details>

  </details>
  
#### Show indices
---

  <details open>
  <summary>In SQL</summary>

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SHOW TABLES
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```
         catalog       |             name              |     type      |     kind      
  ---------------------+-------------------------------+---------------+---------------
  elasticsearch-cluster|.apm-agent-configuration       |TABLE          |INDEX          
  elasticsearch-cluster|.apm-custom-link               |TABLE          |INDEX          
  elasticsearch-cluster|.kibana                        |VIEW           |ALIAS          
  elasticsearch-cluster|.kibana_7.17.9                 |VIEW           |ALIAS          
  elasticsearch-cluster|.kibana_7.17.9_001             |TABLE          |INDEX          
  elasticsearch-cluster|.kibana_task_manager           |VIEW           |ALIAS          
  elasticsearch-cluster|.kibana_task_manager_7.17.9    |VIEW           |ALIAS          
  elasticsearch-cluster|.kibana_task_manager_7.17.9_001|TABLE          |INDEX          
  elasticsearch-cluster|.security                      |VIEW           |ALIAS          
  elasticsearch-cluster|.security-7                    |TABLE          |INDEX          
  elasticsearch-cluster|.tasks                         |TABLE          |INDEX          
  elasticsearch-cluster|kibana_sample_data_ecommerce   |TABLE          |INDEX          
  elasticsearch-cluster|kibana_sample_data_flights     |TABLE          |INDEX          
  elasticsearch-cluster|my-index-000001                |TABLE          |INDEX          
  elasticsearch-cluster|my-index-000002                |TABLE          |INDEX          
  elasticsearch-cluster|my-index-000003                |TABLE          |INDEX          
  elasticsearch-cluster|my-index-000004                |TABLE          |INDEX          
  elasticsearch-cluster|my-index-000005                |TABLE          |INDEX          
  elasticsearch-cluster|person-object                  |TABLE          |INDEX          

  ```

  </details>

  </details>
  
  <details>
  <summary>Translate to Query DSL</summary>

  ```json
  GET /_sql/translate
  {
    "query": """
      SHOW TABLES
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "error" : {
      "root_cause" : [
        {
          "type" : "planning_exception",
          "reason" : "Cannot generate a query DSL for a special SQL command (e.g.: DESCRIBE, SHOW), sql statement: [\n    SHOW TABLES\n  ]"
        }
      ],
      "type" : "planning_exception",
      "reason" : "Cannot generate a query DSL for a special SQL command (e.g.: DESCRIBE, SHOW), sql statement: [\n    SHOW TABLES\n  ]"
    },
    "status" : 400
  }
  ```
  </details>

  </details>
  
#### Describe index
---

  <details open>
  <summary>In SQL</summary>

  ```json
  GET /_sql?format=txt
  {
    "query": """
      DESCRIBE kibana_sample_data_flights
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
        column      |     type      |    mapping    
  ------------------+---------------+---------------
  AvgTicketPrice    |REAL           |float          
  Cancelled         |BOOLEAN        |boolean        
  Carrier           |VARCHAR        |keyword        
  Dest              |VARCHAR        |keyword        
  DestAirportID     |VARCHAR        |keyword        
  DestCityName      |VARCHAR        |keyword        
  DestCountry       |VARCHAR        |keyword        
  DestLocation      |GEOMETRY       |geo_point      
  DestRegion        |VARCHAR        |keyword        
  DestWeather       |VARCHAR        |keyword        
  DistanceKilometers|REAL           |float          
  DistanceMiles     |REAL           |float          
  FlightDelay       |BOOLEAN        |boolean        
  FlightDelayMin    |INTEGER        |integer        
  FlightDelayType   |VARCHAR        |keyword        
  FlightNum         |VARCHAR        |keyword        
  FlightTimeHour    |VARCHAR        |keyword        
  FlightTimeMin     |REAL           |float          
  Origin            |VARCHAR        |keyword        
  OriginAirportID   |VARCHAR        |keyword        
  OriginCityName    |VARCHAR        |keyword        
  OriginCountry     |VARCHAR        |keyword        
  OriginLocation    |GEOMETRY       |geo_point      
  OriginRegion      |VARCHAR        |keyword        
  OriginWeather     |VARCHAR        |keyword        
  dayOfWeek         |INTEGER        |integer        
  timestamp         |TIMESTAMP      |datetime       

  ```

  </details>

  </details>

  <details>
  <summary>Translate to Query DSL</summary>

  ```json
  GET /_sql/translate
  {
    "query": """
      DESCRIBE kibana_sample_data_flights
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "error" : {
      "root_cause" : [
        {
          "type" : "planning_exception",
          "reason" : "Cannot generate a query DSL for a special SQL command (e.g.: DESCRIBE, SHOW), sql statement: [\n    DESCRIBE kibana_sample_data_flights\n  ]"
        }
      ],
      "type" : "planning_exception",
      "reason" : "Cannot generate a query DSL for a special SQL command (e.g.: DESCRIBE, SHOW), sql statement: [\n    DESCRIBE kibana_sample_data_flights\n  ]"
    },
    "status" : 400
  }
  ```

  </details>

  </details>

  <details>
  <summary>IN Query DSL</summary>

  ```json
  GET /kibana_sample_data_flights

  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "kibana_sample_data_flights" : {
      "aliases" : { },
      "mappings" : {
        "properties" : {
          "AvgTicketPrice" : {
            "type" : "float"
          },
          "Cancelled" : {
            "type" : "boolean"
          },
          "Carrier" : {
            "type" : "keyword"
          },
          "Dest" : {
            "type" : "keyword"
          },
          "DestAirportID" : {
            "type" : "keyword"
          },
          "DestCityName" : {
            "type" : "keyword"
          },
          "DestCountry" : {
            "type" : "keyword"
          },
          "DestLocation" : {
            "type" : "geo_point"
          },
          "DestRegion" : {
            "type" : "keyword"
          },
          "DestWeather" : {
            "type" : "keyword"
          },
          "DistanceKilometers" : {
            "type" : "float"
          },
          "DistanceMiles" : {
            "type" : "float"
          },
          "FlightDelay" : {
            "type" : "boolean"
          },
          "FlightDelayMin" : {
            "type" : "integer"
          },
          "FlightDelayType" : {
            "type" : "keyword"
          },
          "FlightNum" : {
            "type" : "keyword"
          },
          "FlightTimeHour" : {
            "type" : "keyword"
          },
          "FlightTimeMin" : {
            "type" : "float"
          },
          "Origin" : {
            "type" : "keyword"
          },
          "OriginAirportID" : {
            "type" : "keyword"
          },
          "OriginCityName" : {
            "type" : "keyword"
          },
          "OriginCountry" : {
            "type" : "keyword"
          },
          "OriginLocation" : {
            "type" : "geo_point"
          },
          "OriginRegion" : {
            "type" : "keyword"
          },
          "OriginWeather" : {
            "type" : "keyword"
          },
          "dayOfWeek" : {
            "type" : "integer"
          },
          "timestamp" : {
            "type" : "date"
          }
        }
      },
      "settings" : {
        "index" : {
          "routing" : {
            "allocation" : {
              "include" : {
                "_tier_preference" : "data_content"
              }
            }
          },
          "number_of_shards" : "1",
          "auto_expand_replicas" : "0-1",
          "provided_name" : "kibana_sample_data_flights",
          "creation_date" : "1683033627395",
          "number_of_replicas" : "0",
          "uuid" : "d5rZ6-9NSSe3M7blks2d9Q",
          "version" : {
            "created" : "7170999"
          }
        }
      }
    }
  }
  ```

  </details>

  </details>

#### Describe shakespeare index
---

  <details open>
  <summary>In SQL</summary>

  ```json
  GET /_sql?format=txt
  {
    "query": """
      DESCRIBE shakespeare
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
         column        |     type      |    mapping    
  ---------------------+---------------+---------------
  line_id              |BIGINT         |long           
  line_number          |VARCHAR        |text           
  line_number.keyword  |VARCHAR        |keyword        
  play_name            |VARCHAR        |text           
  play_name.keyword    |VARCHAR        |keyword        
  speaker              |VARCHAR        |text           
  speaker.keyword      |VARCHAR        |keyword        
  speech_number        |VARCHAR        |text           
  speech_number.keyword|VARCHAR        |keyword        
  text_entry           |VARCHAR        |text           
  text_entry.keyword   |VARCHAR        |keyword        
  type                 |VARCHAR        |text           
  type.keyword         |VARCHAR        |keyword        

  ```

  </details>

  </details>

#### Simple query
---

  <details open>
  <summary>In SQL</summary>

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        play_name, text_entry
      FROM
        shakespeare
      WHERE
        play_name = 'Romeo and Juliet'
      LIMIT
        50
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
     play_name    |                                    text_entry                                    
  ----------------+----------------------------------------------------------------------------------
  Romeo and Juliet|ACT I                                                                             
  Romeo and Juliet|PROLOGUE                                                                          
  Romeo and Juliet|Two households, both alike in dignity,                                            
  Romeo and Juliet|In fair Verona, where we lay our scene,                                           
  Romeo and Juliet|From ancient grudge break to new mutiny,                                          
  Romeo and Juliet|Where civil blood makes civil hands unclean.                                      
  Romeo and Juliet|From forth the fatal loins of these two foes                                      
  Romeo and Juliet|A pair of star-crossd lovers take their life;                                     
  Romeo and Juliet|Whose misadventured piteous overthrows                                            
  Romeo and Juliet|Do with their death bury their parents strife.                                    
  Romeo and Juliet|The fearful passage of their death-markd love,                                    
  Romeo and Juliet|And the continuance of their parents rage,                                        
  Romeo and Juliet|Which, but their childrens end, nought could remove,                              
  Romeo and Juliet|Is now the two hours traffic of our stage;                                        
  Romeo and Juliet|The which if you with patient ears attend,                                        
  Romeo and Juliet|What here shall miss, our toil shall strive to mend.                              
  Romeo and Juliet|SCENE I. Verona. A public place.                                                  
  Romeo and Juliet|Enter SAMPSON and GREGORY, of the house of Capulet, armed with swords and bucklers
  Romeo and Juliet|Gregory, o my word, well not carry coals.                                         
  Romeo and Juliet|No, for then we should be colliers.                                               
  Romeo and Juliet|I mean, an we be in choler, well draw.                                            
  Romeo and Juliet|Ay, while you live, draw your neck out o the collar.                              
  Romeo and Juliet|I strike quickly, being moved.                                                    
  Romeo and Juliet|But thou art not quickly moved to strike.                                         
  Romeo and Juliet|A dog of the house of Montague moves me.                                          
  Romeo and Juliet|To move is to stir; and to be valiant is to stand:                                
  Romeo and Juliet|therefore, if thou art moved, thou runnst away.                                   
  Romeo and Juliet|A dog of that house shall move me to stand: I will                                
  Romeo and Juliet|take the wall of any man or maid of Montagues.                                    
  Romeo and Juliet|That shows thee a weak slave; for the weakest goes                                
  Romeo and Juliet|to the wall.                                                                      
  Romeo and Juliet|True; and therefore women, being the weaker vessels,                              
  Romeo and Juliet|are ever thrust to the wall: therefore I will push                                
  Romeo and Juliet|Montagues men from the wall, and thrust his maids             
  .....

  ```

  </details>

  </details>

  <details>
  <summary>Translate to Query DSL</summary>

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        play_name, text_entry
      FROM
        shakespeare
      WHERE
        play_name = 'Romeo and Juliet'
      LIMIT
        50
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "size" : 50,
    "query" : {
      "term" : {
        "play_name.keyword" : {
          "value" : "Romeo and Juliet",
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "text_entry"
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

  </details>

  <details>
  <summary>IN Query DSL</summary>

  ```json
  GET /shakespeare/_search
  {
    "size" : 50,
    "query" : {
      "term" : {
        "play_name.keyword" : {
          "value" : "Romeo and Juliet",
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "text_entry"
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
        "value" : 3313,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "85281",
          "_score" : null,
          "fields" : {
            "play_name" : [
              "Romeo and Juliet"
            ],
            "text_entry" : [
              "ACT I"
            ]
          },
          "sort" : [
            85281
          ]
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "85282",
          "_score" : null,
          "fields" : {
            "play_name" : [
              "Romeo and Juliet"
            ],
            "text_entry" : [
              "PROLOGUE"
            ]
          },
          "sort" : [
            85282
          ]
        },
        ....

  ```

  </details>

  </details>

#### Full-text search function - match

- In SQL

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        play_name, text_entry
      FROM
        shakespeare
      WHERE
        MATCH(play_name, 'Romeo and Juliet')
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
       play_name      |                                    text_entry                                    
  --------------------+----------------------------------------------------------------------------------
  Antony and Cleopatra|ACT I                                                                             
  Antony and Cleopatra|SCENE I. Alexandria. A room in CLEOPATRAs palace.                                 
  Antony and Cleopatra|Enter DEMETRIUS and PHILO                                                         
  Antony and Cleopatra|Nay, but this dotage of our generals                                              
  Antony and Cleopatra|Oerflows the measure: those his goodly eyes,                                      
  Antony and Cleopatra|That oer the files and musters of the war                                         
  Antony and Cleopatra|Have glowd like plated Mars, now bend, now turn,                                  
  Antony and Cleopatra|The office and devotion of their view                                             
  Antony and Cleopatra|Upon a tawny front: his captains heart,                                           
  Antony and Cleopatra|Which in the scuffles of great fights hath burst                                  
  Antony and Cleopatra|The buckles on his breast, reneges all temper,                                    
  Antony and Cleopatra|And is become the bellows and the fan                                             
  Antony and Cleopatra|To cool a gipsys lust.                                                            
  Antony and Cleopatra|Flourish. Enter ANTONY, CLEOPATRA, her Ladies, the Train, with Eunuchs fanning her
  Antony and Cleopatra|Look, where they come:                                                            
  Antony and Cleopatra|Take but good note, and you shall see in him.                                     
  Antony and Cleopatra|The triple pillar of the world transformd                                         
  Antony and Cleopatra|Into a strumpets fool: behold and see.                                            
  Antony and Cleopatra|If it be love indeed, tell me how much.                                           
  Antony and Cleopatra|Theres beggary in the love that can be reckond.                                   
  Antony and Cleopatra|Ill set a bourn how far to be beloved.                                            
  Antony and Cleopatra|Then must thou needs find out new heaven, new earth.                              
  Antony and Cleopatra|Enter an Attendant                                                                
  Antony and Cleopatra|News, my good lord, from Rome.                                                    
  Antony and Cleopatra|Grates me: the sum.                                                               
  Antony and Cleopatra|Nay, hear them, Antony:                                                           
  Antony and Cleopatra|Fulvia perchance is angry; or, who knows                                          
  Antony and Cleopatra|If the scarce-bearded Caesar have not sent                                        
  Antony and Cleopatra|His powerful mandate to you, Do this, or this;                                    
  Antony and Cleopatra|Take in that kingdom, and enfranchise that;               
  ....

  ```

  </details>

- Translate to Query DSL

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        play_name, text_entry
      FROM
        shakespeare
      WHERE
        MATCH(play_name, 'Romeo and Juliet')
    """
  }

  ```

  <details>
  <summary>Response:</summary>

  ```json
  {
    "size" : 1000,
    "query" : {
      "match" : {
        "play_name" : {
          "query" : "Romeo and Juliet",
          "operator" : "OR",
          "prefix_length" : 0,
          "max_expansions" : 50,
          "fuzzy_transpositions" : true,
          "lenient" : false,
          "zero_terms_query" : "NONE",
          "auto_generate_synonyms_phrase_query" : true,
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "text_entry"
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

- IN Query DSL

  ```json
  GET /shakespeare/_search
  {
    "size" : 1000,
    "query" : {
      "match" : {
        "play_name" : {
          "query" : "Romeo and Juliet",
          "operator" : "OR",
          "prefix_length" : 0,
          "max_expansions" : 50,
          "fuzzy_transpositions" : true,
          "lenient" : false,
          "zero_terms_query" : "NONE",
          "auto_generate_synonyms_phrase_query" : true,
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : ["play_name","text_entry"],
    "sort" : [
      {
        "_doc" : {
          "order" : "asc"
        }
      }
    ]
  }

  ```

#### Full-text search function - match && sort with score

- In SQL

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        play_name, 
        speaker,
        text_entry,
        SCORE()      
      FROM
        shakespeare
      WHERE
        MATCH(text_entry, 'to be or not to be')
      ORDER BY 
        SCORE() DESC
      LIMIT
        10
      
    """
  }
  ```

  <details>
  <summary>Response:</summary>

  ```json
         play_name        |    speaker    |                  text_entry                   |    SCORE()    
  ------------------------+---------------+-----------------------------------------------+---------------
  Hamlet                  |HAMLET         |To be, or not to be: that is the question:     |17.419369      
  A Winters Tale          |PERDITA        |Not like a corse; or if, not to be buried,     |14.883023      
  Twelfth Night           |SIR ANDREW     |will not be seen; or if she be, its four to one|14.782744      
  Alls well that ends well|LAFEU          |Not to be helped,--                            |14.755895      
  Alls well that ends well|BERTRAM        |not to be recovered.                           |14.755895      
  Much Ado about nothing  |CLAUDIO        |Not to be married,                             |14.755895      
  The Tempest             |GONZALO        |Or be not, Ill not swear.                      |14.221455      
  Henry VIII              |KING HENRY VIII|Would not be friendly to.                      |13.812091      
  Much Ado about nothing  |DON JOHN       |Not to be spoke of;                            |13.812091      
  Taming of the Shrew     |PETRUCHIO      |Intolerable, not to be endured!                |13.812091      

  ```

  </details>

- Translate to Query DSL

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        play_name, 
        speaker,
        text_entry,
        SCORE()      
      FROM
        shakespeare
      WHERE
        MATCH(text_entry, 'to be or not to be')
      ORDER BY 
        SCORE() DESC
      LIMIT
        10
    """
  }

  ```

  <details>
  <summary>Response:</summary>

  ```json
  {
    "size" : 10,
    "query" : {
      "match" : {
        "text_entry" : {
          "query" : "to be or not to be",
          "operator" : "OR",
          "prefix_length" : 0,
          "max_expansions" : 50,
          "fuzzy_transpositions" : true,
          "lenient" : false,
          "zero_terms_query" : "NONE",
          "auto_generate_synonyms_phrase_query" : true,
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "speaker"
      },
      {
        "field" : "text_entry"
      }
    ],
    "sort" : [
      {
        "_score" : {
          "order" : "desc"
        }
      }
    ],
    "track_scores" : true
  }

  ```

  </details>

- IN Query DSL

  ```json
  GET /shakespeare/_search
  {
    "size" : 10,
    "query" : {
      "match" : {
        "text_entry" : {
          "query" : "to be or not to be",
          "operator" : "OR",
          "prefix_length" : 0,
          "max_expansions" : 50,
          "fuzzy_transpositions" : true,
          "lenient" : false,
          "zero_terms_query" : "NONE",
          "auto_generate_synonyms_phrase_query" : true,
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "speaker"
      },
      {
        "field" : "text_entry"
      }
    ],
    "sort" : [
      {
        "_score" : {
          "order" : "desc"
        }
      }
    ],
    "track_scores" : true
  }
  ```

#### Full-text search function - multi-match

- In SQL

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        play_name, 
        speaker,
        text_entry,
        SCORE()      
      FROM
        shakespeare
      WHERE
        MATCH('text_entry,speaker', 'henry')
      ORDER BY 
        SCORE() DESC
      LIMIT
        20
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
     play_name   |     speaker     |                        text_entry                         |    SCORE()    
  ---------------+-----------------+-----------------------------------------------------------+---------------
  Richard II     |HENRY BOLINGBROKE|Henry Bolingbroke                                          |8.618598       
  Henry IV       |MORTIMER         |Enter KING HENRY IV, PRINCE HENRY, and others              |8.121736       
  Richard II     |DUCHESS OF YORK  |Enter HENRY BOLINGBROKE, HENRY PERCY, and other Lords      |8.121736       
  Henry IV       |PRINCE HENRY     |Exit PRINCE HENRY                                          |7.9864817      
  Henry IV       |PRINCE HENRY     |Exit PRINCE HENRY                                          |7.9864817      
  Henry IV       |FALSTAFF         |Enter PRINCE HENRY                                         |7.9864817      
  Henry IV       |PRINCE HENRY     |Exit PRINCE HENRY                                          |7.9864817      
  Richard II     |KING RICHARD II  |To HENRY BOLINGBROKE                                       |7.9864817      
  Richard II     |HENRY BOLINGBROKE|Enter HENRY PERCY                                          |7.9864817      
  Richard II     |HENRY BOLINGBROKE|Enter HENRY PERCY                                          |7.9864817      
  Richard II     |DUKE OF YORK     |To Henry Bolingbroke.                                      |7.9864817      
  Henry IV       |EARL OF DOUGLAS  |They fight. KING HENRY being in danger, PRINCE HENRY enters|7.5580173      
  Henry VI Part 2|CARDINAL         |KING HENRY VI swoons                                       |7.4407525      
  Henry VI Part 3|WARWICK          |They all cry, Henry!                                       |7.4407525      
  Henry IV       |GADSHILL         |Enter PRINCE HENRY and POINS                               |6.9648337      
  Henry IV       |POINS            |Exeunt PRINCE HENRY and POINS                              |6.9648337      
  Henry IV       |LADY PERCY       |Enter PRINCE HENRY and POINS                               |6.9648337      
  Henry IV       |PRINCE HENRY     |Exeunt PRINCE HENRY and LANCASTER                          |6.9648337      
  Henry VI Part 3|WARWICK          |In following this usurping Henry.                          |6.9648337      
  Henry VI Part 3|WESTMORELAND     |Base, fearful and despairing Henry!                        |6.9648337      

  ```

  </details>

- Translate to Query DSL

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        play_name, 
        speaker,
        text_entry,
        SCORE()      
      FROM
        shakespeare
      WHERE
        MATCH('text_entry,speaker', 'henry')
      ORDER BY 
        SCORE() DESC
      LIMIT
        20
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "size" : 20,
    "query" : {
      "multi_match" : {
        "query" : "henry",
        "fields" : [
          "speaker^1.0",
          "text_entry^1.0"
        ],
        "type" : "best_fields",
        "operator" : "OR",
        "slop" : 0,
        "prefix_length" : 0,
        "max_expansions" : 50,
        "zero_terms_query" : "NONE",
        "auto_generate_synonyms_phrase_query" : true,
        "fuzzy_transpositions" : true,
        "boost" : 1.0
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "speaker"
      },
      {
        "field" : "text_entry"
      }
    ],
    "sort" : [
      {
        "_score" : {
          "order" : "desc"
        }
      }
    ],
    "track_scores" : true
  }

  ```

  </details>

- IN Query DSL

  ```json
  GET /shakespeare/_search
  {
    "size" : 20,
    "query" : {
      "multi_match" : {
        "query" : "henry",
        "fields" : [
          "speaker^1.0",
          "text_entry^1.0"
        ],
        "type" : "best_fields",
        "operator" : "OR",
        "slop" : 0,
        "prefix_length" : 0,
        "max_expansions" : 50,
        "zero_terms_query" : "NONE",
        "auto_generate_synonyms_phrase_query" : true,
        "fuzzy_transpositions" : true,
        "boost" : 1.0
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "speaker"
      },
      {
        "field" : "text_entry"
      }
    ],
    "sort" : [
      {
        "_score" : {
          "order" : "desc"
        }
      }
    ],
    "track_scores" : true
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "took" : 4,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 4225,
        "relation" : "eq"
      },
      "max_score" : 8.618598,
      "hits" : [
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "80074",
          "_score" : 8.618598,
          "fields" : {
            "play_name" : [
              "Richard II"
            ],
            "text_entry" : [
              "Henry Bolingbroke"
            ],
            "speaker" : [
              "HENRY BOLINGBROKE"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "1830",
          "_score" : 8.121736,
          "fields" : {
            "play_name" : [
              "Henry IV"
            ],
            "text_entry" : [
              "Enter KING HENRY IV, PRINCE HENRY, and others"
            ],
            "speaker" : [
              "MORTIMER"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "80975",
          "_score" : 8.121736,
          "fields" : {
            "play_name" : [
              "Richard II"
            ],
            "text_entry" : [
              "Enter HENRY BOLINGBROKE, HENRY PERCY, and other Lords"
            ],
            "speaker" : [
              "DUCHESS OF YORK"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "2223",
          "_score" : 7.9864817,
          "fields" : {
            "play_name" : [
              "Henry IV"
            ],
            "text_entry" : [
              "Exit PRINCE HENRY"
            ],
            "speaker" : [
              "PRINCE HENRY"
            ]
          }
        },
        ....

  ```

  </details>

#### Full-text search function - match with options

- In SQL

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        play_name, 
        speaker,
        text_entry,
        SCORE()      
      FROM
        shakespeare
      WHERE
        MATCH(text_entry, 'to be or not to be that is the question','minimum_should_match=7')
      ORDER BY 
        SCORE() DESC
      LIMIT
        50
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
         play_name        |     speaker     |                        text_entry                         |    SCORE()    
  ------------------------+-----------------+-----------------------------------------------------------+---------------
  Hamlet                  |HAMLET           |To be, or not to be: that is the question:                 |28.931799      
  Merry Wives of Windsor  |DOCTOR CAIUS     |to meddle or make. You may be gone; it is not good         |14.707344      
  King John               |CARDINAL PANDULPH|That is, to be the champion of our church!                 |14.542853      
  Measure for measure     |DUKE VINCENTIO   |What is that Barnardine who is to be executed in the       |14.163929      
  Alls well that ends well|PAROLLES         |facinerious spirit that will not acknowledge it to be the--|13.89329       
  Alls well that ends well|PAROLLES         |It is to be recovered: but that the merit of               |13.838069      
  Alls well that ends well|First Lord       |That was not to be blamed in the command of the            |13.827386      
  Merchant of Venice      |LAUNCELOT        |To be brief, the very truth is that the Jew, having        |13.774719      
  Twelfth Night           |MARIA            |to be turned away, is not that as good as a hanging to you?|13.742241      
  Antony and Cleopatra    |Clown            |Look you, the worm is not to be trusted but in the         |13.378763      
  Loves Labours Lost      |PRINCESS         |not yet: the roof of this court is too high to be          |12.806209      
  Much Ado about nothing  |DON JOHN         |What life is in that, to be the death of this marriage?    |12.61533       

  ```

  </details>

- Translate to Query DSL

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        play_name, 
        speaker,
        text_entry,
        SCORE()      
      FROM
        shakespeare
      WHERE
        MATCH(text_entry, 'to be or not to be that is the question','minimum_should_match=7')
      ORDER BY 
        SCORE() DESC
      LIMIT
        50
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "size" : 50,
    "query" : {
      "match" : {
        "text_entry" : {
          "query" : "to be or not to be that is the question",
          "operator" : "OR",
          "prefix_length" : 0,
          "max_expansions" : 50,
          "minimum_should_match" : "7",
          "fuzzy_transpositions" : true,
          "lenient" : false,
          "zero_terms_query" : "NONE",
          "auto_generate_synonyms_phrase_query" : true,
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "speaker"
      },
      {
        "field" : "text_entry"
      }
    ],
    "sort" : [
      {
        "_score" : {
          "order" : "desc"
        }
      }
    ],
    "track_scores" : true
  }

  ```

  </details>

- IN Query DSL

  ```json
  GET /shakespeare/_search
  {
    "size" : 50,
    "query" : {
      "match" : {
        "text_entry" : {
          "query" : "to be or not to be that is the question",
          "operator" : "OR",
          "prefix_length" : 0,
          "max_expansions" : 50,
          "minimum_should_match" : "7",
          "fuzzy_transpositions" : true,
          "lenient" : false,
          "zero_terms_query" : "NONE",
          "auto_generate_synonyms_phrase_query" : true,
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "speaker"
      },
      {
        "field" : "text_entry"
      }
    ],
    "sort" : [
      {
        "_score" : {
          "order" : "desc"
        }
      }
    ],
    "track_scores" : true
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "took" : 11,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 12,
        "relation" : "eq"
      },
      "max_score" : 28.931799,
      "hits" : [
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "34229",
          "_score" : 28.931799,
          "fields" : {
            "play_name" : [
              "Hamlet"
            ],
            "text_entry" : [
              "To be, or not to be: that is the question:"
            ],
            "speaker" : [
              "HAMLET"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "64679",
          "_score" : 14.707344,
          "fields" : {
            "play_name" : [
              "Merry Wives of Windsor"
            ],
            "text_entry" : [
              "to meddle or make. You may be gone; it is not good"
            ],
            "speaker" : [
              "DOCTOR CAIUS"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "44680",
          "_score" : 14.542853,
          "fields" : {
            "play_name" : [
              "King John"
            ],
            "text_entry" : [
              "That is, to be the champion of our church!"
            ],
            "speaker" : [
              "CARDINAL PANDULPH"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "60408",
          "_score" : 14.163929,
          "fields" : {
            "play_name" : [
              "Measure for measure"
            ],
            "text_entry" : [
              "What is that Barnardine who is to be executed in the"
            ],
            "speaker" : [
              "DUKE VINCENTIO"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "13584",
          "_score" : 13.89329,
          "fields" : {
            "play_name" : [
              "Alls well that ends well"
            ],
            "text_entry" : [
              "facinerious spirit that will not acknowledge it to be the--"
            ],
            "speaker" : [
              "PAROLLES"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "14453",
          "_score" : 13.838069,
          "fields" : {
            "play_name" : [
              "Alls well that ends well"
            ],
            "text_entry" : [
              "It is to be recovered: but that the merit of"
            ],
            "speaker" : [
              "PAROLLES"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "14444",
          "_score" : 13.827386,
          "fields" : {
            "play_name" : [
              "Alls well that ends well"
            ],
            "text_entry" : [
              "That was not to be blamed in the command of the"
            ],
            "speaker" : [
              "First Lord"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "62063",
          "_score" : 13.774719,
          "fields" : {
            "play_name" : [
              "Merchant of Venice"
            ],
            "text_entry" : [
              "To be brief, the very truth is that the Jew, having"
            ],
            "speaker" : [
              "LAUNCELOT"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "103217",
          "_score" : 13.742241,
          "fields" : {
            "play_name" : [
              "Twelfth Night"
            ],
            "text_entry" : [
              "to be turned away, is not that as good as a hanging to you?"
            ],
            "speaker" : [
              "MARIA"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "22297",
          "_score" : 13.378763,
          "fields" : {
            "play_name" : [
              "Antony and Cleopatra"
            ],
            "text_entry" : [
              "Look you, the worm is not to be trusted but in the"
            ],
            "speaker" : [
              "Clown"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "53421",
          "_score" : 12.806209,
          "fields" : {
            "play_name" : [
              "Loves Labours Lost"
            ],
            "text_entry" : [
              "not yet: the roof of this court is too high to be"
            ],
            "speaker" : [
              "PRINCESS"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "70078",
          "_score" : 12.61533,
          "fields" : {
            "play_name" : [
              "Much Ado about nothing"
            ],
            "text_entry" : [
              "What life is in that, to be the death of this marriage?"
            ],
            "speaker" : [
              "DON JOHN"
            ]
          }
        }
      ]
    }
  }

  ```

  </details>

#### Full-text search function - Multiple match with boolean operators

- In SQL

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        play_name, 
        speaker,
        text_entry,
        SCORE()      
      FROM
        shakespeare
      WHERE
        MATCH(text_entry, 'to be or not to be')
      AND  
        MATCH(text_entry, 'that is the question','operator=and')
      ORDER BY 
        SCORE() DESC
      LIMIT
        50
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
        play_name       |    speaker    |                 text_entry                  |    SCORE()    
  ----------------------+---------------+---------------------------------------------+---------------
  Hamlet                |HAMLET         |To be, or not to be: that is the question:   |28.931799      
  Merry Wives of Windsor|SIR HUGH EVANS |But that is not the question: the question is|18.59245       

  ```

  </details>

- Translate to Query DSL

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        play_name, 
        speaker,
        text_entry,
        SCORE()      
      FROM
        shakespeare
      WHERE
        MATCH(text_entry, 'to be or not to be')
      AND  
        MATCH(text_entry, 'that is the question','operator=and')
      ORDER BY 
        SCORE() DESC
      LIMIT
        50
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "size" : 50,
    "query" : {
      "bool" : {
        "must" : [
          {
            "match" : {
              "text_entry" : {
                "query" : "to be or not to be",
                "operator" : "OR",
                "prefix_length" : 0,
                "max_expansions" : 50,
                "fuzzy_transpositions" : true,
                "lenient" : false,
                "zero_terms_query" : "NONE",
                "auto_generate_synonyms_phrase_query" : true,
                "boost" : 1.0
              }
            }
          },
          {
            "match" : {
              "text_entry" : {
                "query" : "that is the question",
                "operator" : "AND",
                "prefix_length" : 0,
                "max_expansions" : 50,
                "fuzzy_transpositions" : true,
                "lenient" : false,
                "zero_terms_query" : "NONE",
                "auto_generate_synonyms_phrase_query" : true,
                "boost" : 1.0
              }
            }
          }
        ],
        "adjust_pure_negative" : true,
        "boost" : 1.0
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "speaker"
      },
      {
        "field" : "text_entry"
      }
    ],
    "sort" : [
      {
        "_score" : {
          "order" : "desc"
        }
      }
    ],
    "track_scores" : true
  }

  ```
  </details>

- IN Query DSL

  ```json
  GET /shakespeare/_search
  {
    "size" : 50,
    "query" : {
      "bool" : {
        "must" : [
          {
            "match" : {
              "text_entry" : {
                "query" : "to be or not to be",
                "operator" : "OR",
                "prefix_length" : 0,
                "max_expansions" : 50,
                "fuzzy_transpositions" : true,
                "lenient" : false,
                "zero_terms_query" : "NONE",
                "auto_generate_synonyms_phrase_query" : true,
                "boost" : 1.0
              }
            }
          },
          {
            "match" : {
              "text_entry" : {
                "query" : "that is the question",
                "operator" : "AND",
                "prefix_length" : 0,
                "max_expansions" : 50,
                "fuzzy_transpositions" : true,
                "lenient" : false,
                "zero_terms_query" : "NONE",
                "auto_generate_synonyms_phrase_query" : true,
                "boost" : 1.0
              }
            }
          }
        ],
        "adjust_pure_negative" : true,
        "boost" : 1.0
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "play_name"
      },
      {
        "field" : "speaker"
      },
      {
        "field" : "text_entry"
      }
    ],
    "sort" : [
      {
        "_score" : {
          "order" : "desc"
        }
      }
    ],
    "track_scores" : true
  }
  ```

  <details>
  <summary>Response:</summary>

  ```json
  {
    "took" : 4,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 2,
        "relation" : "eq"
      },
      "max_score" : 28.931799,
      "hits" : [
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "34229",
          "_score" : 28.931799,
          "fields" : {
            "play_name" : [
              "Hamlet"
            ],
            "text_entry" : [
              "To be, or not to be: that is the question:"
            ],
            "speaker" : [
              "HAMLET"
            ]
          }
        },
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "64369",
          "_score" : 18.59245,
          "fields" : {
            "play_name" : [
              "Merry Wives of Windsor"
            ],
            "text_entry" : [
              "But that is not the question: the question is"
            ],
            "speaker" : [
              "SIR HUGH EVANS"
            ]
          }
        }
      ]
    }
  }

  ```

  </details>

####  Find the 3 longest plays by shakespeare

- In SQL

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        play_name AS PlayName, 
        COUNT(*) AS Entries
      FROM
        shakespeare
      GROUP BY 
        play_name
      ORDER BY 
        Entries DESC
      LIMIT
        3
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
     PlayName    |    Entries    
  ---------------+---------------
  Hamlet         |4244           
  Coriolanus     |3992           
  Cymbeline      |3958           

  ```

  </details>

- Translate to Query DSL

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        play_name AS PlayName, 
        COUNT(*) AS Entries
      FROM
        shakespeare
      GROUP BY 
        play_name
      ORDER BY 
        Entries DESC
      LIMIT
        3
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
              "9deed572" : {
                "terms" : {
                  "field" : "play_name.keyword",
                  "missing_bucket" : true,
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

- IN Query DSL

  ```json
  GET /shakespeare/_search
  {
    "size": 0,
    "aggs": {
      "top play names": {
        "terms": {
          "field": "play_name.keyword",
          "size": 3
        }
      }
    }
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
        "value" : 10000,
        "relation" : "gte"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "top play names" : {
        "doc_count_error_upper_bound" : 0,
        "sum_other_doc_count" : 99202,
        "buckets" : [
          {
            "key" : "Hamlet",
            "doc_count" : 4244
          },
          {
            "key" : "Coriolanus",
            "doc_count" : 3992
          },
          {
            "key" : "Cymbeline",
            "doc_count" : 3958
          }
        ]
      }
    }
  }

  ```

  </details>



#### Aggregation with FIRST & LAST functions

- In SQL

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        play_name AS PlayName, 
        FIRST(text_entry, line_id) AS FirstText,
        LAST(text_entry, line_id) AS LastText
      FROM
        shakespeare
      WHERE 
        text_entry NOT IN ('ACT I', 'PROLOGUE', 'Exeunt')
      AND
        play_name IN ('Hamlet', 'Romeo and Juliet')
      AND 
        text_entry NOT LIKE 'SCENE%'
      GROUP BY 
        play_name
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
      PlayName    |                 FirstText                  |                                          LastText                                           
  ----------------+--------------------------------------------+---------------------------------------------------------------------------------------------
  Hamlet          |FRANCISCO at his post. Enter to him BERNARDO|A dead march. Exeunt, bearing off the dead bodies; after which a peal of ordnance is shot off
  Romeo and Juliet|Two households, both alike in dignity,      |Than this of Juliet and her Romeo.                                                           

  ```

  </details>

- Translate to Query DSL

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        play_name AS PlayName, 
        FIRST(text_entry, line_id) AS FirstText,
        LAST(text_entry, line_id) AS LastText
      FROM
        shakespeare
      WHERE 
        text_entry NOT IN ('ACT I', 'PROLOGUE', 'Exeunt')
      AND
        play_name IN ('Hamlet', 'Romeo and Juliet')
      AND 
        text_entry NOT LIKE 'SCENE%'
      GROUP BY 
        play_name
    """
  }

  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "size" : 0,
    "query" : {
      "bool" : {
        "must" : [
          {
            "bool" : {
              "must" : [
                {
                  "bool" : {
                    "must_not" : [
                      {
                        "terms" : {
                          "text_entry.keyword" : [
                            "ACT I",
                            "PROLOGUE",
                            "Exeunt"
                          ],
                          "boost" : 1.0
                        }
                      }
                    ],
                    "adjust_pure_negative" : true,
                    "boost" : 1.0
                  }
                },
                {
                  "terms" : {
                    "play_name.keyword" : [
                      "Hamlet",
                      "Romeo and Juliet"
                    ],
                    "boost" : 1.0
                  }
                }
              ],
              "adjust_pure_negative" : true,
              "boost" : 1.0
            }
          },
          {
            "bool" : {
              "must_not" : [
                {
                  "wildcard" : {
                    "text_entry.keyword" : {
                      "wildcard" : "SCENE*",
                      "boost" : 1.0
                    }
                  }
                }
              ],
              "adjust_pure_negative" : true,
              "boost" : 1.0
            }
          }
        ],
        "adjust_pure_negative" : true,
        "boost" : 1.0
      }
    },
    "_source" : false,
    "aggregations" : {
      "groupby" : {
        "composite" : {
          "size" : 1000,
          "sources" : [
            {
              "9deed572" : {
                "terms" : {
                  "field" : "play_name.keyword",
                  "missing_bucket" : true,
                  "order" : "asc"
                }
              }
            }
          ]
        },
        "aggregations" : {
          "be6cce9e" : {
            "top_hits" : {
              "from" : 0,
              "size" : 1,
              "version" : false,
              "seq_no_primary_term" : false,
              "explain" : false,
              "docvalue_fields" : [
                {
                  "field" : "text_entry.keyword"
                }
              ],
              "sort" : [
                {
                  "line_id" : {
                    "order" : "asc",
                    "missing" : "_last",
                    "unmapped_type" : "long"
                  }
                },
                {
                  "text_entry.keyword" : {
                    "order" : "asc",
                    "missing" : "_last",
                    "unmapped_type" : "text"
                  }
                }
              ]
            }
          },
          "485a669c" : {
            "top_hits" : {
              "from" : 0,
              "size" : 1,
              "version" : false,
              "seq_no_primary_term" : false,
              "explain" : false,
              "docvalue_fields" : [
                {
                  "field" : "text_entry.keyword"
                }
              ],
              "sort" : [
                {
                  "line_id" : {
                    "order" : "desc",
                    "missing" : "_last",
                    "unmapped_type" : "long"
                  }
                },
                {
                  "text_entry.keyword" : {
                    "order" : "desc",
                    "missing" : "_last",
                    "unmapped_type" : "text"
                  }
                }
              ]
            }
          }
        }
      }
    }
  }

  ```

  </details>

- IN Query DSL

  ```json
  GET /shakespeare/_search
  {
    "size" : 0,
    "query" : {
      "bool" : {
        "must" : [
          {
            "bool" : {
              "must" : [
                {
                  "bool" : {
                    "must_not" : [
                      {
                        "terms" : {
                          "text_entry.keyword" : [
                            "ACT I",
                            "PROLOGUE",
                            "Exeunt"
                          ],
                          "boost" : 1.0
                        }
                      }
                    ],
                    "adjust_pure_negative" : true,
                    "boost" : 1.0
                  }
                },
                {
                  "terms" : {
                    "play_name.keyword" : [
                      "Hamlet",
                      "Romeo and Juliet"
                    ],
                    "boost" : 1.0
                  }
                }
              ],
              "adjust_pure_negative" : true,
              "boost" : 1.0
            }
          },
          {
            "bool" : {
              "must_not" : [
                {
                  "wildcard" : {
                    "text_entry.keyword" : {
                      "wildcard" : "SCENE*",
                      "boost" : 1.0
                    }
                  }
                }
              ],
              "adjust_pure_negative" : true,
              "boost" : 1.0
            }
          }
        ],
        "adjust_pure_negative" : true,
        "boost" : 1.0
      }
    },
    "_source" : false,
    "aggregations" : {
      "groupby" : {
        "composite" : {
          "size" : 1000,
          "sources" : [
            {
              "9deed572" : {
                "terms" : {
                  "field" : "play_name.keyword",
                  "missing_bucket" : true,
                  "order" : "asc"
                }
              }
            }
          ]
        },
        "aggregations" : {
          "be6cce9e" : {
            "top_hits" : {
              "from" : 0,
              "size" : 1,
              "version" : false,
              "seq_no_primary_term" : false,
              "explain" : false,
              "docvalue_fields" : [
                {
                  "field" : "text_entry.keyword"
                }
              ],
              "sort" : [
                {
                  "line_id" : {
                    "order" : "asc",
                    "missing" : "_last",
                    "unmapped_type" : "long"
                  }
                },
                {
                  "text_entry.keyword" : {
                    "order" : "asc",
                    "missing" : "_last",
                    "unmapped_type" : "text"
                  }
                }
              ]
            }
          },
          "485a669c" : {
            "top_hits" : {
              "from" : 0,
              "size" : 1,
              "version" : false,
              "seq_no_primary_term" : false,
              "explain" : false,
              "docvalue_fields" : [
                {
                  "field" : "text_entry.keyword"
                }
              ],
              "sort" : [
                {
                  "line_id" : {
                    "order" : "desc",
                    "missing" : "_last",
                    "unmapped_type" : "long"
                  }
                },
                {
                  "text_entry.keyword" : {
                    "order" : "desc",
                    "missing" : "_last",
                    "unmapped_type" : "text"
                  }
                }
              ]
            }
          }
        }
      }
    }
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "took" : 66,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 7476,
        "relation" : "eq"
      },
      "max_score" : null,
      "hits" : [ ]
    },
    "aggregations" : {
      "groupby" : {
        "after_key" : {
          "9deed572" : "Romeo and Juliet"
        },
        "buckets" : [
          {
            "key" : {
              "9deed572" : "Hamlet"
            },
            "doc_count" : 4210,
            "485a669c" : {
              "hits" : {
                "total" : {
                  "value" : 4210,
                  "relation" : "eq"
                },
                "max_score" : null,
                "hits" : [
                  {
                    "_index" : "shakespeare",
                    "_type" : "_doc",
                    "_id" : "36675",
                    "_score" : null,
                    "_source" : {
                      "type" : "line",
                      "line_id" : 36676,
                      "play_name" : "Hamlet",
                      "speech_number" : 147,
                      "line_number" : "5.2.424",
                      "speaker" : "PRINCE FORTINBRAS",
                      "text_entry" : "A dead march. Exeunt, bearing off the dead bodies; after which a peal of ordnance is shot off"
                    },
                    "fields" : {
                      "text_entry.keyword" : [
                        "A dead march. Exeunt, bearing off the dead bodies; after which a peal of ordnance is shot off"
                      ]
                    },
                    "sort" : [
                      36676,
                      "A dead march. Exeunt, bearing off the dead bodies; after which a peal of ordnance is shot off"
                    ]
                  }
                ]
              }
            },
            "be6cce9e" : {
              "hits" : {
                "total" : {
                  "value" : 4210,
                  "relation" : "eq"
                },
                "max_score" : null,
                "hits" : [
                  {
                    "_index" : "shakespeare",
                    "_type" : "_doc",
                    "_id" : "32434",
                    "_score" : null,
                    "_source" : {
                      "type" : "line",
                      "line_id" : 32435,
                      "play_name" : "Hamlet",
                      "speech_number" : 138,
                      "line_number" : "",
                      "speaker" : "CYMBELINE",
                      "text_entry" : "FRANCISCO at his post. Enter to him BERNARDO"
                    },
                    "fields" : {
                      "text_entry.keyword" : [
                        "FRANCISCO at his post. Enter to him BERNARDO"
                      ]
                    },
                    "sort" : [
                      32435,
                      "FRANCISCO at his post. Enter to him BERNARDO"
                    ]
                  }
                ]
              }
            }
          },
          {
            "key" : {
              "9deed572" : "Romeo and Juliet"
            },
            "doc_count" : 3266,
            "485a669c" : {
              "hits" : {
                "total" : {
                  "value" : 3266,
                  "relation" : "eq"
                },
                "max_score" : null,
                "hits" : [
                  {
                    "_index" : "shakespeare",
                    "_type" : "_doc",
                    "_id" : "88592",
                    "_score" : null,
                    "_source" : {
                      "type" : "line",
                      "line_id" : 88593,
                      "play_name" : "Romeo and Juliet",
                      "speech_number" : 65,
                      "line_number" : "5.3.321",
                      "speaker" : "PRINCE",
                      "text_entry" : "Than this of Juliet and her Romeo."
                    },
                    "fields" : {
                      "text_entry.keyword" : [
                        "Than this of Juliet and her Romeo."
                      ]
                    },
                    "sort" : [
                      88593,
                      "Than this of Juliet and her Romeo."
                    ]
                  }
                ]
              }
            },
            "be6cce9e" : {
              "hits" : {
                "total" : {
                  "value" : 3266,
                  "relation" : "eq"
                },
                "max_score" : null,
                "hits" : [
                  {
                    "_index" : "shakespeare",
                    "_type" : "_doc",
                    "_id" : "85283",
                    "_score" : null,
                    "_source" : {
                      "type" : "line",
                      "line_id" : 85284,
                      "play_name" : "Romeo and Juliet",
                      "speech_number" : 7,
                      "line_number" : "1.0.1",
                      "speaker" : "RICHMOND",
                      "text_entry" : "Two households, both alike in dignity,"
                    },
                    "fields" : {
                      "text_entry.keyword" : [
                        "Two households, both alike in dignity,"
                      ]
                    },
                    "sort" : [
                      85284,
                      "Two households, both alike in dignity,"
                    ]
                  }
                ]
              }
            }
          }
        ]
      }
    }
  }

  ```

  </details>



#### Aggregation with having & order

- In SQL

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        Origin AS OriginAirport,
        MIN(DistanceMiles) AS MinDistance,
        MAX(DistanceMiles) AS MaxDistance,
        AVG(DistanceMiles) AS AverageDistance
      FROM
        kibana_sample_data_flights
      WHERE 
        OriginCountry = 'US'
      GROUP BY 
        Origin
      HAVING 
        MinDistance > 0
      ORDER BY 
        MIN(DistanceMiles)
      LIMIT
        20
      
    """
  }
  ``` 

  <details>
  <summary>Response:</summary>

  ```                   OriginAirport                   |   MinDistance    |  MaxDistance   | AverageDistance  
  ---------------------------------------------------+------------------+----------------+------------------
  Newport News Williamsburg International Airport    |22.981517791748047|9775.765625     |4113.748561165549 
  Scott AFB/Midamerica Airport                       |32.1550407409668  |9082.130859375  |4844.910936062152 
  Piedmont Triad International Airport               |66.19200134277344 |9574.158203125  |4110.762691497803 
  Chicago Midway International Airport               |80.48770904541016 |8536.1611328125 |4310.982901573181 
  Portland International Airport                     |129.2322540283203 |7911.83544921875|4243.002852806678 
  Tulsa International Airport                        |131.65792846679688|7318.57373046875|4833.106824239095 
  Norfolk International Airport                      |160.3270263671875 |9788.8515625    |4929.9432335747615
  Des Moines International Airport                   |174.24740600585938|9004.5322265625 |4842.070693404587 
  Reno Tahoe International Airport                   |191.69497680664062|7603.158203125  |4823.237944382888 
  Cleveland Hopkins International Airport            |193.06979370117188|6970.42333984375|3440.1764999915813
  Bangor International Airport                       |200.93922424316406|9841.193359375  |5132.379520284719 
  Detroit Metropolitan Wayne County Airport          |214.13528442382812|9896.630859375  |5097.21588699906  
  Philadelphia International Airport                 |228.00880432128906|7427.111328125  |4017.50319199335  
  Greater Rochester International Airport            |253.674560546875  |9759.4189453125 |4378.471331787109 
  General Edward Lawrence Logan International Airport|254.19284057617188|7897.92822265625|3554.0694405691966
  Pittsburgh International Airport                   |258.8587951660156 |9611.0576171875 |4049.5155725479126
  Chicago O'Hare International Airport               |264.3896484375    |8525.7177734375 |4565.218495336072 
  Austin Straubel International Airport              |275.52142333984375|7895.130859375  |4331.437386971933 
  Syracuse Hancock International Airport             |296.0372009277344 |7084.552734375  |3531.5293611798966
  Phoenix Sky Harbor International Airport           |304.218994140625  |8879.060546875  |5198.780445240162 
  json

  ```

  </details>

- Translate to Query DSL

  ```json
  GET _sql/translate
  {
    "query": """
      SELECT  
        Origin AS OriginAirport,
        MIN(DistanceMiles) AS MinDistance,
        MAX(DistanceMiles) AS MaxDistance,
        AVG(DistanceMiles) AS AverageDistance
      FROM
        kibana_sample_data_flights
      WHERE 
        OriginCountry = 'US'
      GROUP BY 
        Origin
      HAVING 
        MinDistance > 0
    ORDER BY 
      MIN(DistanceMiles)
    LIMIT
      20
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
        "composite" : {
          "size" : 1000,
          "sources" : [
            {
              "54f392e6" : {
                "terms" : {
                  "field" : "Origin",
                  "missing_bucket" : true,
                  "order" : "asc"
                }
              }
            }
          ]
        },
        "aggregations" : {
          "6368e806" : {
            "stats" : {
              "field" : "DistanceMiles"
            }
          },
          "having.a18a5aef" : {
            "bucket_selector" : {
              "buckets_path" : {
                "a0" : "6368e806.min"
              },
              "script" : {
                "source" : "InternalQlScriptUtils.nullSafeFilter(InternalQlScriptUtils.gt(params.a0,params.v0))",
                "lang" : "painless",
                "params" : {
                  "v0" : 0
                }
              },
              "gap_policy" : "skip"
            }
          }
        }
      }
    }
  }

  ```

  </details>

- IN Query DSL

  ```json
  GET /kibana_sample_data_flights/_search
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
        "composite" : {
          "size" : 1000,
          "sources" : [
            {
              "54f392e6" : {
                "terms" : {
                  "field" : "Origin",
                  "missing_bucket" : true,
                  "order" : "asc"
                }
              }
            }
          ]
        },
        "aggregations" : {
          "6368e806" : {
            "stats" : {
              "field" : "DistanceMiles"
            }
          },
          "having.a18a5aef" : {
            "bucket_selector" : {
              "buckets_path" : {
                "a0" : "6368e806.min"
              },
              "script" : {
                "source" : "InternalQlScriptUtils.nullSafeFilter(InternalQlScriptUtils.gt(params.a0,params.v0))",
                "lang" : "painless",
                "params" : {
                  "v0" : 0
                }
              },
              "gap_policy" : "skip"
            }
          }
        }
      }
    }
  }

  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  {
    "took" : 4,
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
      "groupby" : {
        "after_key" : {
          "54f392e6" : "Wichita Mid Continent Airport"
        },
        "buckets" : [
          {
            "key" : {
              "54f392e6" : "Albuquerque International Sunport Airport"
            },
            "doc_count" : 26,
            "6368e806" : {
              "count" : 26,
              "min" : 1117.7847900390625,
              "max" : 9961.1279296875,
              "avg" : 5337.83305476262,
              "sum" : 138783.65942382812
            }
          },
          {
            "key" : {
              "54f392e6" : "Austin Straubel International Airport"
            },
            "doc_count" : 27,
            "6368e806" : {
              "count" : 27,
              "min" : 275.52142333984375,
              "max" : 7895.130859375,
              "avg" : 4331.437386971933,
              "sum" : 116948.80944824219
            }
          },
          {
            "key" : {
              "54f392e6" : "Baltimore/Washington International Thurgood Marshall Airport"
            },
            "doc_count" : 22,
            "6368e806" : {
              "count" : 22,
              "min" : 945.8628540039062,
              "max" : 10206.9736328125,
              "avg" : 5734.00532947887,
              "sum" : 126148.11724853516
            }
          },
          {
            "key" : {
              "54f392e6" : "Bangor International Airport"
            },
            "doc_count" : 29,
            "6368e806" : {
              "count" : 29,
              "min" : 200.93922424316406,
              "max" : 9841.193359375,
              "avg" : 5132.379520284719,
              "sum" : 148839.00608825684
            }
          },
          {
            "key" : {
              "54f392e6" : "Billings Logan International Airport"
            },
            "doc_count" : 39,
            "6368e806" : {
              "count" : 39,
              "min" : 663.8840942382812,
              "max" : 9570.7314453125,
              "avg" : 4720.519888070913,
              "sum" : 184100.27563476562
            }
          },
          {
            "key" : {
              "54f392e6" : "Boeing Field King County International Airport"
            },
            "doc_count" : 19,
            "6368e806" : {
              "count" : 19,
              "min" : 554.1631469726562,
              "max" : 10556.7587890625,
              "avg" : 4510.229270533511,
              "sum" : 85694.35614013672
            }
          },
          {
            "key" : {
              "54f392e6" : "Buffalo Niagara International Airport"
            },
            "doc_count" : 37,
            "6368e806" : {
              "count" : 37,
              "min" : 464.5270690917969,
              "max" : 10136.884765625,
              "avg" : 4781.712841137036,
              "sum" : 176923.3751220703
            }
          },
          {
            "key" : {
              "54f392e6" : "Casper-Natrona County International Airport"
            },
            "doc_count" : 25,
            "6368e806" : {
              "count" : 25,
              "min" : 319.8492431640625,
              "max" : 9932.6455078125,
              "avg" : 4457.515849609375,
              "sum" : 111437.89624023438
            }
          },
          {
            "key" : {
              "54f392e6" : "Charlotte Douglas International Airport"
            },
            "doc_count" : 26,
            "6368e806" : {
              "count" : 26,
              "min" : 430.3017883300781,
              "max" : 7816.8671875,
              "avg" : 4690.099148090069,
              "sum" : 121942.5778503418
            }
          },
          {
            "key" : {
              "54f392e6" : "Chicago Midway International Airport"
            },
            "doc_count" : 24,
            "6368e806" : {
              "count" : 24,
              "min" : 80.48770904541016,
              "max" : 8536.1611328125,
              "avg" : 4310.982901573181,
              "sum" : 103463.58963775635
            }
          },
          {
            "key" : {
              "54f392e6" : "Chicago O'Hare International Airport"
            },
            "doc_count" : 29,
            "6368e806" : {
              "count" : 29,
              "min" : 264.3896484375,
              "max" : 8525.7177734375,
              "avg" : 4565.218495336072,
              "sum" : 132391.3363647461
            }
          },
          {
            "key" : {
              "54f392e6" : "Chicago Rockford International Airport"
            },
            "doc_count" : 23,
            "6368e806" : {
              "count" : 23,
              "min" : 1676.5166015625,
              "max" : 8528.287109375,
              "avg" : 5030.49757982337,
              "sum" : 115701.4443359375
            }
          },
          {
            "key" : {
              "54f392e6" : "Cincinnati Northern Kentucky International Airport"
            },
            "doc_count" : 33,
            "6368e806" : {
              "count" : 33,
              "min" : 308.015625,
              "max" : 8408.453125,
              "avg" : 3961.9093202533145,
              "sum" : 130743.00756835938
            }
          },
          {
            "key" : {
              "54f392e6" : "Cleveland Hopkins International Airport"
            },
            "doc_count" : 29,
            "6368e806" : {
              "count" : 29,
              "min" : 193.06979370117188,
              "max" : 6970.42333984375,
              "avg" : 3440.1764999915813,
              "sum" : 99765.11849975586
            }
          },
          {
            "key" : {
              "54f392e6" : "Denver International Airport"
            },
            "doc_count" : 28,
            "6368e806" : {
              "count" : 28,
              "min" : 679.90087890625,
              "max" : 8776.888671875,
              "avg" : 4601.801411220005,
              "sum" : 128850.43951416016
            }
          },
          {
            "key" : {
              "54f392e6" : "Des Moines International Airport"
            },
            "doc_count" : 27,
            "6368e806" : {
              "count" : 27,
              "min" : 174.24740600585938,
              "max" : 9004.5322265625,
              "avg" : 4842.070693404587,
              "sum" : 130735.90872192383
            }
          },
          {
            "key" : {
              "54f392e6" : "Detroit Metropolitan Wayne County Airport"
            },
            "doc_count" : 27,
            "6368e806" : {
              "count" : 27,
              "min" : 214.13528442382812,
              "max" : 9896.630859375,
              "avg" : 5097.21588699906,
              "sum" : 137624.8289489746
            }
          },
          {
            "key" : {
              "54f392e6" : "Erie International Tom Ridge Field"
            },
            "doc_count" : 32,
            "6368e806" : {
              "count" : 32,
              "min" : 317.5791320800781,
              "max" : 8376.333984375,
              "avg" : 3992.1240968704224,
              "sum" : 127747.97109985352
            }
          },
          {
            "key" : {
              "54f392e6" : "Fort Wayne International Airport"
            },
            "doc_count" : 21,
            "6368e806" : {
              "count" : 21,
              "min" : 434.0052795410156,
              "max" : 8838.1611328125,
              "avg" : 4610.907477969215,
              "sum" : 96829.05703735352
            }
          },
          {
            "key" : {
              "54f392e6" : "General Edward Lawrence Logan International Airport"
            },
            "doc_count" : 28,
            "6368e806" : {
              "count" : 28,
              "min" : 254.19284057617188,
              "max" : 7897.92822265625,
              "avg" : 3554.0694405691966,
              "sum" : 99513.9443359375
            }
          },
          {
            "key" : {
              "54f392e6" : "General Mitchell International Airport"
            },
            "doc_count" : 28,
            "6368e806" : {
              "count" : 28,
              "min" : 348.36566162109375,
              "max" : 8992.8203125,
              "avg" : 4640.639875139509,
              "sum" : 129937.91650390625
            }
          },
          {
            "key" : {
              "54f392e6" : "General Wayne A. Downing Peoria International Airport"
            },
            "doc_count" : 25,
            "6368e806" : {
              "count" : 25,
              "min" : 556.4639282226562,
              "max" : 9552.6552734375,
              "avg" : 4329.158850097656,
              "sum" : 108228.9712524414
            }
          },
          {
            "key" : {
              "54f392e6" : "Greater Rochester International Airport"
            },
            "doc_count" : 20,
            "6368e806" : {
              "count" : 20,
              "min" : 253.674560546875,
              "max" : 9759.4189453125,
              "avg" : 4378.471331787109,
              "sum" : 87569.42663574219
            }
          },
          {
            "key" : {
              "54f392e6" : "Greenville Spartanburg International Airport"
            },
            "doc_count" : 24,
            "6368e806" : {
              "count" : 24,
              "min" : 401.09112548828125,
              "max" : 9429.73046875,
              "avg" : 4126.4176686604815,
              "sum" : 99034.02404785156
            }
          },
          {
            "key" : {
              "54f392e6" : "Hartsfield Jackson Atlanta International Airport"
            },
            "doc_count" : 17,
            "6368e806" : {
              "count" : 17,
              "min" : 739.2357177734375,
              "max" : 8695.5869140625,
              "avg" : 4827.774543313419,
              "sum" : 82072.16723632812
            }
          },
          {
            "key" : {
              "54f392e6" : "Huntsville International Carl T Jones Field"
            },
            "doc_count" : 19,
            "6368e806" : {
              "count" : 19,
              "min" : 630.4315185546875,
              "max" : 9585.1142578125,
              "avg" : 4757.48379998458,
              "sum" : 90392.19219970703
            }
          },
          {
            "key" : {
              "54f392e6" : "Indianapolis International Airport"
            },
            "doc_count" : 36,
            "6368e806" : {
              "count" : 36,
              "min" : 552.6693115234375,
              "max" : 8882.255859375,
              "avg" : 4181.601038614909,
              "sum" : 150537.63739013672
            }
          },
          {
            "key" : {
              "54f392e6" : "Jackson-Medgar Wiley Evers International Airport"
            },
            "doc_count" : 31,
            "6368e806" : {
              "count" : 31,
              "min" : 541.1387329101562,
              "max" : 8992.4453125,
              "avg" : 4517.459484469506,
              "sum" : 140041.2440185547
            }
          },
          {
            "key" : {
              "54f392e6" : "John F Kennedy International Airport"
            },
            "doc_count" : 31,
            "6368e806" : {
              "count" : 31,
              "min" : 337.11578369140625,
              "max" : 8303.2958984375,
              "avg" : 4014.7968257781,
              "sum" : 124458.7015991211
            }
          },
          {
            "key" : {
              "54f392e6" : "Los Angeles International Airport"
            },
            "doc_count" : 30,
            "6368e806" : {
              "count" : 30,
              "min" : 833.558837890625,
              "max" : 8741.6455078125,
              "avg" : 4732.04223022461,
              "sum" : 141961.26690673828
            }
          },
          {
            "key" : {
              "54f392e6" : "Louisville International Standiford Field"
            },
            "doc_count" : 23,
            "6368e806" : {
              "count" : 23,
              "min" : 335.2744140625,
              "max" : 9713.8701171875,
              "avg" : 3818.679406207541,
              "sum" : 87829.62634277344
            }
          },
          {
            "key" : {
              "54f392e6" : "Memphis International Airport"
            },
            "doc_count" : 26,
            "6368e806" : {
              "count" : 26,
              "min" : 442.78802490234375,
              "max" : 8768.5439453125,
              "avg" : 4875.398350642277,
              "sum" : 126760.35711669922
            }
          },
          {
            "key" : {
              "54f392e6" : "Miami International Airport"
            },
            "doc_count" : 30,
            "6368e806" : {
              "count" : 30,
              "min" : 439.7237548828125,
              "max" : 9147.4990234375,
              "avg" : 4785.46259358724,
              "sum" : 143563.8778076172
            }
          },
          {
            "key" : {
              "54f392e6" : "Minneapolis-St Paul International/Wold-Chamberlain Airport"
            },
            "doc_count" : 25,
            "6368e806" : {
              "count" : 25,
              "min" : 470.97430419921875,
              "max" : 9004.7626953125,
              "avg" : 3785.777373046875,
              "sum" : 94644.43432617188
            }
          },
          {
            "key" : {
              "54f392e6" : "Newport News Williamsburg International Airport"
            },
            "doc_count" : 22,
            "6368e806" : {
              "count" : 22,
              "min" : 22.981517791748047,
              "max" : 9775.765625,
              "avg" : 4113.748561165549,
              "sum" : 90502.46834564209
            }
          },
          {
            "key" : {
              "54f392e6" : "Norfolk International Airport"
            },
            "doc_count" : 45,
            "6368e806" : {
              "count" : 45,
              "min" : 160.3270263671875,
              "max" : 9788.8515625,
              "avg" : 4929.9432335747615,
              "sum" : 221847.44551086426
            }
          },
          {
            "key" : {
              "54f392e6" : "Orlando Sanford International Airport"
            },
            "doc_count" : 27,
            "6368e806" : {
              "count" : 27,
              "min" : 864.1926879882812,
              "max" : 9358.029296875,
              "avg" : 4283.839454933449,
              "sum" : 115663.66528320312
            }
          },
          {
            "key" : {
              "54f392e6" : "Philadelphia International Airport"
            },
            "doc_count" : 21,
            "6368e806" : {
              "count" : 21,
              "min" : 228.00880432128906,
              "max" : 7427.111328125,
              "avg" : 4017.50319199335,
              "sum" : 84367.56703186035
            }
          },
          {
            "key" : {
              "54f392e6" : "Phoenix Sky Harbor International Airport"
            },
            "doc_count" : 27,
            "6368e806" : {
              "count" : 27,
              "min" : 304.218994140625,
              "max" : 8879.060546875,
              "avg" : 5198.780445240162,
              "sum" : 140367.07202148438
            }
          },
          {
            "key" : {
              "54f392e6" : "Piedmont Triad International Airport"
            },
            "doc_count" : 24,
            "6368e806" : {
              "count" : 24,
              "min" : 66.19200134277344,
              "max" : 9574.158203125,
              "avg" : 4110.762691497803,
              "sum" : 98658.30459594727
            }
          },
          {
            "key" : {
              "54f392e6" : "Pittsburgh International Airport"
            },
            "doc_count" : 32,
            "6368e806" : {
              "count" : 32,
              "min" : 258.8587951660156,
              "max" : 9611.0576171875,
              "avg" : 4049.5155725479126,
              "sum" : 129584.4983215332
            }
          },
          {
            "key" : {
              "54f392e6" : "Portland International Airport"
            },
            "doc_count" : 26,
            "6368e806" : {
              "count" : 26,
              "min" : 129.2322540283203,
              "max" : 7911.83544921875,
              "avg" : 4243.002852806678,
              "sum" : 110318.07417297363
            }
          },
          {
            "key" : {
              "54f392e6" : "Portland International Jetport Airport"
            },
            "doc_count" : 23,
            "6368e806" : {
              "count" : 23,
              "min" : 1340.5982666015625,
              "max" : 10130.08203125,
              "avg" : 5187.1217677904215,
              "sum" : 119303.80065917969
            }
          },
          {
            "key" : {
              "54f392e6" : "Quad City International Airport"
            },
            "doc_count" : 32,
            "6368e806" : {
              "count" : 32,
              "min" : 668.467041015625,
              "max" : 9092.8525390625,
              "avg" : 3832.8298778533936,
              "sum" : 122650.5560913086
            }
          },
          {
            "key" : {
              "54f392e6" : "Raleigh Durham International Airport"
            },
            "doc_count" : 27,
            "6368e806" : {
              "count" : 27,
              "min" : 636.0322875976562,
              "max" : 9633.85546875,
              "avg" : 4926.278697826244,
              "sum" : 133009.5248413086
            }
          },
          {
            "key" : {
              "54f392e6" : "Reno Tahoe International Airport"
            },
            "doc_count" : 26,
            "6368e806" : {
              "count" : 26,
              "min" : 191.69497680664062,
              "max" : 7603.158203125,
              "avg" : 4823.237944382888,
              "sum" : 125404.18655395508
            }
          },
          {
            "key" : {
              "54f392e6" : "Richmond International Airport"
            },
            "doc_count" : 29,
            "6368e806" : {
              "count" : 29,
              "min" : 1031.249267578125,
              "max" : 9735.2509765625,
              "avg" : 5720.753481108567,
              "sum" : 165901.85095214844
            }
          },
          {
            "key" : {
              "54f392e6" : "Rochester International Airport"
            },
            "doc_count" : 32,
            "6368e806" : {
              "count" : 32,
              "min" : 395.2222595214844,
              "max" : 9027.265625,
              "avg" : 4539.266858100891,
              "sum" : 145256.53945922852
            }
          },
          {
            "key" : {
              "54f392e6" : "Salt Lake City International Airport"
            },
            "doc_count" : 21,
            "6368e806" : {
              "count" : 21,
              "min" : 546.1231079101562,
              "max" : 8013.53173828125,
              "avg" : 4141.730648949033,
              "sum" : 86976.34362792969
            }
          },
          {
            "key" : {
              "54f392e6" : "San Antonio International Airport"
            },
            "doc_count" : 29,
            "6368e806" : {
              "count" : 29,
              "min" : 483.1341552734375,
              "max" : 8410.736328125,
              "avg" : 4941.95766896215,
              "sum" : 143316.77239990234
            }
          },
          {
            "key" : {
              "54f392e6" : "San Diego International Airport"
            },
            "doc_count" : 39,
            "6368e806" : {
              "count" : 39,
              "min" : 367.62481689453125,
              "max" : 7509.64306640625,
              "avg" : 5707.988306290064,
              "sum" : 222611.5439453125
            }
          },
          {
            "key" : {
              "54f392e6" : "San Francisco International Airport"
            },
            "doc_count" : 23,
            "6368e806" : {
              "count" : 23,
              "min" : 751.4320678710938,
              "max" : 7417.0625,
              "avg" : 4973.923050590183,
              "sum" : 114400.23016357422
            }
          },
          {
            "key" : {
              "54f392e6" : "Savannah Hilton Head International Airport"
            },
            "doc_count" : 28,
            "6368e806" : {
              "count" : 28,
              "min" : 689.1752319335938,
              "max" : 7833.34375,
              "avg" : 4700.471019199917,
              "sum" : 131613.18853759766
            }
          },
          {
            "key" : {
              "54f392e6" : "Scott AFB/Midamerica Airport"
            },
            "doc_count" : 26,
            "6368e806" : {
              "count" : 26,
              "min" : 32.1550407409668,
              "max" : 9082.130859375,
              "avg" : 4844.910936062152,
              "sum" : 125967.68433761597
            }
          },
          {
            "key" : {
              "54f392e6" : "Seattle Tacoma International Airport"
            },
            "doc_count" : 28,
            "6368e806" : {
              "count" : 28,
              "min" : 1154.076171875,
              "max" : 7739.4794921875,
              "avg" : 4859.488420758928,
              "sum" : 136065.67578125
            }
          },
          {
            "key" : {
              "54f392e6" : "St Louis Lambert International Airport"
            },
            "doc_count" : 25,
            "6368e806" : {
              "count" : 25,
              "min" : 391.7249450683594,
              "max" : 7248.33056640625,
              "avg" : 4202.95279663086,
              "sum" : 105073.81991577148
            }
          },
          {
            "key" : {
              "54f392e6" : "Syracuse Hancock International Airport"
            },
            "doc_count" : 28,
            "6368e806" : {
              "count" : 28,
              "min" : 296.0372009277344,
              "max" : 7084.552734375,
              "avg" : 3531.5293611798966,
              "sum" : 98882.82211303711
            }
          },
          {
            "key" : {
              "54f392e6" : "Tucson International Airport"
            },
            "doc_count" : 35,
            "6368e806" : {
              "count" : 35,
              "min" : 855.7213134765625,
              "max" : 7178.3212890625,
              "avg" : 5138.726907784599,
              "sum" : 179855.44177246094
            }
          },
          {
            "key" : {
              "54f392e6" : "Tulsa International Airport"
            },
            "doc_count" : 36,
            "6368e806" : {
              "count" : 36,
              "min" : 131.65792846679688,
              "max" : 7318.57373046875,
              "avg" : 4833.106824239095,
              "sum" : 173991.84567260742
            }
          },
          {
            "key" : {
              "54f392e6" : "Washington Dulles International Airport"
            },
            "doc_count" : 25,
            "6368e806" : {
              "count" : 25,
              "min" : 1087.35595703125,
              "max" : 7365.32080078125,
              "avg" : 4130.17978515625,
              "sum" : 103254.49462890625
            }
          },
          {
            "key" : {
              "54f392e6" : "Wichita Mid Continent Airport"
            },
            "doc_count" : 35,
            "6368e806" : {
              "count" : 35,
              "min" : 846.4845581054688,
              "max" : 7194.1533203125,
              "avg" : 4270.185804966518,
              "sum" : 149456.50317382812
            }
          }
        ]
      }
    }
  }

  ```

  </details>

  ```json
  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        Origin AS OriginAirport,
        ST_Distance(OriginLocation, DestLocation) AS FlightDistance
      FROM
        kibana_sample_data_flights
      WHERE 
        OriginCountry = 'US'
    LIMIT
      20
    """
  }
  ```

  <details>
  <summary>Response:</summary>

  ```json

                 OriginAirport               |   FlightDistance   
  -------------------------------------------+--------------------
  Albuquerque International Sunport Airport  |8530471.523590479   
  Cleveland Hopkins International Airport    |8804656.88256446    
  Casper-Natrona County International Airport|1.2059129365440216E7
  Erie International Tom Ridge Field         |1550053.4827251192  
  Newark Liberty International Airport       |529064.9064640459   
  Seattle Tacoma International Airport       |8670950.754035722   
  Phoenix Sky Harbor International Airport   |488616.2086253764   
  Tulsa International Airport                |8071962.524039903   
  Louisville International Standiford Field  |1.0523582225118136E7
  Spokane International Airport              |1973804.45463224    
  Portland International Airport             |8568217.389155334   
  Piedmont Triad International Airport       |7090511.398003435   
  John F Kennedy International Airport       |3928043.005128699   
  Miami International Airport                |7845036.284808581   
  Erie International Tom Ridge Field         |3599647.440946715   
  San Diego International Airport            |9861604.138141762   
  Casper-Natrona County International Airport|1.1274045942420863E7
  Pittsburgh International Airport           |6628396.810461743   
  Bangor International Airport               |1.073857077132059E7 
  Salt Lake City International Airport       |8235446.624366924   

  ```

- IN Query DSL

  ```json
  GET /kibana_sample_data_flights/_search
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
        "composite" : {
          "size" : 1000,
          "sources" : [
            {
              "54f392e6" : {
                "terms" : {
                  "field" : "Origin",
                  "missing_bucket" : true,
                  "order" : "asc"
                }
              }
            }
          ]
        },
        "aggregations" : {
          "6368e806" : {
            "stats" : {
              "field" : "DistanceMiles"
            }
          },
          "having.a18a5aef" : {
            "bucket_selector" : {
              "buckets_path" : {
                "a0" : "6368e806.min"
              },
              "script" : {
                "source" : "InternalQlScriptUtils.nullSafeFilter(InternalQlScriptUtils.gt(params.a0,params.v0))",
                "lang" : "painless",
                "params" : {
                  "v0" : 0
                }
              },
              "gap_policy" : "skip"
            }
          }
        }
      }
    }
  }

  ``` 

  <details>
  <summary>Response:</summary>

  ```json
  ```

  </detail>

- Translate to Query DSL

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

- Translate to Query DSL

  ```json

  GET _sql/translate
  {
    "query": """
      SELECT  
        Origin AS OriginAirport,
        ST_Distance(OriginLocation, DestLocation) AS FlightDistance
      FROM
        kibana_sample_data_flights
      WHERE 
        OriginCountry = 'US'
    LIMIT
      20
    """
  }
  ```

  <details>
  <summary>Response:</summary>

  ```json

  {
    "size" : 20,
    "query" : {
      "term" : {
        "OriginCountry" : {
          "value" : "US",
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "Origin"
      },
      {
        "field" : "OriginLocation"
      },
      {
        "field" : "DestLocation"
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

- IN Query DSL

  ```json
  GET /kibana_sample_data_flights/_search
  {
    "size" : 20,
    "query" : {
      "term" : {
        "OriginCountry" : {
          "value" : "US",
          "boost" : 1.0
        }
      }
    },
    "_source" : false,
    "fields" : [
      {
        "field" : "Origin"
      },
      {
        "field" : "OriginLocation"
      },
      {
        "field" : "DestLocation"
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
      "hits" : [
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "RSmW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Albuquerque International Sunport Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -106.609001,
                  35.040199
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  24.9633007,
                  60.31719971
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            10
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "TCmW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Cleveland Hopkins International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -81.84980011,
                  41.4117012
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  -58.5358,
                  -34.8222
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            17
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "TimW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Casper-Natrona County International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -106.4639969,
                  42.90800095
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  77.103104,
                  28.5665
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            19
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "TymW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Erie International Tom Ridge Field"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -80.17386675,
                  42.08312701
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  -97.43309784,
                  37.64989853
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            20
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "UCmW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Newark Liberty International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -74.16870117,
                  40.69250107
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  -75.66919708,
                  45.32249832
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            21
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "UimW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Seattle Tacoma International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -122.3089981,
                  47.44900131
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  16.56970024,
                  48.11029816
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            23
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "VimW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Phoenix Sky Harbor International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -112.012001,
                  33.43429947
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  -117.1900024,
                  32.73360062
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            27
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "WCmW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Tulsa International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -95.88809967,
                  36.19839859
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  8.54917,
                  47.464699
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            29
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "WymW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Louisville International Standiford Field"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -85.736,
                  38.1744
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  140.3860016,
                  35.76470184
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            32
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "XCmW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Spokane International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -117.5339966,
                  47.61989975
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  -97.43309784,
                  37.64989853
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            33
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "XSmW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Portland International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -122.5979996,
                  45.58869934
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  37.4146,
                  55.972599
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            34
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "XymW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Piedmont Triad International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -79.93730164,
                  36.09780121
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  7.64963,
                  45.200802
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            36
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "YimW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "John F Kennedy International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -73.77890015,
                  40.63980103
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  -117.1900024,
                  32.73360062
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            39
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "aCmW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Miami International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -80.29060364,
                  25.79319954
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  8.54917,
                  47.464699
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            45
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "mimW3YcB-Y6qIH7VA0FN",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Erie International Tom Ridge Field"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -80.17386675,
                  42.08312701
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  -122.375,
                  37.61899948
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            95
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "rCmW3YcB-Y6qIH7VA0FO",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "San Diego International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -117.1900024,
                  32.73360062
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  37.4146,
                  55.972599
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            113
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "sCmW3YcB-Y6qIH7VA0FO",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Casper-Natrona County International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -106.4639969,
                  42.90800095
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  103.9469986,
                  30.57850075
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            117
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "ximW3YcB-Y6qIH7VA0FO",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Pittsburgh International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -80.23290253,
                  40.49150085
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  17.91860008,
                  59.65190125
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            139
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "yCmW3YcB-Y6qIH7VA0FO",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Bangor International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -68.82810211,
                  44.80739975
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  126.4509964,
                  37.46910095
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            141
          ]
        },
        {
          "_index" : "kibana_sample_data_flights",
          "_type" : "_doc",
          "_id" : "zSmW3YcB-Y6qIH7VA0FO",
          "_score" : null,
          "fields" : {
            "Origin" : [
              "Salt Lake City International Airport"
            ],
            "OriginLocation" : [
              {
                "coordinates" : [
                  -111.9779968,
                  40.78839874
                ],
                "type" : "Point"
              }
            ],
            "DestLocation" : [
              {
                "coordinates" : [
                  128.445007,
                  51.169997
                ],
                "type" : "Point"
              }
            ]
          },
          "sort" : [
            146
          ]
        }
      ]
    }
  }
  ```

  </details>

### No comment

- Date/Time and Interval Functions and Operators

  ```json

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        INTERVAL 1 DAY  AS Result
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CAST('1969-05-13T12:34:56' AS DATETIME)  AS Result
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CAST('1969-05-13T12:34:56' AS DATETIME) + INTERVAL 45 YEARS  AS Result
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
      - INTERVAL '49-1' YEAR TO MONTH AS Result
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        INTERVAL '1' DAYS - INTERVAL '2' HOURS Result
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CAST('2018-05-13T12:34:56' AS DATETIME) - INTERVAL '2' YEARS AS Result1,
        CAST('2018-05-13T12:34:56' AS DATETIME) - INTERVAL '2-8' YEARS TO MONTH AS Result2
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        -2 * INTERVAL '3' YEARS AS Result
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CURRENT_DATE AS result1,
        CURRENT_DATE() AS result2,
        CURDATE() AS result3,
        TODAY() AS result4
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        TODAY() - INTERVAL 53 YEARS AS result
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CURRENT_TIME   AS result1,
        CURRENT_TIME() AS result2,
        CURTIME()      AS result3
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CAST('12:34:56' AS TIME) - INTERVAL '20' MINUTES AS result
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CURRENT_TIME    AS def_precision,
        CURRENT_TIME(1) AS precision_1,
        CURRENT_TIME(2) AS precision_2,
        CURRENT_TIME(3) AS precision_3
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CURRENT_TIMESTAMP    AS def_precision,
        CURRENT_TIMESTAMP(1) AS precision_1,
        CURRENT_TIMESTAMP(2) AS precision_2,
        CURRENT_TIMESTAMP(3) AS precision_3
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        NOW() - INTERVAL '100' YEARS AS result
    """
  }

  ```

- DATE_ADD , DATEADD , TIMESTAMP_ADD , TIMESTAMPADD

  ```json

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        DATE_ADD('years', 10, '2019-09-04T11:22:33.000Z'::datetime)  AS "+10 years",
        DATEADD('week', 10, '2019-09-04T11:22:33.000Z'::datetime) AS "+10 week",
        DATE_ADD('seconds', -1234, '2019-09-04T11:22:33.000Z'::datetime) AS "-1234 seconds",
        DATEADD('qq', -417, '2019-09-04T11:22:33.000Z'::datetime) AS "-417 quarters",
        DATEADD('minutes', 9235, '2019-09-04T11:22:33.000Z'::datetime) AS "+9235 minutes"
    """
  }

  ```

- DATE_DIF , DATEDIF , TIMESTAMP_DIF , TIMESTAMPDIF

  ```json

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        DATE_DIFF('years','2019-09-04T11:22:33.000Z'::datetime,'2032-09-04T22:33:11.000Z'::datetime) AS "diffInYears",
        DATEDIFF('week','2019-09-04T11:22:33.000Z'::datetime,'2032-09-04T22:33:11.000Z'::datetime) AS "diffInWeeks",
        DATEDIFF('seconds','2019-09-04T11:22:33.000Z'::datetime,'2032-09-04T22:33:11.000Z'::datetime) AS "diffInSeconds"
    """
  }

  ```

- DATE_PARSE , DATETIME_PARSE , TIME_PARSE

  ```json

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        DATE_PARSE('07/04/2020', 'dd/MM/yyyy') AS "date"
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        DATE_PARSE('07/04/2020', 'dd/MM/yyyy') AS "date"
    """,
    "time_zone": "Asia/Tehran"
  }  

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        DATETIME_PARSE('07/04/2020 10:20:30.123', 'dd/MM/yyyy HH:mm:ss.SSS') AS "datetime"
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        DATETIME_PARSE('10:20:30 07/04/2020 Asia/Tehran', 'HH:mm:ss dd/MM/yyyy VV') AS "datetime"
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        TIME_PARSE('10:20:30.123', 'HH:mm:ss.SSS') AS "time"
    """
  }

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        TIME_PARSE('10:20:30-03:30', 'HH:mm:ssXXX') AS "time"
    """
  }

  ```

- DATETIME_FORMAT

  ```json

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CAST('2020-04-05' AS DATE) AS "casted_date",
        DATETIME_FORMAT(CAST('2020-04-05' AS DATE), 'dd/MM/yyyy') AS "formated_date"
    """
  }

  ```

  ```json

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CAST('2020-04-05T11:22:33.987654' AS DATETIME) AS "Casted_datetime",
        DATETIME_FORMAT(CAST('2020-04-05T11:22:33.987654' AS DATETIME), 'dd/MM/yyyy HH:mm:ss.SS') AS "Formated_datetime"
    """
  }

  ```

  ```json

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        CAST('11:22:33.987' AS TIME) AS "Casted_time",
        DATETIME_FORMAT(CAST('11:22:33.987' AS TIME), 'HH mm ss.SS') AS "Formated_time"
    """
  }

  ```

- DATE_PART , DATEPART

  ```json

  GET /_sql?format=txt
  {
    "query": """
      SELECT  
        DATE_PART('years', '2019-09-22T11:22:33.123Z'::datetime) AS "years",
        DATE_PART('mi', '2019-09-22T11:22:33.123Z'::datetime) AS "minutes",
        DATE_PART('quarters', '2019-09-22'::date) AS "quarter",
        DATE_PART('quarters', CAST('2019-09-22' AS DATE)) AS "quarter02",
        DATE_PART('month', CAST('2019-09-22' AS DATE)) AS "month"
        
    """
  }

  ```

