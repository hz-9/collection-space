#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--7zip-version${_m_}${_m_}7Zip version. Default is lastest available.${_m_}"
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

SHELL_NAME="7Zip Installer"
SHELL_DESC="Install '7zip'."

source ./__judge-system.sh

source ./__console.sh

source ./__parse-user-paramter.sh

source ./__parse-paramter.sh

source ./__install.common.sh

print_help_or_param

z7Version=$(get_param '--7zip-version')

inChina=$(get_param '--in-china')

# ------------------------------------------------------------

console_title "Install 7zip"

if command -v 7z &> /dev/null; then
  console_content "7Zip is already installed."
else
  install_by_apt_get() {
    apt_get_update

    local local="7Zip"
    local name="p7zip-full"
    local version=$z7Version

    apt_get_install "$local" "$name" "$version"
  }

  install_by_dnf() {
    if [[ "$OS_NAME" == "RedHat" ]]; then
      dnf_add_epel_repo "$inChina" "$(echo "$OS_VERS" | cut -d '.' -f 1)"
    fi

    dnf_update

    local local="7Zip"
    local name="p7zip"
    local version=$z7Version
    
    dnf_install "$local" "$name" "$version"

    local="7Zip Plugins"
    name="p7zip-plugins"
    version=$z7Version
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

get_7zip_version() {
  local v1
  v1=$(7z | head -n 2 | tail -n 1 | awk '{print $3}')

  if [[ "$v1" == "(x64)" ]]; then
    v1=$(7z | head -n 2 | tail -n 1 | awk '{print $2}')
  fi

  echo "$v1"
}
console_key_value "7Zip" "$(get_7zip_version)"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
