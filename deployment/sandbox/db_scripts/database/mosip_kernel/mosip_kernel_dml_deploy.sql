\c mosip_kernel sysadmin

\set CSVDataPath '\'/home/dbadmin/mosip_kernel/'

-------------- Level 1 data load scripts ------------------------

----- TRUNCATE kernel.key_policy_def TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE kernel.key_policy_def cascade ;

\COPY kernel.key_policy_def (app_id,key_validity_duration,is_active,cr_by,cr_dtimes) FROM './dml/kernel-key_policy_def.csv' delimiter ',' HEADER  csv;


----- TRUNCATE kernel.key_policy_def_h TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE kernel.key_policy_def_h cascade ;

\COPY kernel.key_policy_def_h (app_id,key_validity_duration,is_active,cr_by,cr_dtimes,eff_dtimes) FROM './dml/kernel-key_policy_def_h.csv' delimiter ',' HEADER  csv;


----- TRUNCATE kernel.sync_job_def TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE kernel.sync_job_def  cascade ;

\COPY kernel.sync_job_def (ID,NAME,API_NAME,PARENT_SYNCJOB_ID,SYNC_FREQ,LOCK_DURATION,LANG_CODE,IS_ACTIVE,CR_BY,CR_DTIMES,UPD_BY,UPD_DTIMES,IS_DELETED,DEL_DTIMES) FROM './dml/kernel-sync_job_def.csv' delimiter ',' HEADER  csv;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------


















