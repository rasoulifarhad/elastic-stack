### Run Filebeat in a Docker container 

1.  Run Elastic Search and Kibana as Docker containers on the host machine

```markdown
version: '2.2'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.9.2
    container_name: elasticsearch
    environment:
      - node.name=elasticsearch
      - discovery.seed_hosts=elasticsearch
      - cluster.initial_master_nodes=elasticsearch
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - esdata1:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
  kibana:
    image: docker.elastic.co/kibana/kibana:7.9.2
    container_name: kibana
    environment:
      ELASTICSEARCH_URL: "http://elasticsearch:9200"
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch
volumes:
  esdata1:
    driver: local
```

```markdown
sudo docker-compose up -d

sudo docker-compose logs -f
```

2. Run Nginx and Filebeat as Docker containers on the virtual machine

```markdown
sudo docker run -d -p 8080:80 –name nginx nginx

```
```markdown
curl localhost:8080 
```

3. Setting up the Filebeat container

```markdown
sudo docker pull docker.elastic.co/beats/filebeat:7.9.2
```

Now to run the Filebeat container, we need to set up the elasticsearch host which is going to receive the shipped logs from filebeat. This command will do that –

```markdown
sudo docker run \
docker.elastic.co/beats/filebeat:7.9.2 \
setup -E setup.kibana.host=host_ip:5601 \
-E output.elasticsearch.hosts=["host_ip:9200"]
```

```markdown
# filebeaat.yml:
 
filebeat.config:
  modules:
    path: ${path.config}/modules.d/*.yml
    reload.enabled: false

filebeat.autodiscover:
  providers:
    - type: docker
      hints.enabled: true

processors:
- add_cloud_metadata: ~

output.elasticsearch:
  hosts: '${ELASTICSEARCH_HOSTS:elasticsearch:9200}'
```
  
```markdown
docker run -d \
  --name=filebeat \
  --user=root \
  --volume="$(pwd)/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml:ro" \
  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  docker.elastic.co/beats/filebeat:7.9.2 filebeat -e --strict.perms=false
```
