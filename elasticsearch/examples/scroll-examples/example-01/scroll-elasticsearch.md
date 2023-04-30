### Scroll

See [scroll-elasticsearch](https://linuxhint.com/scroll-elasticsearch/)

#### Recap

See [Scroll in elasticsearch](https://github.com/rasoulifarhad/elastic-stack/blob/main/elasticsearch/recap-docs/scroll-in-elasticsearch.md)

#### Basic 

We will use the kibana_sample_data_flights sample data.

Get the number of flights where the ticket price was greater than 500 and less than 1000.

```json

GET /kibana_sample_data_flights/_search
{
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}

```

<details>
  <summary>Response:</summary>

```json

{
  "took" : 5,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 7844,
      "relation" : "eq"
    },
    "max_score" : 2.0,
    "hits" : [
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "kCeJ0ocB94UPqIvUfjfr",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "9HY9SWR",
          "DestCountry" : "AU",
          "OriginWeather" : "Sunny",
          "OriginCityName" : "Frankfurt am Main",
          "AvgTicketPrice" : 841.2656419677076,
          "DistanceMiles" : 10247.856675613455,
          "FlightDelay" : false,
          "DestWeather" : "Rain",
          "Dest" : "Sydney Kingsford Smith International Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "DE",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 16492.32665375846,
          "timestamp" : "2023-04-24T00:00:00",
          "DestLocation" : {
            "lat" : "-33.94609833",
            "lon" : "151.177002"
          },
          "DestAirportID" : "SYD",
          "Carrier" : "Kibana Airlines",
          "Cancelled" : false,
          "FlightTimeMin" : 1030.7704158599038,
          "Origin" : "Frankfurt am Main Airport",
          "OriginLocation" : {
            "lat" : "50.033333",
            "lon" : "8.570556"
          },
          "DestRegion" : "SE-BD",
          "OriginAirportID" : "FRA",
          "OriginRegion" : "DE-HE",
          "DestCityName" : "Sydney",
          "FlightTimeHour" : 17.179506930998397,
          "FlightDelayMin" : 0
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "kSeJ0ocB94UPqIvUfjfr",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "X98CCZO",
          "DestCountry" : "IT",
          "OriginWeather" : "Clear",
          "OriginCityName" : "Cape Town",
          "AvgTicketPrice" : 882.9826615595518,
          "DistanceMiles" : 5482.606664853586,
          "FlightDelay" : false,
          "DestWeather" : "Sunny",
          "Dest" : "Venice Marco Polo Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "ZA",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 8823.40014044213,
          "timestamp" : "2023-04-24T18:27:00",
          "DestLocation" : {
            "lat" : "45.505299",
            "lon" : "12.3519"
          },
          "DestAirportID" : "VE05",
          "Carrier" : "Logstash Airways",
          "Cancelled" : false,
          "FlightTimeMin" : 464.3894810759016,
          "Origin" : "Cape Town International Airport",
          "OriginLocation" : {
            "lat" : "-33.96480179",
            "lon" : "18.60169983"
          },
          "DestRegion" : "IT-34",
          "OriginAirportID" : "CPT",
          "OriginRegion" : "SE-BD",
          "DestCityName" : "Venice",
          "FlightTimeHour" : 7.73982468459836,
          "FlightDelayMin" : 0
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "lCeJ0ocB94UPqIvUfjfr",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "58U013N",
          "DestCountry" : "CN",
          "OriginWeather" : "Damaging Wind",
          "OriginCityName" : "Mexico City",
          "AvgTicketPrice" : 730.041778346198,
          "DistanceMiles" : 8300.428124665925,
          "FlightDelay" : false,
          "DestWeather" : "Clear",
          "Dest" : "Xi'an Xianyang International Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "MX",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 13358.24419986236,
          "timestamp" : "2023-04-24T05:13:00",
          "DestLocation" : {
            "lat" : "34.447102",
            "lon" : "108.751999"
          },
          "DestAirportID" : "XIY",
          "Carrier" : "Kibana Airlines",
          "Cancelled" : false,
          "FlightTimeMin" : 785.7790705801389,
          "Origin" : "Licenciado Benito Juarez International Airport",
          "OriginLocation" : {
            "lat" : "19.4363",
            "lon" : "-99.072098"
          },
          "DestRegion" : "SE-BD",
          "OriginAirportID" : "AICM",
          "OriginRegion" : "MX-DIF",
          "DestCityName" : "Xi'an",
          "FlightTimeHour" : 13.096317843002314,
          "FlightDelayMin" : 0
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "lyeJ0ocB94UPqIvUfjfr",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "1IRBW25",
          "DestCountry" : "CA",
          "OriginWeather" : "Thunder & Lightning",
          "OriginCityName" : "Rome",
          "AvgTicketPrice" : 585.1843103083941,
          "DistanceMiles" : 4203.1829639346715,
          "FlightDelay" : false,
          "DestWeather" : "Clear",
          "Dest" : "Ottawa Macdonald-Cartier International Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "IT",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 6764.367283910481,
          "timestamp" : "2023-04-24T04:54:59",
          "DestLocation" : {
            "lat" : "45.32249832",
            "lon" : "-75.66919708"
          },
          "DestAirportID" : "YOW",
          "Carrier" : "Kibana Airlines",
          "Cancelled" : false,
          "FlightTimeMin" : 614.9424803554983,
          "Origin" : "Ciampino___G. B. Pastine International Airport",
          "OriginLocation" : {
            "lat" : "41.7994",
            "lon" : "12.5949"
          },
          "DestRegion" : "CA-ON",
          "OriginAirportID" : "RM12",
          "OriginRegion" : "IT-62",
          "DestCityName" : "Ottawa",
          "FlightTimeHour" : 10.249041339258305,
          "FlightDelayMin" : 0
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "mCeJ0ocB94UPqIvUfjfr",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "M05KE88",
          "DestCountry" : "IN",
          "OriginWeather" : "Heavy Fog",
          "OriginCityName" : "Milan",
          "AvgTicketPrice" : 960.8697358054351,
          "DistanceMiles" : 4377.166776556647,
          "FlightDelay" : true,
          "DestWeather" : "Cloudy",
          "Dest" : "Rajiv Gandhi International Airport",
          "FlightDelayType" : "NAS Delay",
          "OriginCountry" : "IT",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 7044.367088850781,
          "timestamp" : "2023-04-24T12:09:35",
          "DestLocation" : {
            "lat" : "17.23131752",
            "lon" : "78.42985535"
          },
          "DestAirportID" : "HYD",
          "Carrier" : "Kibana Airlines",
          "Cancelled" : true,
          "FlightTimeMin" : 602.0305907375651,
          "Origin" : "Milano Linate Airport",
          "OriginLocation" : {
            "lat" : "45.445099",
            "lon" : "9.27674"
          },
          "DestRegion" : "SE-BD",
          "OriginAirportID" : "MI11",
          "OriginRegion" : "IT-25",
          "DestCityName" : "Hyderabad",
          "FlightTimeHour" : 10.033843178959419,
          "FlightDelayMin" : 15
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "mieJ0ocB94UPqIvUfjfs",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "JQ2XXQ5",
          "DestCountry" : "FI",
          "OriginWeather" : "Rain",
          "OriginCityName" : "Albuquerque",
          "AvgTicketPrice" : 906.4379477399872,
          "DistanceMiles" : 5313.8222112173335,
          "FlightDelay" : false,
          "DestWeather" : "Rain",
          "Dest" : "Helsinki Vantaa Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "US",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 8551.76789268935,
          "timestamp" : "2023-04-24T22:06:14",
          "DestLocation" : {
            "lat" : "60.31719971",
            "lon" : "24.9633007"
          },
          "DestAirportID" : "HEL",
          "Carrier" : "JetBeats",
          "Cancelled" : false,
          "FlightTimeMin" : 503.04517015819704,
          "Origin" : "Albuquerque International Sunport Airport",
          "OriginLocation" : {
            "lat" : "35.040199",
            "lon" : "-106.609001"
          },
          "DestRegion" : "FI-ES",
          "OriginAirportID" : "ABQ",
          "OriginRegion" : "US-NM",
          "DestCityName" : "Helsinki",
          "FlightTimeHour" : 8.384086169303284,
          "FlightDelayMin" : 0
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "myeJ0ocB94UPqIvUfjfs",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "V30ITD0",
          "DestCountry" : "AT",
          "OriginWeather" : "Rain",
          "OriginCityName" : "Venice",
          "AvgTicketPrice" : 704.4637710312036,
          "DistanceMiles" : 268.99172653633303,
          "FlightDelay" : false,
          "DestWeather" : "Cloudy",
          "Dest" : "Vienna International Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "IT",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 432.90022115088834,
          "timestamp" : "2023-04-24T11:52:34",
          "DestLocation" : {
            "lat" : "48.11029816",
            "lon" : "16.56970024"
          },
          "DestAirportID" : "VIE",
          "Carrier" : "Logstash Airways",
          "Cancelled" : false,
          "FlightTimeMin" : 36.07501842924069,
          "Origin" : "Venice Marco Polo Airport",
          "OriginLocation" : {
            "lat" : "45.505299",
            "lon" : "12.3519"
          },
          "DestRegion" : "AT-9",
          "OriginAirportID" : "VE05",
          "OriginRegion" : "IT-34",
          "DestCityName" : "Vienna",
          "FlightTimeHour" : 0.6012503071540115,
          "FlightDelayMin" : 0
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "nCeJ0ocB94UPqIvUfjfs",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "P0WMFH7",
          "DestCountry" : "CN",
          "OriginWeather" : "Heavy Fog",
          "OriginCityName" : "Mexico City",
          "AvgTicketPrice" : 922.499077027416,
          "DistanceMiles" : 8025.381414737853,
          "FlightDelay" : false,
          "DestWeather" : "Clear",
          "Dest" : "Shanghai Pudong International Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "MX",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 12915.599427519877,
          "timestamp" : "2023-04-24T02:13:46",
          "DestLocation" : {
            "lat" : "31.14340019",
            "lon" : "121.8050003"
          },
          "DestAirportID" : "PVG",
          "Carrier" : "Logstash Airways",
          "Cancelled" : true,
          "FlightTimeMin" : 679.7683909220988,
          "Origin" : "Licenciado Benito Juarez International Airport",
          "OriginLocation" : {
            "lat" : "19.4363",
            "lon" : "-99.072098"
          },
          "DestRegion" : "SE-BD",
          "OriginAirportID" : "AICM",
          "OriginRegion" : "MX-DIF",
          "DestCityName" : "Shanghai",
          "FlightTimeHour" : 11.32947318203498,
          "FlightDelayMin" : 0
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "nieJ0ocB94UPqIvUfjfs",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "NRHSVG8",
          "DestCountry" : "PR",
          "OriginWeather" : "Cloudy",
          "OriginCityName" : "Rome",
          "AvgTicketPrice" : 552.9173708459598,
          "DistanceMiles" : 4806.775668847457,
          "FlightDelay" : false,
          "DestWeather" : "Clear",
          "Dest" : "Luis Munoz Marin International Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "IT",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 7735.755582005642,
          "timestamp" : "2023-04-24T17:42:53",
          "DestLocation" : {
            "lat" : "18.43939972",
            "lon" : "-66.00180054"
          },
          "DestAirportID" : "SJU",
          "Carrier" : "Logstash Airways",
          "Cancelled" : false,
          "FlightTimeMin" : 407.1450306318759,
          "Origin" : "Ciampino___G. B. Pastine International Airport",
          "OriginLocation" : {
            "lat" : "41.7994",
            "lon" : "12.5949"
          },
          "DestRegion" : "PR-U-A",
          "OriginAirportID" : "RM12",
          "OriginRegion" : "IT-62",
          "DestCityName" : "San Juan",
          "FlightTimeHour" : 6.7857505105312645,
          "FlightDelayMin" : 0
        }
      },
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "nyeJ0ocB94UPqIvUfjfs",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "YIPS2BZ",
          "DestCountry" : "DE",
          "OriginWeather" : "Thunder & Lightning",
          "OriginCityName" : "Chengdu",
          "AvgTicketPrice" : 566.4875569256166,
          "DistanceMiles" : 4896.74792596565,
          "FlightDelay" : false,
          "DestWeather" : "Sunny",
          "Dest" : "Cologne Bonn Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "CN",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 7880.551894165264,
          "timestamp" : "2023-04-24T19:55:32",
          "DestLocation" : {
            "lat" : "50.86589813",
            "lon" : "7.142739773"
          },
          "DestAirportID" : "CGN",
          "Carrier" : "Kibana Airlines",
          "Cancelled" : true,
          "FlightTimeMin" : 656.7126578471053,
          "Origin" : "Chengdu Shuangliu International Airport",
          "OriginLocation" : {
            "lat" : "30.57850075",
            "lon" : "103.9469986"
          },
          "DestRegion" : "DE-NW",
          "OriginAirportID" : "CTU",
          "OriginRegion" : "SE-BD",
          "DestCityName" : "Cologne",
          "FlightTimeHour" : 10.945210964118422,
          "FlightDelayMin" : 0
        }
      }
    ]
  }
}

```

</details>

If only want to view one record at a time instead of the entire records.

```json

GET /kibana_sample_data_flights/_search
{
  "from": 0, 
  "size": 1, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
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
      "value" : 7844,
      "relation" : "eq"
    },
    "max_score" : 2.0,
    "hits" : [
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "kCeJ0ocB94UPqIvUfjfr",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "9HY9SWR",
          "DestCountry" : "AU",
          "OriginWeather" : "Sunny",
          "OriginCityName" : "Frankfurt am Main",
          "AvgTicketPrice" : 841.2656419677076,
          "DistanceMiles" : 10247.856675613455,
          "FlightDelay" : false,
          "DestWeather" : "Rain",
          "Dest" : "Sydney Kingsford Smith International Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "DE",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 16492.32665375846,
          "timestamp" : "2023-04-24T00:00:00",
          "DestLocation" : {
            "lat" : "-33.94609833",
            "lon" : "151.177002"
          },
          "DestAirportID" : "SYD",
          "Carrier" : "Kibana Airlines",
          "Cancelled" : false,
          "FlightTimeMin" : 1030.7704158599038,
          "Origin" : "Frankfurt am Main Airport",
          "OriginLocation" : {
            "lat" : "50.033333",
            "lon" : "8.570556"
          },
          "DestRegion" : "SE-BD",
          "OriginAirportID" : "FRA",
          "OriginRegion" : "DE-HE",
          "DestCityName" : "Sydney",
          "FlightTimeHour" : 17.179506930998397,
          "FlightDelayMin" : 0
        }
      }
    ]
  }
}

```

</details>

To scroll to the next document:

```json

GET /kibana_sample_data_flights/_search
{
  "from": 1, 
  "size": 1, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
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
      "value" : 7844,
      "relation" : "eq"
    },
    "max_score" : 2.0,
    "hits" : [
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "kSeJ0ocB94UPqIvUfjfr",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "X98CCZO",
          "DestCountry" : "IT",
          "OriginWeather" : "Clear",
          "OriginCityName" : "Cape Town",
          "AvgTicketPrice" : 882.9826615595518,
          "DistanceMiles" : 5482.606664853586,
          "FlightDelay" : false,
          "DestWeather" : "Sunny",
          "Dest" : "Venice Marco Polo Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "ZA",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 8823.40014044213,
          "timestamp" : "2023-04-24T18:27:00",
          "DestLocation" : {
            "lat" : "45.505299",
            "lon" : "12.3519"
          },
          "DestAirportID" : "VE05",
          "Carrier" : "Logstash Airways",
          "Cancelled" : false,
          "FlightTimeMin" : 464.3894810759016,
          "Origin" : "Cape Town International Airport",
          "OriginLocation" : {
            "lat" : "-33.96480179",
            "lon" : "18.60169983"
          },
          "DestRegion" : "IT-34",
          "OriginAirportID" : "CPT",
          "OriginRegion" : "SE-BD",
          "DestCityName" : "Venice",
          "FlightTimeHour" : 7.73982468459836,
          "FlightDelayMin" : 0
        }
      }
    ]
  }
}

```

</details>

**Elasticsearch will limit you to only 10,000 documents**.


#### The Scroll API

The first step is to fetch the scroll_id:

> By passing the scroll parameter followed by the duration of the search context. </br>

```json

GET /kibana_sample_data_flights/_search?scroll=5m
{
  "size": 100, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}

```

<details>
  <summary>Response:</summary>

```json
{
  "_scroll_id" : "FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFnpVck5vZlUxU3B1WTB5V3Z4cFpES0EAAAAAAAAEFBZ5amFpSXRjNFNSU3RwamZjYjRSOWVn",
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
      "value" : 7844,
      "relation" : "eq"
    },
    "max_score" : 2.0,
    "hits" : [
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "kCeJ0ocB94UPqIvUfjfr",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "9HY9SWR",
          "DestCountry" : "AU",
          "OriginWeather" : "Sunny",
          "OriginCityName" : "Frankfurt am Main",
          "AvgTicketPrice" : 841.2656419677076,
          "DistanceMiles" : 10247.856675613455,
          "FlightDelay" : false,
          "DestWeather" : "Rain",
          "Dest" : "Sydney Kingsford Smith International Airport",
          "FlightDelayType" : "No Delay",
          "OriginCountry" : "DE",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 16492.32665375846,
          "timestamp" : "2023-04-24T00:00:00",
          "DestLocation" : {
            "lat" : "-33.94609833",
            "lon" : "151.177002"
          },
          "DestAirportID" : "SYD",
          "Carrier" : "Kibana Airlines",
          "Cancelled" : false,
          "FlightTimeMin" : 1030.7704158599038,
          "Origin" : "Frankfurt am Main Airport",
          "OriginLocation" : {
            "lat" : "50.033333",
            "lon" : "8.570556"
          },
          "DestRegion" : "SE-BD",
          "OriginAirportID" : "FRA",
          "OriginRegion" : "DE-HE",
          "DestCityName" : "Sydney",
          "FlightTimeHour" : 17.179506930998397,
          "FlightDelayMin" : 0
        }
      },
      ......

```

</details>

The response from the request above should include a scroll_id which we can use with Scroll API and the first 100 documents matching the specified query.

```json

GET /_search/scroll
{
  "scroll": "5m",
  "scroll_id": "FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFnpVck5vZlUxU3B1WTB5V3Z4cFpES0EAAAAAAAAEFBZ5amFpSXRjNFNSU3RwamZjYjRSOWVn"
}

```

<details>
  <summary>Response:</summary>

```json

{
  "_scroll_id" : "FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFnpVck5vZlUxU3B1WTB5V3Z4cFpES0EAAAAAAAAEFBZ5amFpSXRjNFNSU3RwamZjYjRSOWVn",
  "took" : 10,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 7844,
      "relation" : "eq"
    },
    "max_score" : 2.0,
    "hits" : [
      {
        "_index" : "kibana_sample_data_flights",
        "_type" : "_doc",
        "_id" : "QieJ0ocB94UPqIvUfjjt",
        "_score" : 2.0,
        "_source" : {
          "FlightNum" : "ZC6X84Z",
          "DestCountry" : "RU",
          "OriginWeather" : "Thunder & Lightning",
          "OriginCityName" : "Manchester",
          "AvgTicketPrice" : 920.7303838694188,
          "DistanceMiles" : 1547.4727388986425,
          "FlightDelay" : true,
          "DestWeather" : "Heavy Fog",
          "Dest" : "Olenya Air Base",
          "FlightDelayType" : "NAS Delay",
          "OriginCountry" : "GB",
          "dayOfWeek" : 0,
          "DistanceKilometers" : 2490.4159675100973,
          "timestamp" : "2023-04-24T12:04:38",
          "DestLocation" : {
            "lat" : "68.15180206",
            "lon" : "33.46390152"
          },
          "DestAirportID" : "XLMO",
          "Carrier" : "Logstash Airways",
          "Cancelled" : true,
          "FlightTimeMin" : 289.52079837550485,
          "Origin" : "Manchester Airport",
          "OriginLocation" : {
            "lat" : "53.35369873",
            "lon" : "-2.274950027"
          },
          "DestRegion" : "RU-MUR",
          "OriginAirportID" : "MAN",
          "OriginRegion" : "GB-ENG",
          "DestCityName" : "Olenegorsk",
          "FlightTimeHour" : 4.825346639591747,
          "FlightDelayMin" : 165
        }
      },
      ...

```

</details>

In the request above, we specify that we want to use the scroll API followed by the search context. This tells Elasticsearch to refresh the search context and keep it alive for 5 minutes. Next, we pass the scroll_id we get from the previous request and retrieve the subsequent 100 documents.

**Note**: 

You can check how many search contexts are open with the nodes stats API:

```json
GET /_nodes/stats/indices/search
```

##### Clear scroll:

```json

DELETE /_search/scroll
{
  "scroll_id": "FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFnpVck5vZlUxU3B1WTB5V3Z4cFpES0EAAAAAAAAEFBZ5amFpSXRjNFNSU3RwamZjYjRSOWVn"
}

```

OR:

```json

DELETE /_search/scroll/FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFnpVck5vZlUxU3B1WTB5V3Z4cFpES0EAAAAAAAAEFBZ5amFpSXRjNFNSU3RwamZjYjRSOWVn

```

Response:

```json
{
  "succeeded" : true,
  "num_freed" : 1
}

```

All search contexts can be cleared with the _all parameter:

```json

DELETE /_search/scroll/_all

```

#### Fun ( Convert result to csv)

1. 

```json

curl -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq '.hits.hits[]._source'

```

Response:

```json

{
  "FlightNum": "9HY9SWR",
  "DestCountry": "AU",
  "OriginWeather": "Sunny",
  "OriginCityName": "Frankfurt am Main",
  "AvgTicketPrice": 841.2656419677076,
  "DistanceMiles": 10247.856675613455,
  "FlightDelay": false,
  "DestWeather": "Rain",
  "Dest": "Sydney Kingsford Smith International Airport",
  "FlightDelayType": "No Delay",
  "OriginCountry": "DE",
  "dayOfWeek": 0,
  "DistanceKilometers": 16492.32665375846,
  "timestamp": "2023-04-24T00:00:00",
  "DestLocation": {
    "lat": "-33.94609833",
    "lon": "151.177002"
  },
  "DestAirportID": "SYD",
  "Carrier": "Kibana Airlines",
  "Cancelled": false,
  "FlightTimeMin": 1030.7704158599038,
  "Origin": "Frankfurt am Main Airport",
  "OriginLocation": {
    "lat": "50.033333",
    "lon": "8.570556"
  },
  "DestRegion": "SE-BD",
  "OriginAirportID": "FRA",
  "OriginRegion": "DE-HE",
  "DestCityName": "Sydney",
  "FlightTimeHour": 17.179506930998397,
  "FlightDelayMin": 0
}
{
  "FlightNum": "X98CCZO",
  "DestCountry": "IT",
  "OriginWeather": "Clear",
  "OriginCityName": "Cape Town",
  "AvgTicketPrice": 882.9826615595518,
  "DistanceMiles": 5482.606664853586,
  "FlightDelay": false,
  "DestWeather": "Sunny",
  "Dest": "Venice Marco Polo Airport",
  "FlightDelayType": "No Delay",
  "OriginCountry": "ZA",
  "dayOfWeek": 0,
  "DistanceKilometers": 8823.40014044213,
  "timestamp": "2023-04-24T18:27:00",
  "DestLocation": {
    "lat": "45.505299",
    "lon": "12.3519"
  },
  "DestAirportID": "VE05",
  "Carrier": "Logstash Airways",
  "Cancelled": false,
  "FlightTimeMin": 464.3894810759016,
  "Origin": "Cape Town International Airport",
  "OriginLocation": {
    "lat": "-33.96480179",
    "lon": "18.60169983"
  },
  "DestRegion": "IT-34",
  "OriginAirportID": "CPT",
  "OriginRegion": "SE-BD",
  "DestCityName": "Venice",
  "FlightTimeHour": 7.73982468459836,
  "FlightDelayMin": 0
}

```

**OR**:

```json

curl -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq '.hits.hits[] | ._source'

```

Response:

```json

{
  "FlightNum": "9HY9SWR",
  "DestCountry": "AU",
  "OriginWeather": "Sunny",
  "OriginCityName": "Frankfurt am Main",
  "AvgTicketPrice": 841.2656419677076,
  "DistanceMiles": 10247.856675613455,
  "FlightDelay": false,
  "DestWeather": "Rain",
  "Dest": "Sydney Kingsford Smith International Airport",
  "FlightDelayType": "No Delay",
  "OriginCountry": "DE",
  "dayOfWeek": 0,
  "DistanceKilometers": 16492.32665375846,
  "timestamp": "2023-04-24T00:00:00",
  "DestLocation": {
    "lat": "-33.94609833",
    "lon": "151.177002"
  },
  "DestAirportID": "SYD",
  "Carrier": "Kibana Airlines",
  "Cancelled": false,
  "FlightTimeMin": 1030.7704158599038,
  "Origin": "Frankfurt am Main Airport",
  "OriginLocation": {
    "lat": "50.033333",
    "lon": "8.570556"
  },
  "DestRegion": "SE-BD",
  "OriginAirportID": "FRA",
  "OriginRegion": "DE-HE",
  "DestCityName": "Sydney",
  "FlightTimeHour": 17.179506930998397,
  "FlightDelayMin": 0
}
{
  "FlightNum": "X98CCZO",
  "DestCountry": "IT",
  "OriginWeather": "Clear",
  "OriginCityName": "Cape Town",
  "AvgTicketPrice": 882.9826615595518,
  "DistanceMiles": 5482.606664853586,
  "FlightDelay": false,
  "DestWeather": "Sunny",
  "Dest": "Venice Marco Polo Airport",
  "FlightDelayType": "No Delay",
  "OriginCountry": "ZA",
  "dayOfWeek": 0,
  "DistanceKilometers": 8823.40014044213,
  "timestamp": "2023-04-24T18:27:00",
  "DestLocation": {
    "lat": "45.505299",
    "lon": "12.3519"
  },
  "DestAirportID": "VE05",
  "Carrier": "Logstash Airways",
  "Cancelled": false,
  "FlightTimeMin": 464.3894810759016,
  "Origin": "Cape Town International Airport",
  "OriginLocation": {
    "lat": "-33.96480179",
    "lon": "18.60169983"
  },
  "DestRegion": "IT-34",
  "OriginAirportID": "CPT",
  "OriginRegion": "SE-BD",
  "DestCityName": "Venice",
  "FlightTimeHour": 7.73982468459836,
  "FlightDelayMin": 0
}

```

2. 

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq -c '.hits.hits |  length'

```

Response:

```
2
```

3. 

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq -c '.hits.hits[] | ._source | length'

```

Response:

```
27
27

```

4. 

So that we better understand where we're heading, I want to introduce the @csv format string, which is described as follows:

The input must be an array, and it is rendered as CSV with double quotes for strings, and quotes escaped by repetition.

So this:

```

echo '[1,2,"buckle my shoe"]' | jq --raw-output '@csv'

```

Response:

```

1,2,"buckle my shoe"

```

5. 

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq  '.hits.hits[] | ._source | [.FlightNum, .DestCountry, .DestCityName, .DestAirportID, .AvgTicketPrice, .OriginCountry, .OriginCityName, .OriginAirportID]'

```

Response:

```json

[
  "9HY9SWR",
  "AU",
  "Sydney",
  "SYD",
  841.2656419677076,
  "DE",
  "Frankfurt am Main",
  "FRA"
]
[
  "X98CCZO",
  "IT",
  "Venice",
  "VE05",
  882.9826615595518,
  "ZA",
  "Cape Town",
  "CPT"
]

```

OR:

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq -c '.hits.hits[] | ._source | [.FlightNum, .DestCountry, .DestCityName, .DestAirportID, .AvgTicketPrice, .OriginCountry, .OriginCityName, .OriginAirportID]'

```

Response:

```

["9HY9SWR","AU","Sydney","SYD",841.2656419677076,"DE","Frankfurt am Main","FRA"]
["X98CCZO","IT","Venice","VE05",882.9826615595518,"ZA","Cape Town","CPT"]

```

6. 

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq --raw-output '.hits.hits[] | ._source | [.FlightNum, .DestCountry, .DestCityName, .DestAirportID, .AvgTicketPrice, .OriginCountry, .OriginCityName, .OriginAirportID] | @csv'

```

Response:

```

"9HY9SWR","AU","Sydney","SYD",841.2656419677076,"DE","Frankfurt am Main","FRA"
"X98CCZO","IT","Venice","VE05",882.9826615595518,"ZA","Cape Town","CPT"

```

7. 

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq  '.hits.hits[] | ._source | keys'

```

Response:

```json

[
  "AvgTicketPrice",
  "Cancelled",
  "Carrier",
  "Dest",
  "DestAirportID",
  "DestCityName",
  "DestCountry",
  "DestLocation",
  "DestRegion",
  "DestWeather",
  "DistanceKilometers",
  "DistanceMiles",
  "FlightDelay",
  "FlightDelayMin",
  "FlightDelayType",
  "FlightNum",
  "FlightTimeHour",
  "FlightTimeMin",
  "Origin",
  "OriginAirportID",
  "OriginCityName",
  "OriginCountry",
  "OriginLocation",
  "OriginRegion",
  "OriginWeather",
  "dayOfWeek",
  "timestamp"
]
[
  "AvgTicketPrice",
  "Cancelled",
  "Carrier",
  "Dest",
  "DestAirportID",
  "DestCityName",
  "DestCountry",
  "DestLocation",
  "DestRegion",
  "DestWeather",
  "DistanceKilometers",
  "DistanceMiles",
  "FlightDelay",
  "FlightDelayMin",
  "FlightDelayType",
  "FlightNum",
  "FlightTimeHour",
  "FlightTimeMin",
  "Origin",
  "OriginAirportID",
  "OriginCityName",
  "OriginCountry",
  "OriginLocation",
  "OriginRegion",
  "OriginWeather",
  "dayOfWeek",
  "timestamp"
]

```

OR:

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq  '.hits.hits[] | ._source | keys'

```

Response:

```

["AvgTicketPrice","Cancelled","Carrier","Dest","DestAirportID","DestCityName","DestCountry","DestLocation","DestRegion","DestWeather","DistanceKilometers","DistanceMiles","FlightDelay","FlightDelayMin","FlightDelayType","FlightNum","FlightTimeHour","FlightTimeMin","Origin","OriginAirportID","OriginCityName","OriginCountry","OriginLocation","OriginRegion","OriginWeather","dayOfWeek","timestamp"]
["AvgTicketPrice","Cancelled","Carrier","Dest","DestAirportID","DestCityName","DestCountry","DestLocation","DestRegion","DestWeather","DistanceKilometers","DistanceMiles","FlightDelay","FlightDelayMin","FlightDelayType","FlightNum","FlightTimeHour","FlightTimeMin","Origin","OriginAirportID","OriginCityName","OriginCountry","OriginLocation","OriginRegion","OriginWeather","dayOfWeek","timestamp"]

```

In fact, we have the structure that we want and are now only really one "indirection" away from our goal. Let's put this into the CSV output context to see, by piping the result into @csv:

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq --raw-output '.hits.hits[] | ._source | keys | @csv'

```

Response:

```

"AvgTicketPrice","Cancelled","Carrier","Dest","DestAirportID","DestCityName","DestCountry","DestLocation","DestRegion","DestWeather","DistanceKilometers","DistanceMiles","FlightDelay","FlightDelayMin","FlightDelayType","FlightNum","FlightTimeHour","FlightTimeMin","Origin","OriginAirportID","OriginCityName","OriginCountry","OriginLocation","OriginRegion","OriginWeather","dayOfWeek","timestamp"
"AvgTicketPrice","Cancelled","Carrier","Dest","DestAirportID","DestCityName","DestCountry","DestLocation","DestRegion","DestWeather","DistanceKilometers","DistanceMiles","FlightDelay","FlightDelayMin","FlightDelayType","FlightNum","FlightTimeHour","FlightTimeMin","Origin","OriginAirportID","OriginCityName","OriginCountry","OriginLocation","OriginRegion","OriginWeather","dayOfWeek","timestamp"

```

8. 

We can make use of these key values like City with the [object identifier-index](https://stedolan.github.io/jq/manual/#ObjectIdentifier-Index:.foo,.foo.bar) construct. Well, almost. We need the more [generic form](https://stedolan.github.io/jq/manual/#GenericObjectIndex:.%5B%3Cstring%3E%5D) for which the [object identifier-index](https://stedolan.github.io/jq/manual/#ObjectIdentifier-Index:.foo,.foo.bar) is just a shorthand version for when identifiers are simple and "string-like".

In other words, the [generic object index](https://stedolan.github.io/jq/manual/#GenericObjectIndex:.%5B%3Cstring%3E%5D) can be used when the identifier is not "string-like" ... such as when it's a [variable](https://stedolan.github.io/jq/manual/#Variable/SymbolicBindingOperator:...as$identifier%7C...).

Let's step back and focus for a moment on just one of the objects - the first (0th) one - using the [array index](https://stedolan.github.io/jq/manual/#ArrayIndex:.%5B2%5D) construction ([n]):

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq  '.hits.hits[0] | ._source'

```

Response:

```json

{
  "FlightNum": "9HY9SWR",
  "DestCountry": "AU",
  "OriginWeather": "Sunny",
  "OriginCityName": "Frankfurt am Main",
  "AvgTicketPrice": 841.2656419677076,
  "DistanceMiles": 10247.856675613455,
  "FlightDelay": false,
  "DestWeather": "Rain",
  "Dest": "Sydney Kingsford Smith International Airport",
  "FlightDelayType": "No Delay",
  "OriginCountry": "DE",
  "dayOfWeek": 0,
  "DistanceKilometers": 16492.32665375846,
  "timestamp": "2023-04-24T00:00:00",
  "DestLocation": {
    "lat": "-33.94609833",
    "lon": "151.177002"
  },
  "DestAirportID": "SYD",
  "Carrier": "Kibana Airlines",
  "Cancelled": false,
  "FlightTimeMin": 1030.7704158599038,
  "Origin": "Frankfurt am Main Airport",
  "OriginLocation": {
    "lat": "50.033333",
    "lon": "8.570556"
  },
  "DestRegion": "SE-BD",
  "OriginAirportID": "FRA",
  "OriginRegion": "DE-HE",
  "DestCityName": "Sydney",
  "FlightTimeHour": 17.179506930998397,
  "FlightDelayMin": 0
}

```

9. assign the keys to a variable $k, and just emit the value of that variable:

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq  '.hits.hits[0] | ._source | keys as $k | $k'

```

Response:

```json

[
  "AvgTicketPrice",
  "Cancelled",
  "Carrier",
  "Dest",
  "DestAirportID",
  "DestCityName",
  "DestCountry",
  "DestLocation",
  "DestRegion",
  "DestWeather",
  "DistanceKilometers",
  "DistanceMiles",
  "FlightDelay",
  "FlightDelayMin",
  "FlightDelayType",
  "FlightNum",
  "FlightTimeHour",
  "FlightTimeMin",
  "Origin",
  "OriginAirportID",
  "OriginCityName",
  "OriginCountry",
  "OriginLocation",
  "OriginRegion",
  "OriginWeather",
  "dayOfWeek",
  "timestamp"
]

```

Note that keys produces an array, so we can use the [array value iterator](https://stedolan.github.io/jq/manual/#Array/ObjectValueIterator:.%5B%5D) \(\[\]\) to cause each of the keys to be emitted separately (looped through, effectively) and passed to subsequent filters.

10. Adding the iterator \[\] to the keys function 

```json

curl -s -XGET "localhost:9200/kibana_sample_data_flights/_search" -u elastic:changeme  -H 'Content-Type: application/json' -d'
{
  "from": 0, 
  "size": 2, 
  "query": {
    "range": {
      "AvgTicketPrice": {
        "gte": 500,
        "lte": 1000,
        "boost": 2
      }
    }
  }
}' | jq  '.hits.hits[0] | ._source | keys[] as $k | $k'

```

Response:

```

"AvgTicketPrice"
"Cancelled"
"Carrier"
"Dest"
"DestAirportID"
"DestCityName"
"DestCountry"
"DestLocation"
"DestRegion"
"DestWeather"
"DistanceKilometers"
"DistanceMiles"
"FlightDelay"
"FlightDelayMin"
"FlightDelayType"
"FlightNum"
"FlightTimeHour"
"FlightTimeMin"
"Origin"
"OriginAirportID"
"OriginCityName"
"OriginCountry"
"OriginLocation"
"OriginRegion"
"OriginWeather"
"dayOfWeek"
"timestamp"

```

11. 

```json

```

Response:

```json

```

12. 

```json

```

Response:

```json

```

13. 

```json

```

Response:

```json

```

14. 

```json

```

Response:

```json

```

