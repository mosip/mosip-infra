#!/bin/bash

# Install or update a cron job that runs the SSL renewal script daily.
# Usage: sudo ./certs_renew_cron.sh

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "ERROR: This script must be run as root." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RENEW_SCRIPT="$SCRIPT_DIR/renew_ssl_certs.sh"
LOG_FILE="/var/log/ssl_renewal.cron.log"
CRON_SCHEDULE="0 0 * * *"
CRON_COMMAND="$RENEW_SCRIPT >> $LOG_FILE 2>&1"
CRON_LINE="$CRON_SCHEDULE $CRON_COMMAND"

test -f "$RENEW_SCRIPT" || {
  echo "ERROR: Renewal helper not found at $RENEW_SCRIPT" >&2
  exit 1
}

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

# Preserve existing crontab lines, but remove any old renewal entry for this helper.
crontab -l 2>/dev/null | grep -v -F "$RENEW_SCRIPT" > "$tmpfile" || true

echo "$CRON_LINE" >> "$tmpfile"
crontab "$tmpfile"

echo "Installed/updated SSL renewal cron job:"
echo "  $CRON_LINE"
echo "Renewal output will be logged to: $LOG_FILE"
