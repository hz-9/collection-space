#!/bin/bash
_m_='♥'

source ./__const.sh

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--7zip-version${_m_}${_m_}7Zip version.${_m_}24.08"
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

if command -v 7zz &>/dev/null; then
  console_content "7Zip is already installed."
else
  install_from_github_release() {
    console_content_starting "7Zip $z7Version is installing..."

    if ! command -v jq &> /dev/null; then
      console_content_error "Not found jq, please install jq first."
      console_empty_line
      exit 1
    fi

    local support_versions
    support_versions=$(curl -s "https://api.github.com/repos/ip7z/7zip/releases" | jq -r '.[].tag_name')

    if echo "$support_versions" | grep -q "^${z7Version}$"; then
      converted_version=$(echo "$z7Version" | tr -d '.')
      local url="https://github.com/ip7z/7zip/releases/download/$z7Version/7z${converted_version}-linux-x64.tar.xz"

      # curl -L "$url" -o "7z${converted_version}-linux-x64.tar.xz"
      # mkdir -p "/usr/local/7z/${z7Version}"
      # tar -xf "7z${converted_version}-linux-x64.tar.xz" -C "/usr/local/7z/${z7Version}"
      # rm -rf "./7z${converted_version}-linux-x64.tar.xz"
      # ln -s "/usr/local/7z/${z7Version}/7zz" /usr/bin/7zz
      # chmod +x /usr/bin/7zz
      # eval "curl -L $url -o 7z${converted_version}-linux-x64.tar.xz $(get_redirect_output)"
      download_file "$url" "$(pwd)/7z${converted_version}-linux-x64.tar.xz" "false"

      mkdir -p "/usr/local/7z/${z7Version}"
      eval "tar -xf 7z${converted_version}-linux-x64.tar.xz -C /usr/local/7z/${z7Version} $(get_redirect_output)"
      rm -rf "./7z${converted_version}-linux-x64.tar.xz"
      ln -s "/usr/local/7z/${z7Version}/7zz" /usr/bin/7zz
      chmod +x /usr/bin/7zz
    else
      console_content_error "7Zip $z7Version is not available."
      console_content "Support versions:"
      console_sulines "$support_versions"
      console_empty_line
      exit 1
    fi

    console_content_complete
  }

  if [[ "$OS_NAME" == "Ubuntu" ]] || [[ "$OS_NAME" == "Debian" ]] || [[ "$OS_NAME" == "Fedora" ]] || [[ "$OS_NAME" == "RedHat" ]] || [[ "$OS_NAME" == "AlibabaCloudLinux" ]]; then
    install_from_github_release
  else
    echo "Not support this OS."
    exit 1
  fi
fi

console_key_value "7Zip" "$(7zz | head -n 2 | tail -n 1 | awk '{print $3}')"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
