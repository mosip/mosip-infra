mpartner-default-ida is already onboarded via postgres-init DMLs.  Few more steps need to be carred it out to exchange certificates.  The guide is given [here](https://github.com/mosip/mosip-infra/blob/1.1.5.4/deployment/sandbox-v2/docs/idacert.md)

This folder contains scripts that automate these steps.

Run: 

```sh
python3 lib/ida_cert.py $SERVER mosip-ida-client <password>
```



