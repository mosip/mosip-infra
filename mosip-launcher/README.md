
```
This project(and readme) is in progress and will be updated frequently.
```

# MOSIP Launcher 
This will enable the one-click deployment of MOSIP.

## Pre-requisite
* RHEL7.6 with Ansible 2.7.9
* Make sure you have forked/mirrored mosip repository and mosip-configuration repository, and created a same branch in both the repositories, because the code that will be deployed will be looking for configuration from same named branch. Lets say, if you have created a new branch named `mydevbranch` in mosip repository, create a branch named `mydevbranch` in mosip-configuration also.

## Usage
After installation of Ansible on RHEL based system,  clone this project and navigate to *scripts/mosip-launcher* directory. And perform following actions - 

1. LDAP setup has not been automated, you have to do it manually and update configuration files in comfig-templates directory inside mosip-configuration repository accordingly. You have to update following values:
```
   ldap_1_DS.datastore.ipaddress=< ldap-ipaddress >
   ldap_1_DS.datastore.port=< ldap-port >
```

2. For SMS and Email notification service, you have to configure certain set of properties after registrying to some sms gateway and provide email and password for email servcie in config-templates/kernel-int.properties.j2 file before running this entire setup.

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
        

4. For database user creations and configurations, passwords are getting used from __ansible-playbooks/configurations/psotgres-configuration.yml__ , change the passwords accordingly.

**RUN THE SCRIPTS USING ROOT USER**

5. Once the above changes are done, run `ansible-playbook ansible-playbooks/complete-setup.yml`. This will create and configure the entire setup for you, including devops and deployments box.

**IMPORTANT NOTE**
If you want to setup the entire script again for some other setup, please clone a fresh copy of files from github, because the scripts will detect that you want to change previous configuration and will start deleting previously created and configured infrastructure.

Once everything is successful, files will be generated at /usr/local directory containing info about infrastructure setup in the launcher.
Devops info file will be named /usr/local/devops-box-information.txt
Deployments info file will be named /usr/local/deployments-box-information-<env-name>.txt

**After the setup you will see init-all-modules pipeline in jenkins that has been setup, trigger it aganinst any environment by choosing from dropdown, and it will deploy all the k8 and non k8 services.**

If you already have DevOps setup and you have to setup only deployments infra and CI/CD, you can comment out ` - import_playbook: ./setup-devops/setup-devops.yml` from `mosip-launcher/ansible-playbooks/complete-setup.yml` file, but be informed, this script will ask you information about your DevOps setup and also you have to take care of plugins you need to install and permissions needed for Jenkinsfile etc. (you can get this information from scripts/mosip-launcher/helm-charts/jenkins/values.yaml file ) in your DevOps setup. InitJenkinsfile(in root of MOSIP code), uses few environment variables, that you have to  setup manually in this scenario. These variables are:
```
def server = Artifactory.server env.artifactoryServerId // your artifactory server id
def gitCredentialsId = env.scmRepoCredentials // your git provider credential id
def gitUrl =env.scmUrl // your git url 
def registryUrl = env.dockerRegistryUrl // set your docker registry url
def registryCredentials = env.dockerRegistryCredentials // docker registry credentials
```

## Authors
  This Module is authored by [Swati Kp](https://github.com/Swatikp) and [Ajit Singh](https://github.com/as-ajitsingh)


