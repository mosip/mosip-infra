# Keycloak
## Introduction
An organisation may use any OAuth 2.0 compliant Identity Access Management (IAM) system with MOSIP.  Typically, one installation per organisation/MOSIP project would suffice considering ease of user management.

Here we provide k8s installation procedure for **Keycloak** which is the default supported IAM with MOSIP.

## Cluster
You may install Keycloak on the same cluster as [Rancher](../../rancher/README.md). Just make sure that the cluster has capacity to grow in case Keycloaks gets loaded while running in production.

## Install
* You will need an external domain name like 'iam.xyz.net' that points to the cluster load balancer.
* Install keycloak as given [here](https://github.com/bitnami/charts/tree/master/bitnami/keycloak). You may use the `values.yaml` and `install.sh` provided here. Make sure you have updated `CLUSTER_CONFIG` in all the scripts to point to your cluster.
* Update `ingress.hostname` in `values.yaml` with above domain name.
* Note that the helm chart installs postgres too.  If you already have an external postgres DB, point to the same while installing.
* For postgres persistence the chart uses default storage class available with the cluster.
* While deleting helm chart note that PVC, PV do not get removed for Statefulset. This also means that passwords will be same as before.  Delete them explicity if you need to. CAUTION: all persistent data will be erased if you delete PV.
* To retain data even after PV deletion use a storage class that supports "Retain".  On AWS, you may install `gp2-retain` storage class given here and specify the same while installing Keycloak helm chart.

## Existing Keycloak 
* In case you have not installed Keycloak by above method, and already have an instance running, make sure Kubernetes configmap and secret is created in namespace `keycloak` as expected in [keycloak-init](https://github.com/mosip/mosip-helm/blob/develop/charts/keycloak-init/values.yaml):
```
keycloak:
  host:
    existingConfigMap: keycloak-host
    key: keycloak-host-url
  admin:
    userName:
      existingConfigMap: keycloak-env-vars
      key: KEYCLOAK_ADMIN_USER
    secret:
      existingSecret: keycloak
      key: admin-password
```

## Secret change
In case you change admin password directly from console, then update the secret as well:
```
$ ./update_secret.sh <admin new password>
```
You may get the current admin password:
```
$ ./get_pwd.sh
```
## Rancher integration

* If you have Rancher installed, enabled authentication with Keycloak using the steps given [here](https://rancher.com/docs/rancher/v2.5/en/admin-settings/authentication/keycloak/).
* IMPORTANT: If you have logged in as admin user in Keycloak make sure an email id, and first name field is added to the admin user of Keycloak before you try to authenticate with Rancher. 
* In Keyclok add another Mapper for the rancher client (in Master realm) with following fields:
  * Protocol: saml
  * Name: username
  * Mapper Type: User Property
  * Property: username 
  * Friendly Name: username
  * SAML Attribute Name: username
  * SAML Attribute NameFormat: Basic

* Specify the following mappings in Rancher's Authentication Keycloak form:
  * Display Name Field: givenName
  * User Name Field: email
  * UID Field: username
  * Entity ID Field: https://<your rancher domain>/v1-saml/keycloak/saml/metadata
  * Rancher API Host: https://<your rancher domain>
  * Groups Field: member
* For users in keycloak assign roles rancher - cluster and project roles.  Under `default` project add all the namespaces. Then, for a non-admin user you may provide Read-Only role (under projects).
* Add a member to cluster/project:
  * Give member name exactly as `username` in Keyclaok
  * Assign appropriate role like Cluster Owner, Cluster Viewer etc.

## Keycloak docker version
TODO: The keycloak docker version in `values.yaml` is an older version as the version 12.04 (latest bitnami) was crashing for `userinfo` request for client (like mosip-prereg-client). Watch latest bitnami release and upgrade 13+ version when available.

## Keycloak Init
To populate base data of MOSIP, run Keycloak Init job:
```
$ ./keycloak_init.sh
```

## Server URL
Server URL is of the form `https://iam.xyz.net/auth/`.  The `/auth/` (with slash) is important.


