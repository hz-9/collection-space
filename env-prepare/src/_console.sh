#!/bin/bash
{
  console_name() {
    echo "$SHELL_NAME"
    echo ""
  }

  console_desc() {
    if [[ -n "$SHELL_DESC" ]]; then
      echo "$SHELL_DESC"
      echo ""
    fi
  }

  console_title() {
    local title="$1"

    echo "$title"
    echo ""
  }

  console_key_value() {
    local key="$1"
    local value="$2"

    if [[ ${#key} -gt 16 ]]; then
      printf "   %s\n" "$key"
      printf "   %-16s: %s\n" "" "$value"
    else
      printf "   %-16s: %s\n" "$key" "$value"
    fi

    return 1
  }

  console_empty_line() {
    echo ""
  }

  console() {
    local message="$1"
    echo "$message"
  }

  console_content() {
    local message="$1"
    printf "   %s\n" "$message"
  }
}
