# Minio

## Install
* Update `hostname` in `values.yaml`.  The hostname must point to external load balancer of the cluster. 
* Install using helm
```
$ kubectl create ns minio
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm -n minio install minio bitnami/minio -f values.yaml
```
## Web UI
Web UI may be accessed as `https://<hostname>/minio`.  Provide Access Key and Secret Key.  The same maybe obtained by running the following:
```
$ ./get_pwd.sh
```

