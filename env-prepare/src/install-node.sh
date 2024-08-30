#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--nvm-version${_m_}${_m_}Nvm version.${_m_}v0.40.0"
  "--node-version${_m_}${_m_}Node.js version.${_m_}v18.20.3"
  "--pm2-version${_m_}${_m_}PM2 version.${_m_}5.4.2"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SHELL_NAME="Node.js Installer"
SHELL_DESC="Install 'nvn' 'node.js' and 'pm2'."

source ./_console.sh

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

print_help_or_param

nvmVersion=$(get_param '--nvm-version')
nvmHome="${HOME}/.nvm"

nodeVersion=$(get_param '--node-version')
nodeHome="${nvmHome}/versions/node/${nodeVersion}"

pm2Version=$(get_param '--pm2-version')
pm2Home="${HOME}/.pm2"

inChina=$(get_param '--in-china')

# ------------------------------------------------------------

console_title "Install nvm"

if [[ ! -f "$nvmHome/README.md" ]]; then
  console_content_starting "nvm '${nvmHome}' is installing..."

  if [ "$(get_param '--debug')" == 'true' ]; then
    curl    -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvmVersion}/install.sh" | METHOD=git bash
  else
    curl -s -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvmVersion}/install.sh" | METHOD=git bash &> /dev/null
  fi

  console_content_complete
  source "${nvmHome}/nvm.sh"
else
  console_content "nvm ${nvmHome} is already installed."
  source "${nvmHome}/nvm.sh"
fi

console_key_value "nvm" "$(nvm -v)"
console_empty_line

# ------------------------------------------------------------

console_title "Install Node.js"

if [[ ! -d "$nodeHome" ]]; then
  if [[ "$inChina" == "true" ]]; then
    export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/
    export NVM_IOJS_ORG_MIRROR=https://mirrors.huaweicloud.com/iojs/
    console_content "Node.js source registry use the Chinese mirror."
  else
    console_content "Node.js source registry use the Default mirror."
  fi

  console_content_starting "Node.js ${nodeVersion} is installing..."

  # nvm install "$nodeVersion"
  eval "nvm install $nodeVersion        $(get_redirect_output)"

  console_content_complete
else
  console_content "Node.js ${nodeVersion} is already installed."
fi

console_key_value "Node" "$(node -v)"
console_key_value "npm" "$(npm -v)"
console_empty_line

# ------------------------------------------------------------

console_title "Install pm2 and pm2-logrotate"

installPM2() {
  if [[ "$inChina" == "true" ]]; then
    npm config set registry https://registry.npmmirror.com/
    console_content "npm registry use the Chinese mirror."
  else
    console_content "npm registry use the Default mirror."
  fi

  console_content_starting "pm2 ${pm2Version} is installing..."
  # npm install -g pm2@"$pm2Version"
  eval "npm install -g pm2@$pm2Version        $(get_redirect_output)"
  # pm2 ping
  eval "pm2 ping                              $(get_redirect_output)"
  console_content_complete

  # pm2 startup
  eval "pm2 startup                           $(get_redirect_output)"
  console_content "pm2 startup is done."

  console_content_starting "pm2-logrotate is installing..."
  # pm2 install pm2-logrotate
  eval "pm2 install pm2-logrotate             $(get_redirect_output)"
  # pm2 set pm2-logrotate:max_size 100M
  eval "pm2 set pm2-logrotate:max_size 100M   $(get_redirect_output)"
  console_content_complete
}

if [[ ! -d "$pm2Home" ]]; then
  installPM2
elif [[ $(pm2 -v) != "$pm2Version" ]]; then
  console_content "PM2 $(pm2 -v) is not the version you want."
  installPM2
else
  console_content "PM2 $(pm2 -v) is already installed."
fi

console_key_value "pm2" "$(pm2 -v)"
console_key_value "pm2-logrotate" "$(pm2 info pm2-logrotate | grep 'version' | head -n 1 | awk '{print $4}')"

console_empty_line

# ------------------------------------------------------------

console_end  "Install complete."

console_content "Last please run 'source ~/.bashrc' to make the environment variables take effect."
