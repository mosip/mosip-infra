## Introduction

In current sandbox implementation, we have several worker nodes available in ```mz``` and ```dmz``` cluster with hostnames ```mzworkerX.sb``` or ```dmzworkerX.sb```. In production if we need to add more workers nodes without any down-time of these pre-installed clusters, then we need to follow this guide step-by-step: 
## Procedure

To add a new worker node on the pre-running cluster either be ```mzcluster``` or ```dmzcluster```:
- Create a new VM which is reachable from ```console.sb```.
- Add VM in mzworkers or dmzworkers group in ```hosts.ini```.
- Run ```console.yaml``` and ```coredns.yaml``` in order to install packages and coredns stuffs.
- Run correspondig cluster playbook: ```mzcluster.yaml``` or ```dmzcluster.yaml```.

### Note:
- Try adding ```--ignore-preflight-errors = all``` in ```roles/k8cluster/kubernetes/node/tasks/join.yml``` to avoid pre-flight checks which might inhibit this process.
- Make sure you have latest token from master node corresponding to cluster.
