## Important Elasticsearch configuration

Ideally, Elasticsearch should run alone on a server and use all of the resources available to it. 

In order to do so, you need to configure your operating system to allow the user running Elasticsearch to access more resources than allowed by default.

The following settings must be considered before going to production:

> Configure system settings
> Disable swapping
> Increase file descriptors
> Ensure sufficient virtual memory
> Ensure sufficient threads
> JVM DNS cache settings
> Temporary directory not mounted with noexec
> TCP retransmission timeout


