# Istio gateway
## Overview
* Gateways are the medium to access the k8 services outside the cluster.
* In MOSIP we create two Istio gateways by default for making services accessible.
  * Internal Gateway: Ensures services are accessible using the domain api-internal.sandbox.xyz.net.
                      Access is restricted via WireGuard, allowing only private access.
  * Public Gateway: Ensures services are accessible using the domain api.sandbox.xyz.net.
* The installation script retrieves domain-related values from the global ConfigMap, created in the default namespace.
## Installation:
Run the following command to install the Istio Gateway:
```
./install.sh
```
