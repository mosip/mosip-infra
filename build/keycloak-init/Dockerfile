FROM python:3
WORKDIR  /opt/mosip
COPY keycloak_init.py .
COPY requirements.txt ./
RUN pip3 install -r requirements.txt
ENV KEYCLOAK_URL=https://iam.mosip.net/auth/
ENV USER=
ENV PASSWORD=
ENV INPUT_DIR=/opt/mosip/input
WORKDIR  $INPUT_DIR
WORKDIR  /opt/mosip
CMD ./keycloak_init.py $KEYCLOAK_URL $USER $PASSWORD $INPUT_DIR/input.yaml 

