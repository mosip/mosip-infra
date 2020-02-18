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
1. Edit `mosip-infra/deployment/sandbox/playbooks-properties/all-playbooks.properties` with appropriate values (Change only \<ToBeReplaced\>)
1. Run `/mosip-infra/deployment/sandbox/install-mosip-kernel.sh`     
`$ sudo sh install-mosip-kernel.sh`
This is base shell script which must be run before any other script. It will configure the system for the base dependecies which are required for any to be deployed.
1. Run `/mosip-infra/deployment/sandbox/install-mosip-pre-reg.sh`
`$ sudo install-mosip-pre-reg.sh`
This will run all the pre registration services.

## Test
Pre-Registration:
1. Open the URL <TODO> in the browser to access Pre-Registration module viz http://<your_private_ip>/pre-registration-ui
