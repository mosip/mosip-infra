# Admin module

## Hostname
Set hostname in `values.yaml` of Admin UI
## Install
```
$ helm repo update
$ kubectl create ns admin
$ helm -n admin install admin-service mosip/admin-service
$ helm -n admin install admin-ui mosip/admin-ui
```
## Admin user
Create a user in 'mosip' realm and assign roles GLOBAL_ADMIN and ZONAL_ADMIN.

