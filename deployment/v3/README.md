# MOSIP Deployment V3 _(Reference Implementation)_

## Overview
We provide a reference implementation of a Kubernetes based **production grade** deployment of MOSIP, also called **V3 deployment**. The same can be deployed as a sandbox or scaled up for a larger full-scale deployment. Several security features have been added over the [single click installer (V2)](../sandbox-v2).  

![](docs/images/deployment_architecture.png)

There are two Kubernetes clusters - one for [Rancher](https://www.rancher.com/) and [Keycloak](https://www.keycloak.org/)(IAM) and another for all MOSIP modules. Rancher is used for cluster administration and [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).  MOSIP modules are installed via [Helm Charts](https://github.com/mosip/mosip-helm/tree/1.2.0). The modules may be installed in High Availability (HA) mode by replicating the [pods](https://kubernetes.io/docs/concepts/workloads/pods/).  

We provide installation instructions for both, cloud (here AWS) an on-premise (on-prem). 

## Cloud versus on-prem
There are certain differences between cloud and on-prem deployments. Few of them are given below:
|Feature|Cloud|On-prem|
|---|---|---|
|K8s cluster|Cloud provider provisioned. Eg. EKS on AWS, AKS on Azure|Native, eg. using [Rancher RKE](https://rancher.com/docs/rke/latest/en/)|
|Load balancer|Automatic provision of LB|Nginx|
|TLS termination|Cloud LB|Nginx|
|Inter-node Wireguard network|Not compatible|Works well|
|Storage|Cloud storage like EBS on AWS|[Longhorn](cluster/longhorn) or [NFS](https://en.wikipedia.org/wiki/Network_File_System)|

## Installation
Following install sequence is recommended:
* [Rancher](rancher/README.md) 
* [MOSIP K8s cluster](cluster/README.md)
* [Monitoring](monitoring/README.md)
* [Logging](logging/README.md)
* [MOSIP external components](external/README.md)
* [MOSIP core modules](mosip/README.md)
* [Reporting](reporting/README.md)

## Production hardening
Refer to notes [here](docs/production_checklist.md) for production hardening items.
