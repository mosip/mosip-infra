#  External Services Configuration

* This document describes how to configure external services like Minio,Keycloak, and Postgres


## Postgres external configuration procedure

* Go to mosip-config and checkout to a specific branch to update config properties.
* The default value for the database hostname is `postgres-postgresql. Postgres` and the default value for the database port number are `5432`.
* If you are using an external service, then you have to update the hostname and port number with this below sed command and provide the external-hostname and external-port.
  ```
   cd mosip-config
   sed -i 's/postgres-postgresql.postgres/<postgres-external-hostname>/g' *
   sed -i 's/5432/<postgres-external-port>/g' *
  ```
* Create `postgres` namespace.
* Create a secret with the name keycloak in the keycloak namespace with the following data. The admin password is the password of the admin user of the master realm in the keycloak.
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
* Proceed with **postgres-init** script from [deployment/v3/external/postgres/README.md#initialize-db](../external/postgres/README.md#initialize-db).


## keycloak external configuration procedure

* Create `keycloak` namespace.
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
* Create a secret with the name keycloak in the keycloak namespace with the following data. The admin-password is the password of the admin user of the master realm in the keycloak.
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
* Proceed with **keycloak_init.sh** script from [deployment/v3/external/iam/README.md#keycloak-init](../external/iam/README.md#keycloak-init).


## minio external configuration procedure

* Go to mosip-config and checkout to a specific branch to update config properties.
* The default value for the s3 URL is `object.store.s3.url=http://minio.minio:9000`.
* If you are using an external service, then you have to update the s3 URL using with this below sed command and provide the external URL.
  ```
   cd mosip-config
   sed -i 's/http://minio.minio/<external-url>/g'  *
  ```
* Proceed with **object-store** install scripts from [deployment/v3/external/object-store/README.md](../external/object-store/README.md).
