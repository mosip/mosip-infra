# S3 ReadUser Creation Utility:

This utility is designed to initialize MinIO with user management and policy attachment based on the specified action (create or delete). The Job will either create a new user and attach a policy or delete an existing user in the MinIO server.

## Prerequisites
Ensure the following prerequisites are met before deploying the utility:

- Kubernetes Cluster: A running Kubernetes cluster.
- MinIO Deployment: MinIO server should be deployed and running.
- Kubernetes ConfigMap and Secrets:
    * ConfigMap containing the policy JSON.
    * Secret containing the MinIO access and secret keys.
- Configuration for the username, password, policy name, and action should be managed via a values file (typically used with Helm charts).

### Notes:

* The action (create or delete), username, password, and policy name should be set in the values.yaml file, which will be referenced in the Job manifest.
* The utility uses mc client to perform the above operations.
* If you want to create readuser then the "action" key value from values.yaml needs to be "create".
* If you want to delete readuser then the "action" key value from values.yaml needs to be "delete".
* Once after exicuting this utility please confirm from the miniio server whether the user created has the necessary privilages or not.
* And in case of deleteion of user crosscheck from the minio server if the user is deleted or not.

### Install

* `install.sh`

### Delete

* `delete.sh`