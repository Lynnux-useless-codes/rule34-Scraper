#!/usr/bin/env bash

# Default configuration
DEBUG=false
ONLY_VIDEOS=false
ONLY_IMAGES=false
CACHE_HASH=false
CACHE_FILE="cache_hashes.txt"
API_KEY=""
USER_ID=""
RULE34_API_KEY=""
RULE34_USER_ID=""
GELBOORU_API_KEY=""
GELBOORU_USER_ID=""
MAX_THREADS=5
IMAGE_FOLDER="downloads"
SITE="rule34"
DOWNLOAD_THUMBNAILS=false
VERBOSE=false

# Initialize optional variables
TAGS=""
CONFIG_FILE=""
AMOUNT=""
PAGES=""
CLI_TAGS_PROVIDED="false"
CLI_AMOUNT_PROVIDED="false"
CLI_PAGES_PROVIDED="false"
CLI_THREADS_PROVIDED="false"
CLI_FOLDER_PROVIDED="false"
CLI_API_KEY_PROVIDED="false"
CLI_USER_ID_PROVIDED="false"
CLI_SITE_PROVIDED="false"
CLI_THUMBNAILS_PROVIDED="false"
CLI_VERBOSE_PROVIDED="false"

parse_yaml() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    return
  fi
  while IFS=": " read -r key value; do
    # Skip empty lines and comments
    if [[ -z "$key" || "$key" =~ ^# ]]; then
      continue
    fi
    
    # Trim potential quotes from value
    value=$(echo "$value" | sed 's/^"\(.*\)"$/\1/; s/^'\''\(.*\)'\''$/\1/')
    
    case "$key" in
      "tags") [[ "$CLI_TAGS_PROVIDED" == "false" ]] && TAGS="$value" ;;
      "max_threads") [[ "$CLI_THREADS_PROVIDED" == "false" ]] && MAX_THREADS="$value" ;;
      "image_folder") [[ "$CLI_FOLDER_PROVIDED" == "false" ]] && IMAGE_FOLDER="$value" ;;
      "amount") [[ "$CLI_AMOUNT_PROVIDED" == "false" ]] && AMOUNT="$value" ;;
      "api_key") [[ "$CLI_API_KEY_PROVIDED" == "false" ]] && API_KEY="$value" ;;
      "user_id") [[ "$CLI_USER_ID_PROVIDED" == "false" ]] && USER_ID="$value" ;;
      "site") [[ "$CLI_SITE_PROVIDED" == "false" ]] && SITE="$value" ;;
      "thumbnails") [[ "$CLI_THUMBNAILS_PROVIDED" == "false" ]] && DOWNLOAD_THUMBNAILS="$value" ;;
      "verbose") [[ "$CLI_VERBOSE_PROVIDED" == "false" ]] && VERBOSE="$value" ;;
      "rule34_api_key") RULE34_API_KEY="$value" ;;
      "rule34_user_id") RULE34_USER_ID="$value" ;;
      "gelbooru_api_key") GELBOORU_API_KEY="$value" ;;
      "gelbooru_user_id") GELBOORU_USER_ID="$value" ;;
    esac
  done < "$file"
}
