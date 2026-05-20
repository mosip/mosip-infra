#!/bin/bash

# Script to update config-server environment variables and restart
# This should be run before deploying apitestrig

set -e

NAMESPACE="config-server"
DEPLOYMENT="config-server"

echo "=========================================="
echo "Updating Config Server Environment Variables"
echo "=========================================="

# Update IDREPO allowed audience override
echo "Setting IDREPO allowed audience override..."
kubectl -n ${NAMESPACE} set env deployment/${DEPLOYMENT} \
  SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_AUTH_SERVER_ADMIN_ALLOWED_AUDIENCE_IDREPO_OVERRIDE="mosip-regproc-client,mosip-prereg-client,mosip-admin-client,mosip-crereq-client,mosip-creser-client,mosip-datsha-client,mosip-ida-client,mosip-resident-client,mosip-reg-client,mpartner-default-print,mosip-idrepo-client,mpartner-default-auth,mosip-syncdata-client,mosip-masterdata-client,mosip-idrepo-client,mosip-pms-client,mosip-hotlist-client,opencrvs-partner,mpartner-default-digitalcard,mpartner-default-mobile,mosip-signup-client,mosip-testrig-client"

# Update credential request convention-based ID override
echo "Setting credential request convention-based ID override..."
kubectl -n ${NAMESPACE} set env deployment/${DEPLOYMENT} \
  SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_MOSIP_IDREPO_CREDENTIAL_REQUEST_ENABLE_CONVENTION_BASED_ID_IDREPO_OVERRIDE="true"

# Update KERNEL allowed audience override
echo "Setting KERNEL allowed audience override..."
kubectl -n ${NAMESPACE} set env deployment/${DEPLOYMENT} \
  SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_AUTH_SERVER_ADMIN_ALLOWED_AUDIENCE_KERNEL_OVERRIDE="mosip-toolkit-android-client,mosip-toolkit-client,mosip-regproc-client,mosip-prereg-client,mosip-admin-client,mosip-crereq-client,mosip-creser-client,mosip-datsha-client,mosip-ida-client,mosip-resident-client,mosip-reg-client,mpartner-default-print,mosip-idrepo-client,mpartner-default-auth,mosip-syncdata-client,mosip-masterdata-client,mosip-idrepo-client,mosip-pms-client,mosip-hotlist-client,mobileid_newlogic,opencrvs-partner,mosip-deployment-client,mpartner-default-digitalcard,mpartner-default-mobile,mosip-signup-client,mosip-testrig-client"

# Update pre-registration captcha override
echo "Setting pre-registration captcha override..."
kubectl -n ${NAMESPACE} set env deployment/${DEPLOYMENT} \
  SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_MOSIP_PREREGISTRATION_CAPTCHA_ENABLE_OVERRIDE="false"

# Update eSignet captcha override
echo "Setting eSignet captcha override..."
kubectl -n ${NAMESPACE} set env deployment/${DEPLOYMENT} \
  SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_MOSIP_ESIGNET_CAPTCHA_REQUIRED_ESIGNET_OVERRIDE=""

echo ""
echo "=========================================="
echo "Restarting Config Server Deployment"
echo "=========================================="

# Rollout restart
kubectl -n ${NAMESPACE} rollout restart deploy ${DEPLOYMENT}

# Wait for rollout to complete
echo "Waiting for rollout to complete..."
kubectl -n ${NAMESPACE} get deploy -o name | xargs -n1 -t kubectl -n ${NAMESPACE} rollout status

echo ""
echo "=========================================="
echo "Config Server Update Complete!"
echo "=========================================="
echo "You can now proceed with deploying apitestrig"
