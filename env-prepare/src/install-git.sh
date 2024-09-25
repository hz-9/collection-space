#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--git-version${_m_}${_m_}Git version. Default is lastest available.${_m_}"
)

SUPPORT_SYSTEM=(
  "Ubuntu 20.04 AMD64"
)

SHELL_NAME="Git Installer"
SHELL_DESC="Install 'git'."

source ./_judge-system.sh

source ./_console.sh

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

print_help_or_param

gitVersion=$(get_param '--git-version')

# ------------------------------------------------------------

console_title "Install git"

if ! command -v git &> /dev/null; then
  console_content_starting "Package list is updating..."
  # sudo apt-get -y update
  eval "sudo apt-get -y update $(get_redirect_output)"
  console_content_complete

  console_content_starting "Git is installing..."
  if [[ -z "$gitVersion" ]]; then
    # sudo apt-get -y install git
    eval "sudo apt-get -y install git $(get_redirect_output)"
  else
    # choose version
    availableVersions=$(apt-cache madison git | awk '{print $3}')
    if echo "$availableVersions" | grep -q "^${gitVersion}$"; then
      # sudo apt-get install git="$gitVersion" -y
      eval "sudo apt-get -y install git=$gitVersion $(get_redirect_output)"
    else
      console_content "Git $gitVersion is not available."
      console_content "Support versions:"
      console_sulines "$availableVersions"
      console_empty_line
      exit 1
    fi
  fi
  console_content_complete
else
  console_content "Git is already installed."
fi

console_key_value "Git" "$(git --version | awk '{print $3}')"
console_empty_line

# ------------------------------------------------------------

console_end  "Install complete."
