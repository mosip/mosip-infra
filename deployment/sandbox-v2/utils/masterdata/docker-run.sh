#!/bin/sh
# Sample command to run the docker locally
docker run -d --rm --name masterdata -e branch=develop -e DB_HOST=api-internal.sandbox.mosip.net -e DB_PWD=<pwd>  mosipdev/masterdata-load:develop
