#!/usr/bin/env bash

# Realbooru Site Driver
SITE_DISABLED=true
SITE_DISABLED_REASON="Search error: API offline because apparently it is broken and no one is able to articulate what is broken, so it will be shut off indefinitely. Feel free to browse the site the old fashioned way for now."

SITE_BASE_URL="https://realbooru.com/index.php"

get_api_url() {
  local limit="$1"
  local pid="$2"
  local tags="$3"
  
  echo "${SITE_BASE_URL}?page=dapi&s=post&q=index&limit=${limit}&pid=${pid}&tags=${tags}"
}
