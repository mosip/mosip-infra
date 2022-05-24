# MinIO

## Introduction
MinIO is a High Performance Object Storage released under GNU Affero General Public License v3.0. It is API compatible with Amazon S3 cloud storage service.  MinIO is required for on-prem setups. If you are installing MOSIP on cloud you need explore cloud native options that support S3 API.  On AWS, it would be S3.  

## Helm chart based install
Recommended for sandbox installations:
* Install helm chart
```
./install.sh
``` 
* Create secrets for config server
```
cd ..
./cred.sh
```
## Operator based installation 
Recommended for multi-tenant production based installation.
See [MinIO Operator Based Installation Guide](operator/README.md).


