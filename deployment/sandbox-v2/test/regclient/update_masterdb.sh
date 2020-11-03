#!/bin/sh
# Script to update master data table:
# Usage: update_masterdb <masterdb sql script path>
# Example:
# $ update_masterdb /home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/commons/db_scripts/mosip_master 
cd $1
psql -d mosip_master -h mzworker0.sb -p 30090 -U sysadmin < mosip_master_dml_deploy.sql  
