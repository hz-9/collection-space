#!/bin/bash
_m_='♥'

source ./__const.sh

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--action${_m_}-v${_m_}Action. (action: 'online-install' / 'outline-prepare' / 'outline-install')${_m_}online-install"
  "--package${_m_}${_m_}The package's filepath for offline installation.${_m_}$(get_outline_package 'pstools.zip')"

  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SUPPORT_OS_LIST=(
  "WindowsServer 2019 AMD64"
  "WindowsServer 2022 AMD64"
)

SHELL_NAME="Sysinternals PsTools Installer"
SHELL_DESC="Install 'Sysinternals PsTools'. \n
    More information: https://docs.microsoft.com/en-us/sysinternals/downloads/pstools"

source ./__judge-system.sh

source ./__console.sh

source ./__parse-user-paramter.sh

source ./__parse-paramter.sh

source ./__install.common.sh

print_help_or_param

inChina=$(get_param '--in-china')
action=$(get_param '--action')
package=$(get_param '--package')

installDir="/c/Program Files/Sysinternals/PsTools"

psToolsNormalUrl="https://download.sysinternals.com/files/PSTools.zip"
psToolsChineseUrl="https://gitee.com/hz-9/some-software-installation-packages/raw/master/Sysinternals/PsTools/PSTools.zip"

psToolsFilepath=$package

# ------------------------------------------------------------

console_title "Install Sysinternals PsTools"

pstools_package_prepare() {
  local url
  if [[ "$inChina" == "true" ]]; then
    url=$psToolsChineseUrl
    console_content "Sysinternals PsTools registry registry use the Chinese mirror."
  else
    url=$psToolsNormalUrl
    console_content "Sysinternals PsTools registry registry use the Official mirror."
  fi
  local filepath=$psToolsFilepath

  if [[ "$action" == "online-install" ]]; then
    download_file "$url" "$filepath"
  else
    console_content_starting "The Sysinternals PsTools outline install package is preparing..."

    download_file "$url" "$filepath" "false"

    console_content_complete

    console_empty_line

    console_key_value "Outline Package" "$filepath"
  fi
}

pstools_package_install() {
  if [[ -f "$installDir/psversion.txt" ]]; then
    console_content "Sysinternals PsTools is already installed."
  else
    console_content_starting "Sysinternals PsTools is installing..."
    
    unzip_file "$psToolsFilepath" "$installDir"

    console_content_complete
  fi

  local ps_version
  ps_version=$(grep -oP '(?<=PsTools Version in this package: )\d+\.\d+' "$installDir/psversion.txt")

  console_key_value "PsTools" "$ps_version"
  console_empty_line
}

if [[ "$action" == "outline-prepare" ]]; then
  pstools_package_prepare
elif [[ "$action" == "outline-install" ]]; then
  pstools_package_install
elif [[ "$action" == "online-install" ]]; then
  pstools_package_prepare
  pstools_package_install
else
  console_content_error "The action '$action' is not supported."
  console_empty_line
  exit 1
fi

console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
