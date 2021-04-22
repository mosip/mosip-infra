# Mock ABIS

## Introduction
Unlike real ABIS we run mock abis inside the cluster itself.  The same connects to activemq via activemq's load balancer. 

## Install
* Create namespace
```
$ kubectl create ns abis
```
* Copy other configmaps
```
$ ./copy_cm.sh
```
* Install 
```
$ helm repo add mosip https://mosip.github.io/mosip-helm
$ helm repo update 
$ helm -n abis install mock-abis mosip/mock-abis 
```


  

