#!/bin/bash

# build from install-node.sh
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--nvm-version${_m_}${_m_}Nvm version.${_m_}v0.40.0"
  "--node-version${_m_}${_m_}Node.js version.${_m_}v18.20.3"
  "--pm2-version${_m_}${_m_}PM2 version.${_m_}^5.4.2"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SHELL_NAME="Node.js Installer"
SHELL_DESC="Install 'nvn' 'node.js' and 'pm2'."

# build from ./_console.sh
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

# build from ./_parse-user-paramter.sh
{
  USER_PARAMTERS=()

  parse_user_params() {
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
          # USER_PARAM_KEYS+=("$key")
          # USER_PARAM_VALUES+=("$2")
          USER_PARAMTERS+=("$key${_m_}$2")
          shift
        else
          # USER_PARAM_KEYS+=("$key")
          # USER_PARAM_VALUES+=(true)
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
      local name
      name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value
      value=$(awk -F "$_m_" '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      
      console_key_value "$name" "$value"
    done
    echo ""

    return 1
  }

  has_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local name
      name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value
      value=$(awk -F "$_m_" '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      
      if [[ "$name" == "$key" ]]; then
        return 0
      fi
    done

    return 1
  }

  get_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local name
      name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value
      value=$(awk -F "$_m_" '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      
      if [[ "$name" == "$key" ]]; then
        echo "$value"
      fi
    done
    return
  }

  parse_user_params "$@"
}

# build from ./_parse-paramter.sh
{

  print_default_param() {
    console_title "Default paramters:"

    # shellcheck disable=SC2153
    for PARAMTER in "${PARAMTERS[@]}"; do
      local name
      name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value
      value=$(awk -F "$_m_" '{ for (i=4; i<=4; i++) print $i }' <<< "$PARAMTER")

      console_key_value "$name" "$value"
    done
    console_empty_line

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
        break
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
        break
      fi
    done

    return
  }

  print_help() {
    console_name

    console_desc

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
        defaultStr=" (Default is '$default')"
      fi
      
      console_key_value "$name" "$msg$defaultStr"
    done
    console_empty_line

    return 1
  }

  print_param() {
    console_name

    console_desc

    console_title "Paramters:"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local name
      name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value
      value=$(get_param "$name")

      console_key_value "${name//--/}" "$value"
    done
    console_empty_line

    return 1
  }

  print_help_or_param() {
    if [[ $(get_param '--help') == "true" ]]; then
      print_help
      exit 0
    else
      print_param
    fi
  }
}

print_help_or_param

nvmVersion=$(get_param '--nvm-version')
nvmHome="${HOME}/.nvm"

nodeVersion=$(get_param '--node-version')
nodeHome="${nvmHome}/versions/node/${nodeVersion}"

pm2Version=$(get_param '--pm2-version')
pm2Home="${HOME}/.pm2"

inChina=$(get_param '--in-china')

if [[ ! -f "$nvmHome/README.md" ]]; then
  echo "nvm ${nvmHome} is installing..."
  echo ""

  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvmVersion}/install.sh" | bash
  source "${nvmHome}/nvm.sh"
else
  echo "nvm ${nvmHome} is already installed."
  echo ""

  source "${nvmHome}/nvm.sh"
fi

if [[ ! -d "$nodeHome" ]]; then
  echo "Node.js ${nodeVersion} is installing..."
  echo ""

  if [[ "$inChina" == "true" ]]; then
    export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/
    export NVM_IOJS_ORG_MIRROR=https://mirrors.huaweicloud.com/iojs/
    echo "Use the Chinese mirror."
  fi
  nvm install "$nodeVersion"
else
  echo "Node.js ${nodeVersion} is already installed."
  echo ""
fi

installPM2() {
  echo "PM2 ${pm2Version} is installing..."
  echo ""

  if [[ "$inChina" == "true" ]]; then
    npm config set registry https://registry.npmmirror.com/
    echo "Use the Chinese mirror."
  fi
  npm install -g pm2@"$pm2Version"
  pm2 ping
  pm2 startup
  pm2 install pm2-logrotate
  pm2 set pm2-logrotate:max_size 100M
}

if [[ ! -d "$pm2Home" ]]; then
  installPM2
elif [[ $(pm2 -v) != "$pm2Version" ]]; then
  echo "PM2 $(pm2 -v) is not the version you want."
  echo ""
  installPM2
else
  echo "PM2 $(pm2 -v) is already installed."
fi

echo ""
console_key_value "nvm" "$(nvm -v)"
console_key_value "Node" "$(node -v)"
console_key_value "npm" "$(npm -v)"
console_key_value "PM2" "$(pm2 -v)"
echo ""
echo "Install complete."
