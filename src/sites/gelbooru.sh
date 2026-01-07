# Gelbooru Site Driver
SITE_DISABLED=false
SITE_DISABLED_REASON=""

# Gelbooru requires credentials for API access
_api_key="${GELBOORU_API_KEY:-$API_KEY}"
_user_id="${GELBOORU_USER_ID:-$USER_ID}"

if [[ -z "$_api_key" || -z "$_user_id" ]]; then
   SITE_DISABLED=true
   SITE_DISABLED_REASON="Gelbooru requires API Key and User ID. Please provide them in config.yaml (gelbooru_api_key/gelbooru_user_id) or via CLI."
fi

SITE_BASE_URL="https://gelbooru.com/index.php"

get_api_url() {
  local limit="$1"
  local pid="$2"
  local tags="$3"
  local api_key="${GELBOORU_API_KEY:-$API_KEY}"
  local user_id="${GELBOORU_USER_ID:-$USER_ID}"

  echo "${SITE_BASE_URL}?page=dapi&s=post&q=index&limit=${limit}&pid=${pid}&tags=${tags}&json=1&api_key=${api_key}&user_id=${user_id}"
}

extract_posts() {
  echo "$1" | jq -c '.post[]'
}
