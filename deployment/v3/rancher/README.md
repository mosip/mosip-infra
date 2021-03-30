# Rancher Management Server 

## Introduction
Rancher may be used to manage all your clusters.  Typically, you would need just one installation per organisation. 
Install Rancher before you install your clusters.  While Rancher may be installed native, or just using Docker on any VM, for high availability and management, we recommend installing on a Kubernetes cluster dedicated to Rancher.  

## Rancher k8s cluster
### Cluster
Create K8s cluster dedicated to Rancher  with at least 1 worker node, on cloud or on-prem
  * AWS: Use `eksctl` command line tool to install cluster
  * On-prem: Install using `rke` tool 

### Ingress
* Install Nginx ingress controller and make sure the same is accessible from outside the cluster on a load balancer IP.
  * AWS: Any service exposed as LoadBalancer service automatically gets an external IP.
  * On-prem: Install Metallab on your worker nodes to obtain an external IP. 
* Use Bitnami nginx ingress controller Helm.

Obtain a domain name like `rancher.mosip.net` and point to the above ingress IP.

### Persistence
Make sure persistence is available on your cluster:
  * AWS: Storage class `gp2`
  * On-prem: Install Longhorn. 

TODO: Add instructions to persist Rancher server data

## Rancher install
* Follow the instructions here
https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/

* Run below command to finally install Rancher:
    ```
    helm install rancher rancher-latest/rancher  --namespace cattle-system  --set hostname=rancher.mosip.net --set ingress.tls.source=letsEncrypt  --set letsEncrypt.email=info@mosip.io --set replicas=1
    ```
* Set replicas in above command to number of nodes in your Rancher cluster

  
