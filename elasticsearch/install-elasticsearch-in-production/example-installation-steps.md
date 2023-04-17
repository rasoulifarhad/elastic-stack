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

Create the elastic user:
```markdown
sudo useradd elastic
```
Open the limits.conf file as root:
```markdown
sudo vim /etc/security/limits.conf
```
Add the following line near the bottom:
```markdown
elastic - nofile 65536
```
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
Become the elastic user:
```markdown
sudo su - elastic
```
Download the binaries for Elasticsearch 7.16.2 in the elastic user's a home directory:
```markdown
curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.2-linux-x86_64.tar.gz
```
Unpack the archive:
```markdown
tar -xzvf elasticsearch-7.16.2-linux-x86_64.tar.gz
```
Remove the archive:
```markdown
rm elasticsearch-7.16.2-linux-x86_64.tar.gz
```
Rename the unpacked directory:
```markdown
mv elasticsearch-7.16.2 elasticsearch
```
#### Configure each node’s elasticsearch.yml file

Log in to each node and become the elastic user:
```markdown
sudo su - elastic
```
Create elasticsearch direcories: 
```markdown
sudo nano /etc/fstab
sudo mount /dev/xxx/data/elasticsearch /var/lib/elasticsearch/
```
```markdown
sudo mount -a
sudo lsblk

sudo mkdir -p /etc/elasticsearch

sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch/
sudo chmod -R g+rs /etc/elasticsearch/
sudo chmod -R o-rwx /etc/elasticsearch/
 
sudo mkdir -p /var/lib/elasticsearch/data
sudo mkdir -p /var/lib/elasticsearch/logs
 
sudo chown -R elasticsearch:elasticsearch /var/lib/elasticsearch/
sudo chmod -R g+rs /var/lib/elasticsearch/
sudo chmod -R o-rwx /var/lib/elasticsearch/

sudo rm -rf /var/log/elasticsearch
sudo ln -sf /var/lib/elasticsearch/logs /var/log/elasticsearch
```
Let's open port 9200 to we can communicate with ElasticSearch:

```markdown
sudo firewall-cmd --zone=public --add-port=9200/tcp --permanent
sudo firewall-cmd --reload
```
 
Open the elasticsearch.yml file:

```markdown
vim /etc/elasticsearch/elasticsearch.yml
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
#xpack.monitoring.enabled: true
#xpack.security.transport.ssl.enabled: true
#xpack.security.transport.ssl.verification_mode: certificate
#xpack.security.transport.ssl.keystore.path: certs/elastic-certificates.p12
#xpack.security.transport.ssl.truststore.path: certs/elastic-certificates.p12
#xpack.security.transport.ssl.truststore.type: PKCS12
#xpack.security.transport.ssl.keystore.type: PKCS12
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
xpack.monitoring.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.keystore.path: certs/elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: certs/elastic-certificates.p12
xpack.security.transport.ssl.truststore.type: PKCS12
xpack.security.transport.ssl.keystore.type: PKCS12
```

Insteed you can do this:

```markdown
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig~

touch /etc/elasticsearch/elasticsearch.yml

chmod 660 /etc/elasticsearch/elasticsearch.yml
```
  
Then: 
  
```markdown
echo 'node.name: es-node1' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'cluster.name: op-es-cluster'|tee -a /etc/elasticsearch/elasticsearch.yml

echo 'network.host: "0.0.0.0"' |tee -a /etc/elasticsearch/elasticsearch.yml

echo 'discovery.seed_hosts: "es-node1, es-node2, es-node3"' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'cluster.initial_master_nodes: "es-node1, es-node2, es-node3"' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'bootstrap.memory_lock: true' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.security.enabled: true' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.monitoring.enabled: true' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.monitoring.collection.enabled: true' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.security.transport.ssl.enabled: true' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.security.transport.ssl.verification_mode: certificate' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.security.transport.ssl.keystore.path: certs/elastic-certificates.p12' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.security.transport.ssl.truststore.path: certs/elastic-certificates.p12' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.security.transport.ssl.truststore.type: PKCS12' | tee -a /etc/elasticsearch/elasticsearch.yml

echo 'xpack.security.transport.ssl.keystore.type: PKCS12' | tee -a /etc/elasticsearch/elasticsearch.yml
```

OR
  
```markdown
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig~

touch /etc/elasticsearch/elasticsearch.yml

chmod 660 /etc/elasticsearch/elasticsearch.yml
```

Then: 

```markdown
# bootstrap elasticsearch config with defined values
cat > /etc/elasticsearch/elasticsearch.yml << EOF
cluster.name: <CHANGE_THIS_TO_ELASTIC_CLUSTER_NAME>
node.name: <CHANGE_THIS_TO_ELASTIC_NODE_NAME>-<CHANGE_THIS_TO_ELASTIC_NODE_NUMBER>
network.host: <CHANGE_THIS_TO_ELASTIC_NODE_IP>,_local_
http.port: 9200
discovery.seed_hosts: ["<CHANGE_THIS_TO_ELASTIC_MASTER_IPS>"]
cluster.initial_master_nodes: ["<CHANGE_THIS_TO_ELASTIC_MASTER_NAME>"]
bootstrap.memory_lock: true
path.logs: /var/lib/elasticsearch/logs
path.data: /var/lib/elasticsearch/data
xpack.monitoring.enabled: true
xpack.monitoring.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.keystore.path: certs/elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: certs/elastic-certificates.p12
xpack.security.transport.ssl.truststore.type: PKCS12
xpack.security.transport.ssl.keystore.type: PKCS12
EOF  
```
    
Create systemd file: elasticsearch.service\

```markdown
cat > /usr/lib/systemd/system/elasticsearch.service << EOF
[Unit]
Description=Elasticsearch
Documentation=https://www.elastic.co
Wants=network-online.target
After=network-online.target
[Service]
Type=notify
RuntimeDirectory=elasticsearch
PrivateTmp=true
Environment=ES_HOME=/usr/share/elasticsearch
Environment=ES_PATH_CONF=/etc/elasticsearch
Environment=PID_DIR=/var/run/elasticsearch
Environment=ES_SD_NOTIFY=true
EnvironmentFile=-/etc/sysconfig/elasticsearch
WorkingDirectory=/usr/share/elasticsearch
User=elasticsearch
Group=elasticsearch
ExecStart=/usr/share/elasticsearch/bin/systemd-entrypoint -p ${PID_DIR}/elasticsearch.pid --quiet
# StandardOutput is configured to redirect to journalctl since
# some error messages may be logged in standard output before
# elasticsearch logging system is initialized. Elasticsearch
# stores its logs in /var/log/elasticsearch and does not use
# journalctl by default. If you also want to enable journalctl
# logging, you can simply remove the "quiet" option from ExecStart.
StandardOutput=journal
StandardError=inherit
LimitMEMLOCK=infinity
# Specifies the maximum file descriptor number that can be opened by this process
LimitNOFILE=65535
# Specifies the maximum number of processes
LimitNPROC=4096
# Specifies the maximum size of virtual memory
LimitAS=infinity
# Specifies the maximum file size
LimitFSIZE=infinity
# Disable timeout logic and wait until process is stopped
TimeoutStopSec=0
# SIGTERM signal is used to stop the Java process
KillSignal=SIGTERM
# Send the signal only to the JVM rather than its control group
KillMode=process
# Java process is never killed
SendSIGKILL=no
# When a JVM receives a SIGTERM signal it exits with code 143
SuccessExitStatus=143
# Allow a slow startup before the systemd notifier module kicks in to extend the timeout
TimeoutStartSec=75
[Install]
WantedBy=multi-user.target
# Built for packages-7.16.3 (packages)
EOF  
```
override.conf

```markdown  
mkdir -p /etc/systemd/system/elasticsearch.service.d
touch /etc/systemd/system/elasticsearch.service.d/override.conf

echo '[Service]' | tee -a /etc/systemd/system/elasticsearch.service.d/override.conf
echo 'LimitMEMLOCK=infinity' | tee -a /etc/systemd/system/elasticsearch.service.d/override.conf
echo 'LimitNPROC=infinity' | tee -a /etc/systemd/system/elasticsearch.service.d/override.conf
echo 'LimitNOFILE=infinity' | tee -a /etc/systemd/system/elasticsearch.service.d/override.conf
echo 'LimitCORE=0' | tee -a /etc/systemd/system/elasticsearch.service.d/override.conf
```

OR
  
```markdown  
mkdir -p /etc/systemd/system/elasticsearch.service.d
cat > /etc/systemd/system/elasticsearch.service.d/override.conf << EOF
[Service]
LimitMEMLOCK=infinity
LimitNPROC=infinity
LimitNOFILE=infinity
LimitCORE=0
EOF  
```

Create /etc/sysconfig/elasticsearch

```markdown
cat > /etc/sysconfig/elasticsearch << EOF
################################
# Elasticsearch
################################

# Elasticsearch home directory
#ES_HOME=/usr/share/elasticsearch

# Elasticsearch Java path
#ES_JAVA_HOME=

# Elasticsearch configuration directory
# Note: this setting will be shared with command-line tools
ES_PATH_CONF=/etc/elasticsearch

# Elasticsearch PID directory
#PID_DIR=/var/run/elasticsearch

# Additional Java OPTS
#ES_JAVA_OPTS=

# Configure restart on package upgrade (true, every other setting will lead to not restarting)
#RESTART_ON_UPGRADE=true

################################
# Elasticsearch service
################################

# SysV init.d
#
# The number of seconds to wait before checking if Elasticsearch started successfully as a daemon process
ES_STARTUP_SLEEP_TIME=5

################################
# System properties
################################

# Specifies the maximum file descriptor number that can be opened by this process
# When using Systemd, this setting is ignored and the LimitNOFILE defined in
# /usr/lib/systemd/system/elasticsearch.service takes precedence
#MAX_OPEN_FILES=65535

# The maximum number of bytes of memory that may be locked into RAM
# Set to "unlimited" if you use the 'bootstrap.memory_lock: true' option
# in elasticsearch.yml.
# When using systemd, LimitMEMLOCK must be set in a unit file such as
# /etc/systemd/system/elasticsearch.service.d/override.conf.
#MAX_LOCKED_MEMORY=unlimited

# Maximum number of VMA (Virtual Memory Areas) a process can own
# When using Systemd, this setting is ignored and the 'vm.max_map_count'
# property is set at boot time in /usr/lib/sysctl.d/elasticsearch.conf
#MAX_MAP_COUNT=262144
EOF  
```

Create /usr/lib/sysctl.d/elasticsearch.conf

```markdown
cat > /usr/lib/sysctl.d/elasticsearch.conf << EOF
vm.max_map_count=262144
EOF  
```
```markdown
systemctl daemon-reload
systemctl restart elasticsearch
systemctl enable elasticsearch
```
#### Configure the heap for each node

Log in to each master node and become the elastic user:
```markdown
sudo su - elastic
```
Create file heap.options in  /etc/elasticsearch/jvm.options.d directory:

```markdown
mkdir -p /etc/elasticsearch/jvm.options.d
cat > /etc/elasticsearch/jvm.options.d/heap.options << EOF
-Xms2g
-Xmx2g
EOF  
```

#### Start Elasticsearch as a daemon on each node
