#!/usr/bin/env bash

check_dependencies() {
  local deps=("curl" "jq" "sha256sum")
  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
      log_error "Dependency '$dep' is not installed. Please install it to continue."
      exit 1
    fi
  done
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
      " ") encoded+="+" ;;
      *) printf -v encoded '%s%%%02X' "$encoded" "'$c" ;;
    esac
  done
  echo "$encoded"
}

calculate_hash() {
  local file="$1"
  sha256sum "$file" | awk '{print $1}'
}

update_cache() {
  local file="$1"
  local hash="$2"
  echo "$hash  $file" >> "$CACHE_FILE"
}

is_cached() {
  local file="$1"
  local hash="$2"
  grep -q "$hash  $file" "$CACHE_FILE"
}

show_help() {
  echo -e "${BLUE}Usage:${RESET} $0 [options] \"tags\""
  echo ""
  echo -e "${BLUE}Options:${RESET}"
  echo -e "  ${YELLOW}-h, --help${RESET}         Show this help message"
  echo -e "  ${YELLOW}--debug${RESET}            Enable debug logging"
  echo -e "  ${YELLOW}--verbose${RESET}          Enable verbose logging (disable progress bar)"
  echo -e "  ${YELLOW}--config <file>${RESET}    Path to YAML configuration file"
  echo -e "  ${YELLOW}--pages <count>${RESET}    Number of pages to download"
  echo -e "  ${YELLOW}--amount <count>${RESET}   Total number of images to download"
  echo -e "  ${YELLOW}--threads <count>${RESET}  Maximum simultaneous downloads (default: 5)"
  echo -e "  ${YELLOW}--folder <path>${RESET}   Target folder for downloads (default: downloaded)"
  echo -e "  ${YELLOW}--only-videos${RESET}      Only download videos and GIFs"
  echo -e "  ${YELLOW}--only-images${RESET}      Only download images"
  echo -e "  ${YELLOW}--thumbnail${RESET}        Download thumbnails instead of full images"
  echo -e "  ${YELLOW}--cache-hash${RESET}       Check for existing hashes in $CACHE_FILE"
  echo -e "  ${YELLOW}--api-key <key>${RESET}    Set API key for the selected site"
  echo -e "  ${YELLOW}--user-id <id>${RESET}     Set User ID for the selected site"
  echo -e "  ${YELLOW}--site <site>${RESET}      Set site to scrape (default: rule34, options: rule34, xbooru, hypnohub, konachan, realbooru, safebooru, gelbooru)"
  echo ""
  echo -e "${BLUE}Note:${RESET} You can find your API key and User ID at:"
  echo -e "${YELLOW}https://rule34.xxx/index.php?page=account&s=options${RESET}"
  echo ""
  echo -e "${BLUE}Arguments:${RESET}"
  echo -e "  ${YELLOW}tags${RESET}               Search tags (e.g., \"high_res female\")"
  echo ""
  echo -e "${BLUE}Examples:${RESET}"
  echo "  $0 --amount 10 \"solo\""
  echo "  $0 --config config.yaml"
}
