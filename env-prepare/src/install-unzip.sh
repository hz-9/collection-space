#!/bin/bash
_m_='♥'

source ./__const.sh

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--unzip-version${_m_}${_m_}unzip version. Default is lastest available.${_m_}"
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

SHELL_NAME="unzip Installer"
SHELL_DESC="Install 'unzip'."

source ./__judge-system.sh

source ./__console.sh

source ./__parse-user-paramter.sh

source ./__parse-paramter.sh

source ./__install.common.sh

print_help_or_param

unzipVersion=$(get_param '--unzip-version')

inChina=$(get_param '--in-china')

# ------------------------------------------------------------

console_title "Install unzip"

if command -v unzip &>/dev/null; then
  console_content "unzip is already installed."
else
  install_by_apt_get() {
    apt_get_update

    local local="unzip"
    local name="unzip"
    local version=$unzipVersion

    apt_get_install "$local" "$name" "$version"
  }

  install_by_dnf() {
    if [[ "$OS_NAME" == "RedHat" ]]; then
      dnf_add_epel_repo "$inChina" "$(echo "$OS_VERS" | cut -d '.' -f 1)"
    fi

    dnf_update

    local local="unzip"
    local name="unzip"
    local version=$unzipVersion

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

console_key_value "unzip" "$(unzip -v | sed -n '1s/UnZip \([0-9.]*\).*/\1/p')"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
