#!/bin/sh
# Script to update regdevice data table:
# Usage: update_regdevicedb <regdevice db sql script path>
# Example:
# $ update_regdevicedb /home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/commons/db_scripts/mosip_regdevice 
cd $1
psql -d mosip_regdevice -h mzworker0.sb -p 30090 -U sysadmin < mosip_regdevice_dml_deploy.sql  
