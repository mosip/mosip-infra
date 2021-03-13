FROM python:3
RUN pip3 install python-keycloak
ENV KEYCLOAK_URL=https://iam.mosip.net/auth/
ENV USER=admin
ENV PASSWORD=admin 
WORKDIR  /opt
COPY keycloak_init.py .
COPY input .
CMD python keycloak_init.py  $KEYCLOAK_URL $USER $PASSWORD input

