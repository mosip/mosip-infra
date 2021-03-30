# Keycloak
## Introduction
An organisation may use any OAuth 2.0 compliant Identity Access Management (IAM) system with MOSIP.  Typically, one installation per organisation/MOSIP project would suffice keeping in mind ease of user management. 

Here we provide installation procedure of Keycloak which is the default supported IAM with MOSIP.

## Install
* Make sure ingress controller is running with service type as LoadBalancer
* There is an external domain name like 'iam.mosip.net' that is forwarded to the LoadBalancer
* Change postgres PV policy to `Retain` if you would like to persist keycloak data. This can be achieved by setting 'gp2-retain' storage class defined in `../cluster/sc.yaml`.
* Update `ingress.hostname` in `values.yaml`.
* Run
```
$ ./install.sh
```
* While deleting helm chart note that PVC, PV do not get removed for Statefulset. This also means that passwords will be same as before.  Delete them explicity if you need to. CAUTION: all persistent data will get rased if you delete PV.
* If you use `gp2-retain` storage class then even after deleting PVC, PV, the storage will remain intact on AWS. If you wish to delete the same, go to AWS Console --> Volumes and delete the volume.
* The chart above installs Postgres by default. 

## Rancher integration

* If you have Rancher installed, enabled authentication with Keycloak using the steps given [here](https://rancher.com/docs/rancher/v2.5/en/admin-settings/authentication/keycloak/).
* For users in keycloak assign roles - cluster and project roles.  Under `default` project add all the namespaces. Then, for a non-admin user you may provide Read-Only role (under projects).

## Keycloak Init
To populate base data of MOSIP:
* Add mosip helm repo for Keycloak 
```
$ helm repo add mosip https://mosip.github.io/mosip-helm 
```
* Run Keycloak init job
```
$ helm install keycloak-init mosip/keycloak-init --set keycloak.admin.user=<username> --set keycloak.admin.password=<password> --set keycloak.serverUrl=<url>
```
Server URL is of the form `https://iam.xyz.net/auth/`.  The `/auth/` (with slash) is important.


