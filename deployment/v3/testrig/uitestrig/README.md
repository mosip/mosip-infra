# UITESTRIG

## Introduction
UITESTRIG will test end-to-end functional flows involving multiple UI modules.

## Install
* Install
```sh
./install.sh
```

## Uninstall
* To uninstall UITESTRIG, run `delete.sh` script.
```sh
./delete.sh 
```

## Run UITESTRIG manually

#### CLI
* Download Kubernetes cluster `kubeconfig` file from `rancher dashboard` to your local.
* Install `kubectl` package to your local machine.
* Run UITESTRIG manually via CLI by creating a new job from an existing k8s cronjob.
  ```
  kubectl --kubeconfig=<k8s-config-file> -n UITESTRIG create job --from=cronjob/<cronjob-name> <job-name>
  ```
  example: 
  ```
  kubectl --kubeconfig=/home/xxx/Downloads/qa4.config -n UITESTRIG create job --from=cronjob/cronjob-uitestrig cronjob-uitestrig
  ```

  

