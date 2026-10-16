#!/bin/bash
# Deprecated: the Helm-based "info" chart conflicts with info-cronjob (same namespace and names).
# Use ../info-cronjob/install.sh instead. See that directory's README.
## Deprecated: invoke ../info-cronjob/install.sh [kubeconfig] directly.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEW="$DIR/../info-cronjob/install.sh"

echo "ERROR: deployment/v3/utils/info is deprecated and would conflict with info-cronjob."
echo "Install with:"
echo "  ENV_NAME=<env> [ASSUME_YES=1] $NEW [kubeconfig]"
echo "See $DIR/../info-cronjob/README.md"
exit 1
