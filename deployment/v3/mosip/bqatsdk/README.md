# Bqatsdk Service

## Introduction
Details about this service are given [here](https://github.com/mosip/mosip-ref-impl/tree/develop/bqat-sdk)

The service expects **bqatsdk library** typically provided by a vendor.  Host the library at a location that can be downloaded from within cluster with a URL.

## Prerequisites
To run this BqatSDK service, you will need to provide URL that contains the Bqatsdk service library.

## Install 
* Update `values.yaml` with your bqatsdk zipped library url and classpath.
* Install
```sh
./install.sh
``` 

