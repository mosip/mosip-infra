# DSLRIG

## Introduction
DSL RIG will test end-to-end functional flows involving multiple MOSIP modules.

#### Prerequisites
* Packet utility running in rancher cluster exposed to be accessed by the cluster.
* Auth demo and DSL RIG to be running in the same cluster.
* NFS server already present and related details.

## Install
* Install
```sh
./install.sh
```

## Run dslrig manually

#### Rancher UI
* Run dslrig manually via Rancher UI.
  ![dslrig-2.png](../../docs/images/dslrig-2.png)
* There are two modes of dslrig `smoke` & `smokeAndRegression`.
* By default, dslrig will execute with `smokeAndRegression`. <br>
  If you want to run dslrig with only `smoke`. <br>
  You have to update the `dslrig` configmap and rerun the specific dslrig job.

#### CLI
* Download Kubernetes cluster `kubeconfig` file from `rancher dashboard` to your local.
  ![dslrig-1.png](../../docs/images/dslrig-1.png)
* Install `kubectl` package to your local machine.
* Run dslrig manually via CLI by creating a new job from an existing k8s cronjob.
  ```
  kubectl --kubeconfig=<k8s-config-file> -n dslrig create job --from=cronjob/<cronjob-name> <job-name>
  ```
  example: 
  ```
  kubectl --kubeconfig=/home/xxx/Downloads/qa4.config -n dslrig create job --from=cronjob/cronjob-dslrig-masterdata cronjob-dslrig-masterdata
  ```

  

