# Guide to work with real HSM

### Introduction

The default sandbox uses simulator of HSM called [SoftHSM](https://github.com/mosip/mosip-mock-services/blob/master/softhsm/README.md). To connect to a real HSM you need to do the following:
  1.  Update `client.zip` of HSM in artifactory
  1.  MOSIP properites update 
  1.  Point MOSIP services to HSM

### `client.zip`

The HSM connects over the network. In order for applications to connect to HSM  they need `client.zip` which is a bundle of self dependent PKCS11 compliant libraries used to connect to the HSM.  The same is installed by mosip services before the services start. This library must be provided by the HSM vendor.  When dockers start the `client.zip` file is pulled from the artifactory, unzipped and `install.sh` is run. 

This file must fulfil the following:
* Contain an `install.sh` as mentioned below
* Available in the artificatory    

### `install.sh`

This script must fulfil the following:
* Have executable permission
* Sets up all that is needed to connect to HSM
* Able run inside dockers that are based on Debian, inherited from OpenJDK dockers.
* Place HSM client configuration file in `mosip.kernel.keymanager.softhsm.config-path` (see below)
* Not set any environment variables. If needed, they should be passed while running the mosip service dockers.

##  Properties

Update the following properties in Kernel and IDA property files:
```
mosip.kernel.keymanager.softhsm.config-path=/config/softhsm-application.conf
mosip.kernel.keymanager.softhsm.keystore-pass={cipher}<ciphered password>
mosip.kernel.keymanager.softhsm.certificate.common-name=www.mosip.io
mosip.kernel.keymanager.softhsm.certificate.organizational-unit=MOSIP
mosip.kernel.keymanager.softhsm.certificate.organization=IITB
mosip.kernel.keymanager.softhsm.certificate.country=IN
```

WARNING: The password is extremely critical.  Make sure you use a very strong password to encrypt it (using Config Server encryption).  Further, access to Config Server should be extremely tightly  controlled.

## Artifactory

In the sandbox, artifactory is installed as docker and accessed by services.  Replace the `client.zip` in this docker. You may may wish to upload this modified docker to your own registry on Docker Hub for subsequent use.

## Point services to HSM

Kernel and IDA services use HSM. Point the TCP URL in Helm Charts of these services to new HSM host and port:
```
hsmUrl: tcp://<hsm host>:<port>  
```


