# MOSIP K8S Cluster Setup using RKE

## Overview
This is a guide to set up Kubernetes cluster on Virtual Machines using RKE. This cluster would host all MOSIP modules.

![Architecture](../../docs/images/deployment_architecture.png)

## Prerequisites
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
- [Hardware, network, certificate requirements](./requirements.md).
- [Rancher](../../rancher).
- Command line utilities:
  - `kubectl`
  - `helm`
  - `rke`
  - `istioctl`
- Helm repos:
  ```sh
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo add mosip https://mosip.github.io/mosip-helm
  ```
## Virtual machines
* Set up VMs.
* Set up [passwordless SSH](../../docs/ssh.md).
* Create copy of `hosts.ini.sample` as `hosts.ini`. Update the IP addresses.

## Wireguard bastion node
_If you already have a Wireguard bastion host then you may skip this step._

* Open required Wireguard ports.
```
ansible-playbook -i hosts.ini wireguard.yaml
```
* Install [Wireguard docker](../../docs/wireguard-bastion.md) with enough number of peers.
- Assign peer1 to yourself and set your Wireguard client before working on the cluster.

## Ports
* Open ports on each of the nodes.
```
ansible-playbook -i hosts.ini ports.yaml
```
* Disable swap _(perhaps not needed as swap is already disabled)_.
```
ansible-playbook -i hosts.ini swap.yaml
```

## Docker
Install docker on all nodes.
```
ansible-playbook -i hosts.ini docker.yaml
```

## RKE cluster setup
* Create a cluster config file. 
    ```
    rke config
    ```
    *  _controlplane, etcd, worker_: At least one of each. For high availability specify _controlplane_, _etc_ on at least two nodes. All notes may be _worker_.
    * Use default _canal_ networking model
    * Keep the _Pod Security Policies_ disabled.
    * Sample configuration options:
    ```
    [+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]:
    [+] Number of Hosts [1]:
    [+] SSH Address of host (1) [none]: <node1-ip>
    [+] SSH Port of host (1) [22]:
    [+] SSH Private Key Path of host (<node1-ip>) [none]:
    [-] You have entered empty SSH key path, trying fetch from SSH key parameter
    [+] SSH Private Key of host (<node1-ip>) [none]:
    [-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
    [+] SSH User of host (<node1-ip>) [ubuntu]:
    [+] Is host (<node1-ip>) a Control Plane host (y/n)? [y]: y
    [+] Is host (<node1-ip>) a Worker host (y/n)? [n]: y
    [+] Is host (<node1-ip>) an etcd host (y/n)? [n]: y
    [+] Override Hostname of host (<node1-ip>) [none]: node2
    [+] Internal IP of host (<node1-ip>) [none]:
    [+] Docker socket path on host (<node1-ip>) [/var/run/docker.sock]:
    [+] Network Plugin Type (flannel, calico, weave, canal) [canal]:
    [+] Authentication Strategy [x509]:
    [+] Authorization Mode (rbac, none) [rbac]:
    [+] Kubernetes Docker image [rancher/hyperkube:v1.17.17-rancher1]:
    [+] Cluster domain [cluster.local]:
    [+] Service Cluster IP Range [10.43.0.0/16]:
    [+] Enable PodSecurityPolicy [n]:
    [+] Cluster Network CIDR [10.42.0.0/16]:
    [+] Cluster DNS Service IP [10.43.0.10]:
    [+] Add addon manifest URLs or YAML files [no]:
    ```
* Remove the default Ingress install by editing `cluster.yaml`:
    ```
    ingress:
      provider: none
    ```
* For production deplopyments edit the `cluster.yml`, according to this [RKE Cluster Hardening Guide](./rke-cluster-hardening.md)

* Bring up the cluster:
```
rke up
```
* After successful creation of cluster a `kube_config_cluster.yaml` will get created. Copy the file to `$HOME/.kube` folder.
  ```
  cp kube_config_cluster.yml $HOME/.kube/<cluster_name>_config
  chmod 400 $HOME/.kube/<cluster_name>_config
  ```
* To set this file as global default for `kubectl`, make sure you have a copy of existing `$HOME/.kube/config`. 
```
cp  $HOME/.kube/<cluster_name>_config  $HOME/.kube/config
```
* Alternatively, set `KUBECOFIG` env variable:
```
KUBECONFIG="$HOME/.kube/<cluster_name>_config
```
* Test
```
kubect get nodes
```
## Global configmap
* `cd ../`
* Copy `global_configmap.yaml.sample` to `global_configmap.yaml`  
* Update the domain names in `global_configmap.yaml` and run
```sh
kubectl apply -f global_configmap.yaml
```
## Register the cluster with Rancher
* Login as admin in Rancher console
* Select `Import Existing` for cluster addition.
* Select the `Generic` as cluster type to add.
* Fill the `Cluster Name` field and select `Create`.
* You will get the kubecl commands to be executed in the kubernetes cluster
```
eg.
kubectl apply -f https://rancher.e2e.mosip.net/v3/import/pdmkx6b4xxtpcd699gzwdtt5bckwf4ctdgr7xkmmtwg8dfjk4hmbpk_c-m-db8kcj4r.yaml
```
* Wait for few seconds after executing the command for the cluster to get verified.
* Your cluster is now added to the rancher management server.

## Longhorn
* Install [Longhorn](../longhorn/README.md) for persistent storage.

## Istio for service discovery and Ingress
* `cd /istio/`
* Edit the `install.sh` and `iop.yaml` accordingly and install it.
  ```
  export KUBECONFIG="$HOME/.kube/<cluster_name>_config
  ./install.sh
  ```
* This will bring up all Istio components and the Ingress Gateways.
* Check Ingress Gateway services:
  ```
  kubectl get svc -n istio-system
  ```
## Nginx + Wireguard 
* Install [Nginx Reverse Proxy](./nginx/) on a seperate machine/VM, that proxies traffic to the above Ingress Gateways.
## DNS mapping
* Point your domain names to respective public IP or internal IP of the Nginx node. Refer to the [DNS Requirements](./requirements.md#DNS_requirements) document and your `global_configmap.yaml` to correlate the mappings.
## Metrics server
Although Prometheus runs it own metrics server to collect data, it is useful to install Kubernetes Metrics Server.  The same will enable `kubectl top` command and also some of the metrics in Rancher UI. Install as below:
```sh
helm -n kube-system install metrics-server bitnami/metrics-server
helm -n kube-system upgrade metrics-server bitnami/metrics-server  --set apiService.create=true
```
We have installed in `default` namespace.  You may choose any other namespace as per your deployment.

## Httpbin
* Install [`httpbin`](../../utils/httpbin/README.md) for testing the wiring.
