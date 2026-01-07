#!/usr/bin/env bash

download_file() {
  local file_url="$1"
  local file_name="$2"
  local post_id="$3"
  local max_retries=3
  local attempt=1

  while [ $attempt -le $max_retries ]; do
    curl -s -o "${IMAGE_FOLDER}/${file_name}" "$file_url"
    if [ $? -eq 0 ]; then
      log_success "Successfully downloaded ${file_name} (Post ID: $post_id)"
      local file_hash=$(calculate_hash "${IMAGE_FOLDER}/${file_name}")
      update_cache "$file_name" "$file_hash"
      return 0
    fi
    log_warning "Attempt $attempt failed for ${file_name}. Retrying..."
    ((attempt++))
    sleep 1
  done

  log_error "Failed to download ${file_name} after $max_retries attempts (Post ID: $post_id)"
  return 1
}

handle_file() {
  local file_url="$1"
  local post_id="$2"
  local file_name
  file_name=$(basename "$file_url")

  local file_ext="${file_name##*.}"

  if [[ "$CACHE_HASH" == "true" ]]; then
    local temp_file="${IMAGE_FOLDER}/${file_name}"
    if [[ -f "$temp_file" ]]; then
      local file_hash
      file_hash=$(calculate_hash "$temp_file")
      if is_cached "$file_name" "$file_hash"; then
        log_info "File $file_name is already downloaded and cached. Skipping."
        return
      fi
    fi
  fi

  if [[ "$ONLY_IMAGES" == "true" ]] && [[ "$file_ext" =~ ^(jpg|jpeg|png|gif)$ ]]; then
    log_info "Downloading image $file_name | Post ID: $post_id"
    download_file "$file_url" "$file_name" "$post_id"
  elif [[ "$ONLY_VIDEOS" == "true" ]] && [[ "$file_ext" =~ ^(mp4|webm|gif)$ ]]; then
    log_info "Downloading video/GIF $file_name | Post ID: $post_id"
    download_file "$file_url" "$file_name" "$post_id"
  elif [[ "$ONLY_IMAGES" == "false" ]] && [[ "$ONLY_VIDEOS" == "false" ]]; then
    log_info "Downloading $file_name | Post ID: $post_id"
    download_file "$file_url" "$file_name" "$post_id"
  else
    log_warning "Skipping $file_name (Not matching filters)"
  fi
}

process_posts() {
  local response="$1"
  local page="$2"

  if [[ -z "$response" ]]; then
    log_warning "Empty response for page $page. Skipping."
    return
  fi

  if [[ -z "$response" ]]; then
    log_warning "Empty response for page $page. Skipping."
    return
  fi

  while read -r post; do
    local post_id
    local file_url
    post_id=$(echo "$post" | jq -r '.id')
    file_url=$(echo "$post" | jq -r '.file_url')

    if [[ -z "$post_id" || "$post_id" == "null" || -z "$file_url" || "$file_url" == "null" ]]; then
       log_warning "Skipping malformed post entry on page $page"
       continue
    fi

    log_info "Preparing file | page $page | post $post_id"

    while (( $(jobs | wc -l) >= MAX_THREADS )); do
      sleep 0.1
    done

    handle_file "$file_url" "$post_id" &
  done < <(extract_posts "$response")
  wait
}

download_images_by_amount() {
  local tags="$1"
  local total_limit="$2"
  local per_page_limit=50
  local encoded_tags
  encoded_tags=$(urlencode "$tags")

  mkdir -p "$IMAGE_FOLDER"

  local total_downloaded=0
  local page=1

  while (( total_downloaded < total_limit )); do
    local limit
    if (( total_downloaded >= total_limit - per_page_limit )); then
      limit=$(( total_limit - total_downloaded ))
    else
      limit=$per_page_limit
    fi

    local url
    url=$(get_api_url "$limit" "$((page - 1))" "$encoded_tags")
    log_debug "Fetching URL: $url"
    
    local response
    local http_code
    # Capture both output and HTTP status code
    response=$(curl -s -w "%{http_code}" "$url")
    http_code="${response: -3}"
    response="${response%???}"

    if [[ "$http_code" != "200" ]]; then
      log_error "API request failed with HTTP $http_code for page $page."
      if [[ "$http_code" == "429" ]]; then
        log_error "You are being rate limited. Please wait before running again."
      fi
      exit 1
    fi

    log_info "Received response from API (Page $page)"
    process_posts "$response" "$page"

    total_downloaded=$((total_downloaded + limit))
    ((page++))
  done
}

download_images_by_pages() {
  local tags="$1"
  local end_page="$2"
  local per_page_limit=50
  local encoded_tags
  encoded_tags=$(urlencode "$tags")

  mkdir -p "$IMAGE_FOLDER"

  for (( page=1; page<=end_page; page++ )); do
    local url
    url=$(get_api_url "$per_page_limit" "$((page - 1))" "$encoded_tags")
    log_debug "Fetching URL: $url"
    
    local response
    local http_code
    response=$(curl -s -w "%{http_code}" "$url")
    http_code="${response: -3}"
    response="${response%???}"

    if [[ "$http_code" != "200" ]]; then
      log_error "API request failed with HTTP $http_code for page $page."
      exit 1
    fi

    log_info "Received response from API (Page $page)"
    process_posts "$response" "$page"
  done
}
