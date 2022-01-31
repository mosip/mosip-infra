# MOSIP cluster Setup on-premise

![Architecture](../../docs/images/deployment_architecture.png)

Before getting started be aware of your infrastructure architecture. In the above architecture it is assumed that, the landing-zone node(for ssh into the other nodes, etc), the external nginx node, and the wireguard bastion node, all three are clubbed together. But during production, one might choose to use nginx plus cluster, or one might choose not have any landing zone for ssh, or etc, and in those cases the procedure has to change accordingly.

### 1. Prerequisites

- Refer to [this](./requirements.md) for the requirements or prerequisites before getting started.
- For setting up a rancher cluster, refer to [this](../../rancher) (This cluster is not used for/by mosip components but can be used to manage rest of the clusters in the organization).

### 2. Cluster Setup
* Set up VMs.
* [Optional] Install Wireguard each cluster node (wireguard-mesh) as given [here](wireguard-mesh/README.md). In this case, give `internal_address: <wireguard address>` in `rke config`.
* Create K8s cluster, using `rke` utility. Using [this](../../docs/rke-setup.md).

### 3. Metallb Setup for Loadbalancer

Metallb is suitable for baremetal installations and requires specific network configurations (like Routers to have BGP protocol enabled). If you you have virtual machines in your on-prem infra, you may skip installing Metallb, but instead use Nginx as loadbalancer directly talking to Istio ingress services in Nodeport mode.  Of course, the node ports have to be manually enabled on the nodes as well as Nginx.

If you would like to install Metallb, check the instructions [here](./metallb/)

### 4. Istio for Service Discovery and Ingress

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

### 5. Global configmap

* Copy `../global_configmap.yaml.sample` to `../global_configmap.yaml`  
* Update the domain names in `../global_configmap.yaml` and run
```
kubectl apply -f ../global_configmap.yaml
```

### 6. Nginx Loadbalancer + Wireguard Bastion Setup

* Use [this](./nginx/) to install nginx on an external node that proxies traffic to the above loadbalancers.
* The above will also setup wireguard on the nginx node.

### 7. Rancher Integration
* This section is for integrating the newly created mosip cluster with rancher.
* Assuming a rancher cluster, open that dashboard. Click on add cluster on top right.
* Add members, atleast one as Owner.
* In the cluster type selection screen, at the top, there is an option to "import any other kubernetes cluster", select that.
* That should give two commands to run on the new cluster (the mosip cluster). After running those, the new cluster should be integrated into Rancher.

### 8. Longhorn for Persistence

* Install Longhorn as given [here](../longhorn/README.md)
