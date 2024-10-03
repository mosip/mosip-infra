# Istio gateway
## Overview
* Gateways are the medium to access the k8 services outside the cluster.
* In MOSIP we create two Istio gateways by default for making services accessible.
  * Internal: to make sure services are accessible using domain `api-internal.sandbox.xyz.net` over wireguard restriting private access.
  * Public: to make sure services are accessible using domain `api.sandbox.xyz.net`
* Script here picks up domain related values from confligmap `global` created in `default` namespace.
## Install
```
./install.sh
```
