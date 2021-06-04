# Datashare

## Install
```
$ kubectl create namespace datashare
$ ./copy_cm.sh
$ helm repo update
$ helm -n datashare install identity mosip/datashare
```
