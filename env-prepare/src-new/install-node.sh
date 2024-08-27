#!/bin/bash

_m_='__@@__'


PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--node-version${_m_}${_m_}Node.js version.${_m_}v18.20.3"
)

SHELL_NAME="Node.js Installer"

SHELL_DES="Install 'nvn' 'node.js' and 'pm2'."

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

# print_default_param

# print_user_param

if [[ $(get_param '--help') == "true" ]]; then
  print_help
  exit 0
fi

print_param
