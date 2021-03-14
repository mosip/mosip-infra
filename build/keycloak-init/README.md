# Keycloak Init

## Context

After Keycloak is installed, it needs to be populated with base data that is needed for MOSIP.  The script and docker created here provide this function.  The script may be run standalone or as a docker. 

## Prerequisites
* Keycloak server must be running and available via a url like `https://iam.xyz.net/auth/`.
* Updated `input.yaml` file
* Install `pyyaml`
```
$ sudo pip3 install pyyaml
```

## Script
* Help
```
$ python3 keycloak_init.py --help
```
* Run (example):
```
$ ./keycloak_init.py https://iam.xyz.net/auth/ user userpassword input
```

# Docker
## Create
```
$ docker build -t <your docker registry >/keycloak-init:<tag>
$ docker push <your docker registry >/keycloak-init:<tag>
```
## Run
Refer to helm chart for details on environment variables to be passed to run the docker

## Helm
* Update
```
$ help dependency update
```


