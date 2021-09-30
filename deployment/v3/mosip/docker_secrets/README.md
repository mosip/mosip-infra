# Docker secrets

MOSIP module installations may be done from docker registries that are private.  Create secrets for all registries from where you are going to pull the dockers using the following command:
```sh
kubectl create secret docker-registry regsecret --docker-server=$DOCKER_REGISTRY_URL --docker-username=$USERNAME --docker-password=$PASSWORD --docker-email=$EMAIL
```
For DockerHub DOCKER_REGISTRY_URL=https://index.docker.io/v1/

You may provide access token instead of password.



