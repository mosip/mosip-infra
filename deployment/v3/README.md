# MOSIP Deployment V3 _(Reference Implementation)_

## Overview
We provide reference implementation of a Kubernetes based **production grade** deployment of MOSIP, also called **V3 deployment**. The same may be deployed both as a **sandbox** or **full-scale production deployment**. Several security features and enhancements have been added over the [single click installer (V2)](../sandbox-v2).  

![](docs/images/deployment_architecture.png)

There are two Kubernetes clusters - one for [Rancher](https://www.rancher.com/) and another for all MOSIP modules. Rancher is used for cluster administration and [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).  MOSIP modules are installed via [Helm Charts](https://github.com/mosip/mosip-helm/tree/1.2.0). The modules may be installed in High Availability (HA) mode by replicating the [pods](https://kubernetes.io/docs/concepts/workloads/pods/).  

We provide installation instructions for both, cloud (here AWS) and on-premise (on-prem). 

## Cloud versus on-prem
There are certain differences between cloud and on-prem deployments. Few of them are given below:
|Feature|Cloud|On-prem|
|---|---|---|
|K8s cluster|Cloud provider provisioned. Eg. EKS on AWS, AKS on Azure|Native, eg. using [Rancher RKE](https://rancher.com/docs/rke/latest/en/)|
|Load balancer|Automatic provision of loadbalancer|Nginx|
|TLS termination|Cloud loadbalancer|Nginx|
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
Refer to [production hardening checklist](docs/production_checklist.md).
