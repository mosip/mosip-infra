# Keycloak

* Make sure ingress controller is running with service type as LoadBalancer
* There is an external domain name like 'iam.mosip.net' that is forwarded to the LoadBalancer
* Change postgres PV policy to `Retain` if you would like to persist keycloak data. This can be achieved by setting 'gp2-retain' storage class defined in `../cluster/sc.yaml`.
* Update `values.yaml` appropriately
* Run
```
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install keycloak bitnami/keycloak -f values.yaml
```
* While deleting helm chart note that PVC, PV do not get removed for Statefulset. This also means that passwords will be same as before.  Delete them explicity if you need to.
* If you use `gp2-retain` storage class then even after deleting PVC, PV, the storage will remain intact on AWS. If you wish to delete the same, go to AWS Console --> Volumes and delete the volume.
* The chart above installs Postgres by default. 

# Keycloak Init
To populate base data for MOSIP:
* Add mosip helm repo for Keycloak 
```
$ helm repo add mosip https://mosip.github.io/mosip-helm 
```
* Run Keycloak init job
```
$ helm install keycloak-init mosip/keycloak-init --set keycloak.admin.user=<username> --set keycloak.admin.password=<password> --set keycloak.serverUrl=<url>
```
Server URL is of the form `https://iam.xyz.net/auth/`.  The `/auth/` (with slash) is important.


