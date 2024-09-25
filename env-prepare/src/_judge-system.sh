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
      if [[ "$__OS_NAME__" == "Ubuntu" ]]; then
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
      elif [[ "$__OS_ARCH__" == "x86_64" ]]; then
        echo "AMD64"
      else
        echo "$__OS_ARCH__"
      fi
    }

    if judge_window_system; then
      OS_NAME='Windows'
      IS_WINDOWS=true
    elif judge_linux_system; then
      OS_NAME=$__OS_NAME__
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
