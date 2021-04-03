# Keycloak Init

## Context

After Keycloak is installed, it needs to be populated with base data that is needed for MOSIP.  The script and docker created here provide this function.  The script may be run standalone or as a docker. 

## Prerequisites
* Keycloak server must be running and available via a url like `https://iam.xyz.net/auth/`.
* Updated `input.yaml` file
* Install utilities
```
$ sudo pip3 install -r requirements.txt
```

## Script
* Help
```
$ python3 keycloak_init.py --help
```
* Run (example):
```
$ python3 keycloak_init.py https://iam.xyz.net/auth/ user userpassword input.yaml
```

# Docker
## Create
```
$ docker build -t <your docker registry >/keycloak-init:<tag> .
$ docker push <your docker registry >/keycloak-init:<tag>
```
## Run
```
docker run -it  -v /Users/myhome/config/:/opt/mosip/input -e KEYCLOAK_ADMIN_USER=user -e KEYCLOAK_ADMIN_PASSWORD=<password> -e KEYCLOAK_SERVER_URL=https://iam.xyz.net/auth/  mosipdev/keycloak-init:develop
```


