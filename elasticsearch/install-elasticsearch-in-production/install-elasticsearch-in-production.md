## Install elasticsearch in production

#### Overview

Types of Nodes:
```markdown
Master-Eligible Node 

   Control of the cluster requires a minimum of 3 with one active at any given time.
```
```markdown
Data Nodes

   Holds indexed data and performs data related operations Differentiated Hot and Warm Data nodes can be used -> More below.
```
```markdown
Ingest Nodes

   Use ingest pipelines to transform and enrich data before indexing.
```
```markdown
Coordinating Nodes

   Route requests, handle Search reduce phase, distribute bulk indexing. All nodes function as coordinating nodes by default.A node that has no attribute is a coordinator node and helps with the queries.
```
```markdown
Machine Learning Nodes

   Run machine learning jobs
```
```markdown
Transform node

  Enables you to convert existing Elasticsearch indices into summarised indices. 
```
```markdown
Remote-eligible node

  A node with the remote_cluster_client role, which is activated by default, makes it eligible to act as a remote client. By default, any node in the cluster can act as a cross-cluster client and connect to remote clusters. This is particularly useful in some use cases when your production cluster needs access to remote clusters.
```
  
![Elastic Stack Topology](../images/topology.png)

###### Minimum of Master Nodes:

Master nodes are the most critical nodes in your cluster. In order to calculate how many master nodes you need in your production cluster, here is a simple formula:
```markdown
N / 2 + 1
```
Where N is the total number of “master-eligible” nodes in your cluster, you need to round that number down to the nearest integer.

At least a minimum of 3 master nodes in order to avoid any split-brain situation. 
  
A quorum is (number of master-eligible nodes / 2) + 1. Here are some examples:

If you have ten regular nodes ( ones that can either hold data and become master), the quorum is 6

If you have three dedicated master nodes and a hundred data nodes, the quorum is 2.

If you have two regular nodes, you are in a conundrum. A quorum would be 2, but this means a loss of one node will make your cluster inoperable. A setting of 1 will allow your cluster to function but doesn’t protect against the split-brain. It is best to have a minimum of three nodes.

  
#### Hardware

**Heap: Sizing and Swapping**

Sizing your nodes is a tricky task.

Making the right choice isn’t an easy task. You should always scale according to your requirements and your budget. One way to do it is by trial and error. Scale up or down your nodes and their number depending on the usage that you are seeing. After a few runs, you should end up with a configuration that utilizes just enough resources with good indexing and searching performances.

When you attribute 8Gb to an elastic search node, the standard recommendation is to give 50% of the available memory to ElasticSearch heap while leaving the other 50% free. 

Don’t allocate more than 32Gb (64Gb total) to your nodes.

**Disks**

Disks are probably the most essential aspect of a cluster and especially so for indexing-heavy clusters such as those that ingest log data.

Disks are by far the slowest subsystem in a server. This means that if you have write-heavy loads such as logs retention, you are doing a lot of writing, and the disks can quickly become saturated, which in turn becomes the bottleneck of the cluster.

Use SSDs. 

Their far superior writing and re
ading speed significantly increase your overall performance. SSD-backed nodes see an increase in bot query and indexing performance.

**CPU**

CPUs are not so crucial with elastic Search as deployments tend to be relatively light on CPU requirements.

The recommended option is to use a modern processor with multiple cores. Common production-grade ElasticSearch clusters tend to utilize between two to eight-core machines.

If you need to choose between faster CPUs or more cores, choose more cores. The extra concurrency that multiple cores offer will far outweigh a slightly faster clock speed.

**Kibana**

Most clusters use Kibana to visualize data.

For heavy Kibana usage, recommended that using coordinator nodes. This will unload the query stress from your master nodes and improve the overall performance of cluster.

![Kibana](../images/kibana.png)

#### Sharding Impact on Performance

In ElasticSearch, your data is organized in indices, and those are each made of shards that are distributed across multiple nodes. Shards are created when a new document needs to be indexed, then a unique id is being generated, and the destination of the shard is calculated based on this id. Once the shard has been delegated to a specific node, each write is sent to the node. This method allows a reasonably smooth distribution of documents across all of your shards. Thanks to this method, you can easily and quickly query thousands of documents in the blink of an eye.

Your data is organized in indices, each made of shards and distributed across multiple nodes. If a new document needs to be indexed, a unique id is being generated, and the destination shard is being calculated based on this id. After that, the writer is delegated to the node, which is holding the calculated destination shard. This will distribute your documents pretty well across all of your shards.

What is a shard? Each shard is a separate Lucene index, made of little segments of files located on your disk. Whenever you write, a new segment will be created. When a certain amount of segments is reached, they are all merged. This has some drawbacks; however, whenever you need to query your data, each segment is searched, meaning a higher I/O and memory consumption for your single node, whenever you need to search data against multiple shards meaning that the more shards you have, the more CPU work you need to do.

**For example**, if you have a write-heavy indexing case with just one node, the optimal number of indices and shards is 1. However, for search cases, you should set the number of shards to the number of CPUs available. In this way, searching can be multithreaded, resulting in better search performance.

But what are the benefits of sharding?

1. Availability: Replication of the shards to other nodes ensures that you always have the data even if you lose some nodes.

2. Performance: Distribution of your primary shards to other nodes implies that all shards can share the workload. They are improving the overall performance.

  So:
```markdown
- if your scenario is write-heavy, keep the number of shards per index low. 
- If you need better search performance, increase the number of shards, but keep the “physics” in mind. 
- If you need reliability, take the number of nodes/replicas into account.
```
#### Important Elasticsearch configuration

Elasticsearch requires very little configuration to get started, but there are a number of items which must be considered before using your cluster in production:

```markdown
Path settings
Cluster name setting
Node name setting
Network host settings
Discovery settings
Heap size settings
JVM heap dump path setting
GC logging settings
Temporary directory settings
JVM fatal error log setting
Cluster backups
```

#### Important system configuration

Ideally, Elasticsearch should run alone on a server and use all of the resources available to it. 

In order to do so, you need to configure your operating system to allow the user running Elasticsearch to access more resources than allowed by default.

The following settings must be considered before going to production:
```markdown
Configure system settings
Disable swapping
Increase file descriptors
Ensure sufficient virtual memory
Ensure sufficient threads
JVM DNS cache settings
Temporary directory not mounted with noexec
TCP retransmission timeout
```
#### Bootstrap Checks

These bootstrap checks inspect a variety of Elasticsearch and system settings and compare them to values that are safe for the operation of Elasticsearch. If Elasticsearch is in development mode, any bootstrap checks that fail appear as warnings in the Elasticsearch log. If Elasticsearch is in production mode, any bootstrap checks that fail will cause Elasticsearch to refuse to start.

There are some bootstrap checks that are always enforced to prevent Elasticsearch from running with incompatible settings. These checks are documented individually.

```markdown
- Heap size check
- File descriptor check
- Memory lock check
- Maximum number of threads check
- Max file size check
- Maximum size virtual memory check
- Maximum map count check
- Client JVM check
- Use serial collector check
- System call filter check
- OnError and OnOutOfMemoryError checks
- Early-access check
- G1GC check
```
#### Resilience in small clustersedit

In smaller clusters, it is most important to be resilient to single-node failures.

**Three-node clusters**

If you have three nodes, we recommend they all be data nodes and every index that is not a searchable snapshot index should have at least one replica. Nodes are data nodes by default. You may prefer for some indices to have two replicas so that each node has a copy of each shard in those indices. You should also configure each node to be master-eligible so that any two of them can hold a master election without needing to communicate with the third node. Nodes are master-eligible by default. This cluster will be resilient to the loss of any single node.

You should avoid sending client requests to just one of your nodes. If you do, and this node fails, then any requests will not receive responses even if the remaining two nodes form a healthy cluster. Ideally, you should balance your client requests across all three nodes. You can do this by specifying the address of multiple nodes when configuring your client to connect to your cluster. Alternatively you can use a resilient load balancer to balance client requests across your cluster. 

**Clusters with more than three nodes**

Once your cluster grows to more than three nodes, you can start to specialise these nodes according to their responsibilities, allowing you to scale their resources independently as needed. You can have as many data nodes, ingest nodes, machine learning nodes, etc. as needed to support your workload. As your cluster grows larger, we recommend using dedicated nodes for each role. This allows you to independently scale resources for each task.

However, it is good practice to limit the number of master-eligible nodes in the cluster to three. Master nodes do not scale like other node types since the cluster always elects just one of them as the master of the cluster. If there are too many master-eligible nodes then master elections may take a longer time to complete. In larger clusters, we recommend you configure some of your nodes as dedicated master-eligible nodes and avoid sending any client requests to these dedicated nodes. Your cluster may become unstable if the master-eligible nodes are overwhelmed with unnecessary extra work that could be handled by one of the other nodes.

You may configure one of your master-eligible nodes to be a voting-only node so that it can never be elected as the master node. For instance, you may have two dedicated master nodes and a third node that is both a data node and a voting-only master-eligible node. This third voting-only node will act as a tiebreaker in master elections but will never become the master itself.

**Summary**

The cluster will be resilient to the loss of any node as long as:

The cluster health status is green.

There are at least two data nodes.

Every index that is not a searchable snapshot index has at least one replica of each shard, in addition to the primary.

The cluster has at least three master-eligible nodes, as long as at least two of these nodes are not voting-only master-eligible nodes.

Clients are configured to send their requests to more than one node or are configured to use a load balancer that balances the requests across an appropriate set of nodes. The Elastic Cloud service provides such a load balancer.


