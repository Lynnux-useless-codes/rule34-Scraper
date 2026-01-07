#!/usr/bin/env bash

# Rule34 Site Driver

SITE_BASE_URL="https://api.rule34.xxx/index.php"

get_api_url() {
  local limit="$1"
  local pid="$2"
  local tags="$3"
  
  echo "${SITE_BASE_URL}?page=dapi&s=post&q=index&limit=${limit}&pid=${pid}&tags=${tags}&json=1&api_key=${API_KEY}&user_id=${USER_ID}"
}
