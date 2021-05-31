#!/bin/sh
# Install one regproc chart
# ./install.sh <chart name>
# Eg: ./install regproc-validator

echo "Installing $1"
helm -n regproc install $1 mosip/$1

