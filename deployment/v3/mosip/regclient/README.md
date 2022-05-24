# Regclient 

## Introduction
The chart here installs a regclient downloader accessed over an http URL. 

## Prerequisites
* Make sure openssl package is installed in your machine.

## Install
* Make sure global configmap contains the url for regclient host e.g. `regclient.sandbox.xyz.net`.
* The url must point to your internal loadbalancer as regclient will typically not be open to public.
* Install
```sh
./install.sh
```
## Download
The download URL will be available at `https://your-reglient-host`. Example: `https://reglient.sandbox.xyz.net`.

## Set up of regclient
Follow the guide [here](https://github.com/mosip/registration-client/blob/develop/README.md)
