#!/usr/bin/env bash

# Rule34 Site Driver
SITE_DISABLED=false
SITE_DISABLED_REASON=""

# Rule34 requires credentials for API access
_api_key="${RULE34_API_KEY:-$API_KEY}"
_user_id="${RULE34_USER_ID:-$USER_ID}"

if [[ -z "$_api_key" || -z "$_user_id" ]]; then
   SITE_DISABLED=true
   SITE_DISABLED_REASON="Rule34 requires API Key and User ID. Please provide them in config.yaml (rule34_api_key/rule34_user_id) or via CLI."
fi

SITE_BASE_URL="https://api.rule34.xxx/index.php"

get_api_url() {
  local limit="$1"
  local pid="$2"
  local tags="$3"
  
  # Priority: Site-specific > Global (CLI/YAML)
  local api_key="${RULE34_API_KEY:-$API_KEY}"
  local user_id="${RULE34_USER_ID:-$USER_ID}"
  
  echo "${SITE_BASE_URL}?page=dapi&s=post&q=index&limit=${limit}&pid=${pid}&tags=${tags}&json=1&api_key=${api_key}&user_id=${user_id}"
}
