# Kafka

Kafka is required only if you are installing Registration Processor.

## Install
* Review `values.yaml`  
* Replication factor must not exceed number of nodes available.
* Install
```
$ ./install.sh
```

## Procedure to Backup & Restore bitnami kafka via Velero

#### Prerequisites
* Required separate `minio` server / 'S3' , accessible from both backup & restore clusters along with `api` & `console` port accessible.
* Ensure to create a bucket with name `velero`.
* Required backup & restore servers cluster config file.
* Install [velero](https://velero.io/docs/v1.9/basic-install/#install-the-cli) cli on both cluster management machines.
* Install [minio client](https://docs.min.io/docs/minio-client-quickstart-guide.html) cli on both cluster management machines.

#### Backup kafka
* Login to the console machine,navigate to the `Kafka directory (under /v3/external/)`, and execute the backup script to create a backup of Kafka.
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


#### Restore kafka
* Ensure `values.yaml` & `ui-values.yaml` is up-to-date.
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