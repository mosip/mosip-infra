# PostgreSQL ReadUser Creation Chart:

This helm chart is designed to run a script that creates a read-only user in a PostgreSQL database. The chart uses a PostgreSQL Docker image and executes a script provided via a ConfigMap.

## Prerequisites
Before deploying this chart, ensure the following prerequisites are met:

- Kubernetes Cluster: A running Kubernetes cluster.
- PostgreSQL Deployment: PostgreSQL should be deployed and running in your cluster.
- Kubernetes Secrets and ConfigMaps:
  * A Secret containing the PostgreSQL password.
  * A ConfigMap containing the script to create the read-only user.
  
## Notes

* The PostgreSQL password is securely stored in a Kubernetes Secret.

## Install

* `helm install my-release mosip/postgres-readuser-util`
