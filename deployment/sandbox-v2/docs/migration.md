# Sandbox Migration to 1.1.5 Guide

## Introduction
Below are the steps which are needed to be followed for migrating to the required version 1.1.5

* Infra Changes
	- Rebase/Merge the open source Infra repo 1.1.5 branch into the required existing version branch of forked repo.
	- update/crosscheck the secrets.yml in the current branch and resolve all the conflicts.
	- Add keys-job.yaml from kernel, ida, idrepo into .helmignore.
	- UPDATE ```config_repo``` section all.yml with details pointing to the latest existing branch.
        - Update the postgres upgrade section in all.yml as required.
          ```
            upgrade:
            set: true  # accepts true or false value as per need.
            version: 1.1.5 # version gto which upgrade is needed.
            type: release
          ```

* Config Changes
	- Rebase the 1.1.5 open source config into the current required existing branch.
	- update the ciphered text for password changes if any.

* DB Rlease Changes
	- Execute the DB release scripts for ``` mosip_master, mosip_websub ```
	- Steps to execute is given in respective DB section in Modular repositories. ``` eg. for mosip_master, mosip_websub check Commons ```
         OR
        - Execute the ``` postgres-init.yml ``` playbook after updating the upgrade section in ``` all.yml ```. 

* Nginx changes
	- 1.1.5 version have some changes with respect to below points so we need to redeploy nginx once after updating sandbox ```domain name``` in ```all.yml```.
	- minio nodeport exposing over console VM
	- Pms module new api's
	- Command to redeploy using playbooks from ```sb``` folder is 
	- ```an playbooks/nginx.yml```

* Deploying Latest Mosip Modules
	- Uninstall all the mosip modules from mz and dmz clusters 
	- Update artifactory to the latest version i.e 1.1.5 in versions.yml and redeploy.
	- Install all the mz and dmz mosip modular services.
