## Introduction

In current sandbox implementation, we have several worker nodes available in ```mz``` and ```dmz``` cluster with hostnames ```mzworkerX.sb``` or ```dmzworkerX.sb```. In production if we need to add more workers nodes without any down-time of these pre-installed clusters, then we need to follow this guide step-by-step: 
## Procedure

To add a new worker node on the pre-running cluster either be ```mzcluster``` or ```dmzcluster```:
- Create a new VM which is reachable from ```console.sb```.
- Establish ssh passwordless connection with new VM's using ssh-copy-id command. 
- Add VM in mzworkers or dmzworkers group in ```hosts.ini```.
- Run ```console.yaml``` and ```coredns.yaml``` in order to install packages and coredns stuffs.
- Run correspondig cluster playbook: ```mzcluster.yaml``` or ```dmzcluster.yaml```.
- Run ```nfs.yaml``` in order to install nfs client on the new node.

### Note:
- Try adding ```--ignore-preflight-errors = all``` in ```roles/k8cluster/kubernetes/node/tasks/join.yml``` to avoid pre-flight checks which might inhibit this process.
- Make sure you have latest token from master node corresponding to cluster.


## Troubleshooting:

If you face error in joining the cluster due to missing jwt token please check the master node if any token is present or not. If not follow the instructions given next :

Command to check Jwt token on master node
- kubeadm token list

Steps to add the node to the cluster if above error is there...
- ```sudo kubeadm --v=5 token create --print-join-command``` this will create a jwt token and update cluster-info.yaml and prints the join command which is needed to be executed in the new nodes.
- Now execute the join command from the result of the above command in the new nodes to join it into the cluster. for eg. ```kubeadm join 172.16.26.136:6443 --token 0l27fp.tegcha916hiwn4lv --discovery-token-ca-cert-hash sha256:058073bb05c1d15ec802288c815e2f1d5fa12f912e6e7da9086f4b7c2e2aa850```
