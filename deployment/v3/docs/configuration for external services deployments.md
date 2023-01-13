#  configuration for external minio, keycloak and postgres deployments

1. Procedure to be followed while configuring Postgres externally.
2. Procedure to be followed while configuring Keycloak externally.
3. Procedure to be followed while configuring Minio externally.


## 1. Procedure to be followed while configuring Postgres externally.

* If you want to configure Postgres externally, these are some property files required to be updated
* In config repo where ever there is a db server changes is required, there you have to update it.
* Default value is this 
  * **mosip.kernel.database.hostname=postgres-postgresql.postgres**
  * **mosip.kernel.database.port=5432**
* If you want to change you can change it via below command
  * **sed -i 's/old-text/new-text/g' input.txt**

## 2. Procedure to be followed while configuring Keycloak externally.

* For keycloak we are passing it has a parameter
* We just have to update in config-server/configmap
* That host we are passing it has config-server env variable (https://github.com/mosip/mosip-helm/blob/master/charts/config-server/templates/_overides.tpl#L42)


## 3. Procedure to be followed while configuring Minio externally.

* If you want to configure Minio externally, these are some property files required to be updated

* In config repo where there is a minio server changes is required, there you have to update it.
* Default value is this
  * **object.store.s3.url=http://minio.minio:9000**
  * **object.store.s3.region=${s3.region}**
  * **object.store.s3.readlimit=10000000**
* If you want to change you can change it via below command
  * **sed -i 's/old-text/new-text/g' input.txt**

