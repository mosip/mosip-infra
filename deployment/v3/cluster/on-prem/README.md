# MOSIP cluster using Rancher on-premise  

## Rancher k8s cluster
### Cluster
* Set up VMs.
* Install Wireguard as given [here](wireguard/README.md)
* Create K8s cluster for MOSIP modules at least 5 worker nodes using Rancher's `rke` utility.
* Use default Canal networking model (if you are using Wireguard)
* Give `internal_address: <wireguard address>` in `cluster.yml`.
* Keep the Pod Security Policies disabled.

### Persistence
* Install Longhorn
* Install backup scripts 
* Ensure that restoration works even if you dismantle current cluster and install Longhorn again

### Loadbalancers
* Provision one VM for Nginx. Or multiple VMs for high avaiability like Nginx Plus.
* The machine should be external facing with public ip and DNS like `api.xyz.mosip.net`.  
* Make sure you have SSL certificate for the above domain such that HTTPS is enabled. 
* Install Nginx which will serve as Loadbalancer.  
* TLS termination will happen here.  The traffic will be forward to cluster ingress over HTTP.
* TODO: Add instsrutions for Internal LB.
 
## Metallb
Install metallb. Assign pool of IPs within the subnet and make sure appropriate routing and NAT is done for packet to reach the subnet where worker nodes are running.

## Ingress
* Remove default ingress controller installed by `rke`.
```
kc -n ingress-nginx delete all --all
```
* Install nginx ingress as
```
$ kubectl create namespace ingress-nginx
$ helm -n ingress-nginx install ingress-nginx ingress-nginx/ingress-nginx -f values.yaml
```
## TLS termination for Rancher
* Install cert-manager for Letsencrypt:
https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes

* Use Canal networking model for Rancher RKE cluster install. 

