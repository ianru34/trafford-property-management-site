#!/usr/bin/env bash
set -u

SFTP_CONFIG="${SFTP_CONFIG:-$HOME/.ssh/tpm-cpanel}"
SFTP_HOST="${SFTP_HOST:-tpm-cpanel}"
REMOTE_ROOT="${REMOTE_ROOT:-public_html}"
LOG_FILE="${LOG_FILE:-deploy-cpanel.log}"

required_files=(
  "index.html"
  "sitemap.xml"
  "robots.txt"
  "app/globals.css"
  "public/favicon.svg"
  "public/trafford-property-management-logo.png"
  "public/stays-property-placeholder.svg"
  "public/warwickshire-cotswolds-door.jpg"
  "public/benefit-management-photo.jpg"
  "public/benefit-revenue-photo.jpg"
  "public/benefit-bookings-photo.jpg"
  "public/benefit-maintenance-photo.jpg"
  "public/benefit-communication-photo.jpg"
  "public/benefit-marketing-photo.jpg"
  "public/onboarding-property-photo.jpg"
  "public/property-redress-scheme-logo.png"
  "public/ico-registered-badge.png"
  "public/property-redress-scheme-certificate.pdf"
  "public/ico-registration-certificate-zc196423.pdf"
  "privacy/index.html"
  "landlords/index.html"
  "stays/index.html"
  "properties/index.html"
  "properties/stratford-townhouse/index.html"
)

optional_files=(
  "public/file.svg"
  "public/globe.svg"
  "public/window.svg"
)

remote_dirs=(
  "app"
  "public"
  "privacy"
  "landlords"
  "stays"
  "properties"
  "properties/stratford-townhouse"
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
raw_log_file="$(mktemp "${TMPDIR:-/tmp}/tpm-deploy.XXXXXX.raw.log")"
cleanup() {
  rm -f "$batch_file"
  rm -f "$raw_log_file"
}
trap cleanup EXIT

{
  echo "cd $REMOTE_ROOT"
  for dir in "${remote_dirs[@]}"; do
    # The leading dash tells sftp not to abort if the folder already exists.
    echo "-mkdir $dir"
  done
  echo "put index.html index.html"
  echo "put sitemap.xml sitemap.xml"
  echo "put robots.txt robots.txt"
  echo "put app/globals.css app/globals.css"
  echo "put public/favicon.svg public/favicon.svg"
  echo "put public/trafford-property-management-logo.png public/trafford-property-management-logo.png"
  echo "put public/stays-property-placeholder.svg public/stays-property-placeholder.svg"
  echo "put public/warwickshire-cotswolds-door.jpg public/warwickshire-cotswolds-door.jpg"
  echo "put public/benefit-management-photo.jpg public/benefit-management-photo.jpg"
  echo "put public/benefit-revenue-photo.jpg public/benefit-revenue-photo.jpg"
  echo "put public/benefit-bookings-photo.jpg public/benefit-bookings-photo.jpg"
  echo "put public/benefit-maintenance-photo.jpg public/benefit-maintenance-photo.jpg"
  echo "put public/benefit-communication-photo.jpg public/benefit-communication-photo.jpg"
  echo "put public/benefit-marketing-photo.jpg public/benefit-marketing-photo.jpg"
  echo "put public/onboarding-property-photo.jpg public/onboarding-property-photo.jpg"
  echo "put public/property-redress-scheme-logo.png public/property-redress-scheme-logo.png"
  echo "put public/ico-registered-badge.png public/ico-registered-badge.png"
  echo "put public/property-redress-scheme-certificate.pdf public/property-redress-scheme-certificate.pdf"
  echo "put public/ico-registration-certificate-zc196423.pdf public/ico-registration-certificate-zc196423.pdf"
  for file in "${optional_files[@]}"; do
    if [[ -f "$file" ]]; then
      echo "put $file $file"
    fi
  done
  echo "put privacy/index.html privacy/index.html"
  echo "put landlords/index.html landlords/index.html"
  echo "put stays/index.html stays/index.html"
  echo "put properties/index.html properties/index.html"
  echo "put properties/stratford-townhouse/index.html properties/stratford-townhouse/index.html"
} > "$batch_file"

echo "Deploying to $SFTP_HOST:$REMOTE_ROOT ..."
echo "Writing log to $LOG_FILE"

if sftp -F "$SFTP_CONFIG" -b "$batch_file" "$SFTP_HOST" > "$raw_log_file" 2>&1; then
  {
    echo "Deploy target: $SFTP_HOST:$REMOTE_ROOT"
    echo "Deploy time: $(date)"
    echo
    echo "Note: sftp may report existing folders as generic mkdir errors."
    echo "      Those expected mkdir lines are converted to INFO below."
    echo
    perl -pe 's/^remote mkdir "([^"]+)": Failure\r?$/INFO: remote folder already exists: $1/' "$raw_log_file"
  } > "$LOG_FILE"

  echo "Deploy completed successfully."
  echo "Uploaded files:"
  printf '  %s\n' "${required_files[@]}"
  for file in "${optional_files[@]}"; do
    [[ -f "$file" ]] && printf '  %s\n' "$file"
  done
else
  status=$?
  {
    echo "Deploy target: $SFTP_HOST:$REMOTE_ROOT"
    echo "Deploy time: $(date)"
    echo
    cat "$raw_log_file"
  } > "$LOG_FILE"

  echo "Deploy failed with exit code $status." >&2
  echo "Last 40 lines from $LOG_FILE:" >&2
  tail -n 40 "$LOG_FILE" >&2
  exit "$status"
fi

if grep -E "Couldn't|No such file|Permission denied|not found|Failure" "$LOG_FILE" | grep -v "^INFO: remote folder already exists:" >/dev/null 2>&1; then
  echo "Deploy completed, but the log contains warnings/errors to review:" >&2
  grep -E "Couldn't|No such file|Permission denied|not found|Failure" "$LOG_FILE" | grep -v "^INFO: remote folder already exists:" >&2
  exit 2
fi
