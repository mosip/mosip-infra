# Bqatsdk Service

## Introduction
Details about this service are given [here](https://github.com/mosip/mosip-ref-impl/tree/develop/bqat-sdk)

The service expects **bqatsdk library** typically provided by a vendor.  Host the library at a location that can be downloaded from within cluster with a URL. The default installation biosdk service contains mock SDK for testing the interfaces.

## Prerequisites
To run this BqatSDK service, you will need to first run the [artifactory](../../mosip/artifactory/README.md) which contains the mock SDK library.

## Install 
* Update `values.yaml` with your bqatsdk zipped library url and classpath.
* Install
```sh
./install.sh
``` 

