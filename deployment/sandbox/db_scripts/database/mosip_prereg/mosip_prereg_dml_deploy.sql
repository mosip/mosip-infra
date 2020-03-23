\c mosip_prereg sysadmin

\set CSVDataPath '\'/home/dbadmin/mosip_prereg/'

-------------- Level 1 data load scripts ------------------------

----- TRUNCATE prereg.language_transliteration TABLE Data and It's reference Data and COPY Data from CSV file -----
TRUNCATE TABLE prereg.language_transliteration cascade ;

\COPY prereg.language_transliteration (lang_from_code,lang_to_code,lang_id,cr_by,cr_dtimes) FROM './dml/prereg-language_transliteration.csv' delimiter ',' HEADER  csv;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------


















