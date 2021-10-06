# Sandbox Migration to 1.1.5.4 Guide

## Introduction

This document details the steps to migrate MOSIP version 1.1.4.x to 1.1.5.4.

## Pre-requisites
All the services should be stopped when the migration activity starts, not a single API call or data entry should be made as this might lead to data inconsistency. Before the migration, the steps documented here related to MOSIP Infra and MOSIP Configuration should be completed.

### MOSIP Infra

	* Update the open-source infra repo 1.1.5.4 branch into the required existing version branch of the forked repo
	* Update/crosscheck the secrets.yml in the current branch and resolve all the conflicts
	* Update ```config_repo``` section all.yml with details pointing to the latest existing branch
	* Update the Postgres upgrade section in all.yml as required

```
	upgrade:
	set: true  # accepts true or false value as per need.
	version: 1.1.5 # version to which upgrade is needed.
	type: release
```
	  
### MOSIP Configuration

	* Rebase the 1.1.5.3 open-source config into the current required existing branch
	* Update the ciphered text for password changes (if any)

## Migration

### Database
Steps to execute is available in respective repositories under the database release scripts section ``` eg. for mosip_master, mosip_websub check Commons ``` or
the scripts can be executed using the ``` postgres-init.yml ``` playbook after updating the upgrade section in ``` all.yml ``` (as mentioned in infra change section).

The databases which were modified from 1.1.4 to 1.1.5.4 are,
	* mosip_master
	* mosip_regproc
	* mosip_credential
	* mosip_ida
	* mosip_websub

In 1.1.5 of MOSIP, we have made a change in the id schema for particular attributes i.e. gender and resident status. These fields are now being pulled from dynamic fields instead of gender or individual_type tables in master DB. Hence, for 1.1.5.4, dynamic fields for gender and resident status should be created and UI specification needs to be modified, apart from creating running the above database migration scripts.

### Nginx

In the 1.1.5.4 version, some changes impact the nginx, so we need to redeploy nginx once after updating sandbox ```domain name``` in ```all.yml```. The list of changes that impacting nginx are:
	* MinIO nodeport exposing over console VM (in case using sandbox minIO)
	* New APIs in PMS module

The command to redeploy using playbooks from ```sb``` folder is ```an playbooks/nginx.yml```

### Minio Migration

In MOISP 1.1.4.3 release we had stopped creating buckets in the packet store (minIO) for every packet, instead, we are using one bucket for all packets. Hence, we have written a script to move all the packets from individual buckets to a common bucket called "packet-manager". If you were using any version before 1.1.4.3, you might need to run this script by following the below steps,

- Remove the minIO service running in the MZ cluster using the command ```helm1 delete minio```
- Redeploy the minIO service in the MZ cluster with ansible command ```an playbooks/minio.yml``` from ```sb``` folder
- Open port 32000 on the console so that the minIO service can be accessed over nodeport for tcp connection on this port
- Please check if the above-mentioned nginx changes are already completed before performing this minIO migration
- Follow the instruction as given in ```Readme.md``` in the minIO migration section in utils of MOSIP Infra ```utils/minio_migration```

### Deploying Latest MOSIP Modules
 
	* Update artifactory to the latest version i.e 1.1.5.4 in versions.yml and redeploy.
	* deploy mock sdk service in the mz cluster using commmand `an playbooks/mock-biosdk.yml` from sandboxv2 folder (use `sb` to reach there).
	* Install all the MZ and DMZ MOSIP modular services.

### Encryption logic
In MOISP the encryption/decryption keys are mapped against the set of application ID and reference ID. There is a change in application ID and reference ID being used for encryption/decryption in pre-registration and id-repository from 1.1.4 to 1.1.5.x.

In pre-registration, for encryption of demographic data, application ID, "REGISTRATION" and reference ID "" (blank) was used and now for encryption application ID "PRE_REGISTRATION" and reference ID "INDIVIDUAL" is used. Hence, if you are planning to migrate the pre-registration data created in the 1.1.4 version of pre-registration then a utility to migrate the data needs to be created.

In id-repository, for encryption of demographic data, uin, biometric data and document we were earlier using the application ID, "IDREPOSITORY" and reference ID "" (blank). But now we are using the same application ID but different reference IDs which is configured based on the below properties in id-repository-mz.properties.

	* mosip.idrepo.crypto.refId.uin=uin (for UIN number)
	* mosip.idrepo.crypto.refId.uin-data=identity_data (for demographic data)
	* mosip.idrepo.crypto.refId.demo-doc-data=demographic_data (for documents)
	* mosip.idrepo.crypto.refId.bio-doc-data=biometric_data (for biometrics)

By default, this scenario is handled in id-repository with key manager 1.1.5.5 fix which will allow us to still process and fetch details of the packets created before migration and encrypted only using the master key. Still a utility to decrypt the data using the master key and re-encrypt and save it in the DB after encrypting with master and reference keys is requiered.
