# Softhsm

## Install
```
$ kubectl create namespace keymanager
$ helm repo udpate
$ helm -n keymanager install softhsm-kernel mosip/softhsm --set fullnameOverride=softhsm-kernel
```
If you are running IDA, you will need another instance of softhsm.  

```
$ helm -n keymanager install softhsm-ida mosip/softhsm --set fullnameOverride=softhsm-ida
```

## Defaults
* Replication factor is 1.  Multiple replication factors are not supported on AWS at the moment 'cause AWS EBS does not support `ReadWriteMany`.
* Keys are created in the mounted PV which gets mounted at `/softhsm/tokens` inside the container.
* Random PIN generated if not specified. Set `securityPIN` in `values.yaml`.



