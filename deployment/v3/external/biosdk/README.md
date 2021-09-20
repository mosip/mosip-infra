# Biosdk Service

## Introduction
Details about this service are given [here](https://github.com/mosip/mosip-ref-impl/tree/develop/biosdk-services)

The service expects **biosdk library** typically provided by a vendor.  Host the library at a location that can be downloaded from within cluster with a URL. The default installation biosdk service contains mock SDK for testing the interfaces.

## Prerequisites
To run this BioSDK service, you will need to first run the [artifactory](../../mosip/artifactory/README.md) which contains the mock SDK library.

## Install
* Update `values.yaml` with your biosdk zipped library url and classpath. 
* Install
```sh
./install.sh
``` 

