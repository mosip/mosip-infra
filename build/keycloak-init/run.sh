#!/bin/sh
# Examples of how to run keycloak init using docker and directly wiht python.
docker run --rm  -v /Users/puneet/Documents/mosip/develop/mosip-infra/build/keycloak-init/:/opt/mosip/input -e KEYCLOAK_ADMIN_USER=admin -e KEYCLOAK_ADMIN_PASSWORD=password -e KEYCLOAK_SERVER_URL=https://iam.sandbox.mosip.net -e INPUT_FILE=user.yaml  mosipdev/keycloak-init:develop

#python keycloak_init.py https://iam.v3box1.mosip.net admin <password> input.yaml
