#!/usr/bin/env sh
set -eu

BRANCH=CHATGPT
BASE_URL="https://raw.githubusercontent.com/fadilp5x/STUDIOARENA/${BRANCH}/release/parts"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT INT TERM

for PART in 01 02 03 04 05 06; do
  curl --fail --location --silent --show-error "${BASE_URL}/studioarena-source.tar.xz.${PART}.b64" >> "${TMP_DIR}/payload.b64"
done

if command -v base64 >/dev/null 2>&1; then
  base64 --decode "${TMP_DIR}/payload.b64" > studioarena-source.tar.xz 2>/dev/null || base64 -D "${TMP_DIR}/payload.b64" > studioarena-source.tar.xz
else
  echo 'base64 utility is required' >&2
  exit 1
fi

xz --test studioarena-source.tar.xz
echo 'Source archive assembled: studioarena-source.tar.xz'
echo 'Extract with: tar -xJf studioarena-source.tar.xz'