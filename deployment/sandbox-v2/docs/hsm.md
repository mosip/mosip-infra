# Guide to work with real HSM

### Introduction

The default sandbox uses simulator of HSM called [SoftHSM](https://github.com/mosip/mosip-mock-services/blob/master/softhsm/README.md). To connect to a real HSM you need to do the following:
  1.  Create `client.zip` 
  1.  Update MOSIP properties
  1.  Point MOSIP services to HSM

### `client.zip`

The HSM connects over the network. For services to connect to HSM they need `client.zip` which is a bundle of self dependent PKCS11 compliant libraries.  The same is installed by MOSIP services before the services start. This library must be provided by the HSM vendor.  When dockers start the `client.zip` file is pulled from the artifactory, unzipped and `install.sh` is run. 

The zip must fulfil the following:
* Contain an `install.sh`
* Available in the artificatory    

### `install.sh`

This script must fulfil the following:
* Have executable permission
* Set up all that is needed to connect to HSM
* Able to run inside dockers that are based on Debian, inherited from OpenJDK dockers.
* Place HSM client configuration file in `mosip.kernel.keymanager.softhsm.config-path` (see below)
* Not set any environment variables. If needed, they should be passed while running the MOSIP service dockers.

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
Make sure you restart the services after this change.

_WARNING: The password is extremely critical.  Make sure you use a very strong password to encrypt it (using Config Server encryption).  Further, access to Config Server should be very tightly  controlled._

## Artifactory

In the sandbox, artifactory is installed as a docker and accessed by services.  Replace the `client.zip` in this docker. You may upload the modified docker to your own registry on Docker Hub for subsequent use.

## HSM URL

HSM is used by Kernel and IDA services. Point the TCP URL of these services to new HSM host and port:
```
hsmUrl: tcp://<hsm host>:<port>  
```

The above parameter is available in the Helm Chart of respective service.


