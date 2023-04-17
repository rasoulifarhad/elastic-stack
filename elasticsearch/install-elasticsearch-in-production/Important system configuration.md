## Important system configuration

Elasticsearch should run alone on a server and use all of the resources available to it. In order to do so, you need to configure your operating system to allow the user running Elasticsearch to access more resources than allowed by default.

The following settings must be considered before going to production:

```markdown
- Configure system settings
- Disable swapping
- Increase file descriptors
- Ensure sufficient virtual memory
- Ensure sufficient threads
- JVM DNS cache settings
- Temporary directory not mounted with noexec
- TCP retransmission timeout
```
#### Configure system settings

When using the RPM or Debian packages on systems that use systemd, system limits must be specified via systemd. The systemd service file (/usr/lib/systemd/system/elasticsearch.service) contains the limits that are applied by default.

To override them, add a file called /etc/systemd/system/elasticsearch.service.d/override.conf (alternatively, you may run sudo systemctl edit elasticsearch which opens the file automatically inside your default editor). Set any changes in this file, such as:
```markdown
[Service]
LimitMEMLOCK=infinity
```  
Once finished, run the following command to reload units:
```markdown
sudo systemctl daemon-reload
```
#### Disable swapping

Disable all swap files

```markdown
sudo swapoff -a
```
This doesn’t require a restart of Elasticsearch. To disable it permanently, you will need to edit the /etc/fstab file and comment out any lines that contain the word swap.

##### Configure swappines

Another option available on Linux systems is to ensure that the sysctl value vm.swappiness is set to 1. This reduces the kernel’s tendency to swap and should not lead to swapping under normal circumstances, while still allowing the whole system to swap in emergency conditions.

##### Enable bootstrap.memory_lock

Another option is to use mlockall on Linux/Unix systems, or VirtualLock on Windows, to try to lock the process address space into RAM, preventing any Elasticsearch heap memory from being swapped out.

To enable a memory lock, set bootstrap.memory_lock to true in elasticsearch.yml:

```markdown
bootstrap.memory_lock: true
```

After starting Elasticsearch, you can see whether this setting was applied successfully by checking the value of mlockall in the output from this request:
```markdown
GET _nodes?filter_path=**.mlockall
```
##### Systems using systemd
```markdown
Set LimitMEMLOCK to infinity in the systemd configuration.
```

#### Increase file descriptors

Elasticsearch uses a lot of file descriptors or file handles. Running out of file descriptors can be disastrous and will most probably lead to data loss. Make sure to increase the limit on the number of open files descriptors for the user running Elasticsearch to 65,536 or higher.

For the .zip and .tar.gz packages, 
```markdown
Set ulimit -n 65535 as root before starting Elasticsearch
Or 
Set nofile to 65535 in /etc/security/limits.conf
```
You can check the max_file_descriptors configured for each node using the Nodes stats API, with:
```markdown
GET _nodes/stats/process?filter_path=**.max_file_descriptors
```  
RPM and Debian packages already default the maximum number of file descriptors to 65535 and do not require further configuration.

#### Ensure sufficient virtual memory

Elasticsearch uses a mmapfs directory by default to store its indices. The default operating system limits on mmap counts is likely to be too low, which may result in out of memory exceptions.

On Linux, you can increase the limits by running the following command as root:
```markdown
sysctl -w vm.max_map_count=262144
```  
To set this value permanently, 
```markdown
Update the vm.max_map_count setting in /etc/sysctl.conf. 
```
To verify after rebooting, 
```markdown
Run sysctl vm.max_map_count. 
```
The RPM and Debian packages will configure this setting automatically. No further configuration is required.

#### Ensure sufficient threads

Elasticsearch uses a number of thread pools for different types of operations. It is important that it is able to create new threads whenever needed. Make sure that the number of threads that the Elasticsearch user can create is at least 4096.

This can be done by setting ulimit -u 4096 as root before starting Elasticsearch, or by setting nproc to 4096 in /etc/security/limits.conf

The package distributions when run as services under systemd will configure the number of threads for the Elasticsearch process automatically. No additional configuration is required.

#### Temporary directory not mounted with noexec

To resolve these problems, either remove the noexec option from your /tmp filesystem, or configure Elasticsearch to use a different location for its temporary directory by setting the $ES_TMPDIR environment variable. For instance:

If you are running Elasticsearch directly from a shell, set $ES_TMPDIR as follows:
```markdown  
export ES_TMPDIR=/usr/share/elasticsearch/tmp
```  
If you are using systemd to run Elasticsearch as a service, add the following line to the [Service] section in a service override file:
```markdown
Environment=ES_TMPDIR=/usr/share/elasticsearch/tmp
```  
#### TCP retransmission timeout

Each pair of Elasticsearch nodes communicates via a number of TCP connections which remain open until one of the nodes shuts down or communication between the nodes is disrupted by a failure in the underlying infrastructure.

TCP provides reliable communication over occasionally unreliable networks by hiding temporary network disruptions from the communicating applications. Your operating system will retransmit any lost messages a number of times before informing the sender of any problem. Elasticsearch must wait while the retransmissions are happening and can only react once the operating system decides to give up. Users must therefore also wait for a sequence of retransmissions to complete.

Most Linux distributions default to retransmitting any lost packets 15 times. Retransmissions back off exponentially, so these 15 retransmissions take over 900 seconds to complete. This means it takes Linux many minutes to detect a network partition or a failed node with this method. Windows defaults to just 5 retransmissions which corresponds with a timeout of around 6 seconds.

The Linux default allows for communication over networks that may experience very long periods of packet loss, but this default is excessive and even harmful on the high quality networks used by most Elasticsearch installations. When a cluster detects a node failure it reacts by reallocating lost shards, rerouting searches, and maybe electing a new master node. Highly available clusters must be able to detect node failures promptly, which can be achieved by reducing the permitted number of retransmissions. Connections to remote clusters should also prefer to detect failures much more quickly than the Linux default allows. Linux users should therefore reduce the maximum number of TCP retransmissions.

You can decrease the maximum number of TCP retransmissions to 5 by running the following command as root. Five retransmissions corresponds with a timeout of around six seconds.
```markdown
sysctl -w net.ipv4.tcp_retries2=5
```  
To set this value permanently, update the net.ipv4.tcp_retries2 setting in /etc/sysctl.conf. To verify after rebooting, run sysctl net.ipv4.tcp_retries2.
