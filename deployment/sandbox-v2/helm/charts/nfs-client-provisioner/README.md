The NFS provisioner provides dynamic storage using PVC (Persistent Volume Claim).  This is dynamic provisioning where we do not have to create a Persistent Volume (PV).  Few things to note:
1. A PV is created with a unique name for corresponding PVC.  The same can be seen in the NFS folder on console.
1. If a Statefulset is used, and we delete the same using Helm, the PVC will not get deleted.  Hence we restart the Stateful set again, the same storage will be used.  (See Elasticsearch Statefulset as an example).
1. If these dynamic PVCs and PVs are manually deleted, then of course, new PVs will get created for the same PVCs.
1. Remember PV and PVC has 1:1 relationshiop in Kubernetes.
