# mosipcertmanager
Helm chart for installing mosipcertmanager

## Introduction
its a Cronjob which will go though the DB & Check for partner certifiactes expiry Dates
if certificates expired will renew the Certifcates.

## Install
RUN Install script
```
./install.sh
```

# TL;DR
```console
$ helm repo add mosip https://mosip.github.io
$ helm install my-release mosip/mosipcertmanager
```