## MOSIP Database scripts inventory and deployment guidelines on postgresql database. 

#### The details disclosed below gives a clear information on complete database script structure with the instructions for database scripts deployments.

## Prerequisities

* DB Server and access details

* Postgres client (psql) has to be installed on the deployment servers.

* Copy latest database scripts(DDL, DML, .SH ... etc) from git/repository on to the DB deployment server.

* Necessary details to be updated in peoperties file against to the releavnt variables being used (details listed below).

* Database objects related to MOSIP modules are placed in "**mosip_base_directory**>>db_scripts>>mosip_<schema_name> folder on git/repository

**Example:** the pre-registration module script folder is /**mosip_base_directory**>>db_scripts>>mosip_prereg where all the database scripts related to pre-registration are available.

* Create a log file directory on DB deployment server before updating the properties file. Please follow the steps to create the same:
 
<em> bash-4.2$mkdir /mosip_base_directory/<folder_name> </em>

* If we wish to place the log files under different directory other than the above mentioned then we need to create directory and specify the path of the directory in the properties file.

* Pull the DB deployment scripts from Git repository to the deployment server and start deploying  OR

* If are pulling to local system from Git repository and pushing them back to deployment server using WinSCP then make a note to modify the following encoding settings in WinSCP before pushing the files to deployment server --> Open WinSCP --> Options --> Preferences --> Transfer --> Edit --> In "Transfer mode" section --> select "Text" --> Click Ok --> Click Ok 

## Each database folder has the following files / folders

* **ddl folder:** This folder contains all the database data definition language (DDL) scripts to create or alter a database object of this module.

* **dml folder:** This folder contains the scripts (insert/update/delete scripts) to create seed data / metadata needed to run this module.

* **mosip_<schema_name>_db.sql:** This file contains the database creation script of this module

* **mosip_<schema_name>_grants.sql:** The needed privilege / grants scripts assigned to database user / role to access database objects are described in this file.

* **mosip_role_<schema_name>user.sql:** The role creation script that will be used by the application to perform DML operations is defined here.

* **mosip_role_common.sql:** This file contains the common roles creation script that are needed to manage the database.

* **mosip_<schema_name>_ddl_deploy.sql:** This is a wrapper script used to **deploy the DDL scripts available in ddl folder**. This will also be used to prepare the script run sequence to manage all the needed dependency across DB objects being created.

* **mosip_<schema_name>_dml_deploy.sql:** This is a wrapper script used to **deploy the DML scripts available in dml folder**. This will also used to prepare the script run sequence to manage all the needed dependency across DB objects.

* **mosip_<schema_name>_db_deploy.sh:** This is the shell script available and present in each database folders/directories.

* **mosip_<schema_name>_deploy.properties:** This is the properties file name and present in each database.

* **mosip_all_db_deployment.sh:** This is the .sh file which is present in /home/madmin/database directory and which will be executed for all database deployment in single command execution.

**Note :** Not all Modules will have dml scripts. Make necessary changes in the properties file with dml variables for the modules where dml exists.

**Note :** No need to change anything in the shell script unless it is really causing any problem or any further implementation is being introduced.

Once we complete with sourcing the database files, we need to follow the below DB deployment process with the modifying the properties file according the requirement.

## Deployment can be performed in two ways based on the requirement and they are as follows:
1) DB Deployment for all the databases
2) DB Deployment for single or selected databases

### Properties file variable details and description: Properties file has to be updated with the required details before proceeding with deployment steps for each databases.

**DB_SERVERIP:** Contains details of Destination DB SERVER_IP(Ex:10.0.0.1) where the deployment is targeted

**DB_PORT:** Contains the postgres server port details where the postgres is allowed to connect. Ex: 5433

**SU_USER:** Contains the postgres super user name to connect to the postgres database i.e. postgres

**SU_USER_PWD:** Contains the password for postgres super user

**DEFAULT_DB_NAME:** Default database name to connect with respective postgres server i.e. ex: postgres

**MOSIP_DB_NAME:** MOSIP Database name for which the deployment is scheduled.

**SYSADMIN_USER:** This variable contains the mosip_common_role which indeed is going to be the super user for the remaining actions going to be performed by shell script.

**SYSADMIN_PWD:** Contains the credential details for SYSADMIN_USER.

**DBADMIN_PWD:** Contains the credential details for DBADMIN_USER.

**APPADMIN_PWD:** Contains the credential details for APPADMIN_USER.

**DBUSER_PWD:** Contains the credential details for dbuserpwd.

**BASE_PATH:** Path for DB scrips which are kept in the Deployment server.

**LOG_PATH:** Path where deployment log file will be created

**COMMON_ROLE_FILENAME:** Contains the common roles creation filename, ex: mosip_role_common.sql

**APP_ROLE_FILENAME:** Contains specific DB user role creation filename, ex: mosip_role_databaseuser.sql

**DB_CREATION_FILENAME:** Contains specific DB creation script name, ex: mosip_database_db.sql.

**ACCESS_GRANT_FILENAME:** This variable contains file name of access provisioning script details for the above created users, ex: mosip_<schema_name>_grants.sql.

**DDL_FILENAME:** DDL script file name, ex:mosip_<schema_name>_ddl_deploy.sql.

**DML_FLAG:** Its a flag variable which contains value as 0 or 1 for any DML existance for the particular DB. if flag=0 then no DML else flag=1.

**DML_FILENAME:** DML cript file name only if the flag=1, else it will be empty or null, ex: mosip_<schema_name>_dml_deploy.sql.

**Note - Make sure, There is a single empty line at end of the .properties files content and No spaces in beggining and end of the parameter values**

## DB Deployment for all the mosip databases with single click deployment:
		
**Step 1** -> Make prior modification to all the respective database properties files **(mosip_<schema_name>_deploy.properties)** in the respective database directories. Path of properties file and variables list remains same as explained above. Once the properties files are ready then access the directory where the deployment script is kept.

**Step 2** -> Deployment on all databases, run the **"mosip_all_db_deployment.sh"** script which is avialble in the /database directory.  To access **"mosip_all_db_deployment.sh"** script, follow the below given commands:

<em> **Enter:-bash-4.2$** cd /home/madmin/database/ </em>

<em> **Enter:-bash-4.2$** bash mosip_all_db_deployment.sh </em>

**Step 3** -> Please observe <em> Post Deployment Validation </em>  steps below

**No modification required to be done on any of the <>.sql files in the database folder. If it is required to be modified then please reach out to database team and have it modified.**

## DB_Deployment for single or selected databases

**Step 1:** update the properties(.properties) file with the required parameter values for single or selected databases. 

All these .sh and properties files are kept in each database directories. Please follow the below steps: 

**Step 2** -> Login into Deployment server/VM

**Step 3** -> check the pwd(present working directory). Make sure we are inside the right database folder/directory to run the deployment for that specific database.

**Enter:-bash-4.2$** pwd
This should be the path if we are performing deployment for the database name **mosip_schema_name** : /home/madmin/database/mosip_<schema_name>

**Step 4** -> Please move all the necessary files from local directory to the deployment server directory under respective databases. 

**Step 5** -> After prior modifications to the properties file, run the below deployment shell script as given:

**Enter:-bash-4.2$** bash mosip_<schema_name>_db_deploy.sh mosip_<schema_name>_deploy.properties

**Step 6** -> Please observe <em> Post Deployment Validation </em>  steps below

**No modification required to be done on any of the <>.sql files in the database folder. If it is required to be modified then please reach out to database team and have it modified.**

### Post Deployment Validation

**Note:** If you encounter the following messages then please recheck the details(ip address, port number, database name, password) entered in the properties file, the message would be as follows:

<psql: could not translate host name "52.172.12.285" to address: Name or service not known>.

<psql: FATAL:  password authentication failed for user "postgress">

<psql: FATAL:  database "postgress" does not exist>

**Key points during or after the script execution:**

 * Properties file found message

 * Server status

 * Accessing the right path for DB deploy

 * Creates respective roles

 * Check for any active connections

 * Creates roles, creating Database, schemas, granting access, creating respective tables.

 * Loading data or DML operations valid only for those DB's which carries DML actions.

 * End of sourcing or deployment process.
		
**Post deployment process, look out for database deployment log file which captures all stages of deployment. Log file path is defined in the properties file of the databases.**

**During all the above stages please watch out for any errors which will be capture in the log file.**

Kindly ignore **NOTICE** or **SKIPPING** messages. As these messages states that particular action is already in place hence sql script ignore performing again.

### Post deployment process, look out for each database deployment log files which captures all stages of deployment. Log file path is defined in the properties file of the respective databases.
