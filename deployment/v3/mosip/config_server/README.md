# Config server

## Introduction
Config server serves all properties required by MOSIP modules. This must be installed before any other MOSIP modules.

## Install
* Review `values.yaml` and make sure gitrepo parameters are as per your installation.
* Update IAM kubeconfig file in `copy_cm.sh` and `copy_secrets.sh`
* Install
```sh
./install.sh
```


  

