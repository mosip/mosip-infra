## Private dockers
If you are pulling dockers from private registry in Docker Hub, then provide the Docker Hub credentails in `secrets.yml` and set following flag in `group_vars/all.yml`:
```
docker:
  hub:
    private: true
```

Update `versions.yml` with your docker versions.

All the above mentioned changes work if it is done before the cluster creation. If you want to create the docker secrets after the cluster is created please run the below command from sandboxv2 directory in Console:

for mz:
```
an playbooks/docker-secrets.yml --extra-vars "kube_config={{clusters.mz.kube_config}}"
```

for dmz:
```
an playbooks/docker-secrets.yml --extra-vars "kube_config={{clusters.dmz.kube_config}}"
```
