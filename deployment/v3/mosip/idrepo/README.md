# ID Repository

## Install
```
$ kubectl create namespace idrepo
$ ./copy_cm.sh
$ helm repo update
$ helm -n idrepo install identity mosip/identity
```
