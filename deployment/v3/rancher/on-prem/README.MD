## On-prem Cluster for Rancher

* Create a dedicated k8s cluster. You would need at least 2 worker nodes for high availability. Create cluster on AWS as given [here](aws/README.md).  For on-prem clusters you will have to follow cluster installation as given [here](on-prem/README.md)
* Follow the instructions given [here](https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/) for Rancher related prerequisites.
* For external access you will need a public domain like `rancher.xyz.net` to point to this installation.
* A reference architecture which integrates rancher and IAM in same cluster is depicted as follows:
![](../docs/images/rancher_iam.png)  
* TLS termination: you may terminate TLS in any of the following ways:
  * Directly on Rancher service
  * On ingress controller
  * On a reverse proxy before the ingress controller

* Run below command to install all Rancher with tls termination on rancher itself, using letsencrypt certs:
    ```
    helm install rancher rancher-latest/rancher  --namespace cattle-system  --set hostname=<your-rancher-domain> --set ingress.tls.source=letsEncrypt  --set letsEncrypt.email=info@mosip.io --set replicas=2
    ```
* Set replicas in above command to number of nodes in your Rancher cluster or higher.
