#!/bin/bash
{

  print_default_param() {
    echo "Default paramters:"
    echo ""

    # shellcheck disable=SC2153
    for PARAMTER in "${PARAMTERS[@]}"; do
      local name
      name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value
      value=$(awk -F "$_m_" '{ for (i=4; i<=4; i++) print $i }' <<< "$PARAMTER")

      if [[ ${#name} -gt 16 ]]; then
        printf "   %s\n" "$name"
        printf "   %-16s: %s\n" "" "$value"
      else
        printf "   %-16s: %s\n" "$name" "$value"
      fi
    done
    echo ""

    return 1
  }

  has_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local name
      name=$(awk -F "${_m_}" '{ for (i=1; i<=1; i++) print $i }' <<<"$PARAMTER")

      if [[ "$name" == "$key" ]]; then
        return 0
      fi
    done

    return 1
  }

  get_param_default() {
    local key="$1"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local name
      name=$(awk -F "${_m_}" '{ for (i=1; i<=1; i++) print $i }' <<<"$PARAMTER")
      local default
      default=$(awk -F "${_m_}" '{ for (i=4; i<=4; i++) print $i }' <<<"$PARAMTER")

      if [[ "$name" == "$key" ]]; then
        echo "$default"
      fi
    done

    return
  }

  get_param() {
    local key="$1"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local name
      name=$(awk -F "${_m_}" '{ for (i=1; i<=1; i++) print $i }' <<<"$PARAMTER")
      local alias
      alias=$(awk -F $_m_ '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      local default
      default=$(awk -F "${_m_}" '{ for (i=4; i<=4; i++) print $i }' <<<"$PARAMTER")

      if [[ "$name" == "$key" ]]; then
        if has_user_param "$name"; then
          echo "$(get_user_param $name)"
        elif has_user_param "$alias"; then
          echo "$(get_user_param $alias)"
        else
          echo "$(get_param_default $name)"
        fi
      fi
    done

    return
  }

  print_help() {
    echo "$SHELL_NAME"
    echo ""
    echo "$SHELL_DES"
    echo ""
    for PARAMTER in "${PARAMTERS[@]}"; do
      local name
      name=$(awk -F $_m_ '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local alias
      alias=$(awk -F $_m_ '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      local msg
      msg=$(awk -F $_m_ '{ for (i=3; i<=3; i++) print $i }' <<< "$PARAMTER")
      local default
      default=$(awk -F $_m_ '{ for (i=4; i<=4; i++) print $i }' <<< "$PARAMTER")

      if [[ -n "$alias" ]]; then
        name+=",$alias"
      fi
      local defaultStr=''
      if [[ -n "$default" ]]; then
        defaultStr=" (default: $default)"
      fi
      
      if [[ ${#name} -gt 16 ]]; then
        printf "   %s\n" "$name"
        printf "   %-16s: %s\n" "" "$msg$defaultStr"
      else
        printf "   %-16s: %s\n" "$name" "$msg$defaultStr"
      fi
      
    done
    echo ""

    return 1
  }

  print_param() {
    echo "$SHELL_NAME"
    echo ""
    echo "$SHELL_DES"
    echo ""
    echo "Paramters:"
    echo ""

    for PARAMTER in "${PARAMTERS[@]}"; do
      local name
      name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value
      value=$(get_param "$name")

      if [[ ${#name} -gt 16 ]]; then
        printf "   %s\n" "$name"
        printf "   %-16s: %s\n" "" "$value"
      else
        printf "   %-16s: %s\n" "$name" "$value"
      fi
    done
    echo ""

    return 1
  }

}
