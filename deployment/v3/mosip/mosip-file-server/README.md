# mosip-file-server

## Introduction
The chart here installs a mosip-file-server accessed over an https URL.

## Install
* Mosip-file-server contains certs, json which will be used by partners to integrate with MOSIP services.
* To install mosip-file-server.
```sh
./install.sh
```
## Restart
* To restart mosip-file-server.
```sh
./restart.sh
```
## Delete
* To delete mosip-file-server.
```sh
./delete.sh
```
## URL
* The URL will be available at https://api-host.
  Example:
    * https://api.sandbox.xyz.net/.well-known/
    * https://api.sandbox.xyz.net/inji/
    * https://api.sandbox.xyz.net/mosip-certs/