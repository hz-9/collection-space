#!/bin/bash
_m_='♥'

source ./__const.sh

source ./__judge-system.sh

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--git-version${_m_}${_m_}Git version. Default is lastest available.${_m_}2.47.0"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"

  "--action${_m_}-v${_m_}Action. (action: 'online-install' / 'outline-prepare' / 'outline-install')${_m_}online-install"
  "--package${_m_}${_m_}The package's filepath for offline installation.${_m_}$(get_outline_package 'Git-64-bit.zip')"
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
SHELL_DESC="Install 'git' by installation package."

source ./__console.sh

source ./__parse-user-paramter.sh

source ./__parse-paramter.sh

source ./__install.common.sh

print_help_or_param

gitVersion=$(get_param '--git-version')

inChina=$(get_param '--in-china')

action=$(get_param '--action')

package=$(get_param '--package')

# ------------------------------------------------------------

console_title "Install git"

gitFilepath="$package"
gitDirpath=$(dirname "$gitFilepath")/git

support_versions='2.47.0'

git_windows_package_prepare() {
  echo "Prepare git on Windows. TODO"

  local url
  if [[ "$inChina" == "true" ]]; then
    url="https://mirrors.huaweicloud.com/git-for-windows/"
    console_content "Git registry use the Chinese mirror."
  else
    url="https://github.com/git-for-windows/git/releases/download/"
    console_content "Git registry use the Official mirror."
  fi

  if echo "$support_versions" | grep -q "^${gitVersion}$"; then
    local filepath=$gitFilepath

    # 1. 下载文件
    # 2. 写入版本信息
    # 3. 压缩文件

    if [[ "$action" == "online-install" ]]; then
      download_file "$url/$gitVersion.windows.1/Git-$gitVersion-64-bit.exe" "$filepath"
    else
      console_content_starting "The Git outline install package is preparing..."

      download_file "$url/$gitVersion.windows.1/Git-$gitVersion-64-bit.exe" "$filepath" "false"

      console_content_complete
      console_empty_line
      console_key_value "Outline Package" "$filepath"
    fi
  else
    console_content_error "Git $gitVersion is not available."
    console_content "Support versions:"
    console_sulines "$support_versions"
    console_empty_line
    exit 1
  fi
}

git_windows_package_install() {
  echo "Install git on Windows. TODO"
}

git_linux_package_prepare() {
  echo "Prepare git on Linux. TODO"
}

git_linux_package_install() {
  echo "Install git on Linux. TODO"
}

# install_on_windows() {
#   # local url
#   # if [[ "$inChina" == "true" ]]; then
#   #   url="https://mirrors.huaweicloud.com/git-for-windows/"
#   #   console_content "Git registry use the Chinese mirror."
#   # else
#   #   url="https://github.com/git-for-windows/git/releases/download/"
#   # fi

#   # if echo "$support_versions" | grep -q "^${gitVersion}$"; then
#   #   download_file "$url/$gitVersion.windows.1/Git-$gitVersion-64-bit.exe" "$package"

#   #   console_content "Git $gitVersion is downloaded."

#   #   # sdk install java $javaVersion
#   #   # eval "sdk install tomcat $tomcatVersion $(get_redirect_output)"
#   # else
#   #   console_content_error "Git $gitVersion is not available."
#   #   console_content "Support versions:"
#   #   console_sulines "$support_versions"
#   #   console_empty_line
#   #   exit 1
#   # fi
# }

# install_on_linux() {
#   local support_versions='2.47.0'

#   echo "Install git on Linux. TODO"
# }

if judge_window_system; then
  if [[ "$action" == "outline-prepare" ]]; then
    git_windows_package_prepare
  elif [[ "$action" == "outline-install" ]]; then
    git_windows_package_install
  elif [[ "$action" == "online-install" ]]; then
    git_windows_package_prepare
    git_windows_package_install
  else
    console_content_error "The action '$action' is not supported."
    console_empty_line
    exit 1
  fi
elif judge_linux_system; then
  if [[ "$action" == "outline-prepare" ]]; then
    git_linux_package_prepare
  elif [[ "$action" == "outline-install" ]]; then
    git_linux_package_install
  elif [[ "$action" == "online-install" ]]; then
    git_linux_package_prepare
    git_linux_package_install
  else
    console_content_error "The action '$action' is not supported."
    console_empty_line
    exit 1
  fi
else
  echo "Not support this OS."
  exit 1
fi

console_key_value "Git" "$(git --version | awk '{print $3}')"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
