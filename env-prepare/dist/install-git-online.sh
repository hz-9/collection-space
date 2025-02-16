#!/bin/bash

# import from install-git-online.sh
_m_='♥'

# import from ./__const.sh
{
  get_outline_package() {
    local packageName="$1"
    echo "${HOME}"/Downloads/"$packageName"
  }

  # to_windows_path_format() {
  #   local original_path=$1
  #   local windows_path
  #   windows_path=$(echo "$original_path" | sed 's|^/c/|C:\\|' | sed 's|/|\\|g')
  #   echo "$windows_path"
  # }

  to_windows_path_format() {
    local original_path=$1
    local windows_path
    windows_path=$(echo "$original_path" | sed 's|^/\([a-zA-Z]\)/|\1:\\|' | sed 's|/|\\|g')
    echo "$windows_path"
  }

  to_git_bash_path_format() {
    local original_path=$1
    local git_bash_path
    git_bash_path=$(echo "$original_path" | sed 's|^\([a-zA-Z]\):|/\1|' | sed 's|\\|/|g')
    echo "$git_bash_path"
  }
}

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--git-version${_m_}${_m_}Git version. Default is lastest available.${_m_}"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SUPPORT_OS_LIST=(
  "Ubuntu 20.04 AMD64"
  "Ubuntu 22.04 AMD64"
  "Ubuntu 24.04 AMD64"

  "Debian 11.9 AMD64"
  "Debian 12.2 AMD64"

  "Fedora 40 AMD64"

  "RedHat 8.5 AMD64"
  "RedHat 9.0 AMD64"

  "AlibabaCloudLinux 3.2104 AMD64"
)

SHELL_NAME="Git Installer"
SHELL_DESC="Install 'git' by software manange tool."

# import from ./__judge-system.sh
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
    local __BASE_OS_NAME__
    local __BASE_OS_VERS__
    local __BASE_OS_ARCH__

    if [ -f /etc/os-release ]; then
      . /etc/os-release
      __BASE_OS_NAME__=$NAME
      __BASE_OS_VERS__=$VERSION_ID
      __BASE_OS_ARCH__=$(uname -m)
    else
      __BASE_OS_NAME__=$(uname -s)
      __BASE_OS_VERS__=$(uname -r)
      __BASE_OS_ARCH__=$(uname -m)
    fi

    # -------------------- judge os name --------------------

    judge_name() {
      if [[ "$__BASE_OS_NAME__" == "Debian GNU/Linux" ]]; then
        echo "Debian"
      elif [[ "$__BASE_OS_NAME__" == "Fedora Linux" ]]; then
        echo "Fedora"
      elif [[ "$__BASE_OS_NAME__" == "Alibaba Cloud Linux" ]]; then
        echo "AlibabaCloudLinux"
      elif [[ "$__BASE_OS_NAME__" == "Red Hat Enterprise Linux" ]]; then
        echo "RedHat"
      elif [[ "$__BASE_OS_NAME__" == "MINGW"* ]] || [[ "$__BASE_OS_NAME__" == "CYGWIN"* ]] || [[ "$__BASE_OS_NAME__" == "MSYS"* ]] || [[ "$__BASE_OS_NAME__" == "Windows_NT" ]]; then
        # Read from 'registry' to determine the Windows version
        local productName
        productName=$(powershell.exe -Command "(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName" | tr -d '\r')
        if [[ "$productName" == "Windows Server 2019"* ]] || [[ "$productName" == "Windows Server 2022"* ]]; then
          echo "WindowsServer"
        else 
          echo "No Support Windows Version"
        fi
      else
        echo "$__BASE_OS_NAME__"
      fi
    }

    judge_window_system() {
      local _OS_NAME
      _OS_NAME=$(judge_name)
      if [[ "$_OS_NAME" == "WindowsServer" ]]; then
        return 0
      else
        return 1
      fi
    }

    judge_linux_system() {
      local _OS_NAME
      _OS_NAME=$(judge_name)
      if [[ "$_OS_NAME" == "Ubuntu" ]] || [[ "$_OS_NAME" == "Debian" ]] || [[ "$_OS_NAME" == "Fedora" ]] || [[ "$_OS_NAME" == "RedHat" ]] || [[ "$_OS_NAME" == "AlibabaCloudLinux" ]]; then
        return 0
      else
        return 1
      fi
    }

    judge_macos_system() {
      local _OS_NAME
      _OS_NAME=$(judge_name)
      if [[ "$_OS_NAME" == "Darwin" ]]; then
        return 0
      else
        return 1
      fi
    }

    if judge_window_system; then
      OS_NAME=$(judge_name)
      IS_WINDOWS=true
    elif judge_linux_system; then
      OS_NAME=$(judge_name)
      IS_LINUX=true
    elif judge_macos_system; then
      OS_NAME='MacOS'
      IS_MACOS=true
    else
      OS_NAME='Unknown'
    fi

    # -------------------- judge os version -----------------

    judge_version() {
      if [[ "$OS_NAME" == "MacOS" ]]; then
        sw_vers -productVersion
      elif [[ "$OS_NAME" == "Debian" ]]; then
        cat /etc/debian_version
      elif [[ "$OS_NAME" == "AlibabaCloudLinux" ]]; then
        . /etc/os-release
        echo "$PRETTY_NAME" | awk '{print $4}'
      elif [[ "$OS_NAME" == "WindowsServer" ]]; then
        local productName
        productName=$(powershell.exe -Command "(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName" | tr -d '\r')
        echo "$productName" | awk '{print $3}'
      else
        echo "$__BASE_OS_VERS__"
      fi
    }

    OS_VERS=$(judge_version)

    # -------------------- judge os arch --------------------

    judge_arch() {
      if [[ "$__BASE_OS_ARCH__" == "arm64" ]]; then
        echo "ARM64"
      elif [[ "$__BASE_OS_ARCH__" == "x86_64" ]]; then
        echo "AMD64"
      else
        echo "$__BASE_OS_ARCH__"
      fi
    }

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
    echo "CURRENT_OS : $CURRENT_OS"
  }

  print_system_extra_info() {
    print_system_info
    echo "IS_WINDOWS : $IS_WINDOWS"
    echo "IS_LINUX   : $IS_LINUX"
    echo "IS_MACOS   : $IS_MACOS"
  }

  # print_system_extra_info
}

# import from ./__console.sh
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

    if [ "$(get_param '--debug')" == 'false' ]; then
      printf "    %s" "$1"
    else
      printf "    %s\n\n" "$1"
    fi
  }

  console_content_complete() {
    local currentTime
    currentTime=$(get_current_time_ms)
    local timeDiff
    timeDiff=$((currentTime - tempTime))

    if [ "$(get_param '--debug')" == 'false' ]; then
      printf " ${GREEN}%s${NC} %s${NC}\n" "done." "(${timeDiff} ms)"
    else
      printf "\n ${GREEN}%s${NC} %s${NC}\n" "done." "(${timeDiff} ms)"
    fi
  }

  console_content_error() {
    local msg=$1

    if [ "$(get_param '--debug')" == 'false' ]; then
      printf " ${RED}%s${NC}\n" "error."
      printf "    ${RED}%s${NC}\n" "Reason: \"${msg}\""
    else
      printf "\n ${RED}%s${NC}\n" "error."
      printf "    ${RED}%s${NC}\n" "Reason: \"${msg}\""
    fi
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

# import from ./__parse-user-paramter.sh
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

# import from ./__parse-paramter.sh
{

  print_default_param() {
    console_title "Default paramters:"

    # shellcheck disable=SC2153
    for PARAMTER in "${PARAMTERS[@]}"; do
      local split
      IFS="$_m_" read -r -a split <<< "$PARAMTER"

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
      IFS="${_m_}" read -r -a split <<< "$PARAMTER"

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
      IFS="${_m_}" read -r -a split <<< "$PARAMTER"

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
      IFS="${_m_}" read -r -a split <<< "$PARAMTER"

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

    console_check_system

    console_support_os

    return 1
  }

  print_param() {
    console_name

    console_desc

    console_check_system

    console_title "Paramters:"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local split
      IFS="${_m_}" read -r -a split <<< "$PARAMTER"

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

# import from ./__install.common.sh
{
  apt_get_update() {
    console_content_starting "Package list is updating..."
    # sudo apt-get -y update
    eval "sudo apt-get -y update $(get_redirect_output)"
    console_content_complete
  }

  apt_get_install() {
    local label="$1"
    local name="$2"
    local version="$3"

    # shellcheck disable=SC2086,SC2155
    local versions="$(apt-cache madison $name | awk '{print $3}')"

    console_content_starting "$label is installing..."
    if [[ -z "$version" ]]; then
      # sudo apt-get -y install git
      eval "sudo apt-get -y install $name $(get_redirect_output)"
    else
      # choose version
      if echo "$versions" | grep -q "^${version}$"; then
        # sudo apt-get install git="$gitVersion" -y
        eval "sudo apt-get -y install $name=$version $(get_redirect_output)"
      else
        console_content_error "$label $version is not available."
        console_content "Support versions:"
        console_sulines "$versions"
        console_empty_line
        exit 1
      fi
    fi
    console_content_complete
  }

  dnf_update() {
    console_content_starting "Package list is updating..."
    # sudo apt-get -y update
    eval "sudo dnf makecache $(get_redirect_output)"
    console_content_complete
  }

  dnf_add_epel_repo() {
    local inChina="$1"
    local version="$2"
    local repoUrl

    if [[ "$inChina" == "true" ]]; then
      console_content "dnf registry use the Chinese mirror."

      repoUrl="https://mirrors.aliyun.com/epel/epel-release-latest-$version.noarch.rpm"
    else
      console_content "dnf registry use the Fedora Offical mirror."
      repoUrl="https://dl.fedoraproject.org/pub/epel/epel-release-latest-$version.noarch.rpm"
    fi

    console_content_starting "Epel repo is installing..."
    # sudo dnf install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm
    eval "sudo dnf install -y $repoUrl $(get_redirect_output)"
    console_content_complete
  }

  dnf_install() {
    local label="$1"
    local name="$2"
    local version="$3"

    # shellcheck disable=SC2086,SC2155
    local versions="$(dnf list --showduplicates $name | awk '{print $2}' | tail -n +2)"
    if echo "$versions" | grep -q "Packages"; then
      versions=$(echo "$versions" | tail -n +2)
    fi

    console_content_starting "$label is installing..."
    if [[ -z "$version" ]]; then
      # sudo dnf -y install git
      eval "sudo dnf -y install $name $(get_redirect_output)"
    else
      # choose version
      if echo "$versions" | grep -q "^${version}$"; then
        # sudo dnf install git="$gitVersion" -y
        eval "sudo dnf -y install $name-$version $(get_redirect_output)"
      else
        console_content_error "$label $version is not available."
        console_content "Support versions:"
        console_sulines "$versions"
        console_empty_line
        exit 1
      fi
    fi
    console_content_complete
  }

  download_file() {
    local url="$1"
    local target="$2"
    local dir
    dir=$(dirname "$target")
    local filename
    filename=$(basename "$target")
    local showConsoleContent="$3"

    mkdir -p "$dir"

    if [[ "$showConsoleContent" != "false" ]]; then
      console_content "The file '$filename' is downloading..."
      console_content "  from : $url"
      console_content "  to   : $target"
      console_content_starting "..."
    fi

    eval "curl -L '$url' -o '$target' $(get_redirect_output)"

    if [[ "$showConsoleContent" != "false" ]]; then
      console_content_complete
    fi
  }

  unzip_file() {
    local sourceFile=$1
    local targetDir=$2

    mkdir -p "$targetDir"

    if [[ $IS_WINDOWS == true ]]; then
      # powershell.exe -Command "
      #   \$zipFile = '$(to_windows_path_format "$sourceFile")'
      #   \$targetDir = '$(to_windows_path_format "$targetDir")'
      #   Add-Type -AssemblyName System.IO.Compression.FileSystem
      #   [System.IO.Compression.ZipFile]::ExtractToDirectory(\$zipFile, \$targetDir)
      # "
      eval """
        powershell.exe -Command \"
          Add-Type -AssemblyName System.IO.Compression.FileSystem
          [System.IO.Compression.ZipFile]::ExtractToDirectory(
            '$(to_windows_path_format "$sourceFile")'
          , '$(to_windows_path_format "$targetDir")')
        \"
       $(get_redirect_output)

      """
    else
      # tar -xf "$1" -C "$2"
      echo "TODO"
    fi
  }
}

print_help_or_param

gitVersion=$(get_param '--git-version')

inChina=$(get_param '--in-china')

# ------------------------------------------------------------

console_title "Install git"

if command -v git &>/dev/null; then
  console_content "Git is already installed."
else
  install_by_apt_get() {
    apt_get_update

    local local="Git"
    local name="git"
    local version=$gitVersion

    apt_get_install "$local" "$name" "$version"
  }

  install_by_dnf() {
    if [[ "$OS_NAME" == "RedHat" ]]; then
      dnf_add_epel_repo "$inChina" "$(echo "$OS_VERS" | cut -d '.' -f 1)"
    fi

    dnf_update

    local local="Git"
    local name="git"
    local version=$gitVersion
    
    dnf_install "$local" "$name" "$version"
  }

  if [[ "$OS_NAME" == "Ubuntu" ]] || [[ "$OS_NAME" == "Debian" ]]; then
    install_by_apt_get
  elif [[ "$OS_NAME" == "Fedora" ]] || [[ "$OS_NAME" == "RedHat" ]] || [[ "$OS_NAME" == "AlibabaCloudLinux" ]]; then
    install_by_dnf
  else
    echo "Not support this OS."
    exit 1
  fi
fi

console_key_value "Git" "$(git --version | awk '{print $3}')"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
