# ClamAV

## Overivew
[ClamAV](https://www.clamav.net/) is an open source antivirus software. We install the [wiremind](https://wiremind.github.io/wiremind-helm-charts) helm chart here. The docker image has been updated to official image as updated in [`values.yaml`](values.yaml) file.

The same may be used for development and testing; for production deployments you may need a production-grade antivirus software.

## Install
* Update `replicaCount` and docker image (if required).
* Run
```sh
./install.sh
```


