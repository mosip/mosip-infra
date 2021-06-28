# Regclient 

## Introduction
The chart here installs a regclient downloader accessed over an http URL. 

## Install
* Make sure global configmap contains the url for regclient e.g. `regclient.sandbox.xyz.net`.
* The url must point to your internal loadbalancer as regclient will typically not be open to public.
* Install
```sh
./install.sh
```
## Download
The download URL will be displayed after the above script runs successfully. The url is of the form
`https://regclient.sandbox.xyz.net/registration-client/1.1.5.3-SNAPSHOT/reg-client.zip`.  The version number can be obtained by reading `regclient.version` parameter of the helm chart.
