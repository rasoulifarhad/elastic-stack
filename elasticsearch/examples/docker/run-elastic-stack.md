### Elasticsearch 7 with Docker Compose

See [Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docker.html)

1. Create **.env** file
```markdown
VERSION=7.16.2
```
2. create **docker-compose.yml** file :
```markdown
version: '3.9'
```
```markdown
services:
  elasticsearch:
    image: "docker.elastic.co/elasticsearch/elasticsearch:${VERSION}"
    container_name: singleElasticsearch
    environment:
      ES_JAVA_OPTS: "-Xms1g -Xmx1g"
      node.name: elasticsearch
      cluster.name: elasticsearch-cluster
      network.host: "0.0.0.0"
      network.bind_host: "0.0.0.0"
      discovery.type: single-node
      bootstrap.memory_lock: "true"
      xpack.security.enabled: false
      xpack.monitoring.enabled: false
      xpack.monitoring.collection.enabled: false
    ports:
      - 9200:9200
    privileged: true
  kibana:
    image: "docker.elastic.co/kibana/kibana:${VERSION}"
    container_name: singleKibana
    depends_on:
      - elasticsearch
    environment:
      SERVER_NAME: kibana
      SERVER_HOST: "0.0.0.0"
      SERVER_PORT: 5601
      ELASTICSEARCH_HOSTS: http://singleElasticsearch:9200
    ports:
      - 5601:5601
```
3. Run **docker compose** to bring up the cluster:

```markdown
docker compose up -d
```
4. Submit a **_cat/nodes** request to see that the nodes are up and running:
```markdown
curl -X GET "localhost:9200/_cat/nodes?v=true&pretty"
```
5. For seeing elasticsearch && kibana logs:
```markdown
docker compose logs --follow
```
Log messages go to the console and are handled by the configured Docker logging driver.

If you would prefer the Elasticsearch container to write logs to disk, set the **ES_LOG_STYLE** environment variable to **file**. This causes Elasticsearch to use the same logging configuration as other Elasticsearch distribution formats.

6. To stop the cluster, run: 
```markdown 
docker compose down. 
```
The data in the Docker volumes is preserved and loaded when you restart the cluster with **docker compose up**. To **delete the data volumes** when you bring down the cluster, specify the -v option:
```markdown
docker compose down -v.
```

