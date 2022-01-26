# Kuberenetes cluster for MOSIP


* [AWS](aws/README.md):  Create cluster on Amazon EKS
* [On-prem](on-prem/README.md): Create cluster on-premise using Rancher

## Hardware configurations

### Rancher cluster 
* There should be one cluster organisation wide for Common Rancher and IAM (keycloak) installation:
* Below is the configuration for the same:

| no. of nodes | no. of vCPU's | RAM | Storage |
|---|---|---|--|
| 2 | 2 vCPU | 8GB | 32 GB |

* In case of Cloud installation with AWS the type of resource used is `t3.large` for above mentioned configuration. Do update the same in cluster.config while cluster creation.
* In case of On-prem installation both the nodes should be there in same VPC so that there is no connectivity issue between them.

### MOSIP cluster
* There should be one cluster organisation wide for Common Rancher and IAM (keycloak) installation:
* Below is the configuration for the same:

| no. of nodes | no. of vCPU's | RAM | Storage |
|---|---|---|--|
| 5 | 8 vCPU | 32GB | 64 GB |

* In case of Cloud installation with AWS the type of resource used is `t3.2xlarge` for above mentioned configuration. Do update the same in cluster.config while cluster creation.
* In case of On-prem installation all the nodes should be there in same VPC so that there is no connectivity issue between them.

## Wireguard bastion Server

* There should be a wireguard bastion server for all the internal routings there with MOSIP cluster.
* The configuration for the same will be as follows:

| no. of VM | no. of vCPU's | RAM | storage |
|---|---|---|--|
| 1 | 2 vCPU | 1 GB | 8 GB |

* In case of cloud installation with AWS the instance type tested with is `t2.micro` and it should be in same VPC where Loadbalancer is there.
* In case of On-prem the VM should be in same VPC where MOSIP cluster is located.
* For better security and acces we can have seperate Wireguard bastion server for all the partners and field operations like:
1. ABIS Partner.
1. Auth Partners.
1. Print Partners.
1. Field Operators.
1. Admin Authorities.
1. Process Monitoring departments. 

## Nginx server

* In case of On-prem installation we will need a nginx server which will act as a Loadbalancer and tls terminator.
* The configureation for the same will be as follows:

| no. of VM | no. of vCPU's | RAM | storage |
|---|---|---|--|
| 1 | 2 vCPU | 1 GB | 8 GB |

* It should be in the same VPC for better connectivity to Mosip cluster nodes.
