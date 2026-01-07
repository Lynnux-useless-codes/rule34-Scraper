#!/usr/bin/env bash

# Konachan Site Driver

SITE_BASE_URL="https://konachan.com/post.json"

get_api_url() {
  local limit="$1"
  local pid="$2" # This is page - 1
  local tags="$3"
  local page=$((pid + 1))
  
  echo "${SITE_BASE_URL}?limit=${limit}&page=${page}&tags=${tags}"
}
