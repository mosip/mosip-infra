\c mosip_regprc sysadmin

\set CSVDataPath '\'/home/dbadmin/mosip_regprc/'

-------------- Level 1 data load scripts ------------------------


\COPY regprc.transaction_type (code,descr,lang_code,is_active,cr_by,cr_dtimes) FROM './dml/regprc-transaction_type.csv' delimiter ',' HEADER  csv;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------


















