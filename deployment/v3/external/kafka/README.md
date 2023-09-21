# Kafka

## Install
* Review `values.yaml`  
* Replication factor must not exceed number of nodes available.
* Install
```
$ ./install.sh
```

## Steps to Backup & Restore Bitnami Kafka manually

#### Prerequisites
* Install `zip` & `unzip` packages on both backup/restore control plane nodes.

#### Backup
* Set WebSub and Kafka replicas to zero via the below command.
  ```
  kc2 -n default scale --replicas=0 deploy consolidator-websub-service websub-service
  kc2 -n default scale --replicas=0 statefulset kafka kafka-zookeeper
  ```
* Once Websub & Kafka pods are completely terminated, go to `/srv/nfs/mosip/`.
  ```
  cd /srv/nfs/mosip
  ```
* Run the below command to zip DMZ Kafka directories.
  ```
  sudo zip -r dmzkafka-backup.zip $( ls -d $( kc2 get pv | awk '/kafka/{print "*" $1}'))
  ```
* Move the backup file to the machine where the restore cluster is present.
* Set the Kafka replicas to their original value via the below command.
  ```
  kc2 -n default scale --replicas=<no-of-replicas> statefulset kafka kafka-zookeeper
  ```
* Set the websub replicas to their original value via the below command.
  ```
  kc2 -n default scale --replicas= deploy consolidator-websub-service websub-service
  ```

#### Restore

* Deploy kafka on the restore cluster.
* Run the below command to remove k8s probes and set pod command to `bash -c sleep infinity`.
  ```
  kubectl -n kafka patch statefulset kafka-zookeeper kafka --type=json \
  -p='[
        {"op": "replace", "path": "/spec/template/spec/containers/0/command", "value": ["bash"]},
        {"op": "replace", "path": "/spec/template/spec/containers/0/args", "value": ["-c", "sleep infinity"]},
        {"op": "replace", "path": "/spec/template/spec/containers/0/livenessProbe", "value": null},
        {"op": "replace", "path": "/spec/template/spec/containers/0/readinessProbe", "value": null},
        {"op": "replace", "path": "/spec/template/spec/containers/0/startupProbe", "value": null}
  ]'
  ```
* Wait until all changes are applied and the pods are up and running.
* To clear the data, update N value (i.e., number of replicas) in the below command.
  ```
  for i in {0..N}; do kubectl -n kafka exec -it kafka-zookeeper-$i -- bash -c 'rm -rf /bitnami/zookeeper/data/*'; done
  for i in {0..N}; do kubectl -n kafka exec -it kafka-$i -- bash -c 'rm -rf /bitnami/kafka/data/*'; done
  ```
* Unzip the backup zip file via below command
  ```
  unzip dmzkafka-backup.zip  -d kafka/
  
  chown -R 1001:1001 kafka
  ```
* To copy data from backup, update N value (i.e., number of replicas) in the below command.
  ```
  ## copy zookeeper data
  for i in {0..N}; do
    echo "KAFKA ZOOKEEPER - $i";
    kubectl -n kafka cp kafka/default-data-kafka-zookeeper-$i-*/data  kafka-zookeeper-$i:/bitnami/zookeeper/;
    sleep 10;
    sync; echo 1 > /proc/sys/vm/drop_caches && sync; echo 2 > /proc/sys/vm/drop_caches && sync; echo 3 > /proc/sys/vm/drop_caches
    sleep 10;
  done

  ## copy kafka data
  for i in {0..N}; do
    echo "KAFKA - $i";
    kubectl -n kafka cp kafka/default-data-kafka-$i-*/data  kafka-$i:/bitnami/kafka/;
    sleep 10;
    sync; echo 1 > /proc/sys/vm/drop_caches && sync; echo 2 > /proc/sys/vm/drop_caches && sync; echo 3 > /proc/sys/vm/drop_caches
    sleep 10;
  done
  ```
* Once all data is copied to the pods, then update `logRetentionBytes` to `_-1` in values.yaml file.
* Delete kafka via helm, ensure not to delete the pv/pvc of kafka.
  ```
  helm -n kafka delete kafka
  ```
* Run `install.sh` to deploy kafka.
* Once all kafka services are up, confirm the existence of topics, messages, etc... via kafka-ui.

## Procedure to Backup & Restore Bitnami Kafka via Velero

#### Prerequisites
* Require separate `minio` server / `S3` which is accessible from both backup & restore clusters along with accessible `api` & `console` ports.
* Ensure to create a bucket with name `velero`.
* Required backup & restore server cluster's kube config file.
* Install [velero](https://velero.io/docs/v1.9/basic-install/#install-the-cli) cli on both cluster management machines.
* Install [minio client](https://docs.min.io/docs/minio-client-quickstart-guide.html) cli on both cluster management machines.

#### Backup Kafka
* Login to the console machine, navigate to the `Kafka directory (under /v3/external/)`, and execute the backup script to create a backup of Kafka.
  ```
  [mosipuser@console ~]$ cd $HOME/mosip-infra/deployment/v3/external/kafka
  ```
  ```
  [mosipuser@console kafka]$ ./backup.sh <K8S_CLUSTER_CONFIG_FILE>
   ============== Check Cluster Config File ==========================================================================================================
     Kubernetes Cluster file found 
   ============== Check packages installed ===========================================================================================================
     kubectl, minio client (mc), & velero packages are already installed !!! 
   ============== S3 Setup ===========================================================================================================================
     Provide S3 server : <S3_SERVER_NAME>
     Provide S3 access key : <S3_ACCESS_KEY>
     Provide S3 secret key : <S3_SECRET_KEY>
     Provide S3 region ( Default region = minio ) : <S3_REGION>
    ....
    ....
   ============== Create Backup ======================================================================================================================
    Provide k8s service to be taken for backup  : <K8S_SERVICE_NAME>
    Provide k8s service Namespace : <K8S_NAMESPACE>

    [ Creating Backup ] 
        Backup request "kafka-15-09-2022-13-21" submitted successfully.
        Waiting for backup to complete. You may safely press ctrl-c to stop waiting - your backup will continue in the background.
        .........................................
        Backup completed with status: Completed. You may check for more information using the commands `velero backup describe kafka-15-09-2022-13-21` and `velero backup logs kafka-15-09-2022-13-21`.
  ```


#### Restore Kafka
* Ensure `values.yaml` & `ui-values.yaml` is up-to-date.
* Ensure to update the required storage in `values.yaml`.
* Run `restore.sh` to restore kafka from backup
  ```
    $ ./restore.sh  <K8S_CLUSTER_CONFIG_FILE>

     ============== Check Cluster Config File ==========================================================================================================

      Kubernetes Cluster file found 

     ============== Check packages installed ===========================================================================================================

      kubectl, minio client (mc), & velero packages are already installed !!! 

     ============== S3 Setup ===========================================================================================================================
      Provide S3 server : <S3_SERVER_NAME>
      Provide S3 access key : <S3_ACCESS_KEY>
      Provide S3 secret key : <S3_SECRET_KEY>
      Provide S3 region ( Default region = minio ) : <S3_REGION>
     ....
     ....
     ============== Create Restore =====================================================================================================================
      Provide Namespace to restore ( Default Namespace = kafka ) : <NAMSPACE_TO_RESTORE>
     ....
     ....
     ============== Restore Kafka from Backup ==========================================================================================================
     [ List Backups ] 	
      NAME                     STATUS      ERRORS   WARNINGS   CREATED                         EXPIRES   STORAGE LOCATION   SELECTOR
      kafka-backup             Completed   0        0          2022-08-25 20:00:08 +0530 IST   2d        default            app.kubernetes.io/instance=kafka
      kafka-backup-1           Completed   0        0          2022-08-29 15:03:31 +0530 IST   6d        default            app.kubernetes.io/instance=kafka
     [ Check backup existence ]
      Provide Backup Name : <KAFKA_BACKUP_NAME>
  ```

## Troubleshoot
* If you encounter the following error while executing `backup.sh` or `restore.sh`.
  ```
  mc: <ERROR> Unable to list folder. The request signature we calculated does not match the signature you provided. Check your key and signing method
  ```
  Then, ensure that you provide the appropriate API version, either `--api S3v2` or `--api S3v4`, when executing the `mc set alias` command.
* To list backup/restore.
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> get backup
  ```
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> get restore
  ```
* To check the status of backup/restore.
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> describe backup <backup-name> --details
  ```
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> describe restore <restore-name> --details
  ```
* To check the logs of backup/restore.
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> backup logs <backup-name>
  ```
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> restore logs <restore-name>
  ```
* Restart velero pod if backup/restore is stuck in `New` state.
  ```
  kubectl --kubeconfig=<K8S_CLUSTER_CONFIG_FILE> -n velero rollout restart deploy velero
  ```
* To list podvolumerestores.
  ```
  kubectl --kubeconfig=<K8S_CLUSTER_CONFIG_FILE> -n velero get podvolumerestores
  ```
* To delete backup/restore.
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> backup <backup-name>
  ```
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> restore delete <restore-name>
  ```
* If the restore operation `Failed`/`partiallyFailed`, describe the restore and check for which pod the restore operation failed to restore volume.
  Once the same kafka/zookeeper pod is up, login to the pod and remove the data for kafka `rm -rf /bitnami/kafka/data/*`, for zookeeper `rm -rf /bitnami/zookeeper/data/*`.
  Re-run the restore operation via running `./restore.sh` script.
  ```
  velero --kubeconfig <K8S_CLUSTER_CONFIG_FILE> describe restore <restore-name> --details
  ```
  For kafka pods,
  ```
  kubectl --kubeconfig=<K8S_CLUSTER_CONFIG_FILE> -n kafka exec -it <kafka-pod-name> -- bash
  
  I have no name!@kafka-X:/$ rm -rf /bitnami/kafka/data/*
  ```
  For zookeeper pods,
  ```
  kubectl --kubeconfig=<K8S_CLUSTER_CONFIG_FILE> -n kafka exec -it <zookeeper-pod-name> -- bash
  
  I have no name!@kafka-zookeeper-X:/$ rm -rf /bitnami/zookeeper/data/*
  ```
