# On-prem Kubernetes Cluster for Rancher

##  Prerequisites
* [Hardware, network, certificate requirements](./requirements.md).
* TLS termination: you may terminate TLS in any of the following ways:
  * On a reverse proxy (like Nginx) before the ingress controller (done as default in this installation).
  * On ingress controller
  * Directly on Rancher service
 
## Cluster setup
* Set up VMs.
* Create K8s cluster, using `rke` utility. Using [this](../../docs/rke-setup.md).

## Ingress controller
Install [Nginx ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/):

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install \                               
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --version 3.12.0 \
  --create-namespace  \
  -f ingress-nginx.values.yaml
```

## Reverse proxy (Nginx) + Wireguard bastion host
* Install [Nginx reverse proxy](./nginx/) that proxies into ingresscontroller on a seperate node.
