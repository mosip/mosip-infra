
```
This project(and readme) is in progress and will be updated frequently.
```

# MOSIP Launcher 
This will enable the one-click deployment of MOSIP.

## Pre-requisite
* RHEL7.6 with Ansible 2.7.9 <br/>
Lets get started with installing and configuring ansible on your machine. Run the following commands one by one on your RHEL 7.6 machine

   1. Switch to root user <br/>
      `sudo su`
   2. Install Ansible 7.9.1 using rpm  <br/>
      `yum install https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.7.9-1.el7.ans.noarch.rpm`
   3. Install required python Modules  <br/>
      `easy_install pip`
   4. Install jmespath version 0.9.4 using pip  <br/>
      `pip install jmespath==0.9.4`
    <br/>  
      
*  Make sure you have forked **mosip-platforms** repository, **mosip-ref-impl** repository and **mosip-config** repository, and created a same branch in all the repositories, because the code that will be deployed will be looking for configuration from same named branch as code.<br/>
Lets say, if you have created a new branch named `mydevbranch` in mosip-platform repository, create a branch named `mydevbranch` in mosip-config and mosip-ref-impl repo also.

## Usage
After installation of Ansible on RHEL based system,  clone this project and navigate to *mosip-launcher* directory. And perform following actions - 

1. LDAP setup has not been automated, you have to do it manually and update configuration files in comfig-templates directory  inside mosip-config repository accordingly. You have to update following values:
```
   ldap_1_DS.datastore.ipaddress=< ldap-ipaddress >
   ldap_1_DS.datastore.port=< ldap-port >
```
and also look for all the ldap related tokens or secrets to be manually replaced. (Replace all the values in the form of `< my-value >` i.e. starting and ending with double angular brackets )

2. For SMS and Email notification service, you have to configure certain set of properties after registrying to some sms gateway and provide email and password for email service in config-templates/kernel-env.properties file in config-templates directory inside mosip-config repository before running this entire setup. (Replace all the values in the form of `< my-value >` i.e. starting and ending with double angular brackets )

3. Create a new file named __ansible-playbooks/configurations/common-configurations.yml__  from template file  __ansible-playbooks/configurations/common-configurations.template__ <br/>

        Once done change the following values accordingly.

       i. Create client_id, secret, tenant id in azure and change the following values:
        For more information on how to generate these in azure, follow this link: (service_principal_client_Secret_azure)[https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html]

        
        client_id: <your_client_id>
        client_secret: <your_client_secret>
        subscription_id: <your_subscription_id>
        tenant_id: <your_tenant_id>
        

       ii. Also add the environments you want to create and configure in the same file under environments

        
        environments:
            - dev
        

**RUN THE SCRIPTS USING ROOT USER**

4. Once the above changes are done, run `ansible-playbook ansible-playbooks/complete-setup.yml`. This will create and configure the entire setup for you, including devops and deployments box.

**IMPORTANT NOTE**
If you want to run the entire script again for a fresh setup, please clone a fresh copy of files from github in a different location, because if you try to run the scripts again from the same location, the scripts will detect that you want to change previous configuration and will start deleting previously created and configured infrastructure.

Once everything is successful, files will be generated at /usr/local directory containing info about the entire infrastructure that has been setup by the launcher.
DevOps info file will be named /usr/local/devops-box-information.txt
Deployments info file will be named /usr/local/deployments-box-information-< env-name >.txt

**After the setup you will see init-all-modules pipeline in jenkins that has been setup, trigger it aganinst any environment by choosing from dropdown, and it will deploy all the k8 and non k8 services.**

If you already have DevOps setup and you have to setup only deployments infra and CI/CD, you can comment out ` - import_playbook: ./setup-devops/setup-devops.yml` from `scripts/mosip-launcher/ansible-playbooks/complete-setup.yml` file, but be informed, this script will ask you information about your DevOps setup and you have to manually take care of plugins you need to install in your Jenkins instance which are:
    
    
    - kubernetes:1.15.6
    - workflow-job:2.32
    - workflow-aggregator:2.6
    - credentials-binding:1.19
    - git:3.10.0
    - artifactory:3.2.2
    - kubernetes-cli:1.6.0
    - matrix-auth:2.4.2
    - publish-over-ssh:1.20.1
    - pipeline-utility-steps:2.2.0
    - ws-cleanup:0.37
   
    
and Script approvals needed for Jenkinsfile in your Jenkins instance, which are:
 
 
    - "new java.io.File java.lang.String"
    - "method java.io.File exists"
    - "method org.apache.maven.model.Model getParent"
    
    

InitJenkinsFile (kept jenkinsfile folder in root of mosip-infra repository) uses few environment variables, that you have to  setup manually in this scenario. These variables are:
```
def server = Artifactory.server env.artifactoryServerId // your artifactory server id
def gitCredentialsId = env.scmRepoCredentials // your git provider credential id
def gitUrl =env.scmUrl // your git url 
def registryUrl = env.dockerRegistryUrl // set your docker registry url
def registryCredentials = env.dockerRegistryCredentials // docker registry credentials
```

**Registration Client is a thick client which is not automated by MOSIP launcher, it has to be setup manually. For more information see [this](https://github.com/mosip/mosip-docs/wiki/Registration-Client-Setup) link**

## Authors
  This Module is authored by [Swati Kp](https://github.com/Swatikp) and [Ajit Singh](https://github.com/as-ajitsingh)


