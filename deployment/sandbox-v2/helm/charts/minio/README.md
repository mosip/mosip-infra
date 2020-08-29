Some modifications have been made to the original minio code:

* Pv, pvc added to connect to NFS
* Ingress changed

Init:

Delete .minio.sys on nfs persistence storage if you want to change credentials. TODO: Explore method to change credentials.  Some discussion here: https://docs.min.io/docs/minio-server-configuration-guide.html
