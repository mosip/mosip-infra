#  External Services Configuration

This document describes how to configure external services like MinIO, Keycloak, and Postgres.


## Postgres external configuration procedure

* Go to `mosip-config` and checkout to a specific branch to update the `config` properties.
* The default value for the database hostname is `postgres-postgresql.postgres` and the default value for the database port number are `5432`.
* If you are using an external service, you need to update the hostname and port number via `sed` command mentioned below and also provide the external-hostname along with external-port.
  ```
   cd mosip-config
   sed -i 's/postgres-postgresql.postgres/<postgres-external-hostname>/g' *
   sed -i 's/5432/<postgres-external-port>/g' *
  ```
* Create a `postgres` namespace.
  ```
   kubectl create ns postgres
  ```
* Create a secret with the name `postgres-postgresql` in the `postgres` namespace, with the appropriate superuser password.
* For example:
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
* Proceed with **postgres-init** script from [here](../external/postgres/README.md#initialize-db).


## Keycloak external configuration procedure

* Create a `keycloak` namespace.
  ```
   kubectl create ns keycloak
  ```
* Create configmap with the name `keycloak-host` in the `keycloak` namespace and with the following data. Use appropriate hostname and URLs.
* For example:
  ```
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: keycloak-host
    namespace: keycloak
  data:
    keycloak-external-host: iam.sandbox.mosip.net
    keycloak-external-url: https://iam.sandbox.mosip.net
    keycloak-internal-host: keycloak.keycloak
    keycloak-internal-url: http://keycloak.keycloak
  ```
* Create a secret with the name `keycloak` in the `keycloak` namespace with the following data.
* For example:
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
  >Note:
  - The admin-password is the password of the admin user of the master realm in the keycloak.
* Proceed with **keycloak_init.sh** script from [here](../external/iam/README.md#keycloak-init).



## MinIO external configuration procedure

* Go to `mosip-config` and checkout to a specific branch to update the `config` properties.
* The default value for the s3 URL is `object.store.s3.url=http://minio.minio:9000`.
* If you are using an external service, you need to update the s3 URL via `sed` command below and also provide the external URL.
  ```
   cd mosip-config
   sed -i 's/http://minio.minio/<external-url>/g' *
  ```
* Proceed with **object-store** install scripts from [here](../external/object-store/README.md).
