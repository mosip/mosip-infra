#!/bin/bash
# Uninstalls uitestrig from the MOSIP "dev" environment.
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi

NS=uitestrig

set -e
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail

echo "Deleting uitestrig from namespace $NS"
helm -n "$NS" uninstall uitestrig || true
echo "Deleted uitestrig (if it was installed)."
