# Partner Management

## Install
```
$ kubectl create namespace pms
$ ./copy_cm.sh
$ helm repo update
$ helm -n pms install pms-partner mosip/pms-partner
$ helm -n pms install pms-policy mosip/pms-policy
```
