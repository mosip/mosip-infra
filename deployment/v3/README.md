# MOSIP Deployment V3

## High level architecture
![](docs/images/deployment_architecture.png)

## Features
* Clusters not dependent on OS of underlying VM's i.e. Operating System agnostic.
* Supports all type of Kubernetes solution like RKE, EKS, AKS etc. 
* Single Kubernetes cluster MOSIP installation.
* Single organisation-wide IAM system. Here, we install Keycloak.
* Cluster administration using Rancher. 
* Rancher-IAM-cluster integration for Role Based Access Control (RBAC).
* Intra cluster traffic management using powerfull Istio Mesh.
* Two communication channels for the cluster (PUBLIC and INTERNAL to the cluster). 
* Internal LB for ActiveMQ - ABIS connection. 
* Published Production grade Helm charts for each MOSIP modules from seperate [repository](https://github.com/mosip/mosip-helm).
* All cluster, external services and MOSIP services deployments via Helm charts using shell scripts.
* Deployment of MOSIP modules and external services in separate namespaces with its own ingress, permissions and policies.
* Storing secrets as Kubernetes secrets, no more passing of secrets via plain texts anywhere.
* Passing necessary configuration properties like usernames and URL's via configmaps. 
* Option to run external components inside cluster for development and testing.
* High Availability option for all components including Rancher and IAM.
* Easy instalation and control of Logging and monitoring from Rancher dashboards directly.

### IAM (Keycloak)
We recommend a single Identity & Access Management (IAM) for an organization or a project to avoid managing multiple entries for the same user.  The IAM may be shared across multiple MOSIP installations.  Here, we deploy Keycloak. However, any OAuth 2.0 compliant IAM should work well with MOSIP.

### Network load balancer
We have chosen cloud's Network Load Balancer (Layer 4) over Application Load Balancer (Layer 7) as we have application load balancing done by Nginx Ingress running inside the cluster.

### TLS termination
HTTS connections are terminated at load balancer on Cloud and Nginx on on-prem setup. Termination at LB level makes it possible to inspect packets before sending to cluster.

### Wireguard
Wireguard may be installed on all nodes of Kubernetes cluster to secure inter-node commmunication.  However, note that Wireguard typically does not run on cloud infrastructures.

Further, for private access to MOSIP APIs, a Wireguard bastion host may be installed.  This acts like a VPN tunnel to reach MOSIP server.

### High availability
All components installed here have High Availibity (HA) option.
* IAM:  Keycloak may be run on a separate k8s cluster thereby providing HA. 
* Rancher: Similar to IAM, Rancher server may also be run on a separate k8s cluster. 
* Activemq: Master-slave configuration of ActiveMQ installed.
* MOSIP pods:  All pods may be replicated for HA.

## Cloud versus on-prem
There are certain differences between cloud and on-prem deployments.  Few of them are given below:
|Feature|Cloud|On-prem|
|---|---|---|
|K8s cluster|Cloud provider provisioned. Eg. EKS on AWS, AKS on Azure|Native, eg. using Rancher RKE|
|Load balancer|Automatic provision of LB|Nginx|
|TLS termination|Cloud LB|Nginx|
|Inter-node Wireguard network|Not compatible|Works well|

## Installation
Following install sequence is recommended:
* [Rancher](rancher/README.md) 
* [IAM (Keycloak)](external/iam/README.md)
* [MOSIP K8s cluster](cluster/README.md)
* [Monitoring](monitoring/README.md)
* [Logging](logging/README.md)
* [MOSIP external components](external/README.md)
* [MOSIP core modules](mosip/README.md)
