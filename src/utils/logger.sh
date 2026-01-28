#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
WHITE='\033[0;37m'
RESET='\033[0m'

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

log_info() {
  if [[ "${VERBOSE:-false}" == "true" ]]; then
    echo -e "${GREEN}$(timestamp) ${WHITE}[${BLUE}INFO${WHITE}]${RESET} $1"
  fi
}

log_success() {
  if [[ "${VERBOSE:-false}" == "true" ]]; then
    echo -e "${GREEN}$(timestamp) ${WHITE}[${GREEN}SUCCESS${WHITE}]${RESET} $1"
  fi
}

log_warning() {
  echo -e "${GREEN}$(timestamp) ${WHITE}[${YELLOW}WARNING${WHITE}]${RESET} $1"
}

log_error() {
  echo -e "${GREEN}$(timestamp) ${WHITE}[${RED}ERROR${WHITE}]${RESET} $1"
}

log_debug() {
  if [[ "${DEBUG:-false}" == "true" ]]; then
    echo -e "${GREEN}$(timestamp) ${WHITE}[DEBUG]${RESET} $1"
  fi
}
