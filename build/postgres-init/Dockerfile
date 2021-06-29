FROM postgres

ARG SOURCE
ARG COMMIT_HASH
ARG COMMIT_ID
ARG BUILD_TIME
LABEL source=${SOURCE}
LABEL commit_hash=${COMMIT_HASH}
LABEL commit_id=${COMMIT_ID}
LABEL build_time=${BUILD_TIME}

RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN pip3 install xlrd
WORKDIR /home/mosip/repos/db_scripts
COPY ./repos/commons/db_scripts .
COPY ./repos/pre-registration/db_scripts .
COPY ./repos/registration/db_scripts .
COPY ./repos/id-repository/db_scripts .
COPY ./repos/id-authentication/db_scripts .
COPY ./repos/partner-management-services/db_scripts .
COPY ./repos/websub/db_scripts .
ENV MOSIP_DB_NAME=
ENV DB_SERVERIP=
ENV DB_PORT=5432
ENV SU_USER=postgres
ENV SU_USER_PWD=
ENV DEFAULT_DB_NAME=postgres
ENV DBUSER_PWD=
ENV DML_FLAG=
WORKDIR /home/mosip/repos/db_scripts/
CMD cd $MOSIP_DB_NAME;bash deploy.sh 
