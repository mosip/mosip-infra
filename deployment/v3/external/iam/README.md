# Keycloak

## Introduction
An organisation may use any OAuth 2.0 compliant Identity Access Management (IAM) system with MOSIP.  Here we provide k8s installation procedure for **Keycloak** which is the default supported IAM with MOSIP.

## Prerequisites
- It is recommended to have two seperate installations of keycloak;
  1. one that can be considered as an organization level keycloak (which will be integrated with rancher for authentication); You may install this Keycloak on the same cluster as [Rancher](../../rancher/README.md), since Rancher is also a single installation per organization.
  2. another installation per every MOSIP cluster. This needs to installed in the mosip cluster itself, so that modules can use this for authentication.
- Note: make sure that these cluster have capacity to grow in case these Keycloaks gets loaded while running in production.
- You will need two seperate external domain names. Example:
  1. 'iam.xyz.net' that points to the organization cluster(rancher cluster)'s load balancer.
  2. 'iam.mosip.xyz.net' that points to the mosip cluster's load balancer.

## Install
* Use the `install.sh` provided in this directory. This will install Keycloak as bitnami helm chart. To further configure `values.yaml` and for any other info, refer [here](https://github.com/bitnami/charts/tree/master/bitnami/keycloak). Run the following, **twice**, with different keycloak hostnames and kubeconfig files, one time for organisation keycloak, second time for mosip keycloak.
```
$ ./install.sh <keycloak external host name for this install> <kubeconfig file for this cluster>
```
* Note that the helm chart installs postgres too.  If you already have an external postgres DB, point to the same while installing.
* For postgres persistence the chart uses default storage class available with the cluster.
* While deleting helm chart note that PVC, PV do not get removed for Statefulset. This also means that passwords will be same as before. Delete them explicity if you need to. CAUTION: all persistent data will be erased if you delete PV.
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
$ ./update_secret.sh <admin new password> <kubeconfig file for this cluster>
```
You may get the current admin password:
```
$ ./get_pwd.sh <kubeconfig file for this cluster>
```

## Keycloak docker version
TODO: The keycloak docker version in `values.yaml` is an older version as the version 12.04 (latest bitnami) was crashing for `userinfo` request for client (like mosip-prereg-client). Watch latest bitnami release and upgrade 13+ version when available.

## Keycloak Init
To populate base data of MOSIP, run Keycloak Init job:
```
$ ./keycloak_init.sh <kubeconfig file for mosip cluster>
```
