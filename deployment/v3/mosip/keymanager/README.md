# Keymanager

## Install
* Create `keymanager` namespace
```
$ kubectl create namespace keymanager
```
* Copy all config maps from other namespaces
```
$ ./copy_cm.sh
```
* Helm install
```
$ helm repo add mosip https://mosip.github.io/mosip-helm
$ helm repo update
$ helm -n keymanager install keymanager mosip/keymanager 
```
