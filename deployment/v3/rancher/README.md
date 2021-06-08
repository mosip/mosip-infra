# Rancher Management Server 

## Introduction
Rancher may be used to manage all your clusters.  Typically, you would need just one installation per organisation. 
Install Rancher before you install your clusters.  While Rancher may be installed native, or just using Docker on any VM, for high availability and management, we recommend installing on a Kubernetes cluster dedicated to Rancher.  

## Rancher install
* Follow the instructions here
https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/

* Run below command to finally install Rancher:
    ```
    helm install rancher rancher-latest/rancher  --namespace cattle-system  --set hostname=rancher.mosip.net --set ingress.tls.source=letsEncrypt  --set letsEncrypt.email=info@mosip.io --set replicas=1
    ```
* Set replicas in above command to number of nodes in your Rancher cluster

## Register clusters with Rancher
* Login as admin in Rancher console 
* Configure your cloud credentials
* Add the clusters created on cloud.  
* Make sure the correct zone is selected to be able to see the clusters.

  
