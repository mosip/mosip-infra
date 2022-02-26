# Minio server installation 

* We use Bitnami charts here to install incluster minio

## Installation
* update the hostname in gateway.yaml.
* run `install.sh` to install the minio in minio namespace.

## Create configmap and secret
Run the script and pass the access key and secret.  For region specify "".
```sh
cd ../
./cred.sh
```
