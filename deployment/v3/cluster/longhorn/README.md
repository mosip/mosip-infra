# Longhorn Persistence Storage

## Introduction
[Longhorn](https://longhorn.io) is a persistant storage provider that installs are storage class `longhorn` on the cluster.

## Prerequisites
```sh
./pre_install.sh
```
## Longhorn
* Install using Rancher UI as given [here](https://longhorn.io/docs/latest/deploy/install/install-with-rancher/)).
* Make sure you disable default storage class flag before installing on Cloud.
	```
	$ kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
	```
For on-prem, keep the defaults.
* Access Longhorn dashboard from Rancher.

## Backup
For some basic tests and, how to setup an AWS S3 backupstore in Longhorn, refer [../docs/longhorn-backupstore-and-tests.md](../docs/longhorn-backupstore-and-tests.md).

