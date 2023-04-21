###

#### Prepare the environment

In an  empty directory, create the following four files:


instances.yml:

```yml

instances:
  - name: es01
    dns:
      - es01 
      - localhost
    ip:
      - 127.0.0.1

  - name: es02
    dns:
      - es02
      - localhost
    ip:
      - 127.0.0.1
  - name: es03
    dns:
      - es03
      - localhost
    ip:
      - 127.0.0.1

  - name: 'kib01'
    dns:
      - kib01
      - localhost
      
```

.env:

```yml

COMPOSE_PROJECT_NAME=es 
CERTS_DIR=/usr/share/elasticsearch/config/certificates 
ELASTIC_PASSWORD=PleaseChangeMe 
VERSION=7.17.9

```

create-certs.yml:

```yml

version: '2.2'

services:
  create_certs:
    container_name: create_certs
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.9
    command: >
      bash -c '
        if [[ ! -f /certs/bundle.zip ]]; then
          bin/elasticsearch-certutil cert --silent --pem --in config/certificates/instances.yml -out /certs/bundle.zip;
          unzip /certs/bundle.zip -d /certs; 
        fi;
        chown -R 1000:0 /certs
      '
    user: "0"
    working_dir: /usr/share/elasticsearch
    volumes: ['certs:/certs', '.:/usr/share/elasticsearch/config/certificates']

volumes: {"certs"}

```

OR

```yml

services:
  create_certs:
    image: docker.elastic.co/elasticsearch/elasticsearch:${VERSION}
    container_name: create_certs
    command: >
      bash -c '
        yum install -y -q -e 0 unzip;
        if [[ ! -f /certs/bundle.zip ]]; then
          bin/elasticsearch-certutil cert --silent --pem --in config/certificates/instances.yml -out /certs/bundle.zip;
          unzip /certs/bundle.zip -d /certs;
        fi;
        chown -R 1000:0 /certs
      '
    working_dir: /usr/share/elasticsearch
    volumes:
      - certs:/certs
      - .:/usr/share/elasticsearch/config/certificates
    networks:
      - elastic

volumes:
  certs:
    driver: local

networks:
  elastic:
    driver: bridge

```

docker-compose.yml:

```yml

version: '2.2'

services:
  es01:
    container_name: es01
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.9
    environment:
      - node.name=es01
      - discovery.seed_hosts=es01,es02
      - cluster.initial_master_nodes=es01,es02
      - ELASTIC_PASSWORD=$ELASTIC_PASSWORD 
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.license.self_generated.type=trial 
      - xpack.security.enabled=true
      - xpack.security.http.ssl.enabled=true
      - xpack.security.http.ssl.key=$CERTS_DIR/es01/es01.key
      - xpack.security.http.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.http.ssl.certificate=$CERTS_DIR/es01/es01.crt
      - xpack.security.transport.ssl.enabled=true
      - xpack.security.transport.ssl.verification_mode=certificate 
      - xpack.security.transport.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.transport.ssl.certificate=$CERTS_DIR/es01/es01.crt
      - xpack.security.transport.ssl.key=$CERTS_DIR/es01/es01.key
    volumes: ['data01:/usr/share/elasticsearch/data', 'certs:$CERTS_DIR']
    ports:
      - 9200:9200
    healthcheck:
      test: curl --cacert $CERTS_DIR/ca/ca.crt -s https://localhost:9200 >/dev/null; if [[ $$? == 52 ]]; then echo 0; else echo 1; fi
      interval: 30s
      timeout: 10s
      retries: 5

  es02:
    container_name: es02
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.9
    environment:
      - node.name=es02
      - discovery.seed_hosts=es01,es02
      - cluster.initial_master_nodes=es01,es02
      - ELASTIC_PASSWORD=$ELASTIC_PASSWORD
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.license.self_generated.type=trial
      - xpack.security.enabled=true
      - xpack.security.http.ssl.enabled=true
      - xpack.security.http.ssl.key=$CERTS_DIR/es02/es02.key
      - xpack.security.http.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.http.ssl.certificate=$CERTS_DIR/es02/es02.crt
      - xpack.security.transport.ssl.enabled=true
      - xpack.security.transport.ssl.verification_mode=certificate 
      - xpack.security.transport.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.transport.ssl.certificate=$CERTS_DIR/es02/es02.crt
      - xpack.security.transport.ssl.key=$CERTS_DIR/es02/es02.key
    volumes: ['data02:/usr/share/elasticsearch/data', 'certs:$CERTS_DIR']

  wait_until_ready:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.9
    command: /usr/bin/true
    depends_on: {"es01": {"condition": "service_healthy"}}

volumes: {"data01", "data02", "certs"}

```

OR

```yml

version: '2.2'

services:
  es01:
    image: docker.elastic.co/elasticsearch/elasticsearch:${VERSION}
    container_name: es01
    environment:
      - node.name=es01
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=es02,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.license.self_generated.type=trial 
      - xpack.security.enabled=true
      - xpack.security.http.ssl.enabled=true 
      - xpack.security.http.ssl.key=$CERTS_DIR/es01/es01.key
      - xpack.security.http.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.http.ssl.certificate=$CERTS_DIR/es01/es01.crt
      - xpack.security.transport.ssl.enabled=true 
      - xpack.security.transport.ssl.verification_mode=certificate 
      - xpack.security.transport.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.transport.ssl.certificate=$CERTS_DIR/es01/es01.crt
      - xpack.security.transport.ssl.key=$CERTS_DIR/es01/es01.key
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data01:/usr/share/elasticsearch/data
      - certs:$CERTS_DIR
    ports:
      - 9200:9200
    networks:
      - elastic

    healthcheck:
      test: curl --cacert $CERTS_DIR/ca/ca.crt -s https://localhost:9200 >/dev/null; if [[ $$? == 52 ]]; then echo 0; else echo 1; fi
      interval: 30s
      timeout: 10s
      retries: 5

  es02:
    image: docker.elastic.co/elasticsearch/elasticsearch:${VERSION}
    container_name: es02
    environment:
      - node.name=es02
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=es01,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.license.self_generated.type=trial
      - xpack.security.enabled=true
      - xpack.security.http.ssl.enabled=true
      - xpack.security.http.ssl.key=$CERTS_DIR/es02/es02.key
      - xpack.security.http.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.http.ssl.certificate=$CERTS_DIR/es02/es02.crt
      - xpack.security.transport.ssl.enabled=true
      - xpack.security.transport.ssl.verification_mode=certificate
      - xpack.security.transport.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.transport.ssl.certificate=$CERTS_DIR/es02/es02.crt
      - xpack.security.transport.ssl.key=$CERTS_DIR/es02/es02.key
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data02:/usr/share/elasticsearch/data
      - certs:$CERTS_DIR
    networks:
      - elastic

  es03:
    image: docker.elastic.co/elasticsearch/elasticsearch:${VERSION}
    container_name: es03
    environment:
      - node.name=es03
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=es01,es02
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.license.self_generated.type=trial
      - xpack.security.enabled=true
      - xpack.security.http.ssl.enabled=true
      - xpack.security.http.ssl.key=$CERTS_DIR/es03/es03.key
      - xpack.security.http.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.http.ssl.certificate=$CERTS_DIR/es03/es03.crt
      - xpack.security.transport.ssl.enabled=true
      - xpack.security.transport.ssl.verification_mode=certificate
      - xpack.security.transport.ssl.certificate_authorities=$CERTS_DIR/ca/ca.crt
      - xpack.security.transport.ssl.certificate=$CERTS_DIR/es03/es03.crt
      - xpack.security.transport.ssl.key=$CERTS_DIR/es03/es03.key
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data03:/usr/share/elasticsearch/data
      - certs:$CERTS_DIR
    networks:
      - elastic
  kib01:
    image: docker.elastic.co/kibana/kibana:${VERSION}
    container_name: kib01
    depends_on: {"es01": {"condition": "service_healthy"}}
    ports:
      - 5601:5601
    environment:
      SERVERNAME: localhost
      ELASTICSEARCH_URL: https://es01:9200
      ELASTICSEARCH_HOSTS: https://es01:9200
      ELASTICSEARCH_USERNAME: kibana_system
      ELASTICSEARCH_PASSWORD: CHANGEME
      ELASTICSEARCH_SSL_CERTIFICATEAUTHORITIES: $CERTS_DIR/ca/ca.crt
      SERVER_SSL_ENABLED: "true"
      SERVER_SSL_KEY: $CERTS_DIR/kib01/kib01.key
      SERVER_SSL_CERTIFICATE: $CERTS_DIR/kib01/kib01.crt
    volumes:
      - certs:$CERTS_DIR
    networks:
      - elastic
volumes:
  data01:
    driver: local
  data02:
    driver: local
  data03:
    driver: local
  certs:
    driver: local

networks:
  elastic:
    driver: bridge
    
```

#### Run the example

1. Generate the certificates (only needed once):

```

docker compose -f create-certs.yml run --rm create_certs

```

2. Start two Elasticsearch nodes configured for SSL/TLS:

```

docker compose up -d

```	

3. Access the Elasticsearch API over SSL/TLS using the bootstrapped password:

```
docker run --rm -v es_certs:/certs --network=es_default docker.elastic.co/elasticsearch/elasticsearch:7.17.9 curl --cacert /certs/ca/ca.crt -u elastic:PleaseChangeMe https://es01:9200

```

4. The elasticsearch-setup-passwords tool can also be used to generate random passwords for all users:

```

docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords \
auto --batch \
--url https://localhost:9200"

```

5. Set ELASTICSEARCH_PASSWORD in the elastic-docker.yml compose file to the password generated for the kibana_system user.

6. Use docker-compose to restart the cluster and Kibana:

```
docker compose stop
docker compose -f elastic-docker.yml up -d

```

#### Loading settings from a file

To use es01.yml as the configuration file for the es01 Elasticsearch node, you can create a bind mount in the volumes section.

```yml

    volumes:
      - data01:/usr/share/elasticsearch/data
      - certs:$CERTS_DIR
      - ./es01.yml:/usr/share/elasticsearch/config/elasticsearch.yml

```

Similarly, to load Kibana settings from a file, you overwrite /usr/share/kibana/config/kibana.yml:

```yml

    volumes:
      - certs:$CERTS_DIR
      - ./kibana.yml:/usr/share/kibana/config/kibana.yml

```

#### Tear everything down

```
docker compose down -v

```

