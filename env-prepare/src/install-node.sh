#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--nvm-version${_m_}${_m_}Nvm version.${_m_}v0.40.0"
  "--node-version${_m_}${_m_}Node.js version.${_m_}v18.20.3"
  "--pm2-version${_m_}${_m_}PM2 version.${_m_}^5.4.2"
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

if [[ ! -f "$nvmHome/README.md" ]]; then
  echo "nvm ${nvmHome} is installing..."
  echo ""

  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvmVersion}/install.sh" | bash
  source "${nvmHome}/nvm.sh"
else
  echo "nvm ${nvmHome} is already installed."
  echo ""

  source "${nvmHome}/nvm.sh"
fi

if [[ ! -d "$nodeHome" ]]; then
  echo "Node.js ${nodeVersion} is installing..."
  echo ""

  if [[ "$inChina" == "true" ]]; then
    export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/
    export NVM_IOJS_ORG_MIRROR=https://mirrors.huaweicloud.com/iojs/
    echo "Use the Chinese mirror."
  fi
  nvm install "$nodeVersion"
else
  echo "Node.js ${nodeVersion} is already installed."
  echo ""
fi

installPM2() {
  echo "PM2 ${pm2Version} is installing..."
  echo ""

  if [[ "$inChina" == "true" ]]; then
    npm config set registry https://registry.npmmirror.com/
    echo "Use the Chinese mirror."
  fi
  npm install -g pm2@"$pm2Version"
  pm2 ping
  pm2 startup
  pm2 install pm2-logrotate
  pm2 set pm2-logrotate:max_size 100M
}

if [[ ! -d "$pm2Home" ]]; then
  installPM2
elif [[ $(pm2 -v) != "$pm2Version" ]]; then
  echo "PM2 $(pm2 -v) is not the version you want."
  echo ""
  installPM2
else
  echo "PM2 $(pm2 -v) is already installed."
fi

echo ""
console_key_value "nvm" "$(nvm -v)"
console_key_value "Node" "$(node -v)"
console_key_value "npm" "$(npm -v)"
console_key_value "PM2" "$(pm2 -v)"
echo ""
echo "Install complete."
