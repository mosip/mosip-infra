#!/bin/bash

VERSION=`helm show values mosip/regclient | grep "^  version" `
set $VERSION
echo 
echo Regclient download url:
echo $REGCLIENT_URL/registration-client/$2/reg-client.zip
