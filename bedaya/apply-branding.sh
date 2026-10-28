#!/usr/bin/env bash
# Applies Bedaya branding to the RustDesk sources before building.
# Usage: bedaya/apply-branding.sh <app-name> <company> [server] [public-key]
# When server/key are empty the stock RustDesk servers are kept.
set -euo pipefail

APP_NAME="$1"
COMPANY="$2"
SERVER="${3:-}"
KEY="${4:-}"

config=libs/hbb_common/src/config.rs
rc=flutter/windows/runner/Runner.rc

sed -i -E "s|RwLock::new\(\"RustDesk\"\.to_owned\(\)\)|RwLock::new(\"${APP_NAME}\".to_owned())|" "$config"
if [ -n "$SERVER" ]; then
  sed -i -E "s|^pub const RENDEZVOUS_SERVERS: &\[&str\] = &\[.*\];|pub const RENDEZVOUS_SERVERS: \&[\&str] = \&[\"${SERVER}\"];|" "$config"
fi
if [ -n "$KEY" ]; then
  sed -i -E "s|^pub const RS_PUB_KEY: &str = \".*\";|pub const RS_PUB_KEY: \&str = \"${KEY}\";|" "$config"
fi

sed -i -E \
  -e "s|VALUE \"CompanyName\", \".*\" \"\\\\0\"|VALUE \"CompanyName\", \"${COMPANY}\" \"\\\\0\"|" \
  -e "s|VALUE \"FileDescription\", \".*\" \"\\\\0\"|VALUE \"FileDescription\", \"${APP_NAME} Remote Desktop\" \"\\\\0\"|" \
  -e "s|VALUE \"LegalCopyright\", \".*\" \"\\\\0\"|VALUE \"LegalCopyright\", \"Copyright © ${COMPANY}\" \"\\\\0\"|" \
  -e "s|VALUE \"ProductName\", \".*\" \"\\\\0\"|VALUE \"ProductName\", \"${APP_NAME}\" \"\\\\0\"|" \
  "$rc"

# Optional logo overrides: bedaya/assets/icon.ico (Windows/tray icon),
# icon.svg (in-app logo) and logo.png.
if [ -f bedaya/assets/icon.ico ]; then
  cp bedaya/assets/icon.ico res/icon.ico
  cp bedaya/assets/icon.ico res/tray-icon.ico
  cp bedaya/assets/icon.ico flutter/windows/runner/resources/app_icon.ico
fi
if [ -f bedaya/assets/logo.png ]; then
  cp bedaya/assets/logo.png res/icon.png
fi
if [ -f bedaya/assets/icon.svg ]; then
  cp bedaya/assets/icon.svg flutter/assets/icon.svg
fi

grep -nE 'APP_NAME: RwLock|^pub const RENDEZVOUS_SERVERS|^pub const RS_PUB_KEY' "$config"
grep -nE 'CompanyName|FileDescription|LegalCopyright|ProductName' "$rc"
