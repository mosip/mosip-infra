# Docker secrets

MOSIP module installations may be done from docker registries that are private.  Create secrets for all registries from where you are going to pull the dockers using the following command:
```
$ kubectl create secret docker-registry regsecret --docker-server=$DOCKER_REGISTRY_RUL --docker-username=$USERNAME --docker-password=$PASSWORD --docker-email=$EMAIL
```
You may provide access token instead of password.



