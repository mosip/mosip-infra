# APITESTRIG

## Introduction
ApiTestRig will test the working of APIs of the MOSIP modules.

## Install
* Review `values.yaml` and, Make sure to enable required modules for apitestrig operation.
* Install
```sh
./install.sh
```

## Uninstall
* To uninstall ApiTestRig, run `delete.sh` script.
```sh
./delete.sh 
```

## Run apitestrig manually

#### Rancher UI
* Run apitestrig manually via Rancher UI.
  ![apitestrig-2.png](../../docs/images/apitestrig-2.png)
* There are two modes of apitestrig `smoke` & `smokeAndRegression`.
* By default, apitestrig will execute with `smokeAndRegression`. <br>
  If you want to run apitestrig with only `smoke`. <br>
  You have to update the `apitestrig` configmap and rerun the specific apitestrig job.

#### CLI
* Download Kubernetes cluster `kubeconfig` file from `rancher dashboard` to your local.
  ![apitestrig-1.png](../../docs/images/apitestrig-1.png)
* Install `kubectl` package to your local machine.
* Run apitestrig manually via CLI by creating a new job from an existing k8s cronjob.
  ```
  kubectl --kubeconfig=<k8s-config-file> -n apitestrig create job --from=cronjob/<cronjob-name> <job-name>
  ```
  example: 
  ```
  kubectl --kubeconfig=/home/xxx/Downloads/qa4.config -n apitestrig create job --from=cronjob/cronjob-apitestrig-masterdata cronjob-apitestrig-masterdata
  ```

  

