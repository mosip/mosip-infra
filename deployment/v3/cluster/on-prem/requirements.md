# Requirements for On-prem MOSIP Cluster Sandbox

Listed below are hardware, network and certificate requirements to setup a **MOSIP sandbox** on-prem.  Note that [Rancher cluster requirements](../../rancher/on-prem) are not covered here.

## Hardware requirements

|Purpose|vCPUs|RAM|Storage|Number of VMs\*|
|---|:---:|:---:|:---:|---:|
|Cluster nodes | 8 | 32 GB | 64 GB |5|
|Wireguard bastion host| 2 | 4 GB | 16 GB |1| 
|Nginx|4|16GB|32 GB|1|

\* Virtual Machines

## Network configuration
### Nginx network interface
* Internal: To access cluster nodes.
* Public: Either has a direct public IP or behind a firewall that forwards traffic on 443/tcp & 51820/udp to this interface. 

* The cluster nodes needs not be accessed by public internet. So an internal interface with internet access is sufficient. (Eg: NAT Network)
## DNS requirements

Will require the DNS mappings. <br/>
The actual hostnames will vary from organisation to organisation. A sample hostname list is given at [global_configmap.yaml.sample](../global_configmap.yaml.sample) <br/>
Note: Will get the loadbalancer ip only after the ingressgateways are installed and the loadbalancers are setup. Only then proceed to DNS mapping. <br/>
Note: If there are multiple replicas of this nginx+wireguard node, public ips of all of the nodes can be mapped to public hostnames, same with the internal ips.

| Hostname | Mapped to |
|---|---|
| mosip-api-host | Public ip of Nginx node |
| mosip-api-internal-host | Internal ip of Nginx Node|
| mosip-prereg-host | Public ip |
| mosip-activemq-host | Internal ip |
| mosip-kibana-host | Internal ip |
| mosip-regclient-host | Internal ip |
| mosip-admin-host | Internal ip |
| mosip-minio-host | Internal ip |
| mosip-kafka-host | Internal ip |
| mosip-iam-external-host | Internal ip |

## Certificate requirements

* Depending upon the above hostnames, will requires atleast one wildcard SSL certificate. For example; `*.mosip.gov.country`.
* Will need more ssl certificates, for every new level of hierarchy. For example; `*.sandbox1.mosip.example.org`.
