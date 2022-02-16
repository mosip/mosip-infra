FROM python:3

ARG SOURCE
ARG COMMIT_HASH
ARG COMMIT_ID
ARG BUILD_TIME
LABEL source=${SOURCE}
LABEL commit_hash=${COMMIT_HASH}
LABEL commit_id=${COMMIT_ID}
LABEL build_time=${BUILD_TIME}

# can be passed during Docker build as build time environment for github branch to pickup configuration from.
ARG container_user=mosip

# can be passed during Docker build as build time environment for github branch to pickup configuration from.
ARG container_user_group=mosip

# can be passed during Docker build as build time environment for github branch to pickup configuration from.
ARG container_user_uid=1001

# can be passed during Docker build as build time environment for github branch to pickup configuration from.
ARG container_user_gid=1001

# install packages and create user
RUN apt-get -y update \
&& groupadd -g ${container_user_gid} ${container_user_group} \
&& useradd -u ${container_user_uid} -g ${container_user_group} -s /bin/sh -m ${container_user}

COPY requirements.txt .
RUN pip3 install -r requirements.txt

# change permissions of file inside working dir
RUN chown -R ${container_user}:${container_user} /home/${container_user}

# select container user for all tasks
USER ${container_user_uid}:${container_user_gid}

WORKDIR  /home/${container_user}
COPY keycloak_init.py .

ENV KEYCLOAK_SERVER_URL=
ENV KEYCLOAK_ADMIN_USER=user
ENV KEYCLOAK_ADMIN_PASSWORD=
ENV INPUT_DIR=/opt/mosip/input
ENV INPUT_FILE=input.yaml

CMD python3 keycloak_init.py $KEYCLOAK_SERVER_URL $KEYCLOAK_ADMIN_USER $KEYCLOAK_ADMIN_PASSWORD $INPUT_DIR/$INPUT_FILE 
