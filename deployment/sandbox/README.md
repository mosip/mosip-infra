# Sandbox environment installer

#### Background

New users to MOSIP want to try out MOSIP in their local machines. A single click installer to install, configure and setup the entire MOSIP platform will be helpful. The installer should be simple enough to setup MOSIP in a high end laptop or desktop.

#### Solution


**The key solution considerations are**

- Following are the key considerations for the sandbox environment setup,

##### Sandbox components

	1. Different installers are present for various MOSIP versions. The user clones the https://github.com/mosip/mosip-infra.git repository. 
	2. The user can go inside the /mosip-infra/tree/master/deployment/sandbox folder and refer the README.md file for further instructions. 
	3. Once Ansible is installed, the Ansible playbook is played by Ansbile, which installs the necessary software required for MOSIP.
	4. The docker images of corresponding modules and components are downloaded from the docker.io website.
	5. After the installation of software, every module like Kernel, Pre-Registration, Registration Processor, IDA et., are setup. For each module, the configurations are done. Once the configurations are done, the docker images are started.

![Component diagram](images/SandboxComponents.jpg)

##### Sandbox external components

 - Following are the external components, 
	1. SMS vendor
	2. Email vendor

 - Default vendors with a minimum subscription limit it provided with each installer. 
	
##### Post installation

1. Once the installation is completed successfully, necessary startup guide is opened in browser. Following informations are mentioned,

 - URLs of the web applications like Pre-Registration
 - Instructions to open the stand alone application
 - Swagger URLs of the various services
 - User credentials for the following items, 
	- various modules
	- database
	- LDAP 
	- Keycloak
 - List of Supported MDS versions
 - Links to the online documentation for the user manual
 
2. Along with the startup guide, the Pre-Registration application is opened in the browser and the Registration client will be started. 
 
##### Modularized scripts 

The Ansible scripts are modularlized for the reuse of the components for future "Infrastructure as code" purposes, such as Production environment setup and any such environments. 

![Modularized scripts  diagram](_images/modularizedscripts.jpg)	

##### Software requirements

Operating System : Linux (ubuntu 18.04)

##### Hardware requirements

Number of CPUs - 12
RAM - 48GB
HDD - 2TB

##### Troubleshooting 

- TODO
	
