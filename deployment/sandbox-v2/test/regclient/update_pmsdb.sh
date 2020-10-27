#!/bin/sh
# Script to update master data table:
# Usage: update_pmsdb <pmsdb sql script path>
# Example:
# $ update_pmsdb /home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/partner-management-services/db_scripts/mosip_pms 
cd $1
psql -d mosip_master -h mzworker0.sb -p 30090 -U sysadmin < mosip_pms_dml_deploy.sql  
