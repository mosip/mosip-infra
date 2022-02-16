# Keycloak Init

## Context

After Keycloak is installed, it needs to be populated with base data that is needed for MOSIP.  The script and docker created here provide this function.  The script may be run standalone or as a docker. 

## Prerequisites
* Keycloak server must be running and available via a url like `https://iam.xyz.net`.
* Updated `input.yaml` file
* Install utilities
* Install python3 virtual environment  and activate the same as per the link https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/


```
$ pip3 install -r requirements.txt
```

## Script
* Help
```
$ python3 keycloak_init.py --help
```
* Run (example):
```
$ python3 keycloak_init.py https://iam.xyz.net user user password input.yaml
```

# Docker
* Create
```
$ docker build -t <your docker registry >/keycloak-init:<tag> .
$ docker push <your docker registry >/keycloak-init:<tag>
```
* Run

See `run.sh`

To just create users see example `users.yaml`
