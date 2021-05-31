#!/bin/sh
# Uninstall one regproc chart
# ./uninstall.sh <chart name>
# Eg: ./uninstall regproc-validator

echo "Uninstalling $1"
helm -n regproc uninstall $1 mosip/$1

