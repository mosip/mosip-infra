# Kernel 

## Overview
Refer [Commons](https://docs.mosip.io/1.2.0/modules/commons).

## Install 
```
./install.sh
```
* During the execution of the `install.sh` script, a prompt appears requesting information regarding the presence of a public domain and a valid SSL certificate on the server.
* If the server lacks a public domain and a valid SSL certificate, it is advisable to select the `n` option. Opting it will enable the `init-container` with an `emptyDir` volume and include it in the deployment process.
* The init-container will proceed to download the server's self-signed SSL certificate and mount it to the specified location within the container's Java keystore (i.e., `cacerts`) file.
* This particular functionality caters to scenarios where the script needs to be employed on a server utilizing self-signed SSL certificates.

## Masterdata seeding
For one time seeding of master data follow the procedure given [here](masterdata/README.md). 

**CAUTION**: If you run the script again, it will erase entire masterdata and seed it fresh.



