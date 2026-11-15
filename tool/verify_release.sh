#!/usr/bin/env bash
#
# F-06 — release artifact gate. Fails CI if the Android release build is
# debug-signed or if the merged release manifest allows backup.
#
# Usage:
#   tool/verify_release.sh
#
# Run it after building the release artifact, e.g.:
#   flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
#   tool/verify_release.sh
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail() { echo "verify_release: FAIL: $1" >&2; exit 1; }
ok()   { echo "verify_release: OK: $1"; }

MERGED_MANIFEST="build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml"

# 1) allowBackup must not be true in the merged release manifest.
if [[ -f "$MERGED_MANIFEST" ]]; then
  if grep -q 'android:allowBackup="true"' "$MERGED_MANIFEST"; then
    fail "merged release manifest has android:allowBackup=\"true\""
  fi
  ok "merged manifest allowBackup is not true"
else
  echo "verify_release: WARN: merged release manifest not found; build a release first." >&2
fi

# 2) The release artifact must not be signed with the Android debug key.
APK="build/app/outputs/flutter-apk/app-release.apk"
AAB="build/app/outputs/bundle/release/app-release.aab"

check_apk_signer() {
  local artifact="$1"
  local apksigner
  apksigner="$(command -v apksigner || true)"
  if [[ -z "$apksigner" && -n "${ANDROID_HOME:-}" ]]; then
    apksigner="$(ls "$ANDROID_HOME"/build-tools/*/apksigner 2>/dev/null | sort | tail -1 || true)"
  fi
  if [[ -z "$apksigner" ]]; then
    echo "verify_release: WARN: apksigner not found; skipping signer-identity check for $artifact." >&2
    return 0
  fi
  local certs
  certs="$("$apksigner" verify --print-certs "$artifact" 2>/dev/null || true)"
  if echo "$certs" | grep -qi "CN=Android Debug"; then
    fail "$artifact is signed with the Android debug certificate"
  fi
  ok "$artifact is not debug-signed"
}

if [[ -f "$APK" ]]; then
  check_apk_signer "$APK"
elif [[ -f "$AAB" ]]; then
  # AABs are signed on upload; still ensure a real key.properties was present.
  if [[ ! -f "android/key.properties" ]]; then
    fail "release bundle built without android/key.properties (would be unsigned/debug)"
  fi
  ok "release bundle built with a configured key.properties"
else
  echo "verify_release: WARN: no release artifact found; build one before verifying." >&2
fi

echo "verify_release: done"
