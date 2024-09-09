# Config server

## Introduction
Config server serves all properties required by MOSIP modules. This must be installed before any other MOSIP modules.

## Pre-requisites
* `conf-secrets` MOSIP module.

## Install
* Review `values.yaml` and make sure git repository parameters are as per your installation.
* Install
```sh
./install.sh
```

## Delete
* To delete config-server.
```sh
./delete.sh
```

## Enable config-server to pull configurations from local git repository.

Enable Config-server to Pull Configurations from Local Repository:
* While running the install script the user will be prompted to decide whether the config-server should pull configurations from a local repository (NFS).
* If the user choose to use local git repository then the user will be asked to provide the NFS path(Dir where local repository is cloned) and the NFS server IP.
* If the user choose to not to pull configurations from a local repository (NFS) then the configurations will be pulled from remote repository which is defined in values.yaml file.   

Note: 
* Before choosing to pull configurations from a local repository (NFS) the user must clone the config-server repository manually into the nfs server where the configurations can be maintained.
* And checkout to the specific branch from where the configurations need to be taken.
