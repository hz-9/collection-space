#!/bin/bash
_m_='♥'

source ./__const.sh

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--winsw-version${_m_}${_m_}Windows Service Wrapper version. Current only support 2.x${_m_}2.12.0"
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

  "WindowsServer 2019 AMD64"
  "WindowsServer 2022 AMD64"
)

SHELL_NAME="Windows Service Wrapper Installer"
SHELL_DESC="Install 'Windows Service Wrapper'. \n
    More information: https://github.com/winsw/winsw"

source ./__judge-system.sh

source ./__console.sh

source ./__parse-user-paramter.sh

source ./__parse-paramter.sh

source ./__install.common.sh

print_help_or_param

inChina=$(get_param '--in-china')
winswVersion=$(get_param '--winsw-version')

psToolsNormalUrl="https://github.com/winsw/winsw/releases/download/v$winswVersion/WinSW-x64.exe"
psToolsChineseUrl="https://gitee.com/hz-9/some-software-installation-packages/raw/master/WinSW/v$winswVersion/WinSW-x64.exe"

psToolsFilepath=$(get_outline_package "WinSW-x64-$winswVersion.exe")

# ------------------------------------------------------------

console_title "Install Windows Service Wrapper"

if [[ -f "$psToolsFilepath" ]]; then
  console_content "$psToolsFilepath has existed."
else
  if [[ "$inChina" == "true" ]]; then
    url=$psToolsChineseUrl
    console_content "Windows Service Wrapper registry registry use the Chinese mirror."
  else
    url=$psToolsNormalUrl
    console_content "Windows Service Wrapper registry registry use the Official mirror."
  fi
  download_file "$url" "$psToolsFilepath"
fi

console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
