# Rancher Management Server 

## Introduction
Rancher may be used to manage all your clusters.  Typically, you would need just one installation per organisation. 
Install Rancher before you install your clusters.  While Rancher may be installed native, or just using Docker on any VM, for high availability and management, we recommend installing on a Kubernetes cluster dedicated to Rancher.  Here, we provide instructions for running Rancher on a k8s cluster.

## Rancher install on k8s
* Create a dedicated k8s cluster (which may be also used to install IAM (../IAM/README.md).  You would need at least 2 worker nodes for high availability. 
* Follow the instructions here
https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/
* For external access you will need a public domain like `rancher.xyz.net` to point to this installation. 
* Install [Nginx Ingress Controller)[(https://kubernetes.github.io/ingress-nginx/deploy/)
* TLS termination: you may terminate TLS in any of the following ways:
  * Directly on Rancher service
  * On ingress controller
  * On a reverse proxy before the ingress controller

* Run below command to finally install Rancher:
    ```
    helm install rancher rancher-latest/rancher  --namespace cattle-system  --set hostname=<your-rancher-domain> --set ingress.tls.source=letsEncrypt  --set letsEncrypt.email=info@mosip.io --set replicas=2
    ```
* Set replicas in above command to number of nodes in your Rancher cluster or higher.

## Register clusters with Rancher
* Login as admin in Rancher console 
* Configure your cloud credentials
* Add the clusters created on cloud.  
* Make sure the correct zone is selected to be able to see the clusters.

  
