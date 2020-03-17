# MOSIP Sandbox Deployer
  
Enables the creation of MOSIP sandbox on a single machine running Linux.  Using pre-crafted docker images, it enables one to quickly setup MOSIP for trying and demonstrating. 

THIS IS NOT FOR PRODUCTION DEPLOYMENTS.  

## Overview
![](images/sandbox-overview.png)

## Pre-requisites
* OS : Ubuntu 18.0.4 LTS
* Hardware : 4 core CPU with 32 GB RAM and about 80 GB of free hard disk space.
* Tools:  Install `curl` and `git`
      
## Get, Set, Go!
1.  Clone this repo:
    ```
    $ git clone https://github.com/mosip/mosip-infra
    ```
1. Go to the root:
    ```
    $ sudo su
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
    
    (Tip-> If you do not have sms configuration, you can replace these four sms configurations i.e. gateway, api, username, password and sedner with dummy values)
    
1.  Change to 'sandbox' dir: 
    ```
    $ cd mosip-infra/deployment/sandbox/
    ````
### MOSIP Kernel
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

## Steps to access the Pre-registration-ui
1. As this sandbox works on private ip address, you have to access the pre registration ui from the google chrome installed inside the 
   machine on which you are working. 
   
1. Please follow this link for <a href="https://linuxconfig.org/how-to-install-google-chrome-web-browser-on-ubuntu-18-04-bionic-beaver-linux">Installing the Google Chrome in your Ubuntu Machine</a>

1. Please follow this link for <a href="https://gist.github.com/hehuan2112/54cca01be23973a9f8b369e8d0df216e">Installing the Remote     Desktop in your Ubuntu Machine</a>. 
   After restarting the xRDP service, which is the last instruction in the above link, connect your ubuntu machine from RDP        application present in your Windows system.
   
   Great, now you have UI access for your Ubuntu. 
   (Tip-> You will need to open 3389 port number from the cloud side)
   
1. After connecting ubuntu machine from RDP application, open google-chrome browser.
 
1. MOSIP Pre-registration UI can be accessed using *http://\<private ip address\>/pre-registration-ui*
    * Note :  To find the private ip address, you may use the following command 
          
          $ hostname -I | awk '{print $1}'
             
    * Sample screen of Pre-registration startup page
![](images/pre-reg-screenshot.png)
          
1. Login into the Pre-registration portal using OTP sent to email or phone.  

