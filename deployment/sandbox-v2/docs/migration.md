# Sandbox Migration to 1.1.4 Guide

## Introduction
Below are the steps which are needed to be followed for migrating to the required version 1.1.4

* Infra Changes
	- Rebase/Merge the open source Infra repo 1.1.4 branch into the required existing version branch of forked repo.
	- update/crosscheck the secrets.yml in the current branch and resolve all the conflicts.
	- Add keys-job.yaml from kernel, ida, idrepo into .helmignore.
	- UPDATE ```config_repo``` section all.yml with details pointing to the latest existing branch.

* Config Changes
	- Rebase the 1.1.4 open source config into the current required existing branch.
	- update the ciphered text for password changes if any.
	- make all the prepend thumbprint parameters to false in all the property files.

* DB Rlease Changes
	- Execute the DB release scripts for ``` mosip_master mosip_kernel mosip_keymgr mosip_ida mosip_prereg mosip_pms ```
	- Steps to execute is given in respective DB section in Modular repositories. ``` eg. for mosip_master, mosip_kernel, mosip_keymgr check Commons ```
	- Execute this Update command in key_mgr:key_alias table.
          ``` update key_alias set app_id= 'PARTNER', upd_dtimes=now() , upd_by='Migration Admin' where app_id in ('CREDENTIAL_SERVICE' , 'DATASHARE')

* Deploying Latest Mosip Modules
	- Uninstall all the mosip modules from mz and dmz clusters 
	- Update artifactory to the latest version i.e 1.1.4 and redeploy.
	- Install mz and dmz cluster Kafka module.
	- Install all the mz and dmz mosip modular services.
