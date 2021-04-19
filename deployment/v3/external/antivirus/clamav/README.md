# ClamAV

ClamAV is open source antivirus software. We provide a helm chart to install ClamAV. The same may be used for development and testing; for production deployments you may need to use a production-grade antivirus software.

## Install
```
$ helm repo add https://mosip.github.io/mosip-helm
$ helm repo udpate
$ helm dep update
$ helm -n clamav install clamav mosip/clamav
```

## Defaults
* Check `values.yaml` for defaults
```
$ helm show values mosip/clamav
```



