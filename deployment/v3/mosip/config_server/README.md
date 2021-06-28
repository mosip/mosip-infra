# Config server

## Introduction
Config server serves all properties required for mosip modules.  This must be installed before any other mosip installations.

## Install
* Review `values.yaml` and make sure gitrepo parameters are as per your installation.
* Update IAM kubeconfig file in `copy_cm.sh` and `copy_secrets.sh`
* Install
```sh
./install.sh
```


  

