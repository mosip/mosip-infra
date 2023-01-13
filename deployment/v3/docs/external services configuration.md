#  External Services Configuration

* This document describes how to configure external services like minio,keycloak and postgres


## postgres external configuration procedure

* Go to mosip-config and checkout to specific branch to update config properties.
* Default value for database hostname is `postgres-postgresql.postgres` and  Default value for database port number is `5432`.
* If you are using external service, then you have to update hostname and port number with this below sed command and provide the new hostname
  ```
   cd mosip-config
   sed -i 's/postgres-postgresql.postgres/new-hostname/g' *
   sed -i 's/5432/new-port number/g' *
  ```
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
* Proceed with **postgres-init** script from [deployment/v3/external/postgres/README.md](../external/postgres/README.md)


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
    keycloak-external-host: iam.sandbox.mosip.net
    keycloak-external-url: https://iam.sandbox.mosip.net
    keycloak-internal-host: keycloak.keycloak
    keycloak-internal-url: http://keycloak.keycloak
  ```
* Create secret with name `keycloak` in `keycloak` namespace with following data. Use appropriate admin-password, admin-password is the password of the admin user in keycloak master realm. For example:
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
* Proceed with **keycloak_init.sh** script from [deployment/v3/external/iam/README.md](../external/iam/README.md)


## minio external configuration procedure

* Go to mosip-config and checkout to specific branch to update config properties
* Default value for s3 URL is `object.store.s3.url=http://minio.minio:9000`
* If you are using external service, then you have to update s3 URL using this below sed command and provide the new s3 URL
  ```
   cd mosip-config
   sed -i 's/old-url/new-url/g' property.files *
  ```
* Proceed with **object-store** install scripts from [deployment/v3/external/object-store/README.md](../external/object-store/README.md)
