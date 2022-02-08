# IDA Certificate Upload

mpartner-default-ida is already onboarded via postgres-init DMLs.  Few more steps need to be carred it out to exchange certificates.  The guide is given [here](https://github.com/mosip/mosip-infra/blob/1.1.5.4/deployment/sandbox-v2/docs/idacert.md)

This folder contains scripts that automate these steps.

## Prerequisites
1. Python3.9
1. Set up python3.9 virtual env
```sh
mkdir ~/.venv
python3.9 -m venv ~/.venv/partner
```
1. Switch to virtual env 
```
source ~/.venv/partner/bin/activate
```
1. Install required modules
```sh
pip install -r requirements.txt
```
## Run
```sh
python3 lib/ida_cert.py $SERVER mosip-ida-client <password>
```



