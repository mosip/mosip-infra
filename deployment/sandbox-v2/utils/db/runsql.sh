######################################## Properties file ############################################
set -e

echo -e "Syntax:\n\tbash runsql.sh db.properties"

if [ $# == 0 ]; then
  echo "Property File not provided; EXITING"
  exit 1;
fi

properties_file="$1"

if [ -f "$properties_file" ]
then
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Property file \"$properties_file\" found."
    while IFS='=' read -r key value
    do
        key=$(echo $key | tr '.' '_')
        eval ${key}=\${value}
   done < "$properties_file"
else
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Property file not found, Pass property file name as argument."
    exit 1;
fi

####################### Check DB variables present in Property File ###################################
while IFS='=' read -r key value;   do
  if [ -z $value ]; then
    echo "$key is undefined; EXITING"
    exit 1;
  elif [[ $key == *"PATH" ]] &&  [[ ! -d $value  && ! -f $value  ]]; then
    echo "$key path $value not found; EXITING"
    exit 1;
  fi
done < "$properties_file"

######################################## LOG FILE CREATION ############################################
today=`date "+%m:%d:%Y_%H:%M:%S"`;
LOG="$LOG_PATH/${MOSIP_DB_NAME}-${today}.log"
touch "${LOG}"

######################################## Check DB connection ##########################################
dbConnChk=$( pg_isready -h $DB_SERVERIP -p $DB_PORT  -d $MOSIP_DB_NAME -U $DB_USER 2>&1 | grep "accepting" | wc -l)

if [[ $dbConnChk  -eq 0 ]]; then
  echo "${today} Unable to connect to $DB_SERVERIP:$DB_PORT Database; EXITING" | tee  $LOG;
  exit 1;
fi
echo "${today} connected to $MOSIP_DB_NAME Database running on server $DB_SERVERIP:$DB_PORT "  | tee -a $LOG;

######################################## DDL/DML FLAG CHECK ###########################################
### If DML_FLAG is 0 (zero). this means not to perform DML operation. If DML_FLAG is 1 (one) then perform DML operation.
### If DDL_FLAG is 0 (zero). this means not to perform DDL operation  If DML_FLAG is 1 (one) then perform DDL operation.

if [[ $DML_FLAG -eq 1 ]]; then

#### TRUNCATE TABLE ######################
PGPASSWORD=$DBUSER_PWD psql -h $DB_SERVERIP -p $DB_PORT  -d $MOSIP_DB_NAME -U $DB_USER -c "TRUNCATE TABLE $TABLE_NAME cascade ;" | tee -a $LOG;

#### IMPORT DATA FROM DML/CSV FILE #######
PGPASSWORD=$DBUSER_PWD psql -h $DB_SERVERIP -p $DB_PORT  -d $MOSIP_DB_NAME -U $DB_USER -c "\copy $TABLE_NAME from $DML_FILE_PATH delimiter ',' DML header;" | tee -a $LOG;
else
  echo "DML Operation not performed; SKIPPING" | tee -a $LOG;
fi


if [[ $DDL_FLAG -eq 1 ]]; then

#### DROP TABLE ######################
PGPASSWORD=$DBUSER_PWD psql -h $DB_SERVERIP -p $DB_PORT  -d $MOSIP_DB_NAME -U $DB_USER -c "DROP TABLE IF EXISTS $MOSIP_DB_NAME.TABLE_NAME CASCADE;" | tee -a $LOG;

#### Run DDL SQL FILE ################
PGPASSWORD=$DBUSER_PWD psql -h $DB_SERVERIP -p $DB_PORT  -d $MOSIP_DB_NAME -U $DB_USER -a -f $DDL_FILE_PATH | tee -a $LOG;

else
  echo "DDL Operation not performed; SKIPPING" | tee -a $LOG;
fi