# Highly Available multi-master cluster using kubeadm

## Introduction

Current sandbox installs a cluster of worker nodes along with one master node only using kubeadm tool provided by kubernetes. But in production, if master node is prone to failure then we would be required to have more than one master nodes to serve API server requests without any failure. The guide here explains the steps to install a multi-master node cluster using Kubeadm tool. All masters will be running individual etcd servers. Kubeadm documentation propose two main ways of cluster implementation, with stacked and external Etcd topology. ([Read here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/))  
We will be using stacked-etcd cluster due to the reason of less complexity and simpler to manage for replication.

## HA- Master Architecture

![](https://d33wubrfki0l68.cloudfront.net/d1411cded83856552f37911eb4522d9887ca4e83/b94b2/images/kubeadm/kubeadm-ha-topology-stacked-etcd.svg)

## Prerequisites

- Load-balancer - 1 node - for load balancing and routing requests to master nodes(loadbalancer.sb).  
- masters - 3 nodes - for serving kubernetes API server requests(mzmaster.sb, mzmaster1.sb, and mzmaster2.sb).    
- worker nodes - as per requirement.  

## Abbreviations

- LB: Loadbalancer.sb
- m0: mzmaster.sb 
- m1: mzmaster1.sb
- m2: mzmaster2.sb

## Procedure

1. ssh to LB from console.sb with root privileges:  
	> $ ssh root@LB  
2. Check if all machines are reachable or not:  
         ```
		$ for i in m0 m1 m2 LB  
		do  
		ssh $i hostname  
		done  
         ```  
	
3. Install a cloud-based TCP load balancer: (keep-alived / haproxy / kube-vip) (ref : [here](https://github.com/kubernetes/kubeadm/blob/master/docs/ha-considerations.md))  
   We will be using use haproxy here.  
	> $ yum install haproxy -y

4. Configure haproxy for load-balancing with front-end and back-end servers:  
	- Add below lines in /etc/haproxy/haproxy.config:  
		 ```
		 frontend fe-apiserver  
		    bind 0.0.0.0:6443  
	  	    mode tcp  
   	   	    option tcplog  
   	   	    default_backend be-apiserver  
		    backend be-apiserver  
		       mode tcp  
		       option tcplog  
		       option tcp-check  
		       balance roundrobin  
		       default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100  

		           server mzmaster.sb 10.20.20.99:6443 check fall 3 rise 2
		           server mzmaster1.sb 10.20.20.98:6443 check fall 3 rise 2
		           server mzmaster2.sb 10.20.20.97:6443 check fall 3 rise 2  
		 ```    

	- Restart haproxy and check status:  
		> $ systemctl restart haproxy  
		> $ systemctl status haproxy (Ensure haproxy is in running status)  
	- Run netcat command to ensure 6443 port:  
		> $ nc -v localhost 6443  

5. ssh to m0/m1/m2 (anyone) with root privileges.  
6. Initialize a control-plane uisng kubeadm init:  
	- > $ kubeadm init --control-plane-endpoint "loadbalancer.sb:6443" --upload-certs --pod-network-cidr=192.168.0.0/16  
	- > 192.168.0.0/16 is default pod-network-cidr used in calico (will be using calico as an overlay nettwork)  
	- Save the output of above command producing three things:
	  - To start using your cluster, you need to run the following as a regular user:  
	  ```  
		  mkdir -p $HOME/.kube  
		  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
		  sudo chown $(id -u):$(id -g) $HOME/.kube/config
	  ```
	  - You can join any number of the control-plane node running the following command on each as root:  
		  > kubeadm join loadbalancer.sb:6443 --token qqutq7.uvzkw5zpjxow17tk \  
    			--discovery-token-ca-cert-hash   sha256:1cfc9754212d1769e92d661dcd86298a1897e328e094efd6a447aa7ca24f9743 \  
    			--control-plane --certificate-key 09cf0f81917a17aa97bf1a7290eb97d70faeacd61e3cbcd9405de5d3472f4aae  
	  - You can join any number of worker nodes by running the following on each as root:  
		  > kubeadm join loadbalancer.sb:6443 --token qqutq7.uvzkw5zpjxow17tk \  
    			--discovery-token-ca-cert-hash   sha256:1cfc9754212d1769e92d661dcd86298a1897e328e094efd6a447aa7ca24f9743  
	- Copy admin.conf to kube directory on this node.  

7. ssh to m1 and m2 with root privilages:  
	- Intialize node as control plane.  
	- Join node to control plane cluster using 6.b command.  
	- Copy admin.conf to kube directory on this node.  

8. ssh to LB with root privileges:  
	- Run below command to copy kubeconfig file from any master (let's take m0):  
		> $ scp m0: /etc/kubernetes/admin.conf $HOME/.kube/config  
	- Run kubectl commands to check nodes.  
		> $ kubectl get nodes ( all will be in not-ready state due to lack of an overlay network).  
	- Deploy an overlay network (calico here):  
		> $ kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml  
	- Again check nodes.  

9. Login into console.sb as mosipuser:  
	- Create kube directory.  
	- Copy kubeconfig file from loadbalancer to console:  
		> $ scp LB: ~/.kube/config ~/.kube/mzcluster.config  
	- Check active nodes and pods:  
		> $ kc1 get nodes  
		> $ kc1 get pods -n kube-system
