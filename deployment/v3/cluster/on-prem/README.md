# On-prem Cluster Setup

## Overview
This is a guide to set up on-prem Kubernetes cluster that will host all the MOSIP modules.

![Architecture](../../docs/images/deployment_architecture.png)


### 1. Prerequisites

- Requirements met as given [here](./requirements.md).
- [Rancher](../../rancher) installed.

### 2. Cluster setup
* Set up VMs.
* [Optional] Install Wireguard each cluster node (wireguard-mesh) as given [here](wireguard-mesh/README.md). In this case, give `internal_address: <wireguard address>` in `rke config`.
* Create K8s cluster, using `rke` utility. Using [this](../../docs/rke-setup.md).

### 3. Istio for service Discovery and ingress
* Go to [v3/cluster/on-prem/istio](./istio/).
* Edit the `install.sh` and `iop.yaml` accordingly and install it.
  ```
  KUBECONFIG="$HOME/.kube/mosip_cluster.config"
  ./install.sh
  ```
* This will bring up all istio components and the ingress-gateways.
* When using metallb, change the type of ingerssgateway service to loadbalancer in iop.yaml, so that metallb will provision loadbalancer ips for the ingressgateway service.
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

### 5. Nginx Loadbalancer + Wireguard Bastion Setup

* Use [this](./nginx_wireguard/) to install nginx on an external node that proxies traffic to the above loadbalancers.
* The above will also setup wireguard on the nginx node.

### 6. Rancher Integration
* This section is for integrating the newly created mosip cluster with rancher.
* Assuming a rancher cluster, open that dashboard. Click on add cluster on top right.
* Add members, atleast one as Owner.
* In the cluster type selection screen, at the top, there is an option to "import any other kubernetes cluster", select that.
* That should give two commands to run on the new cluster (the mosip cluster). After running those, the new cluster should be integrated into Rancher.

### 8. Longhorn for Persistence

* Install Longhorn as given [here](../longhorn/README.md)
