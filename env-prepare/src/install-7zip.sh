#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--7zip-version${_m_}${_m_}7Zip version. Default is lastest available.${_m_}"
)

SHELL_NAME="7Zip Installer"
SHELL_DESC="Install '7zip'."

source ./_console.sh

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

print_help_or_param

z7Version=$(get_param '--7zip-version')

# ------------------------------------------------------------

console_title "Install 7zip"

if ! command -v 7z &> /dev/null; then
  console_content_starting "Package list is updating..."
  # sudo apt-get -y update
  eval "sudo apt-get -y update $(get_redirect_output)"
  console_content_complete

  console_content_starting "7Zip is installing..."
  if [[ -z "$z7Version" ]]; then
    # apt-get -y install p7zip-full
    eval "apt-get -y install p7zip-full $(get_redirect_output)"
  else
    # choose version
    availableVersions=$(apt-cache madison p7zip-full | awk '{print $3}')
    if echo "$availableVersions" | grep -q "^${z7Version}$"; then
      # sudo apt-get install p7zip-full="$z7Version" -y
      eval "sudo apt-get -y install p7zip-full=$z7Version $(get_redirect_output)"
    else
      console_content "7zip $z7Version is not available."
      console_content "Support versions:"
      console_sulines "$availableVersions"
      console_empty_line
      exit 1
    fi
  fi
  console_content_complete
else
  console_content "7Zip is already installed."
fi

get_7zip_version() {
  local v1
  v1=$(7z | head -n 2 | tail -n 1 | awk '{print $3}')
  local v2
  v2=$(7z | head -n 2 | tail -n 1 | awk '{print $2}')

  if [[ "$v1" == "(x64)" ]]; then
    echo "$v2"
  else
    echo "$v1"
  fi
}
console_key_value "7Zip" "$(get_7zip_version)"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
