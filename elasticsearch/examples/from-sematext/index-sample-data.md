#### To index the sample documents in Elasticsearch, you would run

```markdown
cd data
curl -s -XPOST "localhost:9200/videos/_bulk?pretty" -H 'Content-Type: application/x-ndjson' --data-binary "@es_bulk_videos.json"; echo;
curl -s -XPOST "localhost:9200/videosearch/_bulk?pretty" -H 'Content-Type: application/x-ndjson' --data-binary "@es_bulk_videosearch_2014.json"; echo;
```

