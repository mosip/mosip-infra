FROM postgres
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN pip3 install xlrd
WORKDIR /home/mosip/repos/db_scripts
COPY ./repos/commons/db_scripts .
COPY ./repos/pre-registration/db_scripts .
ENV MOSIP_DB_NAME=
ENV DB_SERVERIP=
ENV DB_PORT=5432
ENV SU_USER=postgres
ENV SU_USER_PWD=
ENV DEFAULT_DB_NAME=postgres
ENV SYSADMIN_USER=sysadmin
ENV SYSADMIN_PWD=
ENV DBADMIN_PWD=
ENV APPADMIN_PWD=
ENV DBUSER_PWD=
ENV LOG_PATH=/tmp/
ENV COMMON_ROLE_FILENAME=role_common.sql
ENV APP_ROLE_FILENAME=role_dbuser.sql
ENV DB_CREATION_FILENAME=db.sql
ENV ACCESS_GRANT_FILENAME=grants.sql
ENV DDL_FILENAME=ddl.sql
ENV DML_FLAG=1
ENV DML_FILENAME=dml.sql
WORKDIR /home/mosip/repos/db_scripts/
CMD cd $MOSIP_DB_NAME;bash deploy.sh 
