mpartner-default-ida is already onboarded via postgres-init DMLs.  Few more steps need to be carred it out to exchange certificates.  The guide is given [here](https://github.com/mosip/mosip-infra/blob/1.1.5.4/deployment/sandbox-v2/docs/idacert.md)

This folder contains scripts that automate these steps.

1. Zero Knowledge key exchange

Script `ida_zk.py` uploads IDA:CRED_SERVICE public key to the Key Manager.  This is needed for Zero Kowledge encryption.

1. Other cert exchange

Script `ida_cert` uploads other certificates from IDA --> Keymanager


