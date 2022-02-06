# Requirements for On-prem MOSIP Cluster

## Hardware requirements
Will require the following number of Virtual Machines (VMs).

|Purpose|vCPUs|RAM|Storage|Number of VMs|
|---|:---:|:---:|:---:|---:|
|Cluster nodes | 8 | 32 GB | 64 GB |5|
|Wireguard bastion host| 2 | 1 GB | 8 GB |1| 

For better security and access we can have separate Wireguard bastion server for all the partners and field operations like:
1. ABIS Partner
1. Auth Partners
1. Print Partners
1. Field Operators
1. Admin Authorities
1. Process Monitoring departments

Note: The same can be configured with single bastion server node also

## Network configuration
* The Cluster nodes needs not be accessed by public internet. So an internal interface with internet access is sufficient. (Eg: NAT Network)
* The Nginx node should be accessible publicly. That means, this node should have atleast the following networking configuration:
  * One internal network interface where it CAN ACCESS the other nodes. And one public interface
  * One public interface; this either has a direct public ip. Or there is some firewall rule somewhere else to forward that public-ip 443/tcp & 51820/udp traffic to this interface. (51820 is wireguard port, for bastion server).

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
