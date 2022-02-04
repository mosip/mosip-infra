# On-prem Cluster Setup

## Overview
This is a guide to set up on-prem Kubernetes cluster that will host all the MOSIP modules.

![Architecture](../../docs/images/deployment_architecture.png)


### 1. Prerequisites
- Following requirements to be met:
  - [Hardware requirements](./requirements.md#Hardware-requirements).
  - [Network configuration requirements](./requirements.md#Network-configuration).
  - [Certificate requirements](./requirements.md#Certificate-requirements).
- [Rancher](../../rancher) installed.
- Install following command line utilities:
  - `kubectl`
  - `helm`
  - `rke`
  - `istioctl`
- Add the following Helm repos:
  ```sh
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo add mosip https://mosip.github.io/mosip-helm
  ```

### 2. Cluster setup
* Set up VMs.
* Create K8s cluster, using `rke` utility. Using [this](../../docs/rke-setup.md).

### 3. Istio for service discovery and ingress
* Go to [v3/cluster/on-prem/istio](./istio/).
* Edit the `install.sh` and `iop.yaml` accordingly and install it.
  ```
  KUBECONFIG="$HOME/.kube/mosip_cluster.config"
  ./install.sh
  ```
* This will bring up all istio components and the ingress-gateways.
* Check inressgateway services using;
  ```
  kubectl get svc -n istio-system
  ```

### 4. Global configmap

* Copy `../global_configmap.yaml.sample` to `../global_configmap.yaml`  
* Update the domain names in `../global_configmap.yaml` and run
```
kubectl apply -f ../global_configmap.yaml
```

### 5. Nginx loadbalancer + Wireguard bastion setup

* Use [this](./nginx_wireguard/) to install nginx on an external node that proxies traffic to the above loadbalancers.
* The above will also setup wireguard on the nginx node.

### 6. Domain name mapping
* Point your domain names to respective public IP or internal ip of the nginx node.

### 7. Httpbin
Install `httpbin` for testing the wiring as given [here](../../utils/httpbin/README.md)

### 8. Register the cluster with Rancher
* This section is for integrating the newly created mosip cluster with rancher.
* Assuming a rancher cluster, open that dashboard. Click on add cluster on top right.
* Add members, atleast one as Owner.
* In the cluster type selection screen, at the top, there is an option to "import any other kubernetes cluster", select that.
* That should give two commands to run on the new cluster (the mosip cluster). After running those, the new cluster should be integrated into Rancher.

### 9. Longhorn for persistence

* Install Longhorn as given [here](../longhorn/README.md)
