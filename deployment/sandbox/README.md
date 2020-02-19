# MOSIP Sandbox Deployer
  
Enables the creation of MOSIP sandbox on a Linux OS.  Using pre-crafted docker images, it enables one to quickly setup MOSIP for trying and demonstrating. 

THIS IS NOT FOR PRODUCTION DEPLOYMENTS.  

## Overview
![](images/sandbox-overview.png)

## Pre-requisites
This has been tried and verified

      * OS : Ubuntu 18.0.4 LTS
      * Hardware : 4 core CPU with 32 GB RAM and a about 200 GB of free hard disk space.
      * Make sure you have installed 'curl' and 'git'
      
## Get, Set, Go!
1. Clone the 'mosip-infra' repo

       $ git clone https://github.com/mosip/mosip-infra

1. Edit `mosip-infra/deployment/sandbox/playbooks-properties/all-playbooks.properties` with appropriate values (Change only \<ToBeReplaced\>)

1. Change over to 'sandbox' folder which has the shell scripts for installing various MOSIP components

       $ cd ~/mosip-infra/deployment/sandbox/

1. First, install the MOSIP Kernel.  This is the base for all other modules.

       $ sudo sh install-mosip-kernel.sh

Note : All log messages are logged in 'install-mosip-sandbox.log'   

***  
  
#### Pre-registration 

     $ sudo sh install-mosip-pre-reg.sh
    
MOSIP Pre-registration UI can be accessed using *https://\<hostname or ip address\>/pre-registration-ui*

Note : All log messages are log appended in 'install-mosip-sandbox.log'  
***

#### Registration Processor


Note : All log messages are log appended in 'install-mosip-sandbox.log' 
***

#### ID Authentication


Note : All log messages are log appended in 'install-mosip-sandbox.log' 
***

#### ID Repo


Note : All log messages are log appended in 'install-mosip-sandbox.log' 
***


