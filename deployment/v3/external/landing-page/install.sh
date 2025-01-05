#!/bin/bash
# Installs resident service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=landing-page
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

function select_index_template() {
  while true; do
    echo "Do you want to use the default index HTML? Type 'Y' for (default) or 'N' for a custom index HTML [default: Y]:"
    read -r use_default

    # Set default to "Y" if input is empty
    if [[ -z "$use_default" ]]; then
      use_default="Y"
    fi

    # Check if the user selected "Y" or "N"
    if [[ "$use_default" =~ ^[Yy]([Ee][Ss])?$ ]]; then
      echo "Using default-index.html"
      indexfile="default-index.html"
      customindexfile=""
      return
    elif [[ "$use_default" =~ ^[Nn]([Oo])?$ ]]; then
      break
    else
      echo "Invalid input. Please enter 'Y' for default or 'N' for custom index."
    fi
  done

  # Proceed to other options if the user selected "N"
  echo "Select custom index file :"
  echo "Enter 1 for collab-index.html"
  echo "Enter 2 for inji-index.html"
  echo "Enter 3 for a local custom index file"
  read -r selected_option

  case "$selected_option" in
    1)
      echo "Using collab-index.html"
      indexfile="collab-index.html"
      customindexfile=""
      ;;
    2)
      echo "Using inji-index.html"
      indexfile="inji-index.html"
      customindexfile=""
      ;;
    3)
      echo "Enter the full path of your custom index file:"
      read -r custom_index
      if [[ -f "$custom_index" ]]; then
        echo "Using custom index: $custom_index"
        customindexfile="$custom_index"
        indexfile=""
      else
        echo "Error: File not found at $custom_index"
        exit 1
      fi
      ;;
    *)
      echo "Invalid option. Exiting."
      exit 1
      ;;
  esac
}


function landing_page() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  VERSION=`git branch | grep "\*" | cut -d ' ' -f 2`
  NAME=$(kubectl get cm global -o jsonpath={.data.installation-name})
  DOMAIN=$(kubectl get cm global -o jsonpath={.data.installation-domain})
  API=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
  API_INTERNAL=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  ADMIN=$(kubectl get cm global -o jsonpath={.data.mosip-admin-host})
  PREREG=$(kubectl get cm global -o jsonpath={.data.mosip-prereg-host})
  KAFKA=$(kubectl get cm global -o jsonpath={.data.mosip-kafka-host})
  KIBANA=$(kubectl get cm global -o jsonpath={.data.mosip-kibana-host})
  ACTIVEMQ=$(kubectl get cm global -o jsonpath={.data.mosip-activemq-host})
  MINIO=$(kubectl get cm global -o jsonpath={.data.mosip-minio-host})
  KEYCLOAK=$(kubectl get cm global -o jsonpath={.data.mosip-iam-external-host})
  REGCLIENT=$(kubectl get cm global -o jsonpath={.data.mosip-regclient-host})
  POSTGRES=$(kubectl get cm global -o jsonpath={.data.mosip-postgres-host})
  POSTGRES_PORT=5432
  PMP=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-host})
  COMPLIANCE=$(kubectl get cm global -o jsonpath={.data.mosip-compliance-host})
  RESIDENT=$(kubectl get cm global -o jsonpath={.data.mosip-resident-host})
  ESIGNET=$(kubectl get cm global -o jsonpath={.data.mosip-esignet-host})
  SMTP=$(kubectl get cm global -o jsonpath={.data.mosip-smtp-host})
  HEALTHSERVICES=$(kubectl get cm global -o jsonpath={.data.mosip-healthservices-host})
  INJIWEB=$(kubectl get cm global -o jsonpath={.data.mosip-injiweb-host})
  INJIVERIFY=$(kubectl get cm global -o jsonpath={.data.mosip-injiverify-host})

select_index_template # calling function

  echo Installing landing page
  helm -n $NS install landing-page mosip/landing-page --version $CHART_VERSION  \
  --set landing.version=$VERSION \
  --set landing.name=$NAME \
  --set landing.api=$API \
  --set landing.apiInternal=$API_INTERNAL \
  --set landing.admin=$ADMIN  \
  --set landing.prereg=$PREREG  \
  --set landing.kafka=$KAFKA \
  --set landing.kibana=$KIBANA \
  --set landing.activemq=$ACTIVEMQ  \
  --set landing.minio=$MINIO \
  --set landing.keycloak=$KEYCLOAK  \
  --set landing.regclient=$REGCLIENT  \
  --set landing.postgres.host=$POSTGRES \
  --set landing.postgres.port=$POSTGRES_PORT \
  --set landing.compliance=$COMPLIANCE \
  --set landing.pmp=$PMP \
  --set landing.resident=$RESIDENT \
  --set landing.esignet=$ESIGNET \
  --set landing.smtp=$SMTP \
  --set landing.healthservices=$HEALTHSERVICES \
  --set landing.injiweb=$INJIWEB \
  --set landing.injiverify=$INJIVERIFY \
  --set istio.host=$DOMAIN \
  --set indexFile="$indexfile" \
  --set-file customindexFile="$customindexfile"

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed landing page
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
landing_page   # calling function
