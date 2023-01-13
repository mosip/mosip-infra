#  External Services Configuration

* This document describes how to configure external services like minio,keycloak and postgres


## postgres external configuration procedure

* Go to mosip-config repo
* Use the following grep command to get all files that are required to be updated
  ```
   cd mosip-config
   grep -r "postgres-postgresql.postgres'
   grep -r "5432"
  ```
* When we perform the above step we will get some files that need to be updated with the correct db.url, db.hostname and db.port number
* Files to be updated.
    * `id-authentication-default.properties`
    * `syncdata-default.properties`
    * `registration-processor-default.properties`
    * `kernel-default.properties`
    * `hotlist-default.properties`
    * `partner-management-default.properties`
    * `pre-registration-default.properties`
    * `id-repository-default.properties`
    * `admin-default.properties`
* Create `postgres` namespace.
* Create secret with name `postgres-postgresql` in `postgres` namespace, with appropriate superuser password. For example:
  ```
  apiVersion: v1
  kind: Secret
  metadata:
    name: postgres-postgresql
    namespace: postgres
  type: Opaque
  data:
    postgresql-password: {{ base64 encoded superuser password }}
  ```
* Proceed with postgres-init script from [deployment/v3/external/postgres](../external/postgres)


## keycloak external configuration procedure

* Create `keycloak` namespace.
* Create configmap with name `keycloak-host` in `keycloak` namespace and with following data. Use appropriate hostname and urls. For example:
  ```
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: keycloak-host
    namespace: keycloak
  data:
    keycloak-external-host: iam.dev.mosip.net
    keycloak-external-url: https://iam.dev.mosip.net
    keycloak-internal-host: keycloak.keycloak
    keycloak-internal-url: http://keycloak.keycloak
  ```
* Create secret with name `keycloak` in `keycloak` namespace with following data. Use appropriate admin-password. For example:
  ```
  apiVersion: v1
  kind: Secret
  metadata:
    name: keycloak
    namespace: keycloak
  type: Opaque
  data:
    admin-password: {{ base64 encoded admin password }}
  ```
* Proceed with **keycloak_init.sh** script from [deployment/v3/external/iam](../external/iam)


## minio external configuration procedure

* Go to mosip-config repo
* Modify the following properties in each of the following files in mosip-config repo, with appropriate values.
  ```
   object.store.s3.url={{ s3 url }}
  ```
* Files to be updated.
    * `registration-processor-default.properties`
    * `packet-manager-default.properties`
    * `pre-registration-default.properties`
    * `data-share-default.properties`
    * `id-repository-default.properties`
* Proceed with **object-store** install scripts from [deployment/v3/external/object-store](../external/object-store)
