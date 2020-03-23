### -- ---------------------------------------------------------------------------------------------------------
### -- Script Name		: Audit DB Artifacts deploy
### -- Deploy Module 	: MOSIP Audit
### -- Purpose    		: To deploy MOSIP Audit Database DB Artifacts.       
### -- Create By   		: Sadanandegowda DM
### -- Created Date		: 25-Oct-2019
### -- 
### -- Modified Date        Modified By         Comments / Remarks
### -- -----------------------------------------------------------------------------------------------------------

### -- -----------------------------------------------------------------------------------------------------------

#########Properties file #############
set -e
properties_file="$1"
echo `date "+%m/%d/%Y %H:%M:%S"` ": $properties_file"
#properties_file="./app.properties"
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
fi
echo `date "+%m/%d/%Y %H:%M:%S"` ": ------------------ Database server and service status check for ${MOSIP_DB_NAME}------------------------"
##############################################LOG FILE CREATION#############################################################

today=`date '+%d%m%Y_%H%M%S'`;
LOG="${LOG_PATH}${MOSIP_DB_NAME}-${today}.log"
touch $LOG

SERVICE=$(PGPASSWORD=$SU_USER_PWD  psql --username=$SU_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -t -c "select count(1) from pg_roles where rolname IN('sysadmin')";exit; > /dev/null)
  
if [ "$SERVICE" -eq 0 ] || [ "$SERVICE" -eq 1 ]
then
echo `date "+%m/%d/%Y %H:%M:%S"` ": Postgres database server and service is up and running" | tee -a $LOG 2>&1
else
echo `date "+%m/%d/%Y %H:%M:%S"` ": Postgres database server or service is not running" | tee -a $LOG 2>&1
fi

echo `date "+%m/%d/%Y %H:%M:%S"` ": ----------------------------------------------------------------------------------------"

     echo `date "+%m/%d/%Y %H:%M:%S"` ": Started sourcing the $MOSIP_DB_NAME Database scripts" | tee -a $LOG 2>&1
#echo "date:" `date "+%m/%d/%Y %H:%M:%S"`
     echo `date "+%m/%d/%Y %H:%M:%S"` ": Database scripts are sourcing from :$BASEPATH" | tee -a $LOG 2>&1

#========================================DB Deployment process begins on AUDIT DB SERVER======================================

echo `date "+%m/%d/%Y %H:%M:%S"` ": Database deployment on $MOSIP_DB_NAME database is started...." | tee -a $LOG 2>&1
cd /$BASEPATH/$MOSIP_DB_NAME/
VALUE=$(PGPASSWORD=$SU_USER_PWD  psql --username=$SU_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -t -c "select count(1) from pg_roles where rolname IN('sysadmin','appadmin','dbadmin')";exit; >>$LOG 2>&1)
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Checking for existing users.... Count of existing users:"$VALUE | tee -a $LOG 2>&1
if [ ${VALUE} == 0 ]
then
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Creating database users" | tee -a $LOG 2>&1
    PGPASSWORD=$SU_USER_PWD psql --username=$SU_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -f $COMMON_ROLE_FILENAME -v sysadminpwd=\'$SYSADMIN_PWD\' -v dbadminpwd=\'$DBADMIN_PWD\' -v appadminpwd=\'$APPADMIN_PWD\' >>$LOG 2>&1
elif [ ${VALUE} == 1 ]
then
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Creating database users" | tee -a $LOG 2>&1
	PGPASSWORD=$SU_USER_PWD psql --username=$SU_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -f $COMMON_ROLE_FILENAME -v sysadminpwd=\'$SYSADMIN_PWD\' -v dbadminpwd=\'$DBADMIN_PWD\' -v appadminpwd=\'$APPADMIN_PWD\' >>$LOG 2>&1
elif [ ${VALUE} == 2 ]
then
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Creating database users" | tee -a $LOG 2>&1
    PGPASSWORD=$SU_USER_PWD psql --username=$SU_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -f $COMMON_ROLE_FILENAME -v sysadminpwd=\'$SYSADMIN_PWD\' -v dbadminpwd=\'$DBADMIN_PWD\' -v appadminpwd=\'$APPADMIN_PWD\' >>$LOG 2>&1 	
else
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Database users already exist" | tee -a $LOG 2>&1
fi

CONN=$(PGPASSWORD=$SYSADMIN_PWD psql --username=$SYSADMIN_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -t -c "SELECT count(pg_terminate_backend(pg_stat_activity.pid)) FROM pg_stat_activity WHERE datname = '$MOSIP_DB_NAME' AND pid <> pg_backend_pid()";exit; >>$LOG 2>&1)

if [ ${CONN} == 0 ]
then
    echo `date "+%m/%d/%Y %H:%M:%S"` ": No active database connections exist on ${MOSIP_DB_NAME}" | tee -a $LOG 2>&1
else
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Active connections exist on the database server and active connection will be terminated for DB deployment." | tee -a $LOG 2>&1
fi 

MASTERCONN=$(PGPASSWORD=$SU_USER_PWD  psql --username=$SU_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -t -c "select count(1) from pg_roles where rolname IN('audituser')";exit; >>$LOG 2>&1)

if [ ${MASTERCONN} == 0 ]
then
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Creating audit database user" | tee -a $LOG 2>&1
    PGPASSWORD=$SYSADMIN_PWD psql --username=$SYSADMIN_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -f $APP_ROLE_FILENAME -v dbuserpwd=\'$DBUSER_PWD\' >>$LOG 2>&1
else
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Audit user already exist" | tee -a $LOG 2>&1
fi
PGPASSWORD=$SYSADMIN_PWD psql --username=$SYSADMIN_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -f $DB_CREATION_FILENAME >> $LOG 2>&1
PGPASSWORD=$SYSADMIN_PWD psql --username=$SYSADMIN_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -f $ACCESS_GRANT_FILENAME >> $LOG 2>&1
PGPASSWORD=$SYSADMIN_PWD psql --username=$SYSADMIN_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -f $DDL_FILENAME >> $LOG 2>&1


if [ ${DML_FLAG} == 1 ]
then
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Deploying DML for ${MOSIP_DB_NAME} database" | tee -a $LOG 2>&1
    PGPASSWORD=$SYSADMIN_PWD psql --username=$SYSADMIN_USER --host=$DB_SERVERIP --port=$DB_PORT --dbname=$DEFAULT_DB_NAME -a -b -f $DML_FILENAME >> $LOG 2>&1
else
    echo `date "+%m/%d/%Y %H:%M:%S"` ": There are no DML deployment required for ${MOSIP_DB_NAME}" | tee -a $LOG 2>&1
fi

if [ $(grep -c ERROR $LOG) -ne 0 ]
then
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Database deployment is completed with ERRORS, Please check the logs for more information" | tee -a $LOG 2>&1
	echo `date "+%m/%d/%Y %H:%M:%S"` ": END of MOSIP database deployment" | tee -a $LOG 2>&1
else
    echo `date "+%m/%d/%Y %H:%M:%S"` ": Database deployment completed successfully, Please check the logs for more information" | tee -a $LOG 2>&1
    echo `date "+%m/%d/%Y %H:%M:%S"` ": END of MOSIP \"${MOSIP_DB_NAME}\" database deployment" | tee -a $LOG 2>&1
fi 	

echo "******************************************"`date "+%m/%d/%Y %H:%M:%S"` "*****************************************************" >> $LOG 2>&1
