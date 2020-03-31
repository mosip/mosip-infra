# Docker

The Docker file in this folder is built and images are pushed to Docker Hub via a separate process. This is not while deploying the sandbox.  it is assumed that the docker images are present on Docker Hub.

## Build docker
```
$ docker build --build-arg git_uri=/mnt/mosip_data/configs/mosip_infra --build-arg version=1.0.5 --build-arg jar_name=kernel-config-server --build-arg config_folder=mosip-infra/deployment/sandbox-v2/roles/config-gitrepo/files/properties --tag mosipid/sandbox-config-server:1.0.5 .
```

## Push to Docker Hub
```
$ docker login
```
Enter username/password
```
$ docker push mosipid/sandbox-config-server:1.0.5
```

## Git repo
It is assumed that the git repo `/mnt/mosip_data/configs/mosip_infra` is available on the mounted on container and property files are checked-in over there.



