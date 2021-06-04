# Biosdk Service

## Introduction
Details about this service are given [here](https://github.com/mosip/mosip-ref-impl/tree/develop/biosdk-services)

The service expects biosdk library typically provided by a vendor.  Host the library URL at a location that can be downloaded from within cluster (or your installation location of biosdk service, which could be outside the cluster as well). The default installation contains mock SDK.

## Install
* Update `values.yaml` with your biosdk zipped library url and classpath. 
* Create namespace
```
$ kubectl create namespace biosdk
```
* Install with helm
```
$ helm repo update
$ helm -n biosdk install biosdk-service mosip/biosdk-service
``` 

