# MinIO

## Introduction
MinIO is a High Performance Object Storage released under GNU Affero General Public License v3.0. It is API compatible with Amazon S3 cloud storage service.  MinIO is required for on-prem setups. If you are installing MOSIP on cloud you need explore cloud native options that support S3 API.  On AWS, it would be S3.  

## Helm chart based install
Recommended for sandbox installations:
* Install helm chart
```
./install.sh
``` 
* Create secrets for config server
```
cd ..
./cred.sh
```
## Operator based installation 
Recommended for multi-tenant production based installation.
See [MinIO Operator Based Installation Guide](operator/README.md).

## Install MinIO client
To install the MinIO client, follow the procedure from [here](https://docs.min.io/docs/minio-client-complete-guide.html).

## MinIO Clone
* Set `alias` for MinIO servers.
  ```
    mc alias set <src-alias-name> http://<server>:9001 <minio-root-user> <minio-root-password> --api S3v4  ( old version )
    mc alias set <dest-alias-name> http://<server>:9100 <minio-root-user> <minio-root-password> --api S3v4  ( latest versions )
    mc alias ls
  ```
* Clone MINIO buckets from one MinIO server to another MinIO server.
  ```
    mc mirror <src-alias-name> <dest-alias-name>
  ```

## Backup and restore MinIO
* Set `alias` for MinIO servers.
  ```
    mc alias set <src-alias-name> http://<server>:9001 <minio-root-user> <minio-root-password> --api S3v4  ( old version )
    mc alias set <dest-alias-name> http://<server>:9100 <minio-root-user> <minio-root-password> --api S3v4  ( latest versions )
    mc alias ls
  ```

#### Backup
* Create a backup directory.
  ```
    mkdir -p <backup-directory>
  ```
* Backup all MinIO buckets to `<backup-directory>` directory.
  ```
    mc mirror <src-alias-name> <backup-directory>
  ```

#### Restore

* Set `MINIO_SERVER` and `MINIO_BACKUP_DIR`.
  ```
    MINIO_SERVER=<dest-alias-name>
    MINIO_BACKUP_DIR=<backup-directory>
  ```
* Run below command to restore MinIO buckets from `<backup-directory>`.
  ```
    for bucket in $( ls $MINIO_BACKUP_DIR ); do
      echo $MINIO_SERVER/$bucket;
      mc mb --ignore-existing $MINIO_SERVER/$bucket;
      mc mirror $MINIO_BACKUP_DIR/$bucket $MINIO_SERVER/$bucket;
    done
  ```