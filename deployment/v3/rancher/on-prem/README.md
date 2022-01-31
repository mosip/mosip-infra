# On-prem Cluster for Rancher

### 1. Prerequisites
* For high availability, you would need at least 2 worker nodes.
* For external access you will need a public domain like `rancher.xyz.net` to point to this installation.
* TLS termination: you may terminate TLS in any of the following ways:
  * Directly on Rancher service
  * On ingress controller
  * On a reverse proxy before the ingress controller

### 2. Cluster Setup
* Set up VMs.
* [IMPORTANT] DON'T remove the default settings for ingress provider while configuring rke `cluster.yml`, because we want the default ingress controller to be installed.
* Create K8s cluster, using `rke` utility. Using [this](../../docs/rke-setup.md).

### 3. Nginx + Wireguard
* Follow [this](./nginx_wireguard/) to install nginx on a seperate node.

### 4. Install rancher
* Run below command to install all Rancher with external tls termination:
  ```
  helm install rancher rancher-latest/rancher  --namespace cattle-system  --set hostname=<your-rancher-domain> --set replicas=2 --set tls=external
  ```
* Set replicas in above command to number of nodes in your Rancher cluster or higher.
