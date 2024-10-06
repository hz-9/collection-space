#!/bin/bash
{
  USER_PARAMTERS=()

  parse_user_param() {
    while [[ "$#" -gt 0 ]]; do
      case $1 in
      --*=*)
        key="${1%%=*}"
        value="${1#*=}"
        USER_PARAMTERS+=("$key${_m_}$value")
        ;;
      --*)
        key="$1"
        if [[ -n "$2" && "$2" != --* ]]; then
          USER_PARAMTERS+=("$key${_m_}$2")
          shift
        else
          USER_PARAMTERS+=("$key${_m_}true")
        fi
        ;;
      -*=*)
        key="${1%%=*}"
        value="${1#*=}"
        USER_PARAMTERS+=("$key${_m_}$value")
        ;;
      -*)
        key="$1"
        if [[ -n "$2" && "$2" != --* ]]; then
          USER_PARAMTERS+=("$key${_m_}$2")
          shift
        else
          USER_PARAMTERS+=("$key${_m_}true")
        fi
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
      esac
      shift
    done
  }

  print_user_param() {
    console_title "User paramters:"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local split
      IFS="${_m_}" read -r -a split <<< "$PARAMTER"

      local name
      name="${split[0]}"
      local value
      value="${split[1]}"
      
      console_key_value "${name//--/}" "$value"
    done
    echo ""

    return 1
  }

  has_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local split
      IFS="${_m_}" read -r -a split <<< "$PARAMTER"

      local name
      name="${split[0]}"

      if [[ "$name" == "$key" ]]; then
        return 0
      fi
    done

    return 1
  }

  get_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local split=()
      IFS="${_m_}" read -r -a split <<< "$PARAMTER"

      local name
      name="${split[0]}"
      local value
      value="${split[1]}"

      if [[ "$name" == "$key" ]]; then
        echo "$value"
      fi
    done
    return
  }

  parse_user_param "$@"
}
