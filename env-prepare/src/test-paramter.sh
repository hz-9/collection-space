#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"
)

SHELL_NAME="Docker CE Installer"
SHELL_DESC="Install 'docker-ce' 'docker-compose'."

source ./_console.sh

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

print_help_or_param

print_default_param

print_user_param
