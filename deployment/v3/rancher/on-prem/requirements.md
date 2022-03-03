# Requirements for On-prem Rancher Cluster

Listed below are hardware, network and certificate requirements to setup a **Rancher Cluster** on-prem.

## Hardware requirements

|Purpose|vCPUs|RAM|Storage| Number of Vms\*|
|---|:---:|:---:|:---:|---:|
|Cluster nodes | 2 | 8 GB | 32 GB | 2|
|Wireguard bastion host**| 2 | 1 GB | 8 GB |1|
|Nginx|2|2GB|16 GB|1|

\* Virtual Machines<br/>
\** Note: Wireguard Bastion Host can also be setup on the Nginx node itself.

## Network configuration

The following network configuration is required for the above mentioned nodes.
* Cluster Nodes
  * One internal interface: with internet access and that is on the same network as all the rest of nodes. (Eg: NAT Network)
* Nginx VM Network interfaces
  * One internal interface: with internet access and that is on the same network as all the rest of nodes.
* Wireguard Bastion Host
  * One internal interface: that is on the same network as all the rest of nodes.
  * One public interface: Either has a direct public IP, or a firewall rule that forwards traffic on 51820/udp port to this interface ip.

## DNS requirements

The following DNS mappings will be required.

| Hostname | Mapped to |
|---|---|
| rancher.org.net | Nginx Internal Ip |
| iam.org.net | Nginx Internal Ip |

Note: The above table is just a placeholder for hostnames, the actual name itself varies from organisation to organisation. <br/>
Note: Only then proceed to DNS mapping after setting up nginx node.

## Certificate requirements

* Depending upon the above hostnames, atleast one wildcard SSL certificate will be required. For example; `*.org.net`.
* More ssl certificates will be required, for every new level of hierarchy. For example; `*.sandbox1.org.net`.
