# Requirements for On-prem MOSIP Cluster Sandbox

Listed below are hardware, network and certificate requirements to setup a **MOSIP sandbox** on-prem.  Note that [Rancher cluster (on-prem) requirements](../../rancher/on-prem) are not covered here.

## Hardware requirements

|Purpose|vCPUs|RAM|Storage|Number of VMs\*|
|---|:---:|:---:|:---:|---:|
|Cluster nodes | 8 | 32 GB | 64 GB |5|
|Wireguard bastion host| 2 | 4 GB | 16 GB |1|
|Nginx|2|4GB|16 GB|1|

\* Virtual Machines

## Network configuration

The following network configuration is required for the above mentioned nodes.
* Cluster Nodes
  * One internal interface: with internet access and that is on the same network as all the rest of nodes. (Eg: NAT Network)
* Nginx VM
  * One internal interface: that is on the same network as all the rest of nodes.
  * One public interface: Either has a direct public IP, or a firewall rule that forwards traffic on 443/tcp port to this interface ip.
* Wireguard Bastion
  * One internal interface: that is on the same network as all the rest of nodes.
  * One public interface: Either has a direct public IP, or a firewall rule that forwards traffic on 51820/udp port to this interface ip.

## DNS requirements

The following DNS mappings will be required.

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

Note: The above table is just a placeholder for hostnames, the actual name itself varies from organisation to organisation.  A sample hostname list is given at [global_configmap.yaml.sample](../global_configmap.yaml.sample) <br/>
Note: Only proceed to DNS mapping after the ingressgateways are installed and the nginx reverse proxy is setup.

## Certificate requirements

* Depending upon the above hostnames, will requires atleast one wildcard SSL certificate. For example; `*.mosip.gov.country`.
* Will need more ssl certificates, for every new level of hierarchy. For example; `*.sandbox1.mosip.example.org`.
