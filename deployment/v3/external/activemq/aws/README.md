# Activemq Artemis

## Introduction
Activemq Artemis is insalled using helm chart that has been slightly modified from the [original](https://github.com/vromero/activemq-artemis-helm).  Activemq Artemis runs in master-slave configuration with failover and failback features.  Persistence is enabled by default.  On AWS an internal load balancer (LB) is spawned as per settings in `values.yaml`.  The LB's address may be used by ABIS to connect to broker on port 61616.

For web console, enable access via MOSIP external facing LB via ingress.  See ingress settings in `values.yaml`

## Domain name
Create a sub-domain like `activemq.your-domain.com` and point it to *internal* load balancer. Access to activemq should NOT be opened to public. It is assumed that the sub-domain and hosts have been defined in global configmap as given [here](../../../cluster/global_configmap.yaml.sample)  

## Install
* Update `values.yaml`.  Make sure `ingress.hosts` points to a sub-domain that you have created in the above step.
* Install
```
$ helm repo add mosip https://mosip.github.io/mosip-helm
$ helm repo update
$ helm -n activemq install activemq mosip/activemq-artemis -f values.yaml
```
## Web console
* Console url: `https://activemq.your-domain.com`
* Default username: `artemis`
* Password:  Run `get_pwd.sh`

## ABIS connection to broker
ABIS must connect to internal LB address (or `activemq.your-domain.com`) over port 61616.

## CLI
Activemq command line utility may be downloaded from [here](https://activemq.apache.org/components/artemis/download/).  Note that since Activemq port 61616 is not accessible externally, you must run the same from a machine that has access to internal load balancer.
