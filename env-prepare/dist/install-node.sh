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

SHELL_DES="Install 'nvn' 'node.js' and 'pm2'."

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
    echo "User paramters:"
    echo ""

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value=$(awk -F "$_m_" '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      
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

  has_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value=$(awk -F "$_m_" '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      
      if [[ "$name" == "$key" ]]; then
        return 0
      fi
    done

    return 1
  }

  get_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value=$(awk -F "$_m_" '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      
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
    echo "Default paramters:"
    echo ""

    for PARAMTER in "${PARAMTERS[@]}"; do
      local name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value=$(awk -F "$_m_" '{ for (i=4; i<=4; i++) print $i }' <<< "$PARAMTER")

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
      local name=$(awk -F "${_m_}" '{ for (i=1; i<=1; i++) print $i }' <<<"$PARAMTER")

      if [[ "$name" == "$key" ]]; then
        return 0
      fi
    done

    return 1
  }

  get_param_default() {
    local key="$1"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local name=$(awk -F "${_m_}" '{ for (i=1; i<=1; i++) print $i }' <<<"$PARAMTER")
      local default=$(awk -F "${_m_}" '{ for (i=4; i<=4; i++) print $i }' <<<"$PARAMTER")

      if [[ "$name" == "$key" ]]; then
        echo "$default"
      fi
    done

    return
  }

  get_param() {
    local key="$1"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local name=$(awk -F "${_m_}" '{ for (i=1; i<=1; i++) print $i }' <<<"$PARAMTER")
      local alias=$(awk -F $_m_ '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      local default=$(awk -F "${_m_}" '{ for (i=4; i<=4; i++) print $i }' <<<"$PARAMTER")

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
      local name=$(awk -F $_m_ '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local alias=$(awk -F $_m_ '{ for (i=2; i<=2; i++) print $i }' <<< "$PARAMTER")
      local msg=$(awk -F $_m_ '{ for (i=3; i<=3; i++) print $i }' <<< "$PARAMTER")
      local default=$(awk -F $_m_ '{ for (i=4; i<=4; i++) print $i }' <<< "$PARAMTER")

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
      local name=$(awk -F "$_m_" '{ for (i=1; i<=1; i++) print $i }' <<< "$PARAMTER")
      local value=$(get_param "$name")

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

if [[ $(get_param '--help') == "true" ]]; then
  print_help
  exit 0
else
  print_param
fi

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
echo "nvm  version : $(nvm -v)"
echo "Node version : $(node -v)"
echo "npm  version : $(npm -v)"
echo "PM2  version : $(pm2 -v)"
echo ""
echo "Install complete."
