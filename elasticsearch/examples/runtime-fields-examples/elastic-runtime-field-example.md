### elastic-runtime-field-example

#### Static value

> emit("my value");

#### Copy value to another field

> if (doc.containsKey('source.field.name')) {
> 	def source = doc['source.field.name'].value;
> 	if (source != "") {
> 		emit(source);
> 	}
> }

The above example does not work if you want to copy a geo_point value. In order to do that the emit function needs to have to parameters. The following example shows a runtime field that is using a geo_point field that was wrongly mapped as text and keyword. The target of the copy to another field runtime field is to change the mapping to geo_point again.

> if (doc.containsKey('enriched.location.keyword')) {
>     def source = doc['enriched.location.keyword'].value;
>     def geo_point = source.splitOnToken(",");
>     if (source != "") {
>         def lat = Double.parseDouble(geo_point[0]);
>         def lon = Double.parseDouble(geo_point[1]);
>         emit(lat,lon);
>     }
> }

#### Compare two field values
The Elasticsearch query DSL is very powerful to search for anything you like. You can search for concrete keyword, for phrases, for ranges of values, IPs and times and much more. But there are also some things in comparison to a SQL based query that are not so easy in Elasticsearch or Kibana Query Language. One of these challenging search features is to look for documents that have the same value in two different fields. Therefore you need the ability to compare two field values.

Comparing two field values can not be done in any of the query languages that Elastic supports. However using a runtime field you can achieve this. The concept is to compare the values using the runtime field and in the query you only search for the result of the runtime field.

> emit (doc['source.host.name'].value == doc['dest.host.name'].value);

This is a simple comparison of two field values. You may need to check the existence of both fields before doing the comparison. Otherwise you might run into shard failures on execution.

#### Concatenate two fields

> emit (doc['geo.dest.keyword'].value + ':' + doc['geo.src.keyword'].value);

> def hostname = doc['host.name'].value;
> def ip = doc['client.ip'].value;
> 
> emit(hostname + "/" + ip);

#### Regular expressions (Regex)

> def fieldname = "host.name";
> if (!doc.containsKey(fieldname)) {
>     return
> }
> 
> def m = /([A-Za-z0-9]+)/.matcher(doc[fieldname].value);
> if ( m.matches() ) {
>     emit (m.group(1))
> }

For a simple check that a regex pattern is present in longer string you can also use this shorthanded syntax.

> if (doc['host.name'].value =~ /([A-Za-z0-9]+)/) { 
>     emit("value detected");
> } else {
>     emit ("value not detected");
> }

… or even shorter if you use the Boolean result of the comparison directly. Make sure to set the format of the field to Boolean.

> emit (doc['host.name'].value =~ /([A-Za-z0-9]+)/)

#### Grok

> String clientip=grok('%{COMMONAPACHELOG}').extract(doc["message"].value)?.clientip;
> if (clientip != null) emit(clientip);

> if (doc['transaction.page.referer'].size()>0) {
>     def referer_full = doc["transaction.page.referer"].value;
>     if (referer_full != null) {
>         String domain=grok('https?://(www.)?%{HOSTNAME:domain}').extract(referer_full)?.domain;
>         if (domain != null) emit(domain); 
>         return;
>     }
> }
> emit("");

Another example is accessing the message field directly from _source.

> String clientip=grok('Returning %{NUMBER:foobar} ads').extract(params._source.message)?.foobar;
> emit(clientip);

#### Dissect

> String clientip=dissect('%{clientip} %{ident} %{auth} [%{@timestamp}] "%{verb} %{request} HTTP/%{httpversion}" %{status} %{size}').extract(doc["message"].value)?.clientip;
> 
> if (clientip != null) emit(clientip);

Dissect can be used to extract multiple data fields at once. This also works with runtime fields as the emit function is also able to take a map of fields as input parameter. This type of extraction and field generation can of course also be used for other use cases.

> Map fields=dissect('%{source.ip} %{url.domain} - %{client.id} %{port} [%{@timestamp}]').extract(params["_source"]["message"]);
> emit(fields);

#### Manipulate time aka applying date math

> emit(doc['@timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.FULL, Locale.ROOT))

> ZonedDateTime date =  doc['@timestamp'].value;
> int hour = date.getHour();
> if (hour < 10) {
>     emit ('0' + String.valueOf(hour));
> } else {
>     emit (String.valueOf(hour));
> }

> long nowDate = new Date().getTime();
> long docDate = doc['@timestamp'].value.toEpochMilli();
> long difference = nowDate - docDate;
> boolean isOlderThan24hr = false;
> if (difference > 86400000) {
>     isOlderThan24hr = true;
> }
> emit(isOlderThan24hr);

#### Sorted day of week

A day of the week that’s sortable in visualizations.  More date masks can be found [in the Java docs](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html).

> ZonedDateTime input = doc['timestamp'].value;
> String output = input.format(DateTimeFormatter.ofPattern('e')) + ' ' + input.format(DateTimeFormatter.ofPattern('E'));
> emit(output);

#### Return a static value when a condition is met

This runtime field can be useful for integrating event style information into visualizations. The example is using “record_score” from ML Anomalies to only show the anomalies over a certain score….but don’t show the score itself on the visualization. This runtime field accounts for empty values in the first conditional. You can take this example runtime field and easily adapt to any other numeric field. You also could add multiple categories and expose this field as a keyword field.

> //Return a 1 when there is a specific value
> if (doc['record_score'].size()==0) {
> 	emit(0);
> } else {
> 	if (doc['record_score'].value > 0.5 ) {
> 		emit(1);
> 	} else {
> 		emit(0);
> 	}
> }

#### Parse specific value from a list

A field named `gh_labels.keyword` contains a list of text values.

For example: `pending_on_dev, kibana, Team:Control Plane/Ingress, cloud, assigned, closed:support, assign::cloud-dev`

But I want to do charts based on the `Team`. The steps are to create this “team” field as a keyword type;

1. check to make sure each doc contains the field
2. check that the field isn’t empty
3. check that the size isn’t 0 (this is probably redundant)
4. set variable labels equal to the value of the field
5. for each label, if it contains the string “Team:”, emit that string. In my case I want to strip “Team:” off so I get the substring starting at position 5. Return so we don’t spend any time comparing other strings in the list.

> if (doc.containsKey('gh_labels.keyword')) {
> 	if (!(doc['gh_labels.keyword'].empty)) {
> 		if (!(doc['gh_labels.keyword'].size() == 0)) {
> 			def labels = doc['gh_labels.keyword'];
> 			for (int i = 0; i < labels.length; i++) {
> 				if (labels[i].contains("Team:")) {
> 					emit(labels[i].substring(5));
> 					return;
> 				}
> 			}
> 		}
> 	}
> }

#### Creating field that detects low test coverage of code called low_coverage

An easy way to see if code test-coverage is low for a given file.

> PUT my-index-000001/
> {
>     "mappings": {
>       "runtime": {
>        "day_of_week": {
>          "type": "keyword",
>          "script": {
>            "source": "emit(doc['@timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.FULL, Locale.ROOT))"
>          }
>       }
>     },
>     "properties": {
>       "timestamp": {
>         "type": "date"
>       }, 
>       "lines": {
>         "type": "object",
>         "properties": {
>           "voltage": {
>             "type": "double"
>           },
>           "node": {
>             "type": "keyword"
>           }
>         }
>       }
>     }
>   }
> }

or 

> PUT my-index-000001/
> {
>   "mappings": {
>     "properties": {
>       "timestamp": {
>         "type": "date"
>       },
>       "lines": {
>         "type": "object",
>         "properties": {
>           "voltage": {
>             "type": "double"
>           },
>           "node": {
>             "type": "keyword"
>           }
>         }
>       }
>     }
>   }
> }

> PUT /my-index-000001/_mapping
> {
>   "runtime": {
>        "day_of_week": {
>          "type": "keyword",
>          "script": {
>            "source": "emit(doc['@timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.FULL, Locale.ROOT))"
>          }
>       }
>   }
> }

> POST my-index-000001/_bulk?refresh=true
> {"index":{}}
> {"timestamp": 1516729294000, "lines": {"total": 200, "covered": 10}}
> {"index":{}}
> {"timestamp": 1516642894000, "lines": {"total": 50, "covered": 30}}
> {"index":{}}
> {"timestamp": 1516556494000, "lines": {"total": 170, "covered": 55}}
> {"index":{}}
> {"timestamp": 1516470094000, "lines": {"total": 360, "covered": 300}}
> {"index":{}}
> {"timestamp": 1516383694000, "lines": {"total": 201, "covered": 110}}
> {"index":{}}
> {"timestamp": 1516297294000, "lines": {"total": 400, "covered": 100}}


> def lines = doc["lines.total"].value;
> def covered = doc["lines.covered"].value;
> def threshold = lines / 2;
> if (covered > threshold) {
> 	emit(false);
> } else {
> 	emit(true);
> }

#### RUNNERS

A runner joined a competition consisting of 3 races and was stored as follows (note we used objects to store the participations):

> {
>  "participant": "Fast Runner",
>  "participations": {
>    "race1": {
>      "place": 2,
>      "time_secs": 55.2
>    },
>    "race2": {
>      "place": 4,
>      "time_secs": 49.22
>    },
>    "race3": {
>      "place": 1,
>      "time_secs": 54.25
>    }
>  }
> }

We want to be able to search through runners and show individual race times but also an average of race times.

> PUT runtime_test

> PUT runtime_test/_doc/1
> {
>   "participant": "Fast Runner",
>   "participations": {
>     "race1": {
>       "place": 2,
>       "time_secs": 55.2
>     },
>     "race2": {
>       "place": 4,
>       "time_secs": 49.22
>     },
>     "race3": {
>       "place": 1,
>       "time_secs": 54.25
>     }
>   }
> }

> PUT runtime_test/_doc/2
> {
>   "participant": "Slow Runner",
>   "participations": {
>     "race1": {
>       "place": 10,
>       "time_secs": 115.50
>     },
>     "race2": {
>       "place": 8,
>       "time_secs": 99.54
>     },
>     "race3": {
>       "place": 10,
>       "time_secs": 100.11
>     }
>   }
> }

> GET runtime_test/_search
> {
>   "query": {
>     "match_all": {}
>   },
>   "script_fields": {
>     "avg": {
>       "script": {
>         "source": "(doc['participations.race1.time_secs'].value + doc['participations.race2.time_secs'].value + doc['participations.race3.time_secs'].value)/3;"
>       }
>     }
>   }
> }

> PUT runtime_test/_mapping
> {
>   "runtime": {
>     "times_average": {
>       "type": "double",
>       "script": {
>         "source": "emit((doc['participations.race1.time_secs'].value + doc['participations.race2.time_secs'].value + doc['participations.race3.time_secs'].value)/3);"
>       }
>     }
>   }
> }

> GET runtime_test/_search
> {
>   "query": {
>     "match_all": {}
>   },
>   "fields" : ["times_average"]
> }

> GET runtime_test/_search
> {
>   "query": {
>     "bool": {
>       "filter": [
>         {
>           "range": {
>             "times_average": {
>               "gte": 100,
>               "lte": 200
>             }
>           }
>         }
>       ]
>     }
>   }
> }

We can remove our runtime field from the index mappings by setting it to null:

> PUT runtime_test/_mapping
> {
>   "runtime": {
>     "times_average": null
>   }
> }

To use a runtime field for a particular query you just have to move the runtime block from the mappings to the query.

> GET runtime_test/_search
> {
>   "runtime_mappings": {
>     "times_average": {
>       "type": "double",
>       "script": {
>         "source": "emit((doc['participations.race1.time_secs'].value + doc['participations.race2.time_secs'].value + doc['participations.race3.time_secs'].value)/3);"
>       }
>     }
>   },
>   "query": {
>     "bool": {
>       "filter": [
>         {
>           "range": {
>             "times_average": {
>               "gte": 50,
>               "lte": 200
>             }
>           }
>         }
>       ]
>     }
>   },
>   "fields": [
>     "times_average"
>   ]
> }

Override fields

Let’s assume that in our example, our Fast Runner received a penalty of 250 seconds because of cheating in the first race and we want to start querying against that change right away. Just define a runtime field with the same name and it will shadow it.

We have to filter the documents first to avoid penalizing other participants: 

> GET runtime_test/_search
> {
>   "runtime_mappings": {
>     "times_average": {
>       "type": "double",
>       "script": {
>         "source": "emit((doc['participations.race1.time_secs'].value + doc['participations.race2.time_secs'].value + doc['participations.race3.time_secs'].value)/3);"
>       }
>     },
>     "participations.race1.time_secs": {
>       "type": "double",
>       "script": "emit(doc['participations.race3.time_secs'].value + 250.00)"
>     }
>   },
>   "query": {
>     "bool": {
>       "filter": [
>         {
>           "range": {
>             "times_average": {
>               "gte": 50,
>               "lte": 100
>             }
>           }
>         },
>         {
>           "ids": {
>             "values": [
>               "1"
>             ]
>           }
>         }
>       ]
>     }
>   },
>   "fields": [
>     "times_average", "participations.race1.time_secs"
>   ]
> }

Dynamic runtime fields

To set runtime dynamic fields you have to specify the option when you create the index: 

> PUT runtime_index
> {
>  "mappings": {
>    "dynamic": "runtime",
>    "properties": {
>      "not_runtime_field": {
>        "type": "text"
>      }
>    }
>  }
> }

Let’s repeat the index creation, now including a runtime field:

> PUT runtime_index
> {
>  "mappings": {
>    "dynamic": "runtime",
>    "runtime": {
>      "runtime_field": {
>        "type": "text"
>      }
>    },
>    "properties": {
>      "not_runtime_field": {
>        "type": "text"
>      }
>    }
>  }
> }

Now all documents you ingest with new fields, will be set up as runtime fields. These fields will use no disk space but be fully functional for queries!

