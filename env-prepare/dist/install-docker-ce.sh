#!/bin/bash

# build from install-docker-ce.sh
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--docker-version${_m_}${_m_}Docker CE version.${_m_}27.1.2-1"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SUPPORT_OS_LIST=(
  "Ubuntu 20.04 AMD64"
  "Ubuntu 22.04 AMD64"
  "Ubuntu 24.04 AMD64"
)

SHELL_NAME="Docker CE Installer"
SHELL_DESC="Install 'docker-ce' 'docker-compose'."

# build from ./_judge-system.sh
{
  OS_NAME=''
  OS_VERS=''
  OS_ARCH=''
  CURRENT_OS=''

  IS_WINDOWS=false
  IS_LINUX=false
  IS_MACOS=false
  IS_SUPPORT_OS=false

  judge_system() {
    local __OS_NAME__
    local __OS_VERS__
    local __OS_ARCH__

    if [ -f /etc/os-release ]; then
      . /etc/os-release
      __OS_NAME__=$NAME
      __OS_VERS__=$VERSION_ID
      __OS_ARCH__=$(uname -m)
    else
      __OS_NAME__=$(uname -s)
      __OS_VERS__=$(uname -r)
      __OS_ARCH__=$(uname -m)
    fi

    judge_window_system() {
      if [[ "$__OS_NAME__" == "MINGW"* ]] || [[ "$__OS_NAME__" == "CYGWIN"* ]] || [[ "$__OS_NAME__" == "MSYS"* ]] || [[ "$__OS_NAME__" == "Windows_NT" ]]; then
        return 0
      else
        return 1
      fi
    }

    judge_linux_system() {
      if [[ "$__OS_NAME__" == "Linux" ]]; then
        return 0
      else
        return 1
      fi
    }

    judge_macos_system() {
      if [[ "$__OS_NAME__" == "Darwin" ]]; then
        return 0
      else
        return 1
      fi
    }

    judge_arch() {
      if [[ "$__OS_ARCH__" == "arm64" ]]; then
        echo "ARM64"
      else
        echo "$__OS_ARCH__"
      fi
    }

    if judge_window_system; then
      OS_NAME='Windows'
      IS_WINDOWS=true
    elif judge_linux_system; then
      OS_NAME='Linux'
      IS_LINUX=true
    elif judge_macos_system; then
      OS_NAME='MacOS'
      IS_MACOS=true
    else
      OS_NAME='Unknown'
    fi

    OS_VERS=$__OS_VERS__
    OS_ARCH=$(judge_arch)
    CURRENT_OS="$OS_NAME $OS_VERS $OS_ARCH"

    check_system() {
      is_support_current_os() {
        for os_info in "${SUPPORT_OS_LIST[@]}"; do
          # 使用 read 将每个元素分成三个部分
          read -r current_os_name current_os_vers current_os_arch <<<"$os_info"
          # echo "操作系统名称: $current_os_name"
          # echo "版本: $current_os_vers"
          # echo "架构: $current_os_arch"

          if [[ "$current_os_name" == "$OS_NAME" ]] && [[ "$current_os_vers" == "$OS_VERS" ]] && [[ "$current_os_arch" == "$OS_ARCH" ]]; then
            return 0
          fi
        done
        return 1
      }

      if is_support_current_os; then
        IS_SUPPORT_OS=true
      fi
    }

    check_system
  }

  judge_system

  print_system_info() {
    echo "OS_NAME    : $OS_NAME"
    echo "OS_VERSION : $OS_VERS"
    echo "OS_ARCH    : $OS_ARCH"
  }

  print_system_extra_info() {
    print_system_info
    echo "IS_WINDOWS : $IS_WINDOWS"
    echo "IS_LINUX   : $IS_LINUX"
    echo "IS_MACOS   : $IS_MACOS"
  }
}

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

  console_check_system() {
    if [[ "$IS_SUPPORT_OS" == false ]]; then
      printf "  ${RED}%s${NC}\n\n"   "This shell script does not support the current operating system. [$CURRENT_OS]"
      printf "  ${YELLOW}%s${NC}\n\n" "Supported operating systems:"
      for os_info in "${SUPPORT_OS_LIST[@]}"; do
        printf "    ${YELLOW}%s${NC}\n" "$os_info"
      done
      console_empty_line
    
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

    console_check_system

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

    console_check_system

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

    # shellcheck disable=SC2154
    if [[ "${inChina}" == "true" ]]; then
      dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/ubuntu"
      console_content "Docker source registry use the Chinese mirror."
    else
      dockerRegistry="https://download.docker.com/linux/ubuntu"
      console_content "Docker source registry use the Official mirror."
    fi

    # ------------------------------------------------------------

    # step 1: Install necessary system tools
    console_content_starting "Package list is updating..."
    # sudo apt-get -y update
    eval "sudo apt-get -y update $(get_redirect_output)"
    console_content_complete

    console_content_starting "The necessary system tools is installing..."
    # sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
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
    console_content_starting "Package list is updating..."
    # sudo apt-get -y update
    eval "sudo apt-get -y update $(get_redirect_output)"
    console_content_complete

    # View all versions of Docker CE
    # apt-cache madison docker-ce

    # ------------------------------------------------------------

    installDocker() {
      # shellcheck disable=SC2154
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
