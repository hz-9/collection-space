#!/bin/bash

# build from install-docker-ce.sh
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--docker-version${_m_}${_m_}Docker CE version.${_m_}27.1.2-1"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SHELL_NAME="Docker CE Installer"
SHELL_DESC="Install 'docker-ce' 'docker-compose'."

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
  
    printf " ${GREEN}%s${NC} %s${NC}\n" "Done." "(${timeDiff} ms)"
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

dockerVersion=$(get_param '--docker-version')
inChina=$(get_param '--in-china')

# ------------------------------------------------------------

# build from ./_install-docker-ce.ubuntu.sh
{

  installOnUbuntu() {
    # ------------------------------------------------------------

    console_title "Install docker-ce on Ubuntu"

    local ubuntuRelease
    ubuntuRelease=$(lsb_release -rs)
    local ubuntuCodename
    ubuntuCodename=$(lsb_release -cs)
    local ubuntuVersion
    ubuntuVersion=$(lsb_release -is | tr '[:upper:]' '[:lower:]').${ubuntuRelease}~${ubuntuCodename}

    console_key_value "OS Version" "$ubuntuVersion"

    if [[ "$inChina" == "true" ]]; then
      dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/ubuntu"
      console_content "Docker source registry use the Chinese mirror."
    else
      dockerRegistry="https://download.docker.com/linux/ubuntu"
      console_content "Docker source registry use the Official mirror."
    fi

    # ------------------------------------------------------------

    # step 1: Install necessary system tools
    console_content_starting "The necessary system tools is installing..."

    # sudo apt-get -y update
    # sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
    eval "sudo apt-get -y update $(get_redirect_output)"
    eval "sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common $(get_redirect_output)"

    console_content_complete

    # ------------------------------------------------------------

    # step 2: Install GPG certificate
    if [ ! -f '/etc/apt/keyrings/docker.asc' ]; then
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL $dockerRegistry/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      console_content "The GPG certificate is installed."
    else
      console_content "The GPG certificate is already installed."
    fi

    # ------------------------------------------------------------

    # Step 3: Write software source information
    if [ ! -f '/etc/apt/sources.list.d/docker.list' ]; then
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] $dockerRegistry \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

      console_content "The software source information is written."
    else
      console_content "The software source information is already written."
    fi

    # ------------------------------------------------------------

    # Step 4: Update
    console_content_starting "The software source information is updating..."

    # sudo apt-get -y update
    eval "sudo apt-get -y update $(get_redirect_output)"

    console_content_complete

    # View all versions of Docker CE
    # apt-cache madison docker-ce

    # ------------------------------------------------------------

    installDocker() {
      console_content_starting "Docker CE '5:$dockerVersion~$ubuntuVersion' is installing..."

      # sudo apt-get -y install "docker-ce=5:$dockerVersion~$ubuntuVersion"
      eval "sudo apt-get -y install docker-ce=5:$dockerVersion~$ubuntuVersion $(get_redirect_output)"

      console_content_complete
    }

    uninstallDocker() {
      console_content_starting "Docker CE $1 is removing..."

      # sudo apt-get -y remove docker-ce
      eval "sudo apt-get -y remove docker-ce $(get_redirect_output)"

      console_content_complete
    }

    if dpkg-query -W -f='${Status}' docker-ce 2>/dev/null | grep -q "ok installed"; then
      local installedVersion
      installedVersion=$(apt-cache policy docker-ce | grep 'Installed' | awk '{print $2}')
      local dockerBaseVersion
      dockerBaseVersion="5:$dockerVersion~$ubuntuVersion"

      if [[ "$installedVersion" != "$dockerBaseVersion" ]]; then
        console_content "Docker CE ${installedVersion} is not the version you want."
        uninstallDocker "$installedVersion"
        installDocker
      else
        console_content "Docker CE ${dockerVersion} is already installed."
      fi
    else
      installDocker
    fi
  }

}

# ------------------------------------------------------------

if grep -qi 'ubuntu' /etc/os-release; then
  installOnUbuntu
else
  echo "Not support this OS."
  exit 1
fi

console_key_value "Docker CE"      "$(docker --version | awk '{print $3}' | sed 's/,//')"
console_key_value "Docker compose" "$(docker compose version | awk '{print $4}')"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
