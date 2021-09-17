# Regclient 

## Introduction
The chart here installs a regclient downloader accessed over an http URL. 

## Install
* Make sure global configmap contains the url for regclient host e.g. `regclient.sandbox.xyz.net`.
* The url must point to your internal loadbalancer as regclient will typically not be open to public.
* Install
```sh
sh install.sh
```
## Download
The download URL will be available at `https://your-reglient-host`. Example: `https://reglient.sandbox.xyz.net`.
