#!/bin/bash
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

source ./_judge-system.sh

source ./_console.sh

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

print_help_or_param

dockerVersion=$(get_param '--docker-version')
inChina=$(get_param '--in-china')

# ------------------------------------------------------------

source ./_install-docker-ce.ubuntu.sh

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
