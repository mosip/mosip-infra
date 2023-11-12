# RESTART-CRON

## Introduction
RESTART_CRON chart deploys a CronJob that runs on a schedule specified in the values.yaml file. The CronJob restarts deployments in the specified namespaces using the kubectl rollout restart command and waits for them to reach the desired state using the kubectl rollout status command..

For now this cronjob is being used to restart packetcreator and authdemo service in a cluster, It can be used to restart other services as
well.

For restart Idgenerator service every after four hour in a cluster, you need to provide time after running './install.sh' Ex. ( time: */4 )

## Prerequisites
* Auth demo, Idgenerator, Packetcreator and DSLRIG to be running in the same cluster.
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
