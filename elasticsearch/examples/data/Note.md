### Earthquake Data 

Selected geophysical data for research.

The following USGS Earthquake API home page contains the link to the API that contains all earthquake data from the past 30 Days(red arrow). We will be retrieving data from this API!

#### Web Services

[Web Services](https://earthquake.usgs.gov/ws/) for real-time and catalog earthquakes, hazard maps, slabs, and more.

#### Earthquakes

- [Real-time Data Feeds](https://earthquake.usgs.gov/earthquakes/feed/)
- [Preliminary Determination of Epicenters \(PDE\)](https://earthquake.usgs.gov/data/comcat/catalog/us/)

#### GeoJSON Summary Format

##### Description

GeoJSON is a format for encoding a variety of geographic data structures.

> {
>   "type": "Feature",
>   "geometry": {
>     "type": "Point",
>     "coordinates": [125.6, 10.1]
>   },
>   "properties": {
>     "name": "Dinagat Islands"
>   }
> }

GeoJSON supports the following geometry types: **Point**, **LineString**, **Polygon**, **MultiPoint**, **MultiLineString**, and **MultiPolygon**. Geometric objects with additional properties are **Feature** objects. Sets of features are contained by FeatureCollection objects.

A GeoJSON object may represent a geometry, a feature, or a collection of features. GeoJSON uses the [JSON standard](http://www.json.org/). The GeoJSONP feed uses the same JSON response, but the GeoJSONP response is wrapped inside the function call, eqfeed_callback. See the [GeoJSON site](http://www.geojson.org/) for more information.

This feed adheres to the USGS Earthquakes [Feed Life Cycle Policy](https://earthquake.usgs.gov/earthquakes/feed/policy.php).

##### Usage

GeoJSON is intended to be used as a programatic interface for applications.

##### Output

> {
>   type: "FeatureCollection",
>   metadata: {
>     generated: Long Integer,
>     url: String,
>     title: String,
>     api: String,
>     count: Integer,
>     status: Integer
>   },
>   bbox: [
>     minimum longitude,
>     minimum latitude,
>     minimum depth,
>     maximum longitude,
>     maximum latitude,
>     maximum depth
>   ],
>   features: [
>     {
>       type: "Feature",
>       properties: {
>         mag: Decimal,
>         place: String,
>         time: Long Integer,
>         updated: Long Integer,
>         tz: Integer,
>         url: String,
>         detail: String,
>         felt:Integer,
>         cdi: Decimal,
>         mmi: Decimal,
>         alert: String,
>         status: String,
>         tsunami: Integer,
>         sig:Integer,
>         net: String,
>         code: String,
>         ids: String,
>         sources: String,
>         types: String,
>         nst: Integer,
>         dmin: Decimal,
>         rms: Decimal,
>         gap: Decimal,
>         magType: String,
>         type: String
>       },
>       geometry: {
>         type: "Point",
>         coordinates: [
>           longitude,
>           latitude,
>           depth
>         ]
>       },
>       id: String
>     },
>     …
>   ]
> }

We want array of **features** converted to ndjson file. mens each **features** index be a compact json
 
> cat all_month.geojson | jq -c  '.features[]' >> all_month.geojson.ndjson	
