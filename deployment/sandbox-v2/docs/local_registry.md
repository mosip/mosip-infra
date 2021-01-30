# Local docker registry

## Local registry on console
You may run a local docker registry instead of using default Docker Hub.  This is especially useful when the Kubernetes cluster is sealed from the Internet for security.  A sample docker registry implementation is available with this sandbox, and you may run the same by enabling the following in `group_vars/all.yml`:
```
docker:
  local_registry:
    enabled: true
    image: 'registry:2'
    name: 'local-registry'
    port: 5000
```
Note that this registry runs on the console machine and maybe accessed as `console.sb:5000`.  The access is via http and not https.

Make sure you pull all the necessary dockers in this registry and update `versions.yml`.

_WARNING_: If you delete/reset this registry or restart console machine, all the contents in registry will be lost and you will have to pull the dockers again.

## Additional local registries
If you have additional **local** docker registries, then list them here:
```
docker:
  registries:  
    - '{{groups.console[0]}}:{{local_docker_registry.port}}'   # Docker registry running on console
```
The list here is needed to make sure http access is enabled for the above registries from cluster machines.






