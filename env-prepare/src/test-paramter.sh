#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"
)

SUPPORT_OS_LIST=(
  "Ubuntu 20.04   AMD64"
  "Ubuntu 22.04   AMD64"
  "Ubuntu 24.04   AMD64"
  # "MacOS  23.6.0  ARM64"
)

SHELL_NAME="Docker CE Installer"
SHELL_DESC="Install 'docker-ce' 'docker-compose'."

source ./_judge-system.sh

source ./_console.sh

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

print_help_or_param

print_default_param

print_user_param

print_help
