# ReadUser Creation Utility:

This Utility is used for the creation of user with readonly privilages for postgres, minio and keycloak server.

This utility is designed to initialize MinIO with user management and policy attachment based on the specified action (create or delete) and to run a script that creates a read-only user in a PostgreSQL database and also to initialize keycloak with user with readonly privilages.

## Prerequisites
Ensure the following prerequisites are met before deploying the utility:

- Kubernetes Cluster: A running Kubernetes cluster.
- MinIO Deployment: MinIO server should be deployed and running.
- Postgres Deployment: Postgres server should be deployed and running.
- Keycloak Deployment: Keycloak server should be deployed and running.
- Kubernetes ConfigMap and Secrets:
    * Secret containing the "postgres-password"
    * Secret containing the MinIO access and secret keys.
- Configuration for the username, password, policy name, and action should be managed via a values file (typically used with Helm charts) for s3-readuser-util chart.
- Configuration for the username, password, dbhost, dbport and action should be managed via a values file (typically used with Helm charts) for postgres-readuser-util chart.
- readuser-init-values.yaml file with user configurations to initialize keycloak.

### Notes:

* The action (create or delete), username, password, and policy name should be set in the values.yaml file, which will be referenced in the Job manifest.
* The utility uses mc client to create readuser in minio server.
* The utility uses sql script which is passed in configmaps to create readuser in postgres server.
* If you want to create readuser then the "action" key value from values.yaml needs to be "create".
* If you want to delete readuser then the "action" key value from values.yaml needs to be "delete".
* Once after exicuting this utility please confirm from the minio, postgres and keycloak server whether the user created has the necessary privilages or not.
* And in case of deleteion of user crosscheck from the minio, postgres and keycloak server if the user is deleted or not.

### Install

* `install.sh`

### Delete

* `delete.sh`