## Introduction
Kilo is a multi-cloud network overlay built on ```WireGuard``` and designed for Kubernetes. Kilo's design allows clients to VPN to a cluster in order to securely access services running on the cluster.  
Kilo uses WireGuard, a performant and secure VPN, to create a mesh between the different nodes in a cluster. The Kilo agent (```kg```), runs on every node in the cluster, setting up the public and private keys for the VPN as well as the necessary rules to route packets between locations.  
Kilo can operate both as a complete, independent networking provider as well as an add-on complimenting the cluster-networking solution currently installed on a cluster. This means that if a cluster uses, for example, ```Flannel``` for networking, Kilo can be installed on top to enable pools of nodes in different locations to join. Kilo will take care of the network between locations, while Flannel will take care of the network within locations.

## Installation
### Pre-requisites:
1. **Kubernetes Cluster**: We recommend installing cluster using ```kubeadm``` for this doc, other alternatives may be used.
2. **WireGuard**: WireGuard must be installed on every node of cluster to provide a network interface in order to facilitate kilo agent on the nodes. WireGuard mesh can be established between nodes using server-client config from [here](https://github.com/mosip/mosip-infra/blob/1.1.3/deployment/sandbox-v2/docs/wireguard.md). 
3. **UDP port**: Nodes in the mesh will communicate with each other using an open UDP port. By default, this port should be one which was used in WireGuard i.e. 51820.
4. **Annotation**: By default, Kilo creates a mesh between the different logical locations in the cluster, e.g. data-centers, cloud providers, etc. For this, Kilo needs to know which groups of nodes are in each location. If the cluster does not automatically set the [topology.kubernetes.io/region](https://kubernetes.io/docs/reference/kubernetes-api/labels-annotations-taints/#topologykubernetesioregion) node label, then the [kilo.squat.ai/location](https://github.com/squat/kilo/blob/main/docs/annotations.md#location) annotation can be used. For more details, see [here](https://github.com/squat/kilo/blob/main/docs/topology.md).

### Procedure:
1. Kilo can be installed by deploying a DaemonSet to the cluster.
	- To run Kilo on kubeadm:
		```
		$ kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/kilo-kubeadm.yaml
		```
	- To run Kilo on bootkube:
		```
		$ kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/kilo-bootkube.yaml
		```
	- To run Kilo on k3s:  
		```
		$ kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/kilo-k3s.yaml
		```
2. Administrators of existing clusters who do not want to swap out the existing networking solution can run Kilo in `add-on` mode. In this mode, Kilo will add advanced features to the cluster, such as VPN and multi-cluster services, while delegating CNI management and local networking to the cluster's current networking provider. Kilo currently supports running on top of Flannel.
For example, to run Kilo on a kubeadm cluster running Flannel (sandbox-v2):  
	```
	$ kubectl apply -f https://raw.githubusercontent.com/squat/kilo/master/manifests/kilo-kubeadm-flannel.yaml
	```  
	You may install manifests for other configurations from [manifests directory](https://github.com/squat/kilo/tree/main/manifests).  
	
**Note**: After these commands, you should be able to see the kilo pods/kilo agents running on every node your cluster by a daemonset named ```kilo``` in kube-system namespace.  

3. Kilo also enables peers outside of a Kubernetes cluster to connect to the VPN, allowing cluster applications to securely access external services and permitting developers and support to securely debug cluster resources. In order to declare a peer, start by defining a Kilo peer resource:
	```
	$ cat <<'EOF' | kubectl apply -f -
	apiVersion: kilo.squat.ai/v1alpha1
	kind: Peer
	metadata:
	 name: squat
	spec:
	 allowedIPs:
	 - <allowed-ips-for-peer> e.g 10.5.0.1/32
	 publicKey: <public-key-of-peer>
	 persistentKeepalive: 10
	EOF
	```

	This configuration can then be applied to a local WireGuard interface, e.g.  `wg0`, to give it access to the cluster with the help of the  `kgctl`  tool:
	```
	$ kgctl showconf peer squat > peer.ini
	$ sudo wg setconf wg0 peer.ini
	```

**Note**: 
- ```kgctl``` tool doesn't come pre-installed with kilo, you need to build it seperately. You can install it from [here](https://github.com/squat/kilo/blob/main/docs/kgctl.md#installation). 
- To verify that traffic is being sent over the WireGuard connection, you may open a session on one of the desired nodes, eg via SSH, and type  ```sudo wg kilo0```. This will show the statistics for the WireGuard interface on that node. You should see that the received and transmitted bytes are non-zero. If you want to convince yourself that traffic is being encrypted for a specific packet, you can use any packet tracing utility, e.g. ```tcpdump```, to verify that each packet destined for a node in another Kilo location results in a corresponding packet over the kilo0 interface.
- Not all traffic in a cluster is encrypted; to understand when Kilo encrypts traffic, consider reading the topology doc: [https://github.com/squat/kilo/blob/main/docs/topology.md](https://github.com/squat/kilo/blob/main/docs/topology.md).
