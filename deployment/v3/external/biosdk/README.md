# Biosdk-services

* Biosdk-service is assumed to be installed outside module cluster and Configuration for the same needs to be updated there in modular configuration.
* For development and testing, MOSIP provides biosdk service. See [Biosdk](../../mosip/biosdk/README.md).

## Introduction
* [Overview](https://github.com/mosip/mosip-ref-impl/tree/develop/biosdk-services).
* The service expects `biosdk library` typically provided by a vendor.
* Host the library at a location that can be downloaded from within cluster with a URL.
* The default installation biosdk service contains mock SDK for testing the interfaces.

## Prerequisites
To run this BioSDK service, you will need to first run the [artifactory](../../mosip/artifactory/README.md) which contains the mock SDK library.

## Install
The same will be installed as part of MOSIP services as [biosdk service](../../mosip/biosdk).
