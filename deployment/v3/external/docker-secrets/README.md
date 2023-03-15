# Docker secrets

## Overview
* You need these only if you are accessing Private Docker Registries. Skip if all your dockers are downloaded from public Docker Hub. 
* All MOSIP services docker images in default charts are in  public. However, if you have your dockers in private Docker registries create secrets for all such registries.

## Prerequisites
* You will need below mentioned inputs for all the private registries you will be pulling image from:
1. DOCKER_REGISTRY_URL - URL for the docker registry.
1. USERNAME: Usename of the docker registry.
1. PASSWORD: Password of the docker regisry. You may provide access token instead of password.
1. EMAIL: Email of the docker registry.

## Install
Run install script to create docker secrets for all the private registries to be used. 
```sh
./install.sh [kubeconfig]
```



