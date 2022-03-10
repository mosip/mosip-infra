# MOSIP cluster on Amazon EKS

## Overview
The instructions here install an EKS cluster on AWS along with Network Loadbalancer and [Istio](https://istio.io/).  We have chosen cloud's Network Load Balancer (Layer 4) over Application Load Balancer (Layer 7) as we have application load balancing done by Istio Ingress running inside the cluster.

## Install Kubernetes cluster
### Prerequisites
* AWS account and credentials with permissions to create EKS cluster.
* AWS credentials in `~/.aws/` folder as given [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
* [Wireguard bastion host setup](../docs/wireguard-bastion.md).
* Copy of `~/.kube/config` file with another name. _(IMPORTANT. As in this process your existing `~/.kube/config` file will be overridden)._
* [`eksctl`](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) utility.
* `kubectl` utility installed.
* `helm`.
* Key `.pem` file from AWS console in `~/.ssh/` folder. (Generate a new one if you do not have this key file).
* [`aws-iam-authenticator`](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) installed.
* [Hardware, network, certificate requirements](./requirements.md). Compute Node requirements are already configured in `cluster.config.sample`.

### Install
* Copy `cluster.config.sample ` to `mosip.cluster.config`.  
* Review the parameters of `mosip.cluster.config` carefully.
* Install
```sh
eksctl create cluster -f mosip.cluster.config
```
* Note that it takes around 30 minutes to create (or delete a cluster).
* After creating cluster make a backup copy of `config` with a suitable name in `~/.kube/` folder, eg. `mosip_config` because if you create cluster again using `eksctl` it will override existing `~/.kube/config`. Set file permission to `chmod 400 ~/.kube/rancher_config` to avoid any accidental changes or deletion.

## Helm repositories
Add the following Helm repos:
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add mosip https://mosip.github.io/mosip-helm
```

## Global configmap
* `cd ../`
* Copy `global_configmap.yaml.sample` to `global_configmap.yaml`  
* Update the domain names in `global_configmap.yaml` and run
```sh
kubectl apply -f global_configmap.yaml
```
## Create using Rancher
You can also create cluster on Cloud using the Rancher console.  Refer to Rancher documentation.

## Register the cluster with Rancher
* Login as admin in Rancher console
* Configure your cloud credentials
* Add this cluster to Rancher  
* Make sure the correct zone is selected to be able to see the cluster on Rancher console.

## Persistence
### GP2
* Default storage class is `gp2` which by is in "Delete" mode which means if PV is deleted, the underlying storage is also deleted.  
* Create storage class `gp2-retain` by running `sc.yaml` for PV in Retain mode. Set the storage class as gp2-retain in case you ant to retain PV.  See some more details on persistence [here](../../docs/persistence.md).
```sh
kubectl apply -f sc.yaml
```
* If the PV gets deleted (say cluster was retarted), then you will have to define a PV connecting to this instance of storage (you will need volume ID etc). TODO: how to do this?

### LongHorn
Install LongHorn as given [here](../longhorn/README.md)

### EFS
EFS may not be necessary if you are using LongHorn + backup on S3. However, if needed you may install it as given [here](efs/README.md)

## Ingress and load balancer (LB)
Ingress is not installed by default on EKS. We use Istio ingress gateway controller to allow traffic in the cluster. Two channels are created - public and internal. See [architecture](../../docs/images/deployment_architecture.png).
* Install Istioctl as given [here](https://istio.io/latest/docs/ops/diagnostic-tools/istioctl/#install-hahahugoshortcode-s2-hbhb)
* Install ingresses as given here:
```sh
cd istio
./install.sh
```

### Load Balancers
The above steps will spin-off two load balancers on AWS. You may view them on AWS console.  These may be also seen with
```sh
kubectl -n istio-system get svc
```
* TLS termination is supposed to be on LB. So all our traffic coming to ingress controller shall be HTTP.
* Obtain AWS TLS certificate as given [here](https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html)
* Add the certificates and 443 access to the LB listener.
* Update listener TCP->443 to **TLS->443** and point to the certificate of domain name that belongs to your cluster.
* Forward TLS->443 listner traffic to target group that corresponds to listner on port 80 of respective Loadbalancers. This is because after TLS termination the protocol is HTTP so we must point LB to HTTP port of ingress controller.
* Update health check ports of LB target groups to node port corresponding to port 15021. You can see the node ports with
```sh
kubectl -n istio-system get svc
```
* Enable Proxy Protocol v2 on target groups.
* Make sure all subnets are included in Availabilty Zones for the LB.  Description --> Availability Zones --> Edit Subnets
* Make sure to delete the listenrs for port 80 and 15021 from each of the loadbalancers as we restrict unsecured port 80 access over http.

The reason for considering a LB for ingress is such that TLS termination can happen at the LB and packets can be inspected before sending to cluster ingress.  Thus ingress will receive plain text. On EKS, we will assume that the connection between Loadbalancer and cluster machines is secure (Wireguard cannot be installed on LB).

### Domain name
* Point your domain names to respective LB's public DNS/IP.
* On AWS this may be done on Route 53 console.  You will have to add a CNAME record if your LB has public DNS or an A record if IP address.

## Metrics server
Although Prometheus runs it own metrics server to collect data, it is useful to install Kubernetes Metrics Server.  The same will enable `kubectl top` command and also some of the metrics in Rancher UI. Install as below:
```sh
helm -n kube-system install metrics-server bitnami/metrics-server
helm -n kube-system upgrade metrics-server bitnami/metrics-server  --set apiService.create=true
```
We have installed in `default` namespace.  You may choose any other namespace as per your deployment.

## Httpbin
Install `httpbin` for testing the wiring as given [here](../../utils/httpbin/README.md)

## Log rotation
The default log max log file size set on EKS cluster is 10MB with max number of files as 10.  Refer to `/etc/docker/daemon.json` on any node.

## Increase/delete nodes
In Rancher console, under Edit Cluster, increase the Desired ASG size to the number of nodes you need.  Nodes should get created.

## Troubleshooting
* **TLS Handshake issue**: If while accessing resources you see error as mentioned [here](https://stackoverflow.com/questions/51302515/kubernetes-net-http-tls-handshake-timeout-when-fetching-logs-baremetal), then it could be due to node(s) not availability due to resource constraints (RAM, storage, compute).  Either add nodes or delete pods.
* **Unable to delete pod**: This could be due to the above issue.  Force delete.  Example:
```
kc -n logging delete pod --grace-period=0 --force elasticsearch-master-1
```
* "Bad Gateway" from ingress controller:  Could be due to enabling proxy protocol v2 but not running `istio/proxy_protoco.yaml`
