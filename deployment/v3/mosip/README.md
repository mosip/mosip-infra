# MOSIP Services

## Overview
The steps here install all MOSIP provided services - core and reference implementations.

## Pre-requisites
* In case you are using private docker images for MOSIP services,
  * Prepare the list of details for all the private registries to be used as per the [prerequisites](docker-secrets/README.md#Prerequisites).
  * Update the secret name in `values.yaml` for all the charts pulling docker images from respective private registry.
* Create the `site key` and `secret key` as per [Captcha prerequisites](captcha/README.md#Prerequisites).
* Update the `values.yaml` file of config-server chart as per the git repository details in [config-repo](config-repo/values.yaml).

## Install
Install in the following order:
* [Config Server Secrets](conf-secrets/README.md)
* [Config Server](config-server/README.md)
* [Artifactory](artifactory/README.md)
* [Key Manager](keymanager/README.md)
* [WebSub](websub/README.md)
* [Kernel](kernel/README.md)
* [Masterdata-loader](masterdata-loader/)
* [Packet Manager](packetmanager/README.md)
* [Datashare](datashare/README.md)
* [Pre-registration](prereg/README.md)
* [ID Repository](idrepo/README.md)
* [Partner Management](pms/README.md)
* [Mock ABIS](mock-abis/README.md)
* [Mock MV](mock-mv/README.md)
* [Registration Processor](regproc/README.md)
* [Admin](admin/README.md)
* [ID Authentication](ida/README.md)
* [Print](print/README.md)
* [Partner Onboarder](partner-onboarder/README.md)
* [Mosip File Server](mosip-file-server/README.md)
* [Resident Services](resident/README.md)
* [Registration Client](regclient/README.md)
## Install
The same can be achieved by running `all/install-all.sh`.
```
cd all
./install-all.sh
```

## Restart
* The `restart-all.sh` script here does rollout restart all the MOSIP services.
* This script is not part of regular installation. Please use the same only when restart of services is required.
```
cd all
./restart-all.sh
```

## Delete
* The `delete-all.sh` script here deletes all MOSIP services Helm charts.
* This script is not part of regular installation. Please use this script cautiously as per need.
```
cd all
./delete-all.sh
```
