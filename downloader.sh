#!/usr/bin/env bash

# Global safety and error handling
set -euo pipefail

cleanup() {
  local code=$?
  if [[ $code -ne 0 ]]; then
    local pids
    pids=$(jobs -p)
    if [[ -n "$pids" ]]; then
      log_warning "Interrupted. Cleaning up background jobs..."
      kill $pids 2>/dev/null
    fi
  fi
  exit $code
}

trap cleanup SIGINT SIGTERM EXIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source modules
source "${SCRIPT_DIR}/src/utils/logger.sh"
source "${SCRIPT_DIR}/src/core/config.sh"
source "${SCRIPT_DIR}/src/utils/helpers.sh"
source "${SCRIPT_DIR}/src/utils/progress.sh"
source "${SCRIPT_DIR}/src/core/engine.sh"

check_dependencies

# Autodetect config.yaml
if [[ -f "config.yaml" ]]; then
  parse_yaml "config.yaml"
elif [[ -f "${SCRIPT_DIR}/config.yaml" ]]; then
  parse_yaml "${SCRIPT_DIR}/config.yaml"
fi

# Look for config file
for arg in "$@"; do
  if [[ "$arg" == "--config" ]]; then
    # We'll find it in the full parsing, but this signals we should load defaults first
    break
  fi
done

# Full parsing
while [[ $# -gt 0 ]]; do
  case $1 in
    --help | -h)
      show_help
      exit 0
      ;;
    --debug)
      DEBUG=true;
      shift
      ;;
    --config)
      CONFIG_FILE="$2"
      if [[ -f "$CONFIG_FILE" ]]; then
        parse_yaml "$CONFIG_FILE"
      else
        log_error "Config file $CONFIG_FILE not found."
        exit 1
      fi
      shift
      shift
      ;;
    --pages)
      PAGES="$2"
      CLI_PAGES_PROVIDED="true"
      shift
      shift
      ;;
    --amount)
      AMOUNT="$2"
      CLI_AMOUNT_PROVIDED="true"
      shift
      shift
      ;;
    --threads)
      MAX_THREADS="$2"
      CLI_THREADS_PROVIDED="true"
      shift
      shift
      ;;
    --folder)
      IMAGE_FOLDER="$2"
      CLI_FOLDER_PROVIDED="true"
      shift
      shift
      ;;
    --only-videos)
      ONLY_VIDEOS=true;
      shift
      ;;
    --only-images)
      ONLY_IMAGES=true;
      shift
      ;;
    --cache-hash)
      CACHE_HASH=true;
      shift
      ;;
    --api-key)
      API_KEY="$2"
      CLI_API_KEY_PROVIDED="true"
      shift
      shift
      ;;
    --user-id)
      USER_ID="$2"
      CLI_USER_ID_PROVIDED="true"
      shift
      shift
      ;;
    --site)
      SITE="$2"
      CLI_SITE_PROVIDED="true"
      shift
      shift
      ;;
    --thumbnail)
      DOWNLOAD_THUMBNAILS=true
      CLI_THUMBNAILS_PROVIDED="true"
      shift
      ;;
    --verbose)
      VERBOSE=true
      CLI_VERBOSE_PROVIDED="true"
      shift
      ;;
    *)
      if [[ "$CLI_TAGS_PROVIDED" == "false" ]]; then
        TAGS="$1"
        CLI_TAGS_PROVIDED="true"
      else
        TAGS="$TAGS $1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$TAGS" ]]; then
  log_error "Tags must be specified."
  exit 1
fi

if [[ -z "$AMOUNT" && -z "$PAGES" ]]; then
  log_error "Either --amount or --pages must be specified."
  exit 1
fi

if [[ "$CACHE_HASH" == "true" ]]; then
  touch "$CACHE_FILE"
fi

# Load site driver
SITE_DISABLED=false
SITE_DISABLED_REASON="This site is currently disabled."
extract_posts() {
  echo "$1" | jq -c '.[]'
}
SITE_DRIVER="${SCRIPT_DIR}/src/sites/${SITE}.sh"
if [[ -f "$SITE_DRIVER" ]]; then
  source "$SITE_DRIVER"
else
  log_error "Site driver for '${SITE}' not found at ${SITE_DRIVER}"
  exit 1
fi

if [[ "$SITE_DISABLED" == "true" ]]; then
  log_error "Site '${SITE}' is disabled."
  log_error "Reason: ${SITE_DISABLED_REASON}"
  exit 1
fi

if [[ -n "$PAGES" ]]; then
  download_images_by_pages "$TAGS" "$PAGES"
elif [[ -n "$AMOUNT" ]]; then
  download_images_by_amount "$TAGS" "$AMOUNT"
fi
