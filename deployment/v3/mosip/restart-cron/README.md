# RESTART-CRON

## Introduction
RESTART_CRON chart deploys a CronJob that runs on a schedule specified in the values.yaml file. The CronJob restarts deployments in the specified namespaces using the kubectl rollout restart command and waits for them to reach the desired state using the kubectl rollout status command..

For now this cronjob is being used to restart idgenerator service in a cluster, It can be used to restart other services like packetcreator and authdemo as well.

Idgenerator service will restart every after four hour in a cluster.

## Prerequisites
* Auth demo, Packetcreator, Idgenerator and DSLRIG to be running in the same cluster.
* If Auth demo, Idgenerator and Packetcreator service is not running in the same cluster then update the values.yaml file by enabling the only service which is present or which you want to restart.
* Set `values.yaml` to run cronjob for restarting specific services.
* run `./install.sh`.

## Install
* Install
```sh
./install.sh
```

## Delete
* Delete
```sh
./delete.sh
```
