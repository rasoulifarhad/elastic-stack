### pipeline to script and loop around all fields in a context

#### Checking the length of possible fields within a document

> POST _ingest/pipeline/_simulate
> {
>   "pipeline": {
>     "processors": [
>       {
>         "script": {
>           "source": """
>              boolean flag = false;
>              java.util.Set keys = ctx.keySet();
>              for (String key : keys) {
>                if (key.length()>15) {
>                  flag = true;
>                }
>              }
>              ctx["has_long_fields"] = flag;
>           """
>         }
>       }
>     ]
>   },
>   "docs": [
>     {
>       "_source": {
>         "very_very_long_field": "dkjfdkjfkdjfkdfjk"
>       }
>     },
>     {
>       "_source": {
>         "age": 12
>       }
>     }
>   ]
> }

**“ctx.keySet()”** method returns a **Set** interface containing all **“field-names”** available under the document. After obtaining the Set, we can start iterating it and apply our matching logics.

This Set also contains meta data fields such as **“_index”** and **“_id”**, hence when we are applying some field matching logics, be aware of such fields too.

#### How to remove(long fields) the corresponding fields from our document context 

> POST _ingest/pipeline/_simulate
> {
>   "pipeline": {
>     "processors": [
>       {
>         "script": {
>           "source": """
>              boolean flag = false;
>              java.util.Set keys = ctx.keySet();
>              java.util.List fields = new java.util.ArrayList();
>              for (String key : keys) {
>                if (!key.startsWith("_") && key.length()>10) {
>                  fields.add(key); 
>                }
>              }
>              // look through and delete those long field(s)
>              if (fields.size() > 0) {
>                for (String field: fields) {
>                  ctx.remove(field);
>                }
>                flag = true;
>              }
>              ctx["has_removed_long_fields"] = flag;
>           """
>         }
>       }
>     ]
>   },
>   "docs": [
>     {
>       "_source": {
>         "very_very_long_field": "dkjfdkjfkdjfkdfjk",
>         "another_long_field": "wakkakakakaka",
>         "age": 13,
>         "name": "Felis"
>       }
>     },
>     {
>       "_source": {
>         "desc": "dkjfdkjfkdjfkdfjk",
>         "address": "wakkakakakaka",
>         "age": 13,
>         "name": "Felis"
>       }
>     }
>   ]
> }

The magic is **ctx.remove(“fieldname”)**. Also note that we have applied a more precise rule on our field matching logic **!key.startsWith(“_”) && key.length()>10** so that all meta fields (e.g. _index) would not be considered.

Also an **ArrayList** is introduced to store the target field names. You might ask why don’t we directly remove the field from the document context during the loop? The reason is if we try to do so, an exception would burst out describing a **concurrent modification** on the document context. Hence we would need to delay the removal process and this ArrayList keeps track on those field-names.

#### How to determine if a field is a “leaf” field or a “branch” field.(remove the inner field)

> POST _ingest/pipeline/_simulate
> {
>   "pipeline": {
>     "processors": [
>       {
>         "script": {
>           "source": """
>             java.util.Set keys = ctx.keySet();
>             java.util.ArrayList fields = new java.util.ArrayList();
>             for (String key : keys) {
>               // access the value; check the type
>               if (key.startsWith("_")) {
>                 continue;
>               }
>               Object value = ctx[key];
>               if (value != null) {
>                 // it is a MAP (equivalent to the "object" structure of a json field)
>                 if (value instanceof java.util.Map) {
>                   // inner fields loop
>                   java.util.Map innerObj = (java.util.Map) value;
>                   for (String innerKey: innerObj.keySet()) {
>                     if (innerKey.length() > 10) {
>                       //Debug.explain("a long field >> "+innerKey);
>                       fields.add(key+"."+innerKey);
>                     }
>                   }
>                 } else {
>                   if (key.length() > 10) {
>                     fields.add(key);
>                   }
>                 }
>               }
>             }
>             
>             if (fields.size()>0) {
>               for (String field:fields) {
>                 // is it an inner field?
>                 int idx = field.indexOf(".");
>                 if (idx != -1) {
>                   ctx[field.substring(0, idx)].remove(field.substring(idx+1));
>                 } else {
>                   ctx.remove(field);  
>                 }
>               }
>             }
>           """
>         }
>       }
>     ]
>   },
>   "docs": [
>     {
>       "_source": {
>         "age": 13,
>         "very_very_very_long_field": "to be removed",
>         "outer": {
>           "name": "Felix",
>           "very_very_long_field": "dkjfdkjfkdjfkdfjk"
>         }
>       }
>     }
>   ]
> }

In order to check whether the field is a “leaf” — a normal field or a “branch” — another level of fields (e.g. object); we would need to check the field value’s type ‘value instanceof java.util.Map’.

PS. The “instanceof” method helps to verify if the value provided matches a particular Java Class type.

Next, we would need to iterate the Set of inner-object fields again to apply our matching rules. The same technique, using ArrayList, would be applied on tracking the target field names for removal at a later stage.

Finally, to remove the fields through ‘ctx.remove(“fieldname”)’. But this time, we would also need to check whether this field is a leaf or a branched one. For a branched field, it would come at this format “outer-object-name.inner-field-name”. We would need to extract the “outer-object-name” first and get access to its context before deleting the “inner-field-name” -> ‘ctx[field.substring(0, idx)].remove(field.substring(idx+1))’

Take an example: outer.very_very_long_field

- idx (index where the “.” separator is) = 5

- field.substring(0, idx) = “outer”

- field.substring(idx+1) = “very_very_long_field”

- hence… ctx[field.substring(0, idx)].remove(field.substring(idx+1)) = ctx[“outer”].remove(“very_very_long_field”)

#### dynamic settings on indices approach

Sometimes, we might not bother a mapping pollution introduced; however~ We do NOT want those meaningless fields to be searchable or aggregatable. Simply we let those meaningless fields act as a dummy, you can see them (available under the ‘_source’ field) but never able to apply any operations on them. If that is the case… we could alter the dynamic settings on indices.

> PUT test_dynamic 
> {
>   "mappings": {
>     "dynamic": "false",
>     "properties": {
>       "name": {
>         "type": "text"
>       },
>       "address": {
>         "dynamic": "true",
>         "properties": {
>           "street": {
>             "type": "keyword"
>           }
>         }
>       },
>       "work": {
>         "dynamic": "strict",
>         "properties": {
>           "department": {
>             "type": "keyword"
>           },
>           "post": {
>             "type": "keyword"
>           }
>         }
>       }
>     }
>   }  
> }

> # all good, everything matches the mapping
> POST test_dynamic/_doc
> {
>   "name": "peter parker",
>   "address": {
>     "street": "20 Ingram Street",
>     "state": "NYC"
>   },
>   "work": {
>     "department": "daily bugle"
>   }
> }

> # added a non-searchable "age" and a searchable field "address.post_code"
> POST test_dynamic/_doc
> {
>   "age": 45,
>   "name": "Edward Elijah",
>   "address": {
>     "post_code": "344013"
>   }
> }

> GET test_dynamic/_search
> {
>   "query": {
>     "match": {
>       "age": 45
>     }
>   }
> }

> GET test_dynamic/_search
> {
>   "query": {
>     "match": {
>       "address.post_code": "344013"
>     }
>   }
> }

> # exception as work.salary is forbidden
> POST test_dynamic/_doc
> {
>   "age": 45,
>   "name": "Prince Tomas",
>   "address": {
>     "post_code": "344013"
>   },
>   "work": {
>     "salary": 10000000
>   }
> }

We have a very simple mapping definition here — ‘“dynamic”: “false”’ is applied at the root level meaning that if there were unknown fields introduced later on, we simply ignore them for operations (not searchable or aggregatable for these fields). However, these fields’ value would still be inside the “_source”, the dummies~

That explains why for this document:

> { “age”: 45, “name”: “Edward Elijah”, “address”: { “post_code”: “344013” }}

We could not search through the field “age” since “age” is a dummy field.

On the “address” level, we set ‘“dynamic”: “true”’ meaning that unknown fields would be included for operations and hence updating our mappings (a mapping pollution). Hence we could search through the field “address.post_code” this time.

Finally we declared ‘“dynamic”: “strict”’ at the “work” level, this means all unknown fields would be treated as exceptions / errors immediately~ This is the strictest way to avoid mapping pollutions but the results seem brutal as well…


