## EKS Cluster Delete Guide

Steps to delete EKS cluster cleanly along with all resources like persistent volumes, load balancers etc. are given below:   

* Check if all Persistent Volumes (PV) allocated to the cluster are in _Delete_ mode using below command:
```
kubectl get pv
```
* If any of the PV allocated is in _Retain_ mode just note the PV name so that the same can be deleted after EKS cluster deletion.
* Delete the Namespaces whose resources are using any of the PV's.
* Istio is in Loadbalancer mode from isto-system Namespace so the same also needed to be removed.
* We have identified the Namespaces using the PV and Loadbalancer. Use the below command delete the required Namespaces:
```
kubectl delete ns postgres kafka regproc cattle-logging-system keycloak activemq keymanager ida istio-system
```
* Verify if all the PV and Loadbalancers are deleted.
* Delete the PV's which were in retain mode from AWS console Volumes.
* Delete the EKS cluster using below command there.
```
eksctl delete cluster --name <cluster name>
```
Note: this may take around 30 mins.
* Once completed verify if the cluster is deleted from AWS console.

