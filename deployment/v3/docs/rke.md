## Introduction
Rancher has provided an interesting tool: Rancher Kubernetes Engine (RKE) which solves the problem of installation complexity, a common issue in the Kubernetes community. With RKE, the installation and operation of Kubernetes is both simplified and easily automated, and it’s entirely independent of the operating system and platform you’re running. As long as you can run a supported version of Docker, you can deploy and run Kubernetes with RKE.  

## RKE Design
### RKE config  
The first building block of RKE is the configuration file definition which by-default is called ```cluster.yaml```. RKE config file can be generated using ```$ rke config``` command.  
The config file following sections:  
- **nodes**: address, port, role, user etc.
- **services**: etcd, kube-api, kube-controller, scheduler etc.
- **network**: flannel/calico/weave etc.  

There are additional sections to build other services up on the top of current config.  
### State file
RKE uses the config file to provision cluster, and keeps track of cluster status using a state file-```cluster.rkestate```. State file consists of two states:  
- **desired state**: state the cluster should be in.
- **current state**: actual state of the cluster.

Both desired and current state consists of: ```RKE config``` and ```Cluster Certficate Bundle```. Desired state is populated by RKE from ```cluster.yml``` file during the provisioning workflow.  
On each run, RKE tries to bring the cluster to match the ```desired state``` and then when it succeed, it writes the ```current state```.  
#### Note:
- Users should edit the ```cluster.yml``` to customize the cluster like adding nodes, roles, services etc.
- ```$ rke init``` command will update ```desired state``` with the new node's info.
- ```$ rke up``` command will add the new configurations. When finished, it'll update the ```current state```.  

## Nodes and Tunneling
Each node should have:  
- Docker installed and running
- SSH enabled

Each node config should have atleast following components:
- Address
- SSH user
- Role

RKE uses SSH tunneling to connect to the docker-socket on each node over an SSH connection. It may be ```RKE cli / RKE local / RKE dind``` tunneling depends on mode of RKE.   

## Services
RKE deploys kubernetes components as docker containers. Components are deployed according to the node's role.  Helper services of RKE tools(e.g. ```entrypoint.sh```) contain scripts that helps to install and deploy kubernetes services.
## Provisioning workflow
When you're running ```$ rke up```, it runs a sequence ```rke init -> rke up```.  
```rke``` uses two main functions : 
- ClusterInit( ) - Updates the desired state and writes a new ```cluster.rkestate``` file.
- ClusterUp( ) - Comparing the desired state and current state, add new config, deploy the cluster components on the nodes.

#### Note:
- ```$ rke up --init``` will convert cluster.yaml to state.DesiredState.
- ```$ rke up``` will convert state.DesiredState to state.CurrentState and reflects installation on nodes.
