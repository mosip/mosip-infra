#!/bin/bash

set -e

# ====== CONFIGURATION ======
NAMESPACE="clear-identity-caches"

# ====== CONFIRMATION ======
echo "WARNING: This will delete the entire namespace '$NAMESPACE' and all resources inside it!"
read -r -p "Are you sure you want to continue? [y/N]: " CONFIRM
CONFIRM=${CONFIRM,,}  # convert to lowercase

if [[ "$CONFIRM" != "y" ]]; then
    echo "Aborting delete operation."
    exit 0
fi

# ====== DELETE NAMESPACE ======
echo "Deleting namespace: $NAMESPACE..."
kubectl delete ns "$NAMESPACE" --ignore-not-found

echo "Namespace '$NAMESPACE' and all its resources have been deleted successfully."