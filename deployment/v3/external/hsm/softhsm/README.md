# Softhsm

## Install
```sh
sh install.sh
```
## Defaults
* Replication factor is 1.  Multiple replication factors are not supported on AWS at the moment 'cause AWS EBS does not support `ReadWriteMany`.
* Keys are created in the mounted PV which gets mounted at `/softhsm/tokens` inside the container.
* Random PIN generated if not specified. Set `securityPIN` in `values.yaml`.

## Backup SoftHSM

#### Backup 
* Update the below variables
  ```
  export KUBECONFIG=<kubeconfig-file>
  export NS=<softhsm-namespace>
  export POD_NAME=<source-pod-name>
  ```
* Execute the following command to create a backup of the SoftHSM to the cluster's console machine.
  ```
  kubectl --kubeconfig=$KUBECONFIG -n $NS cp $POD_NAME:softhsm/tokens ./softhsm-kernel/tokens
  ```

#### Restore
* Ensure to have the backup directory for SoftHSM on cluster's console machine.
* Ensure that the newly generated keys are removed from the destination SoftHSM service, located within the `/softhsm/tokens` directory inside the pod.
* Update the variables provided below.
  ```
  export KUBECONFIG=<kubeconfig-file>
  export NS=<softhsm-namespace>
  export POD_NAME=<destination-pod-name>
  ```
* Execute the following command to restore SoftHSM from backup.
  ```
  kubectl --kubeconfig=$KUBECONFIG -n $NS cp ./softhsm-kernel/tokens $POD_NAME:softhsm/tokens
  ```
