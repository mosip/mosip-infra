# mosipcertmanager
Helm chart for installing mosipcertmanager

## Introduction
It's a cronjob that checks DBs for partner certificate expiry dates and renews the certificates if expired.

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