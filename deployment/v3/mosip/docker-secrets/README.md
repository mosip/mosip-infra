# Docker secrets

You need these **only** if you are accessing Private Docker Registries. Skip if all your dockers are downloaded from public Docker Hub. 

All MOSIP modules are public, however, if you have your dockers in private Docker registries create secrets for all such registries:
```sh
kubectl create secret docker-registry regsecret --docker-server=$DOCKER_REGISTRY_URL --docker-username=$USERNAME --docker-password=$PASSWORD --docker-email=$EMAIL
```

Example for a priviate registry on Docker Hub DOCKER_REGISTRY_URL=https://index.docker.io/v1/

You may provide access token instead of password.



