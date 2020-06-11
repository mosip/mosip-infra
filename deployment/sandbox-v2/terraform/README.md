## MOSIP Terraform Script-7 VM Setup
### Introduction
We are using terraform script to create desired environment.
### How does it work?
 Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Which works as Infrastructure as code (IAC).

Generally, terraform communicates azure portal to create the resources through Azure CLI is interface of Terraform and Azure Portal.
                                                     
<img width="388" alt="terraform" src="https://user-images.githubusercontent.com/58170816/84351992-19113600-abda-11ea-9bec-b555e79d228e.PNG">
                                                    
                                                        
                                      
### Pre-requisites:
1.	Terraform utility
2.	Azure CLI
3.	Azure Portal Access

### Step 1: Install Terraform
1.	Create the directory with the following command: **mkdir terraform && cd terraform**
2.	Then, download Terraform using this command: **wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip**
3.	Install a program called ‘unzip’ in order to unpack the download by entering the following: **sudo yum install unzip**
4.	Once installed, unpack the Terraform download: **unzip terraform_0.12.26_linux_amd64.zip**
5.	Set the Linux path to point to Terraform with the following command: export **PATH=$PATH:$HOME/terraform**
6.	Test that Terraform is installed by typing this command: **terraform –v**

 ![terraform-version](https://user-images.githubusercontent.com/58170816/84352547-2da1fe00-abdb-11ea-8336-8f15e21898e1.png)

### Step 2: Azure CLI installation
### 1.	Azure CLI installation for Ubuntu
       
  **curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash**

### 2.	Azure CLI installation for Linux

  **curl -L https://aka.ms/InstallAzureCli | bash**

 3.	Once the **Azure CLI** is installed, enter **az login** command will provide a **URl and code** to authenticate with your account.

 ![az-login](https://user-images.githubusercontent.com/58170816/84352663-5e823300-abdb-11ea-857d-239135f1e4ec.png)

 4.	Once you authenticated, it will list all the subscription, which has granted access for your account.

![subscription](https://user-images.githubusercontent.com/58170816/84352764-8bcee100-abdb-11ea-8a4c-9ba67db53443.png)
 
 5.	After listed the subscription, we can enter **terraform init** command where terraform config modules are present. Which will download **all the latest plugins** for the terraform modules.

 ![terraform-init](https://user-images.githubusercontent.com/58170816/84352814-a3a66500-abdb-11ea-8ada-c194a7ed2aa6.png)

6.	If the **terraform plan** command is successfully listed, means, terraform is able to communicate with Azure portal.

 ![terraform-plan](https://user-images.githubusercontent.com/58170816/84352913-d05a7c80-abdb-11ea-8d96-f6b8fe9e97ca.png)

### Step 3: Azure portal Access
•	We at least should have contributor access.
•	Using Subscription Id, we can create the resources.

### OS
**CentOS 7.7** on all machines.

## Hardware setup
### The following VMs are recommended:
•	**Kubernetes master:**
o	Number of VMs: 2
o	Configuration: 4 CPU, 8 GB RAM
•	**Kubernetes workers:**
o	Number of Vms: 4
o	Configuration: 4 CPU, 16 GB RAM

### Console
**Console machine:** 1 (2 CPU, 4 GB RAM)
### Console setup
**Console machine** is setup with below steps while creating via terraform.
The below steps are carried out through Terraform scripts.
•	Create **'mosipuser'** user.
•	Make **sudo password-less** for this user.
•	Console machine in the **same subnet as kuberntes** cluster machines.
•	Console machine is accessible with the public domain name (e.g. sandbox.mycompany.com)
•	Port **80, 443, 30090** (for postgres) is opened on the console for external access.
•	Changed **hostname** of console machine to console.
•	**Ansible, Git** installed on console machine.
•	**Tumx** installed on console machine.
•	**Firewalld** stopped and disabled in console machine.
•	Created **ssh keys** using ssh-keygen and placed them in ~/.ssh folder on console machine.
### For new VM addition:
•	We have to add new **hostnames in variables hostname** section and need to place that in vm.tf as parameter.
•	We have to create new resources for **NIC and IP** and need to place the **NIC & IP** resources in to **vm.tf** config file.
•	If you want to change the attributes such as **username, password, ssh_key, resource group, location, tags, storage account type, vm size, hostname, domain name label, prefix**, need to change those in **variables.tf** config file.

### For new port addition:
•	We have to create inbound or outbound rule in **nsg.tf** config file.
### How to convert **openssh private key** as .ppk:
**Open Putty key generator  Actions  Click on load to load the keys  save the private key as .ppk key.**
### How to convert .ppk to .pem:
**Step 1 –** First of all, install the putty tools on your Linux system using below command.
**sudo apt-get install putty-tools**
**Step 2 –** Now, convert the ppk file to pem file using **puttygen** command line tool.
**puttygen server1.ppk -O private-openssh -o server1.pem**
**Step 3 –** Change the .pem file permissions. Set the read-only permissions to the owner of the file, remove any permission to group and other. Otherwise ssh will refuse this key for use.
**chmod 400 server1.pem**
**Step 4 –** Finally, connect to your remote Linux server with ssh using this pem key.
**ssh -i server1.pem ubuntu@ipaddress**






