# MOSIP Sandbox Deployer
  
Enables the creation of MOSIP sandbox on a machine with Linux OS.  Using pre-crafted docker images, it enables one to quickly setup MOSIP for trying and demonstrating. 

THIS IS NOT FOR PRODUCTION DEPLOYMENTS.  

## Overview
![](images/sandbox-overview.png)

## Pre-requisites
* OS : Ubuntu 18.0.4 LTS
* Hardware : 4 core CPU with 32 GB RAM and a about 80 GB of free hard disk space.
* Tools:  Install `curl` and `git`
      
## Get, Set, Go!
1.  Clone this repo:
    ```
    $ git clone https://github.com/mosip/mosip-infra
    ```
1.  Edit `mosip-infra/deployment/sandbox/playbooks-properties/all-playbooks.properties` with appropriate values (change only `<ToBeReplaced\>`)

    Below is a sample (example) key-value pair of the playbook properties
    ```
    spring.mail.username=xxx@gmail.com
    spring.mail.password=xxxpwd
    spring.mail.host=smtp.gmail.com
    spring.mail.port=587
    mosip.kernel.sms.gateway=SMSgatewayProviderName
    mosip.kernel.sms.api=https://SMSGatewayHostName/sms/2/text/single
    mosip.kernel.sms.username=<registered username with SMS gateway provider>
    mosip.kernel.sms.password=<registered password>
    mosip.kernel.sms.sender=<SMS Sender name, can be any name>
    registration.processor.dmz.server.password=<password>
    ```
          
1.  Change to 'sandbox' dir: `
    ```
    $ cd mosip-infra/deployment/sandbox/
    ````
### Kernel
1. First, install the MOSIP Kernel.  This is the base for all other modules.
    ```
    $ sudo sh install-mosip-kernel.sh
    ```
1. Check for errors in `install-mosip-sandbox.log`.  Go to the last line and check for `failed=0` which indicates that there are no failures during the deployment.

1. If there are no errors in the log, wait for about 5 minutes for the kernel services to be up and running. 

### Pre-registration 
1. Install the MOSIP Pre-registration component
    ```
    $ sudo sh install-mosip-pre-reg.sh
    ```    
1. Check for any errors as above.

1. If there are no errors in the log, wait for about 10 minutes for the pre-registration services to be up and running.
 
1. MOSIP Pre-registration UI can be accessed through a browser using *http://\<hostname or ip address\>/pre-registration-ui*
   
    * Sample screen of Pre-registration startup page
![](images/pre-reg-screenshot.png)
          
1. Login into the Pre-registration portal using OTP sent to email or phone.  

