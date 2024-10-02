#!/bin/bash
{
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  PURPLE='\033[0;35m'
  CYAN='\033[0;36m'
  WHITE='\033[0;37m'
  NC='\033[0m' # no color

  get_current_time_ms() {
    # local seconds
    # local nanoseconds
    # seconds=$(date +%s)
    # nanoseconds=$(date +%N)
    # echo $((seconds * 1000 + nanoseconds / 1000000))
    local seconds
    seconds=$(date +%s)
    echo $((seconds * 1000))
  }

  console_name() {
    printf "\n${PURPLE}%s${NC}\n\n" "$SHELL_NAME"
  }

  console_desc() {
    if [[ -n "$SHELL_DESC" ]]; then
      printf "  ${NC}%s${NC}\n\n" "$SHELL_DESC"
    fi
  }

  console_support_os() {
    printf "  ${YELLOW}%s${NC}\n\n" "Supported operating systems:"
    for os_info in "${SUPPORT_OS_LIST[@]}"; do
      printf "    ${YELLOW}%s${NC}\n" "$os_info"
    done
    console_empty_line
  }

  console_check_system() {
    if [[ "$IS_SUPPORT_OS" == false ]]; then
      printf "  ${RED}%s${NC}\n\n"   "This shell script does not support the current operating system. [$CURRENT_OS]"
      console_support_os
    
      exit 1
    else
      printf "  ${GREEN}%s${NC}\n\n" "This shell script supports the current operating system. [$CURRENT_OS]"
    fi
  }

  console_title() {
    local title="$1"
    printf "  ${CYAN}%s${NC}\n\n" "$title"
  }

  console_key_value() {
    local key="$1"
    local value="$2"

    if [[ ${#key} -gt 16 ]]; then
      printf "    ${GREEN}%s${NC}\n" "$key"
      printf "    ${GREEN}%-16s${NC}: %s\n" "" "$value"
    else
      printf "    ${GREEN}%-16s${NC}: %s\n" "$key" "$value"
    fi

    return 1
  }

  console_empty_line() {
    printf "\n"
  }

  console() {
    printf "%s\n" "$1"
  }

  console_content() {
    printf "    %s\n" "$1"
  }

  console_sulines() {
    # printf "    %s\n" "$1"
    local msg=$1
    _console_sub_lines() {
      # shellcheck disable=SC2317
      while IFS= read -r line; do
        printf "      %s\n" "$line"
      done
    }
    echo "$msg" | _console_sub_lines
  }

  tempTime=$(get_current_time_ms)
  console_content_starting() {
    tempTime=$(get_current_time_ms)
    printf "    %s" "$1"
  }

  console_content_complete() {
    local currentTime
    currentTime=$(get_current_time_ms)
    local timeDiff
    timeDiff=$((currentTime - tempTime))

    printf " ${GREEN}%s${NC} %s${NC}\n" "done." "(${timeDiff} ms)"
  }

  console_content_error() {
    local msg=$1
    printf " ${RED}%s${NC}\n" "error."
    printf "    ${RED}%s${NC}\n" "Reason: \"${msg}\""
  }

  console_content_emptystr() {
    printf "%s\n" ""
  }

  console_end() {
    printf "  ${CYAN}%s${NC}\n\n" "$1"
  }

  get_redirect_output() {
    if [ "$(get_param '--debug')" == 'false' ]; then
      echo "&> /dev/null"
    else
      echo ""
    fi
  }
}
