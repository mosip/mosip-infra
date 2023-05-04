# Garbage Cleanup (GC) Utility

## Context
* The utility runs as a cronjob to clear the completed jobs like API Test Rig and DSL Rig Jobs from the Kubernetes cluster.

## Install
```sh
./install.sh
```
#### Run gc-util manually via Rancher UI
* Select the gc-util cronjob and click the 'Run Now' option
![gc.png](../docs/images/gc-util.png)

#### Run gc-util manually via CLI
* Download Kubernetes cluster `kubeconfig` file from `rancher dashboard` to your local.
* Install `kubectl` package to your local machine.
* Run gc-util manually via CLI by creating a new job from an existing k8s cronjob.
  ```
  kubectl --kubeconfig=<k8s-config-file> -n gc-util create job --from=cronjob/<cronjob-name> <job-name>
  ```
  Example:
  ```
  kubectl --kubeconfig=/home/xxx/Downloads/dev.config -n gc-util create job --from=cronjob/cronjob-gc-util cronjob-gc-util
  ```
