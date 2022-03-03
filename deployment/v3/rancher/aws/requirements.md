# Requirements for AWS Rancher Cluster
Listed below are hardware, network and certificate requirements to setup a **Rancher Cluster** on AWS.

## Hardware requirements
The following number of EC2 nodes/instances will be required

|Purpose|vCPUs|RAM|Storage| AWS Type of each node | Number of Nodes|
|---|:---:|:---:|:---:|:---:|---:|
|Cluster nodes | 2 | 8 GB | 32 GB | t3.large |2|
|[Wireguard bastion host](../../docs/wireguard-bastion.md)| 2 | 4 GB | 8 GB | t2.medium |1|

Note: all the above nodes must be on the same VPC.

## Load balancer
Cloud provided load balancer will be automatically created upon installation of the [ingress controller](README.md#ingress-controller).

## DNS requirements
The following DNS mappings will be required.

| Hostname | Mapped to |
|---|---|
| rancher.xyz.net | Ingresscontroller Loadbalancer |
| iam.xyz.net | Ingresscontroller Loadbalancer |

## Certificate requirements
* Depending upon the above hostnames, atleast one wildcard SSL certificate will be required. For example; `*.org.net`.
* More ssl certificates will be required, for every new level of hierarchy. For example; `*.sandbox1.org.net`.
