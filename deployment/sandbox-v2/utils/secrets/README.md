# Secrets' encryption using config server
## Context
Several secrets in `secrets.yml` of Ansible are required in config server property files.  To avoid clear text secrets in properties we use config server's encryption to encrypt the secrets using the following command:
```
curl http://mzworker0.sb:30080/config/encrypt -d  <string to be encrypted>
```
The script here converts all secrets in `secrets.yml` using above command implemented in Python.

## Prerequisites
* Install required modules using
```
$ ./preinstall.sh
```
* Make sure config server is running

## Config
1. Set the `server` url in `config.py`
1. If the url has HTTPS and server SSL certificate is self-signed then set `ssl_verify=False`.

## Run
```
$ ./convert.py <secrets_file_path>
```
In this sandbox `secrets_file_path` is `/home/mosipuser/mosip-infra/deployment/sandbox-v2/secrets.yml`

Output is saved in `out.yaml`


