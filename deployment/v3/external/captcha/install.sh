#!/bin/bash
# Creates captcha secrets for MOSIP services (prereg, admin, resident).
## Usage: ./install.sh [kubeconfig]

set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes

[ $# -ge 1 ] && export KUBECONFIG="$1"

NS=captcha
SECRET_ARGS=()
SERVICES=("prereg:mosip-prereg-host" "admin:mosip-admin-host" "resident:mosip-resident-host")

function ask_yes_no() {
  local ans
  while true; do
    read -r -p "Do you want to continue configuring Captcha secrets for $1 ? (y/n) : " ans
    case "$ans" in
      Y|y) return 0 ;;
      N|n) return 1 ;;
      *) echo "Please provide a correct option (Y or N)" ;;
    esac
  done
}

function get_global_cm_value() {
  kubectl get cm global >/dev/null 2>&1 || { echo "ERROR: ConfigMap 'global' not found in the current namespace/context." >&2; exit 1; }
  local value
  value=$(kubectl get cm global -o jsonpath="{.data.$1}")
  [ -n "$value" ] || { echo "ERROR: Key '$1' not found (or empty) in ConfigMap 'global'." >&2; exit 1; }
  echo "$value"
}

function secret_setup() {
  for svc in "${SERVICES[@]}"; do
    label="${svc%%:*}"
    cm_key="${svc##*:}"

    ask_yes_no "$label" || continue

    echo "Please create captcha site and secret key for $label domain: $label.sandbox.xyz.net"
    host=$(get_global_cm_value "$cm_key")

    echo "Please enter the recaptcha $label site key for domain $host"
    read -r -s site_key
    echo "Please enter the recaptcha $label secret key for domain $host"
    read -r -s secret_key

    [ -n "$site_key" ] && [ -n "$secret_key" ] || { echo "ERROR: Site key / secret key for $label cannot be empty." >&2; exit 1; }

    SECRET_ARGS+=("--from-literal=${label}-captcha-site-key=${site_key}")
    SECRET_ARGS+=("--from-literal=${label}-captcha-secret-key=${secret_key}")
  done

  [ "${#SECRET_ARGS[@]}" -eq 0 ] && { echo "No captcha keys were provided; nothing to do."; return 0; }

  kubectl get ns "$NS" >/dev/null 2>&1 || kubectl create ns "$NS"

  echo "Setting up captcha secrets"
  kubectl -n "$NS" create secret generic mosip-captcha "${SECRET_ARGS[@]}" --dry-run=client -o yaml | kubectl apply -f -
  echo "Captcha secrets for mosip configured sucessfully"
}

secret_setup
