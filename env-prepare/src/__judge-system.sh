#!/bin/bash
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
      else
        echo "$__BASE_OS_NAME__"
      fi
    }

    judge_window_system() {
      local _OS_NAME
      _OS_NAME=$(judge_name)
      if [[ "$_OS_NAME" == "MINGW"* ]] || [[ "$_OS_NAME" == "CYGWIN"* ]] || [[ "$_OS_NAME" == "MSYS"* ]] || [[ "$_OS_NAME" == "Windows_NT" ]]; then
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
      OS_NAME='Windows'
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
