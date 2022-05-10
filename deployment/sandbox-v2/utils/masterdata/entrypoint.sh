#!/bin/sh
# entrypoints.sh 

git clone https://github.com/mosip/mosip-data -b $BRANCH

echo Uploading ..
cd lib
echo Running python upload ..
python upload_masterdata.py $DB_HOST $DB_PWD admin $XLS_FOLDER --db_user=$DB_USER --db_port=$DB_PORT --tables_file table_order
echo Masterdata uploaded successfully.

