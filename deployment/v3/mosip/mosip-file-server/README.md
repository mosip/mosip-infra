# Regclient 

## Introduction
The chart here installs a mosip-file-server accessed over an https URL. 

## Install
* Make sure global configmap contains the url for mosip-file-server host e.g. `fileserver.sandbox.xyz.net`.
* The url must point to your internal loadbalancer as regclient will typically not be open to public.
* Install
```sh
./install.sh
```
## Download
The download URL will be available at `https://your-fileserver-host`. Example: `https://fileserver.sandbox.xyz.net`.
