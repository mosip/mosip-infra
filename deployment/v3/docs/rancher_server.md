# Guide to install Rancher Server K8s cluster

## Prerequisites

* Make sure one or more nodes loaded with RancherOS are available
* You have a Linux/MacOS machine to run the install that has connectivity to the above nodes.


## Cluster
* Create a cluster using RKE
* This cluster has an ingress running on port 80 and 443 of all nodes.

## Domain name
* Point a subdomain like `rancher.mosip.net` to these nodes in load balancing mode.

## Rancher install
* Follow the instructions here
https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/

* Run below command to finally install Rancher:
    ```
    helm install rancher rancher-latest/rancher  --namespace cattle-system  --set hostname=rancher.mosip.net --set ingress.tls.source=letsEncrypt  --set letsEncrypt.email=info@mosip.io --set replicas=1
    ```
* Set replicas in above command to number of nodes in your Rancher cluster
