# Readuser Util Helm Chart

This Helm chart deploys multiple readuser utility Helm charts for creating users with read-only privilages for postgres and minio servers.


## Dependencies

This chart has dependencies on the following Helm charts:

1. **postgres-readuser-util**
    - **Version**: 0.0.1-develop
    - **Condition**: Enabled if `postgres-readuser-util.enabled` is set to `true`

2. **s3-readuser-util**
    - **Version**: 0.0.1-develop
    - **Condition**: Enabled if `s3-readuser-util.enabled` is set to `true`

## Notes

* In order to update the "user" and "host" details for readuser creation for both postgres and minio servers you will have to update the values.yaml file.  
* For more information about dependency chart please go through the README.md file of the specific dependency charts. 

## Install

* `helm install my-release mosip/readuser-util`