# On-prem Kubernetes Cluster for Rancher

##  Prerequisites
* [Hardware, network, certificate requirements](./requirements.md).
* TLS termination: you may terminate TLS in any of the following ways:
  * Directly on Rancher service
  * On ingress controller
  * On a reverse proxy before the ingress controller
* We have configured tls to terminate on the reverse proxy / loadbalancer, as default in our configuration.

## Cluster Setup
* Set up VMs.
* Create K8s cluster, using `rke` utility. Using [this](../../docs/rke-setup.md).

## Nginx Ingress Controller
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

##  Nginx Loadbalancer / Reverse Proxy + Wireguard Bastion Host
* Install [nginx reverse proxy](./nginx/) that proxies into ingresscontroller on a seperate node.
