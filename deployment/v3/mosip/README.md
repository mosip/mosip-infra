# MOSIP Core

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

The same can be achieved by running `install-all.sh`

```
./install-all.sh
```

## Restart
The `restart-all.sh` script here does rollout restart all the mosip services.
Note: this script is not part of fresh installation and use the same only when restart of services are required.
```
./restart-all.sh
```

## Delete
The `delete-all.sh` script here deletes all the mosip services helm charts.
Note: This script is not part of fresh installation. Please use this script cautiously as per need as it deletes all the mosip services.
```
./delete-all.sh
```
