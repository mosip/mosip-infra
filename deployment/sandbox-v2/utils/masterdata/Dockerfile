FROM python:3

ARG branch=develop
#ARG SOURCE
#ARG COMMIT_HASH
#ARG COMMIT_ID
#ARG BUILD_TIME
#LABEL source=${SOURCE}
#LABEL commit_hash=${COMMIT_HASH}
#LABEL commit_id=${COMMIT_ID}
#LABEL build_time=${BUILD_TIME}

ARG container_user=mosip
ARG container_user_group=mosip
ARG container_user_uid=1001
ARG container_user_gid=1001

# Install packages and create user
RUN apt-get -y update \
&& groupadd -g ${container_user_gid} ${container_user_group} \
&& useradd -u ${container_user_uid} -g ${container_user_group} -s /bin/sh -m ${container_user}

COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Permissions
RUN chown -R ${container_user}:${container_user} /home/${container_user}

# Select container user for all tasks
USER ${container_user_uid}:${container_user_gid}

WORKDIR  /home/${container_user}
COPY --chown=${container_user}:${container_user} lib ./lib
COPY entrypoint.sh .

ENV BRANCH=1.2.0.1
ENV DB_HOST= 
ENV DB_PORT=5432
ENV DB_USER=postgres
ENV DB_PWD= 
ENV XLS_FOLDER=/home/${container_user}/mosip-data/mosip_master/xlsx

ENTRYPOINT ["./entrypoint.sh"]

