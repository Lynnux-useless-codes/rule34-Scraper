#!/usr/bin/env bash

# Progress Bar Utility
PROGRESS_FILE=""
PROGRESS_LOCK=""
TOTAL_ITEMS=0

init_progress() {
  TOTAL_ITEMS=${1:-0}
  PROGRESS_FILE=$(mktemp)
  PROGRESS_LOCK="${PROGRESS_FILE}.lock"
  echo "0" > "$PROGRESS_FILE"
}

update_progress() {
  # Acquire lock to update progress safely
  (
    flock 200
    local current
    current=$(<"$PROGRESS_FILE")
    current=$((current + 1))
    echo "$current" > "$PROGRESS_FILE"
    
    _draw_bar "$current" "$TOTAL_ITEMS"
  ) 200>"$PROGRESS_LOCK"
}

_draw_bar() {
  local current=$1
  local total=$2
  
  # Avoid division by zero
  if [[ "$total" -eq 0 ]]; then total=1; fi
  
  local width=40
  local percent=$((current * 100 / total))
  local filled=$((current * width / total))
  local empty=$((width - filled))
  
  # Build bar
  local bar=""
  if [[ $filled -gt 0 ]]; then
    # printf magic to repeat char
    bar=$(printf "%${filled}s" | tr ' ' '#')
  fi
  if [[ $empty -gt 0 ]]; then
    bar="${bar}$(printf "%${empty}s" | tr ' ' '-')"
  fi
  
  # \r moves cursor to start of line, \033[K clears the line
  echo -ne "\r\033[K[${bar}] ${percent}% (${current}/${total})" >&2
}

SPINNER_PID=""

show_spinner() {
  local msg="${1:-Loading...}"
  local delay=0.1
  local spinstr='|/-\'
  
  # Hide cursor
  tput civis
  
  (
    while true; do
      local temp=${spinstr#?}
      printf "\r\033[K [%c] %s" "$spinstr" "$msg" >&2
      spinstr=$temp${spinstr%"$temp"}
      sleep $delay
    done
  ) &
  SPINNER_PID=$!
}

stop_spinner() {
  if [[ -n "$SPINNER_PID" ]]; then
    kill "$SPINNER_PID" 2>/dev/null
    wait "$SPINNER_PID" 2>/dev/null || true
    printf "\r\033[K" >&2 # Clear the line
    tput cnorm >&2 # Show cursor
    SPINNER_PID=""
  fi
}

finish_progress() {
  stop_spinner
  echo "" # Use newline to preserve the last progress bar state
  if [[ -f "$PROGRESS_FILE" ]]; then
    rm -f "$PROGRESS_FILE" "$PROGRESS_LOCK"
  fi
}
