# DSLRIG

## Introduction
DSLRIG will test the end-to-end working of APIs of the MOSIP modules.

## Install
* Make sure to deploy the authdemo and packetcreator services before deploying DSLRIG.
* Packetcreator will be deployed on a separate cluster/observation cluster.
* Authdemo and DSL-Orchestrator will be deployed on the MOSIP cluster.
* A separate server to set up NFS service is required.  
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

  

