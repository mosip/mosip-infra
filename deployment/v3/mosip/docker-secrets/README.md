# Docker secrets

You need these only if you are accessing Private Docker Registries. Skip if all your dockers are downloaded from public Docker Hub. 

All MOSIP modules are public, however, if you have your dockers in private Docker registries create secrets for all such registries:
```sh
./install.sh [kubeconfig]
```

You may provide access token instead of password.



