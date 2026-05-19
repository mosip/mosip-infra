# Run certbot renewal and reload nginx if certificates are renewed.
# Usage: sudo ./renew_ssl_certs.sh

set -euo pipefail

LOG_FILE="/var/log/ssl_renewal.log"
CERTBOT_BIN="$(command -v certbot || true)"

if [ -z "$CERTBOT_BIN" ]; then
  echo "ERROR: certbot is not installed. Install certbot before running this script." >&2
  exit 1
fi

DEPLOY_HOOK=""
if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files nginx.service >/dev/null 2>&1; then
  DEPLOY_HOOK="systemctl reload nginx"
elif command -v service >/dev/null 2>&1; then
  DEPLOY_HOOK="service nginx reload"
fi

{
  echo "[$(date +'%F %T')] Starting SSL certificate renewal."
  if [ -n "$DEPLOY_HOOK" ]; then
    if $CERTBOT_BIN renew --quiet --deploy-hook "$DEPLOY_HOOK"; then
      echo "[$(date +'%F %T')] certbot renew completed successfully."
    else
      echo "[$(date +'%F %T')] certbot renew failed." >&2
      exit 1
    fi
  else
    echo "[$(date +'%F %T')] nginx reload command not found; running certbot renew without reload." >&2
    if $CERTBOT_BIN renew --quiet; then
      echo "[$(date +'%F %T')] certbot renew completed successfully." 
      echo "[$(date +'%F %T')] Please reload nginx manually once certificates are updated." >&2
    else
      echo "[$(date +'%F %T')] certbot renew failed." >&2
      exit 1
    fi
  fi
} >> "$LOG_FILE" 2>&1

# If certbot renewed any certificate, deploy-hook will reload nginx.

echo "Renewal attempt finished. See $LOG_FILE for details." >&2
