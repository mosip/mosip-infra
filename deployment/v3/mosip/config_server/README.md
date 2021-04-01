# Config server

## Introduction
Config server serves all properties required for mosip modules.  This must be installed before any other mosip installations.

## Install
* Create namespace
```
$ kubectl create ns config-server
```
* Review values are update appropriately. `mosipApiHost` is required.  You may create your local `values.yaml`.

* Install 
```
$ helm repo add mosip https://mosip.github.io/mosip-helm
$ helm repo update 
$ helm -n config-server install config-server config-server  -f <your_updated_values_file>
```


  

