# MOSIP cluster using Rancher on-premise  

## Rancher k8s cluster
### Cluster
* Set up VMs with Rancher OS
* Create K8s cluster for MOSIP modules at least 5 worker nodes using Rancher's `rke` utility.
* Use default Canal networking model
* Keep the Pod Security Policies disabled.

### Persistence
* Install Longhorn
* Install backup scripts 
* Ensure that restoration works even if you dismantle current cluster and install Longhorn again

### Loadbalancer
* Provision one VM for Nginx. Or multiple VMs for high avaiability like Nginx Plus.
* The machine should be external facing with public ip and DNS like `api.xyz.mosip.net`.  
* Make sure you have SSL certificate for the above domain such that HTTPS is enabled. 
* Install Nginx which will serve as Loadbalancer.  
* TLS termination will happen here.  The traffic will be forward to cluster ingress over HTTP.
 
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

## Wireguard
To protect the inter node communication in a cluster, you may install  Wireguard on each machine before installing the cluster.

* Install machines as given in this [article](https://vitobotta.com/2019/07/17/kubernetes-wireguard-vpn-rancheros/)
* Each `wg0.conf` would look something like this. This is an example of 3 node cluster:
```
[Interface]
Address = 172.16.4.1
PrivateKey = <private key>
ListenPort = 51820

[Peer]
PublicKey = <public key>
Endpoint = 10.6.1.10:51820
AllowedIPs = 172.16.4.2

[Peer]
PublicKey = <public key>
Endpoint = 10.6.1.11:51820
AllowedIPs = 172.16.4.3
```
The `Address` and `AllowedIPs` are the Wireguard network address (arbitrarily chosen, but should not clash with any other network).
* Use Canal networking model for Rancher RKE cluster install. 
* Give `internal_address: ` in `cluster.yml` as Wireguard address.

