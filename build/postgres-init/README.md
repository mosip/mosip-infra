# Postgres Init

## Overview
Folder here contains Dockerfile to build a docker that will intialize all the Postgres tables by running respective SQL scripts.

## Build
1. Before building the docker create `repos` folder here and clone all the following repos:
    ```
    mkdir -p repos
    cd repos
    git clone -b <branch> https://github.com/mosip/commons 
    git clone -b <branch> https://github.com/mosip/keymanager
    git clone -b <branch> https://github.com/mosip/pre-registration
    git clone -b <branch> https://github.com/mosip/registration
    git clone -b <branch> https://github.com/mosip/partner-management-services
    git clone -b <branch> https://github.com/mosip/id-authentication
    git clone -b <branch> https://github.com/mosip/id-repository
    git clone -b <branch> https://github.com/mosip/admin-services
    ```
1. Review/change `TAG` that you need to create.
1. Run `docker_build.sh`

## Run SQL scripts from command line
1. Set the following environment variables (given with an example below): 
* `MOSIP_DB_NAME`: This is the DB folder name from which scripts have to be executed. Eg. `mosip_master`.
* `DB_SERVERIP`: Host name/IP of postgres server.
* `DB_PORT: Default 5432.
* `SU_USER`: Super user. Default `postgres`
* `SU_USER_PWD`: Super user password.
* `DEFAULT_DB_NAME`: Specify `postgres`.
* `DBUSER_PWD`: This is passed to the SQL scripts to create DB user, like, `masteruser`.
* `DML_FLAG`: Some databases may required default data to be populated using DMLs. Set this flag to `0` or `1`. 

1. Run the deploy script from inside `db_scripts` folder.
    ```
    cd repos/commons/db_scripts
    ./deploy.sh 
    ```

