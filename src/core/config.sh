#!/usr/bin/env bash

# Default configuration
DEBUG=false
ONLY_VIDEOS=false
ONLY_IMAGES=false
CACHE_HASH=false
CACHE_FILE="cache_hashes.txt"
API_KEY="d6a2a402d8df19624e0dab8297f7856eb66e4af291b359236870a775f59b90821b96656e3a8fa485a486d93f337b3a244c790f3bb371f25f584c8cc83a60ad2b"
USER_ID="2961491"
MAX_THREADS=5
IMAGE_FOLDER="downloads"

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
    esac
  done < "$file"
}
