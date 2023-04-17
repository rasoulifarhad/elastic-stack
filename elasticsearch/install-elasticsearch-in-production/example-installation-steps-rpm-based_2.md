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
sudo vim /etc/sysctl.conf
```
Add the following line at the bottom:
```markdown
vm.max_map_count=262144
```
Load the new sysctl values:
```markdown
sudo sysctl -p
```
Install elasticsearch
```markdown
sudo rpm -ivh elasticsearch-7.16.2-x86_64.rpm
```markdown
#### Configure each node’s elasticsearch.yml file

Let's open port 9200 to we can communicate with ElasticSearch:
```markdown
  > sudo firewall-cmd --zone=public --add-port=9200/tcp --permanent
  > sudo firewall-cmd --reload
```
 
Change elasticsearch cluster config
```markdown
sudo echo -e "$MY_IP $MY_HOSTNAME" >> /etc/hosts
```
```markdown
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig~ <br />
touch /etc/elasticsearch/elasticsearch.yml <br />
chmod 660 /etc/elasticsearch/elasticsearch.yml <br />
```

Then: 

```markdown
# bootstrap elasticsearch config with defined values <br />
cat > /etc/elasticsearch/elasticsearch.yml << EOF <br />
cluster.name: <CHANGE_THIS_TO_ELASTIC_CLUSTER_NAME> <br />
node.name: <CHANGE_THIS_TO_ELASTIC_NODE_NAME>-<CHANGE_THIS_TO_ELASTIC_NODE_NUMBER> <br />
network.host: <CHANGE_THIS_TO_ELASTIC_NODE_IP>,_local_ <br />
http.port: 9200 <br />
discovery.seed_hosts: ["<CHANGE_THIS_TO_ELASTIC_MASTER_IPS>"] <br />
cluster.initial_master_nodes: ["<CHANGE_THIS_TO_ELASTIC_MASTER_NAME>"] <br />
bootstrap.memory_lock: true <br />
path.logs: /var/lib/elasticsearch/logs <br />
xpack.monitoring.enabled: true <br />
EOF <br />
```

Configure transport tls:
  
```markdown
SSL_PATH=/etc/elasticsearch/certs <br />
TRANSPORT_CERT_FILENAME=elastic-certificates.p12 <br />
TRANSPORT_CERT_PATH=$SSL_PATH/$TRANSPORT_CERT_FILENAME <br />
mkdir -p $SSL_PATH <br />
Move transport cert file to  $SSL_PATH <br />
chown -R elasticsearch:elasticsearch $SSL_PATH <br />
```

```markdown  
echo "xpack.security.transport.ssl.enabled: true"  | tee -a /etc/elasticsearch/elasticsearch.yml <br />
echo "xpack.security.transport.ssl.verification_mode: certificate"  | tee -a /etc/elasticsearch/elasticsearch.yml <br />
echo "xpack.security.
transport.ssl.keystore.path: $TRANSPORT_CERT_PATH"  | tee -a /etc/elasticsearch/elasticsearch.yml <br />
echo "xpack.security.transport.ssl.truststore.path: $TRANSPORT_CERT_PATH"  | tee -a /etc/elasticsearch/elasticsearch.yml <br />
echo "xpack.security.transport.ssl.truststore.type: PKCS12"  | tee -a /etc/elasticsearch/elasticsearch.yml <br />
echo "xpack.security.transport.ssl.keystore.type: PKCS12"  | tee -a /etc/elasticsearch/elasticsearch.yml <br />
```
Override systemd file:
```markdown
mkdir -p /etc/systemd/system/elasticsearch.service.d <br />
touch /etc/systemd/system/elasticsearch.service.d/override.conf <br />
```
```markdown
cat > /etc/systemd/system/elasticsearch.service.d/override.conf << EOF <br />
[Service] <br />
LimitMEMLOCK=infinity <br />
LimitNPROC=infinity <br />
LimitNOFILE=infinity <br />
LimitCORE=0 <br />
EOF <br /> 
```

#### Configure the heap for each node

Create file heap.options in  /etc/elasticsearch/jvm.options.d directory:
```markdown
mkdir -p /etc/elasticsearch/jvm.options.d <br />
touch /etc/elasticsearch/jvm.options.d/heap.options <br />
```
```markdown  
cat > /etc/elasticsearch/jvm.options.d/heap.options << EOF <br />
-Xms2g <br />
-Xmx2g <br />
EOF <br />
```
#### Start Elasticsearch as a daemon on each node

Start elasticsearch 
```markdown
systemctl daemon-reload <br />
systemctl restart elasticsearch <br />
systemctl enable elasticsearch <br />
```

