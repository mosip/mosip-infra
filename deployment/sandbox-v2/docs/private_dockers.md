## Private dockers
If you are pulling dockers from private registry in Docker Hub, then provide the Docker Hub credentails in `secrets.yml` and set following flag in `group_vars/all.yml`:
```
docker:
  hub:
    private: true
```

Update `versions.yml` with your docker versions.

