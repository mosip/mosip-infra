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
* [Docker secrets](docker-secrets/README.md)
* [Prereg captcha](captcha/README.md)
* [Config Server](config-server/README.md)
* [Artifactory](artifactory/README.md)
* [WebSub](websub/README.md)
* [Mock ABIS](mock-abis/README.md)
* [Key Manager](keymanager/README.md)
* [Kernel](kernel/README.md)
* [Packet Manager](packetmanager/README.md)
* [Datashare](datashare/README.md)
* [Pre-registration](prereg/README.md)
* [ID Repository](idrepo/README.md)
* [Partner Management](pms/README.md)
* [Registration Processor](regproc/README.md)
* [Admin](admin/README.md)
* [ID Authentication](ida/README.md)
* [Print](print/README.md)
* [Mosip File Server](mosip-file-server/README.md)
* [Registration Client](regclient/README.md)
* [Resident Services](resident/README.md)

The same can be achieved by running `all/install-all.sh`.
```
cd all
./install-all.sh
```

## Restart
* The `restart-all.sh` script here does rollout restart all the mosip services.
* This script is not part of regular installation. Please use the same only when restart of services are required.
```
cd all
./restart-all.sh
```

## Delete
* The `delete-all.sh` script here deletes all the mosip services helm charts.
* This script is not part of regular installation. Please use this script cautiously as per need as it deletes all the mosip services.
```
cd all
./delete-all.sh
```
