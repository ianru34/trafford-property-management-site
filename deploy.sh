#!/usr/bin/env bash
set -u

SFTP_CONFIG="${SFTP_CONFIG:-$HOME/.ssh/tpm-cpanel}"
SFTP_HOST="${SFTP_HOST:-tpm-cpanel}"
REMOTE_ROOT="${REMOTE_ROOT:-public_html}"
LOG_FILE="${LOG_FILE:-deploy-cpanel.log}"

required_files=(
  "index.html"
  "app/globals.css"
  "public/favicon.svg"
  "public/trafford-property-management-logo.png"
  "public/stays-property-placeholder.svg"
  "public/warwickshire-cotswolds-door.jpg"
  "stays/index.html"
  "properties/index.html"
  "properties/stratford-townhouse/index.html"
)

optional_files=(
  "public/file.svg"
  "public/globe.svg"
  "public/window.svg"
)

echo "Checking local files..."
missing=0
for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file" >&2
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "Deploy aborted because required files are missing." >&2
  exit 1
fi

batch_file="$(mktemp "${TMPDIR:-/tmp}/tpm-deploy.XXXXXX.sftp")"
cleanup() {
  rm -f "$batch_file"
}
trap cleanup EXIT

{
  echo "cd $REMOTE_ROOT"
  echo "-mkdir app"
  echo "-mkdir public"
  echo "-mkdir stays"
  echo "-mkdir properties"
  echo "-mkdir properties/stratford-townhouse"
  echo "put index.html index.html"
  echo "put app/globals.css app/globals.css"
  echo "put public/favicon.svg public/favicon.svg"
  echo "put public/trafford-property-management-logo.png public/trafford-property-management-logo.png"
  echo "put public/stays-property-placeholder.svg public/stays-property-placeholder.svg"
  echo "put public/warwickshire-cotswolds-door.jpg public/warwickshire-cotswolds-door.jpg"
  for file in "${optional_files[@]}"; do
    if [[ -f "$file" ]]; then
      echo "put $file $file"
    fi
  done
  echo "put stays/index.html stays/index.html"
  echo "put properties/index.html properties/index.html"
  echo "put properties/stratford-townhouse/index.html properties/stratford-townhouse/index.html"
} > "$batch_file"

echo "Deploying to $SFTP_HOST:$REMOTE_ROOT ..."
echo "Writing log to $LOG_FILE"

if sftp -F "$SFTP_CONFIG" -b "$batch_file" "$SFTP_HOST" > "$LOG_FILE" 2>&1; then
  echo "Deploy completed successfully."
  echo "Uploaded files:"
  printf '  %s\n' "${required_files[@]}"
  for file in "${optional_files[@]}"; do
    [[ -f "$file" ]] && printf '  %s\n' "$file"
  done
else
  status=$?
  echo "Deploy failed with exit code $status." >&2
  echo "Last 40 lines from $LOG_FILE:" >&2
  tail -n 40 "$LOG_FILE" >&2
  exit "$status"
fi

if grep -E "Couldn't|No such file|Permission denied|not found" "$LOG_FILE" >/dev/null 2>&1; then
  echo "Deploy completed, but the log contains warnings/errors to review:" >&2
  grep -E "Couldn't|No such file|Permission denied|not found" "$LOG_FILE" >&2
  exit 2
fi
