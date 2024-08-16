#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
WHITE='\033[0;37m'
RESET='\033[0m'

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

DEBUG=false
ONLY_VIDEOS=false
ONLY_IMAGES=false

log_info() {
  echo -e "${GREEN}$(timestamp) ${WHITE}[${BLUE}INFO${WHITE}]${RESET} $1"
}

log_success() {
  echo -e "${GREEN}$(timestamp) ${WHITE}[${GREEN}SUCCESS${WHITE}]${RESET} $1"
}

log_warning() {
  echo -e "${GREEN}$(timestamp) ${WHITE}[${YELLOW}WARNING${WHITE}]${RESET} $1"
}

log_error() {
  echo -e "${GREEN}$(timestamp) ${WHITE}[${RED}ERROR${WHITE}]${RESET} $1"
}

log_debug() {
  if [ "$DEBUG" = true ]; then
    echo -e "${GREEN}$(timestamp) ${WHITE}[DEBUG]${RESET} $1"
  fi
}

urlencode() {
  local raw="$1"
  local encoded=""
  local c
  local i
  for (( i = 0; i < ${#raw}; i++ )); do
    c=${raw:$i:1}
    case $c in
      [a-zA-Z0-9.~_/-]) encoded+=$c ;;
      *) printf -v encoded '%s%%%02X' "$encoded" "'$c" ;;
    esac
  done
  echo "$encoded"
}

download_file() {
  local file_url="$1"
  local file_name="$2"
  local post_id="$3"

  curl -s -o "${IMAGE_FOLDER}/${file_name}" "$file_url"

  if [ $? -ne 0 ]; then
    log_error "Failed to download ${file_name} (Post ID: $post_id)"
  else
    log_success "Successfully downloaded ${file_name} (Post ID: $post_id)"
  fi
}

handle_file() {
  local file_url="$1"
  local post_id="$2"
  local file_name=$(basename "$file_url")

  local file_ext="${file_name##*.}"

  if [ "$ONLY_IMAGES" = true ] && [[ "$file_ext" =~ ^(jpg|jpeg|png|gif)$ ]]; then
    log_info "Downloading image $file_name | Post ID: $post_id"
    download_file "$file_url" "$file_name" "$post_id"
  elif [ "$ONLY_VIDEOS" = true ] && [[ "$file_ext" =~ ^(mp4|webm|gif)$ ]]; then
    log_info "Downloading video/GIF $file_name | Post ID: $post_id"
    download_file "$file_url" "$file_name" "$post_id"
  elif [ "$ONLY_IMAGES" = false ] && [ "$ONLY_VIDEOS" = false ]; then
    log_info "Downloading $file_name | Post ID: $post_id"
    download_file "$file_url" "$file_name" "$post_id"
  else
    log_warning "Skipping $file_name (Not matching filters)"
  fi
}

download_images_by_amount() {
  local tags="$1"
  local total_limit="$2"
  local per_page_limit=50
  local encoded_tags=$(urlencode "$tags")

  mkdir -p "$IMAGE_FOLDER"

  local total_downloaded=0
  local page=1

  while [ $total_downloaded -lt $total_limit ]; do
    if [[ $total_downloaded -ge $((total_limit - per_page_limit)) ]]; then
      limit=$(( total_limit - total_downloaded ))
    else
      limit=$per_page_limit
    fi

    url="https://api.rule34.xxx/index.php?page=dapi&s=post&q=index&limit=$limit&pid=$((page - 1))&tags=$encoded_tags&json=1"
    log_debug "Fetching URL: $url"
    response=$(curl -s "$url")
    log_info "Received response from API"

    if [ $? -ne 0 ]; then
      log_error "Failed to connect to the API."
      exit 1
    fi

    if [ -z "$response" ]; then
      log_warning "Empty response for page $page. Skipping."
      continue
    fi

    echo "$response" | jq -c '.[]' | while read -r post; do
      post_id=$(echo "$post" | jq -r '.id')
      file_url=$(echo "$post" | jq -r '.file_url')

      log_info "Preparing file | page $page | post $post_id"

      while [ "$(jobs | wc -l)" -ge "$MAX_THREADS" ]; do
        sleep 1
      done

      handle_file "$file_url" "$post_id" &
    done

    wait

    total_downloaded=$((total_downloaded + limit))
    page=$((page + 1))
  done
}

download_images_by_pages() {
  local tags="$1"
  local end_page="$2"
  local per_page_limit=50
  local encoded_tags=$(urlencode "$tags")

  mkdir -p "$IMAGE_FOLDER"

  for (( page=1; page<=$end_page; page++ )); do
    url="https://api.rule34.xxx/index.php?page=dapi&s=post&q=index&limit=$per_page_limit&pid=$((page - 1))&tags=$encoded_tags&json=1"
    log_debug "Fetching URL: $url"
    response=$(curl -s "$url")
    log_info "Received response from API"

    if [ $? -ne 0 ]; then
      log_error "Failed to connect to the API."
      exit 1
    fi

    if [ -z "$response" ]; then
      log_warning "Empty response for page $page. Skipping."
      continue
    fi

    echo "$response" | jq -c '.[]' | while read -r post; do
      post_id=$(echo "$post" | jq -r '.id')
      file_url=$(echo "$post" | jq -r '.file_url')

      log_info "Preparing to download | page $page | post $post_id"

      while [ "$(jobs | wc -l)" -ge "$MAX_THREADS" ]; do
        sleep 1
      done

      handle_file "$file_url" "$post_id" &
    done

    wait
  done
}

parse_yaml() {
  local file="$1"
  while IFS=": " read -r key value; do
    case "$key" in
      "tags") TAGS=$(echo "$value" | sed 's/^"\(.*\)"$/\1/') ;;
      "max_threads") MAX_THREADS=$(echo "$value" | sed 's/^"\(.*\)"$/\1/') ;;
      "image_folder") IMAGE_FOLDER=$(echo "$value" | sed 's/^"\(.*\)"$/\1/') ;;
      "amount") AMOUNT=$(echo "$value" | sed 's/^"\(.*\)"$/\1/') ;;
    esac
  done < "$file"
}

MAX_THREADS=5
IMAGE_FOLDER="downloaded"

while [[ $# -gt 0 ]]; do
  case $1 in
    --debug)
      DEBUG=true;
      shift
      ;;
    --config)
      CONFIG_FILE="$2"
      shift
      shift
      ;;
    --pages)
      PAGES="$2"
      shift
      shift
      ;;
    --amount)
      AMOUNT="$2"
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
    *)
      if [ -z "$TAGS" ]; then
        TAGS="$1"
      else
        log_error "Too many arguments."
        exit 1
      fi
      shift
      ;;
  esac
done

if [ ! -z "$CONFIG_FILE" ]; then
  if [ ! -f "$CONFIG_FILE" ]; then
    log_error "Config file $CONFIG_FILE not found."
    exit 1
  fi

  parse_yaml "$CONFIG_FILE"

  if [ -z "$AMOUNT" ]; then
    log_error "Amount must be specified either in the config file or as a command-line argument."
    exit 1
  fi

  if [ -z "$TAGS" ] || [ -z "$MAX_THREADS" ] || [ -z "$IMAGE_FOLDER" ]; then
    log_error "Missing required configuration values."
    exit 1
  fi
fi

if [ -z "$TAGS" ]; then
  log_error "Tags must be specified."
  exit 1
fi

if [ -z "$AMOUNT" ] && [ -z "$PAGES" ]; then
  log_error "Either --amount or --pages must be specified."
  exit 1
fi

if [ ! -z "$PAGES" ]; then
  download_images_by_pages "$TAGS" "$PAGES"
elif [ ! -z "$AMOUNT" ]; then
  download_images_by_amount "$TAGS" "$AMOUNT"
fi
