```markdown
{
  "description": "My optional pipeline description",
  "processors": [
    {
      "remove": {
        "description": "remove not used fields",
        "field": [
          "properties.updated",
          "properties.tz",
          "properties.detail",
          "properties.felt",
          "properties.cdi",
          "properties.mmi",
          "properties.alert",
          "properties.status",
          "properties.tsunami",
          "properties.net",
          "properties.code"
        ],
        "ignore_missing": true
      }
    },
    {
      "remove": {
        "description": "remove not used fields",
        "field": [
          "properties.ids",
          "properties.sources",
          "properties.types",
          "properties.nst",
          "properties.dmin",
          "properties.rms",
          "properties.gap",
          "properties.magType",
          "properties.title"
        ],
        "ignore_missing": true
      }
    },
    {
      "date": {
        "field": "properties.time",
        "formats": [
          "UNIX_MS"
        ]
      }
    },
    {
      "remove": {
        "field": "properties.time",
        "ignore_missing": true
      }
    },
    {
      "script": {
        "source": "ctx['longitude'] = ctx['geometry.coordinates'][0];\nctx['latitude'] = ctx['geometry.coordinates'][1];\nctx['depth'] = ctx['geometry.coordinates'][2];"
      }
    },
    {
      "rename": {
        "field": "latitude",
        "target_field": "coordinates.lat",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "longitude",
        "target_field": "coordinates.lon",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "properties.mag",
        "target_field": "mag",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "properties.place",
        "target_field": "place",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "properties.url",
        "target_field": "url",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "properties.sig",
        "target_field": "sig",
        "ignore_missing": true
      }
    },
    {
      "rename": {
        "field": "properties.type",
        "target_field": "type",
        "ignore_missing": true
      }
    }
  ]
}
```
