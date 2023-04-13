# Minio Client Utility

## Context
* This utility helps to clear objects from S3 buckets.
* The utility is expected to clear objects that are older than specified no of retention days.

## Prerequisites
* S3 accessible using the Server URL.
* ACCESS and SECRET Keys having delete role for the targeted bucket in S3.
* Docker installed in respective server from where the tool will be executed.

## Install
```sh
./install.sh
```
#### Run minio-client-util manually via Rancher UI
* Select the minio-client-util cronjob and click the 'Run Now' option
![mc-1.png](images/mc-1.png)

#### Run minio-client-util manually via CLI
* Download Kubernetes cluster `kubeconfig` file from `rancher dashboard` to your local.
* Install `kubectl` package to your local machine.
* Run minio-client-util manually via CLI by creating a new job from an existing k8s cronjob.
  ```
  kubectl --kubeconfig=<k8s-config-file> -n minio-client-util create job --from=cronjob/<cronjob-name> <job-name>
  ```
  Example:
  ```
  kubectl --kubeconfig=/home/xxx/Downloads/dev.config -n minio-client-util create job --from=cronjob/cronjob-minio-client-util cronjob-minio-client-util
  ```
