# On-prem Kubernetes Cluster for Rancher

##  Prerequisites
* For high availability, you would need at least 2 worker nodes.
* For external access you will need a public domain like `rancher.xyz.net` to point to this installation.
* TLS termination: you may terminate TLS in any of the following ways:
  * Directly on Rancher service
  * On ingress controller
  * On a reverse proxy before the ingress controller

## Cluster Setup
* Set up VMs.
* [IMPORTANT] **DONOT** remove the default settings for ingress provider while configuring rke `cluster.yml`, because we want the default ingress controller to be installed.
* Create K8s cluster, using `rke` utility. Using [this](../../docs/rke-setup.md).

##  Nginx Loadbalancer / Reverse Proxy
* Install [nginx reverse proxy](./nginx/) that proxies into ingresscontroller on a seperate node.

## Wireguard Bastion Host
* Install [Wireguard Bastion Host](../../docs/wireguard-bastion.md) on a seperate node/VM.

## Longhorn
* Install [Longhorn](../longhorn/README.md) for persistent storage.
