#!/bin/sh
# Get artemis admin password
## Usage: ./get_pwd.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

echo Password: $(kubectl -n activemq get secret activemq-activemq-artemis -o jsonpath="{.data.artemis-password}" | base64 --decode)
