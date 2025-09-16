# S3 Initialization Chart:

This helm chart is designed to initialize MinIO with user management and policy attachment based on the specified action (create or delete). The Job will either create a new user and attach a policy or delete an existing user in the MinIO server.

## Prerequisites
Ensure the following prerequisites are met before deploying the chart:

- Kubernetes Cluster: A running Kubernetes cluster.
- MinIO Deployment: MinIO server should be deployed and running.
- Kubernetes ConfigMap and Secrets:
  * ConfigMap containing the policy JSON.
  * Secret containing the MinIO access and secret keys.
- Configuration for the username, password, policy name, and action should be managed via a values file (typically used with Helm charts).

### Notes:

* The action (create or delete), username, password, and policy name should be set in the values.yaml file, which will be referenced in the Job manifest.

### Install

* `helm install my-release mosip/s3-readuser-util`
