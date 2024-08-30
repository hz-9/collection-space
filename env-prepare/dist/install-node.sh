#!/bin/bash

# build from install-node.sh
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--nvm-version${_m_}${_m_}Nvm version.${_m_}v0.40.0"
  "--node-version${_m_}${_m_}Node.js version.${_m_}v18.20.3"
  "--pm2-version${_m_}${_m_}PM2 version.${_m_}5.4.2"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SHELL_NAME="Node.js Installer"
SHELL_DESC="Install 'nvn' 'node.js' and 'pm2'."

# build from ./_console.sh
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

# build from ./_parse-user-paramter.sh
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
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

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
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

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
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

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

# build from ./_parse-paramter.sh
{

  print_default_param() {
    console_title "Default paramters:"

    # shellcheck disable=SC2153
    for PARAMTER in "${PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"
      local value
      value="${split[3]}"

      console_key_value "${name//--/}" "$value"
    done
    console_empty_line

    return 1
  }

  has_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"

      if [[ "$name" == "$key" ]]; then
        return 0
      fi
    done

    return 1
  }

  get_param() {
    local key="$1"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"

      if [[ "$name" == "$key" ]]; then
        local alias
        alias="${split[1]}"
        local default
        default="${split[3]}"

        if has_user_param "$name"; then
          get_user_param "$name"
        elif has_user_param "$alias"; then
          get_user_param "$alias"
        else
          echo "$default"
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
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"
      local alias
      alias="${split[1]}"
      local msg
      msg="${split[2]}"
      local default
      default="${split[3]}"

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
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"
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

# ------------------------------------------------------------

console_title "Install nvm"

if [[ ! -f "$nvmHome/README.md" ]]; then
  console_content_starting "nvm '${nvmHome}' is installing..."

  if [ "$(get_param '--debug')" == 'true' ]; then
    curl    -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvmVersion}/install.sh" | METHOD=git bash
  else
    curl -s -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvmVersion}/install.sh" | METHOD=git bash &> /dev/null
  fi

  console_content_complete
  source "${nvmHome}/nvm.sh"
else
  console_content "nvm ${nvmHome} is already installed."
  source "${nvmHome}/nvm.sh"
fi

console_key_value "nvm" "$(nvm -v)"
console_empty_line

# ------------------------------------------------------------

console_title "Install Node.js"

if [[ ! -d "$nodeHome" ]]; then
  if [[ "$inChina" == "true" ]]; then
    export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/
    export NVM_IOJS_ORG_MIRROR=https://mirrors.huaweicloud.com/iojs/
    console_content "Node.js source registry use the Chinese mirror."
  else
    console_content "Node.js source registry use the Default mirror."
  fi

  console_content_starting "Node.js ${nodeVersion} is installing..."

  # nvm install "$nodeVersion"
  eval "nvm install $nodeVersion        $(get_redirect_output)"

  console_content_complete
else
  console_content "Node.js ${nodeVersion} is already installed."
fi

console_key_value "Node" "$(node -v)"
console_key_value "npm" "$(npm -v)"
console_empty_line

# ------------------------------------------------------------

console_title "Install pm2 and pm2-logrotate"

installPM2() {
  if [[ "$inChina" == "true" ]]; then
    npm config set registry https://registry.npmmirror.com/
    console_content "npm registry use the Chinese mirror."
  else
    console_content "npm registry use the Default mirror."
  fi

  console_content_starting "pm2 ${pm2Version} is installing..."
  # npm install -g pm2@"$pm2Version"
  eval "npm install -g pm2@$pm2Version        $(get_redirect_output)"
  # pm2 ping
  eval "pm2 ping                              $(get_redirect_output)"
  console_content_complete

  # pm2 startup
  eval "pm2 startup                           $(get_redirect_output)"
  console_content "pm2 startup is done."

  console_content_starting "pm2-logrotate is installing..."
  # pm2 install pm2-logrotate
  eval "pm2 install pm2-logrotate             $(get_redirect_output)"
  # pm2 set pm2-logrotate:max_size 100M
  eval "pm2 set pm2-logrotate:max_size 100M   $(get_redirect_output)"
  console_content_complete
}

if [[ ! -d "$pm2Home" ]]; then
  installPM2
elif [[ $(pm2 -v) != "$pm2Version" ]]; then
  console_content "PM2 $(pm2 -v) is not the version you want."
  installPM2
else
  console_content "PM2 $(pm2 -v) is already installed."
fi

console_key_value "pm2" "$(pm2 -v)"
console_key_value "pm2-logrotate" "$(pm2 info pm2-logrotate | grep 'version' | head -n 1 | awk '{print $4}')"

console_empty_line

# ------------------------------------------------------------

console_end  "Install complete."
