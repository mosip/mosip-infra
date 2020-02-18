# MOSIP Sandbox Installer
  
The Ansible scripts here install MOSIP on a single machine. This is a single node Minikube and Docker based installation useful for developers and pilots. The scripts here serve as reference for larger scale deployment with different architecture. Currently, it can run all the pre registration services.

## Overview
![](images/sandbox-overview.png)

## Software requirements
Operating System : Linux (ubuntu 18.04)

## Hardware requirements
* CPU cores: 4
* RAM: 32GB
* HDD: 1TB

## Run
1. Clone this repo  
`$ git clone https://github.com/mosip/mosip-infra.git`

2. Go to the root
`$ sudo su`

3. Edit `mosip-infra/deployment/sandbox/playbooks-properties/all-playbooks.properties` with appropriate values (Change only \<ToBeReplaced\>)

4. Go into this directory `mosip-infra/deployment/sandbox/`  <br /> `$ cd mosip-infra/deployment/sandbox`

5. Run `install-mosip-kernel.sh` <br /> `$ sh install-mosip-kernel.sh`
<br /> This is a base shell script which must be run before any other script. It will configure the system for the base dependecies which are required for any module to be deployed.

6. Run `install-mosip-pre-reg.sh` <br /> `$ sh install-mosip-pre-reg.sh`
<br /> This will run all the pre registration services.

## Test
Pre-Registration:
1. Open the URL <TODO> in the browser to access Pre-Registration module viz http://<your_private_ip>/pre-registration-ui
