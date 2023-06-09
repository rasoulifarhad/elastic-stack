### Elasticsearch install

#### Overview

A Cluster with 3 Nodes

  ```
   ┌─────────────────────────┐┌─────────────────────────┐┌─────────────────────────┐    ─┐
   │  Elasticsearch Node #1  ││  Elasticsearch Node #2  ││  Elasticsearch Node #3  │     │
   ├─────────────────────────┤├─────────────────────────┤├─────────────────────────┤     │
   │ node.name: es-node1     ││ node.name: es-node2     ││ node.name: es-node3     │     │
   │                         ││                         ││                         │     │
   │ cluster.name: mycluster ││ cluster.name: mycluster ││ cluster.name: mycluster │     │
   │                         ││                         ││                         │     │
   │           .             ││           .             ││           .             │     ├─  Elasticsearch Nodes
   │           .             ││           .             ││           .             │     │
   │           .             ││           .             ││           .             │     │
   │           .             ││           .             ││           .             │     │
   │           .             ││           .             ││           .             │     │
   │           .             ││           .             ││           .             │     │
   │                         ││                         ││                         │     │
   └─────────────────────────┘└─────────────────────────┘└─────────────────────────┘    ─┘
      IP : xxx.xxx.xxx.xxx       IP : xxx.xxx.xxx.xxx       IP : xxx.xxx.xxx.xxx
  ```

#### Preparing each node for ES cluster

Open the sysctl.conf file as root:
```markdown
$ sudo vim /etc/sysctl.conf
```
Add the following line at the bottom:
```markdown
vm.max_map_count=262144
```
Load the new sysctl values:
```markdown
$ sudo sysctl -p
```
Install elasticsearch
```markdown
$ sudo rpm -ivh elasticsearch-7.16.2-x86_64.rpm
```
#### Configure each node’s elasticsearch.yml file

Let's open port 9200 to we can communicate with ElasticSearch:
```markdown
$ sudo firewall-cmd --zone=public --add-port=9200/tcp --permanent
$ sudo firewall-cmd --reload
```
 
Open the elasticsearch.yml file:
```markdown
$ vim /etc/elasticsearch/elasticsearch.yml
```

Change the following line:
```markdown
#cluster.name: my-application
#node.name: node-1
#network.host: 192.168.0.1
#http.port: 9200
#discovery.seed_hosts: ["host1", "host2"]
#cluster.initial_master_nodes: ["node-1", "node-2"]
#bootstrap.memory_lock: true
#path.logs: /var/log/elasticsearch
#xpack.monitoring.enabled: true
```

  To
  
```markdown
cluster.name: <CHANGE_THIS_TO_ELASTIC_CLUSTER_NAME>
node.name: <CHANGE_THIS_TO_ELASTIC_NODE_NAME>-<CHANGE_THIS_TO_ELASTIC_NODE_NUMBER>
network.host: <CHANGE_THIS_TO_ELASTIC_NODE_IP>,_local_
http.port: 9200
discovery.seed_hosts: ["<CHANGE_THIS_TO_ELASTIC_MASTER_IPS>"]
cluster.initial_master_nodes: ["<CHANGE_THIS_TO_ELASTIC_MASTER_NAME>"]
bootstrap.memory_lock: true
path.logs: /var/lib/elasticsearch/logs
xpack.monitoring.enabled: true
```
Configure transport tls:
```markdown
SSL_PATH=/etc/elasticsearch/certs
TRANSPORT_CERT_FILENAME=elastic-certificates.p12
TRANSPORT_CERT_PATH=$SSL_PATH/$TRANSPORT_CERT_FILENAME
```
```markdown
$ mkdir -p $SSL_PATH
$ Move transport cert file to  $SSL_PATH
$ chown -R elasticsearch:elasticsearch $SSL_PATH
```
```markdown
$ echo "xpack.security.transport.ssl.enabled: true"  | tee -a /etc/elasticsearch/elasticsearch.yml
$ echo "xpack.security.transport.ssl.verification_mode: certificate"  | tee -a /etc/elasticsearch/elasticsearch.yml
$ echo "xpack.security.transport.ssl.keystore.path: $TRANSPORT_CERT_PATH"  | tee -a /etc/elasticsearch/elasticsearch.yml
$ echo "xpack.security.transport.ssl.truststore.path: $TRANSPORT_CERT_PATH"  | tee -a /etc/elasticsearch/elasticsearch.yml
$ echo "xpack.security.transport.ssl.truststore.type: PKCS12"  | tee -a /etc/elasticsearch/elasticsearch.yml
$ echo "xpack.security.transport.ssl.keystore.type: PKCS12"  | tee -a /etc/elasticsearch/elasticsearch.yml
```
Override systemd file:
```markdown
$ mkdir -p /etc/systemd/system/elasticsearch.service.d
$ cat > /etc/systemd/system/elasticsearch.service.d/override.conf << EOF
[Service]
LimitMEMLOCK=infinity>
LimitNPROC=infinity
LimitNOFILE=infinity
LimitCORE=0
EOF
```

#### Configure the heap for each node

Create file heap.options in  /etc/elasticsearch/jvm.options.d directory:
```markdown
$ mkdir -p /etc/elasticsearch/jvm.options.d
$ cat > /etc/elasticsearch/jvm.options.d/heap.options << EOF
-Xms2g
-Xmx2g
EOF
```
  
#### Start Elasticsearch as a daemon on each node

Start elasticsearch 
```markdown
$ systemctl daemon-reload
$ systemctl restart elasticsearch
$ systemctl enable elasticsearch
```
