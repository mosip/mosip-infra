# Activemq Artemis

## Introduction
Activemq Artemis is insalled using helm chart that has been slightly modified from the [original](https://github.com/vromero/activemq-artemis-helm).  Activemq Artemis runs in master-slave configuration with failover and failback features.  Persistence is enabled by default.  On AWS an internal load balancer (LB) is spawned as per settings in `values.yaml`.  The LB's address may be used by ABIS to connect to broker on port 61616.

For web console, enable access via MOSIP external facing LB via ingress.  See ingress settings in `values.yaml`

## Install
* Update `values.yaml`.  Make sure `ingress.hostName` is defined (see section below). 
* Install
```
$ helm repo add mosip https://mosip.github.io/mosip-helm
$ helm repo update
$ helm -n activemq install activemq mosip/activemq-artemis -f values.yaml
```
## Web console
To access web console from outside cluster define a domain name like "activemq.sandbox.xyz.net". Make sure this domain ppoints to the cluster external LB. 
* Console url: `https://<activemq domain name>`.  
* Default username: `artemis` 
* Password:  Run `get_pwd.sh` 

## ABIS connection to broker 
ABIS must connect to internal LB address over port 61616.
