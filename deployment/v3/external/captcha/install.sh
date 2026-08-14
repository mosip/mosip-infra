#!/bin/bash

# Creates captcha secrets for MOSIP services (prereg, admin, resident).
## Usage: ./install.sh [kubeconfig]

set -o errexit ## set -e : exit the script if any statement returns a non-true return value
set -o nounset ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace # trace ERR through 'time command' and other functions
set -o pipefail # trace ERR through pipes

[ $# -ge 1 ] && export KUBECONFIG="$1"

ROOT_DIR=`pwd`
NS=captcha
SECRET_ARGS=()
SERVICES=("prereg:mosip-prereg-host" "admin:mosip-admin-host" "resident:mosip-resident-host")

SECRET_DIR=
function cleanup_secret_dir() {
  [ -z "$SECRET_DIR" ] || rm -rf -- "$SECRET_DIR"
}
# Fix 1: also clean up on Ctrl+C / termination, not just normal EXIT
trap cleanup_secret_dir EXIT INT TERM

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
  # Fix 3: pin to the 'default' namespace to match the sample ConfigMap / sibling scripts
  kubectl -n default get cm global >/dev/null 2>&1 || { echo "ERROR: ConfigMap 'global' not found in the 'default' namespace." >&2; exit 1; }
  local value
  value=$(kubectl -n default get cm global -o jsonpath="{.data.$1}")
  [ -n "$value" ] || { echo "ERROR: Key '$1' not found (or empty) in ConfigMap 'global'." >&2; exit 1; }
  echo "$value"
}

function secret_setup() {
  for svc in "${SERVICES[@]}"; do
    label="${svc%%:*}"
    cm_key="${svc##*:}"

    ask_yes_no "$label" || continue

    host=$(get_global_cm_value "$cm_key")
    echo "Please create captcha site and secret key for $label domain: $host"

    echo "Please enter the recaptcha $label site key for domain $host"
    read -r -s site_key
    echo # Fix 4: newline after hidden read so prompts don't run together
    echo "Please enter the recaptcha $label secret key for domain $host"
    read -r -s secret_key
    echo # Fix 4: newline after hidden read

    [ -n "$site_key" ] && [ -n "$secret_key" ] || { echo "ERROR: Site key / secret key for $label cannot be empty." >&2; exit 1; }

    if [ -z "$SECRET_DIR" ]; then
      SECRET_DIR="$(mktemp -d)"
      chmod 700 "$SECRET_DIR"
    fi
    printf '%s' "$site_key" > "$SECRET_DIR/${label}-captcha-site-key"
    printf '%s' "$secret_key" > "$SECRET_DIR/${label}-captcha-secret-key"
    SECRET_ARGS+=("--from-file=${label}-captcha-site-key=$SECRET_DIR/${label}-captcha-site-key")
    SECRET_ARGS+=("--from-file=${label}-captcha-secret-key=$SECRET_DIR/${label}-captcha-secret-key")
  done

  [ "${#SECRET_ARGS[@]}" -eq 0 ] && { echo "No captcha keys were provided; nothing to do."; return 0; }

  kubectl get ns "$NS" >/dev/null 2>&1 || kubectl create ns "$NS"

  echo "Setting up captcha secrets"
  # Fix 2 (critical): merge into the existing secret instead of replacing it wholesale,
  # so services skipped in this run keep their previously configured keys.
  if kubectl -n "$NS" get secret mosip-captcha >/dev/null 2>&1; then
    patch=$(kubectl -n "$NS" create secret generic mosip-captcha "${SECRET_ARGS[@]}" --dry-run=client -o json)
    kubectl -n "$NS" patch secret mosip-captcha --type=merge -p "$patch"
  else
    kubectl -n "$NS" create secret generic mosip-captcha "${SECRET_ARGS[@]}"
  fi
  echo "Captcha secrets for mosip configured successfully"

  return 0
}

secret_setup
