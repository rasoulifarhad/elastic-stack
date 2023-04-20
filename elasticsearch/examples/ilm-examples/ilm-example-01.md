### ILM


#### detect which indices had ILM errors:

```json

GET _all/_ilm/explain?filter_path=**.step

```

#### Remove index ILM

```json

PUT <index>-yyyy-MM-dd/_ilm/remove

```

#### Stop all ILM processes

```json

POST _ilm/stop

```

#### Add the newly created ILM to index

```json

PUT <index>/_settings
{
  "index.lifecycle.name":"ilm_no_rollover"
}

```

- If the ILM rollover action is in the error state, you cannot insert new ILM policies into the index without deleting the old ILM.

