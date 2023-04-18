### Backup and Restore

```markdown
#  make a directory for storing all our snapshots.
$ mkdir -p  /path/to/backup/elasticsearch-backup
```
```markdown
# make sure that the service elasticsearch can write into this directory
$ sudo chown -R elasticsearch:elasticsearch elasticsearch-backup
```
```markdown
# give the path of backup directory to elasticsearch.
echo "path.data: /path/to/backup/elasticsearch-backup" >> /etc/elasticsearch/elasticsearch.yml
```
```markdown
# restart elasticsearch service 
sudo systemctl restart elasticsearch.service
```
```markdown
# Register a snapshot repository
PUT _snapshot/elasticsearch-backup
{
  "type": "fs",
  "settings": {
    "location": "/path/to/backup/elasticsearch-backup",
    "compress": true
  }
}
# OR
curl -XPUT "http://localhost:9200/_snapshot/elasticsearch-backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/path/to/backup/elasticsearch-backup",
    "compress": true
  }
}'
```
```markdown
# see the repo description
GET _snapshot?pretty
# OR
curl -XGET "http://localhost:9200/_snapshot?pretty" 
```
```markdown
# Verify a repository
POST _snapshot/elasticsearch-backup/_verify
OR
curl -X POST "http://localhost:9200/_snapshot/elasticsearch-backup/_verify?pretty" -H 'Content-Type: application/json'
```
```markdown
# Clean up a repository
POST _snapshot/elasticsearch-backup/_cleanup
OR
curl -X POST "http://localhost:9200/_snapshot/elasticsearch-backup/_cleanup?pretty" -H 'Content-Type: application/json'
```
```markdown
# Manually create a snapshot
# PUT _snapshot/elasticsearch-backup/<my_snapshot_{now/d}>
PUT _snapshot/elasticsearch-backup/%3Cmy_snapshot_%7Bnow%2Fd%7D%3E?wait_for_completion=true
# OR
curl -X PUT "http://localhost:9200/_snapshot/elasticsearch-backup/%3Cmy_snapshot_%7Bnow%2Fd%7D%3E?pretty&wait_for_completion=true"
```
```markdown
# Monitor a snapshot
GET _snapshot/elasticsearch-backup/_current
GET _snapshot/_status
# OR 
curl -X GET "http://localhost:9200/_snapshot/elasticsearch-backup/_current?pretty"
curl -X GET "http://localhost:9200/_snapshot/_status?pretty"
```
```markdown
# Restore

# Get a list of available snapshots
GET _snapshot
GET _snapshot/elasticsearch-backup/*?verbose=false
# OR
curl -X GET "http://localhost:9200/_snapshot?pretty"
curl -X GET "http://localhost:9200/_snapshot/elasticsearch-backup/*?verbose=false&pretty"

POST _snapshot/elasticsearch-backup/first-snapshot/_restore?wait_for_completion=true
curl -XPOST "http://localhost:9200/_snapshot/elasticsearch-backup/first-snapshot/_restore?wait_for_completion=true"  -H 'Content-Type: application/json'

```
