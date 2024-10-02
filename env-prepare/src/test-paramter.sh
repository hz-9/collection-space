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
  "Debian 11.9    AMD64"
  "Debian 12.2    AMD64"
  "MacOS  14.6.1  ARM64"
  "Fedora 40      AMD64"
  "RedHat 8.5     AMD64"
  "RedHat 9.0     AMD64"
)

SHELL_NAME="Test Paramter"
SHELL_DESC="Some description."

source ./__judge-system.sh

source ./__console.sh

source ./__parse-user-paramter.sh

source ./__parse-paramter.sh

print_system_extra_info

print_help_or_param

print_default_param

print_user_param

print_help
