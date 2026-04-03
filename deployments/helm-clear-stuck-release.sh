#!/usr/bin/env bash
# If a Helm release is stuck in pending-install / pending-upgrade / pending-rollback,
# run `helm rollback` (no revision = undo the pending op). If that fails (e.g. first
# install stuck), uninstall the release so a fresh `helm upgrade --install` can run.
# Usage: helm-clear-stuck-release.sh <release-name> <namespace>
set -euo pipefail

RELEASE="${1:?release name required}"
NS="${2:?namespace required}"

if ! helm status "$RELEASE" -n "$NS" &>/dev/null; then
  echo "No Helm release '$RELEASE' in $NS; nothing to clear."
  exit 0
fi

STATUS="$(helm status "$RELEASE" -n "$NS" 2>/dev/null | sed -n 's/^STATUS: //p' | tr -d '\r' | head -1)"

if [[ "$STATUS" != pending-* ]]; then
  echo "Helm release status: ${STATUS:-unknown} (ok)"
  exit 0
fi

echo "Helm release stuck in '$STATUS'; recovering..."

if helm rollback "$RELEASE" -n "$NS" --wait --timeout 5m; then
  echo "Rollback completed."
else
  echo "Rollback failed (e.g. pending-install); uninstalling stuck release..."
  helm uninstall "$RELEASE" -n "$NS" --wait
fi
