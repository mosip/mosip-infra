# Persistence

## Introduction
The document here describes the behaviour of persistence and storage class on EKS vis-a-vis Deployment and Statefulset.

## Deployment, gp2 storage class
* Storage class: `gp2`
* Default "delete" (not retain) 
* Mount PVC on a deployment
* PV and PVC are created
* `helm delete` deletes PVC and PV. 

## Deployment, gp2-retain storage class
* Storage class: `gp2-retain`
* Default "retain" (not delete)
* Mount PVC on a deployment
* PV and PVC are created with randome UID
* `helm delete` deletes PVC but not PV.
* You can see the PV volume in AWS console -> Volumes
* `kc delete  pv <pv name>` deletes from Kubernetes but volume is still retained in AWS
* Delete the same manually using AWS console.

## Statefulset, gp2 storage class
* Storage class: `gp2`
* Default "delete" (not retain) 
* Mount PVC on a statefulset
* PV and PVC are created
* `helm delete` DOES not delete both PVC and PV
* When you re-install helm chart, same PVC and PV are preserved.
* If you delete PVC, PV is also deleted.

In case of `gp2-retain`, deleting PVC does not delete PV, however, PV cannot be bound again. There are some work arounds to use bind the same given [here](https://github.com/kubernetes/kubernetes/issues/48609#issuecomment-314066616)
