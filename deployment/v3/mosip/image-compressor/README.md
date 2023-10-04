# imagecompressor Service

## Introduction
Details about this service are given [here](https://github.com/mosip/mosip-ref-impl/tree/develop/imagecompressor-services)

The service expects **imagecompressor library** typically provided by a vendor.  Host the library at a location that can be downloaded from within cluster with a URL. The default installation imagecompressor service contains imagecompressorfor testing the interfaces.

## Prerequisites
To run this imagecompressor service, you will need to first run the [artifactory](../../mosip/artifactory/README.md) which contains the image compressor library.

## Install
* Update `values.yaml` with your imagecompressor zipped library url and classpath. 
* Install
```sh
./install.sh
``` 

