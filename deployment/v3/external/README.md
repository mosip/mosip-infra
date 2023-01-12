# MOSIP External Components

## Overview
* This folder contains installation procedures for all components that are not part of core MOSIP offering - they need to be installed separately and integrated.
* MOSIP has provided reference/mock implementations of some of these components that may be used for development and testing.
* Some components may run inside the cluster itself, or outside depending on the choice of deployment.

## External components
* [Postgres](postgres/README.md)
* [IAM (Keycloak)](iam/README.md)
* [HSM](hsm/README.md)
* [Object Storage](object-store/README.md)
* [Anti-virus (Clamav)](antivirus/clamav/README.md)
* [ActiveMQ](activemq/aws/README.md)
* [Kafka](kafka/README.md)
* [BioSDK](biosdk/README.md)
* [ABIS](abis/README.md)
* [Message Gateways](msg-gateway/README.md)
* [docker secrets](docker-secrets/README.md)
* [captcha](captcha/README.md)
* [Landing page](landing-page/README.md)
## Install
* Run `install-all.sh` script to install in defined sequence.
```
cd all
./install-all.sh
```
