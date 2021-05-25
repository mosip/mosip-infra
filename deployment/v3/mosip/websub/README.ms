# Websub

## Install
* Create namespace
```
$ kubectl create namespace websub
```
* Copy postgres secret
```
$ ./copy_secrets.sh
```
* Review `values.yaml` esp for postgres hostname
