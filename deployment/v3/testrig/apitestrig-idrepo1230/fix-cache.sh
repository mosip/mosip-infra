#!/bin/bash
# Thin wrapper — see apply-cache-cmdline.sh for the real fix.
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
exec "$DIR/apply-cache-cmdline.sh" "$@"
