#!/bin/bash
set -euo pipefail

# ====== CONFIGURATION ======
NAMESPACE="clear-identity-caches"
CRONJOB_NAME="clear-identity-cache"
SECRET_NAME="db-credentials"
DB_NAME="mosip_ida"
DB_USER="postgres"
CONFIGMAP_NAME="db-config"

# ====== USER INPUT WITH IMMEDIATE VALIDATION ======

# DB Host
read -p "Enter DB Host: " DB_HOST
if [[ -z "$DB_HOST" ]]; then
  echo "Error: DB_HOST cannot be empty."
  exit 1
fi

# DB Port
read -p "Enter DB Port [default 5432]: " DB_PORT
DB_PORT=${DB_PORT:-5432}
if ! [[ "$DB_PORT" =~ ^[0-9]+$ ]]; then
  echo "Error: DB_PORT must be numeric."
  exit 1
fi

# DB Password
echo "Using DB Username: $DB_USER"
read -s -p "Enter DB Password for user $DB_USER: " DB_PASSWORD
echo
if [[ -z "$DB_PASSWORD" ]]; then
  echo "Error: DB_PASSWORD cannot be empty."
  exit 1
fi

echo "All DB inputs are valid."

# ====== CREATE NAMESPACE ======
echo "Ensuring namespace exists..."
kubectl get ns "$NAMESPACE" >/dev/null 2>&1 || kubectl create ns "$NAMESPACE"

# ====== CREATE / UPDATE SECRET ======
echo "Creating/updating DB secret..."
kubectl create secret generic "$SECRET_NAME" \
  --from-literal=DB_USER="$DB_USER" \
  --from-literal=DB_PASSWORD="$DB_PASSWORD" \
  -n "$NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

# ====== CREATE / UPDATE CONFIGMAP ======
echo "Creating/updating DB ConfigMap..."
kubectl create configmap "$CONFIGMAP_NAME" \
  --from-literal=DB_HOST="$DB_HOST" \
  --from-literal=DB_PORT="$DB_PORT" \
  --from-literal=DB_NAME="$DB_NAME" \
  -n "$NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

# ====== DEPLOY CRONJOB ======
echo "Deploying CronJob in namespace: $NAMESPACE"

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: $CRONJOB_NAME
  namespace: $NAMESPACE
spec:
  schedule: "0 2 1 * *"  # Runs at 2:00 AM on the 1st day of every month
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: db-cleanup
            image: postgres:15
            envFrom:
            - configMapRef:
                name: $CONFIGMAP_NAME
            - secretRef:
                name: $SECRET_NAME
            command:
            - /bin/sh
            - -c
            - |
              set -euo pipefail

              echo "Starting cleanup of identity_cache table..."

              OUTPUT=\$(PGPASSWORD="\$DB_PASSWORD" psql -h "\$DB_HOST" -p "\$DB_PORT" -U "\$DB_USER" -d "\$DB_NAME" -c "TRUNCATE TABLE identity_cache;" 2>&1) || {
                echo "Cleanup failed!"
                echo "\$OUTPUT"
                exit 1
              }

              echo "\$OUTPUT"
              echo "Cleanup completed successfully."
          restartPolicy: OnFailure
EOF

echo "CronJob deployed successfully in namespace: $NAMESPACE"