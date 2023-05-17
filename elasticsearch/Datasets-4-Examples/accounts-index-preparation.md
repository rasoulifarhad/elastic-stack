### Accounts Data 

The accounts data set is organized in the following schema:

```

{
    "account_number": INT,
    "balance": INT,
    "firstname": "String",
    "lastname": "String",
    "age": INT,
    "gender": "M or F",
    "address": "String",
    "employer": "String",
    "email": "String",
    "city": "String",
    "state": "String"
}

```

1. Create index

```json

PUT accounts

```

2. Index Some data

```

curl -s -XPOST 'localhost:9200/accounts/_bulk?pretty' -H 'Content-Type: application/x-ndjson' --data-binary @accounts.json

```

3. Check Data

```json

GET /accounts/_count

GET /accounts/_search?size=1

```

