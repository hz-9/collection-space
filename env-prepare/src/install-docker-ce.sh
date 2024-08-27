#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--docker-version${_m_}${_m_}Docker CE version.${_m_}27.1.2-1"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SHELL_NAME="Docker CE Installer"

SHELL_DES="Install 'docker-ce' 'docker-compose'."

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

if [[ $(get_param '--help') == "true" ]]; then
  print_help
  exit 0
else
  print_param
fi

dockerVersion=$(get_param '--docker-version')
inChina=$(get_param '--in-china')

installOnUbuntu() {
  local ubuntuRelease=$(lsb_release -rs)
  local ubuntuCodename=$(lsb_release -cs)
  local ubuntuVersion=$(lsb_release -is | tr '[:upper:]' '[:lower:]').${ubuntuRelease}~${ubuntuCodename}

  # step 1: Install necessary system tools
  sudo apt-get -y update
  sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

  if [[ "$inChina" == "true" ]]; then
    dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/ubuntu"
    echo "Use the Chinese mirror."
  else
    dockerRegistry="https://download.docker.com/linux/ubuntu"
    echo "Use the Official mirror."
  fi

  # step 2: Install GPG certificate
  if [ ! -f '/etc/apt/keyrings/docker.asc' ]; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL $dockerRegistry/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
  fi

  # Step 3: Write software source information
  if [ ! -f '/etc/apt/sources.list.d/docker.list' ]; then
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] $dockerRegistry \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  fi

  # Step 4: Update
  sudo apt-get -y update

  # View all versions of Docker CE
  # apt-cache madison docker-ce

  if dpkg-query -W -f='${Status}' docker-ce 2>/dev/null | grep -q "ok installed"; then
    local installedVersion
    installedVersion=$(docker --version | awk '{print $3}' | sed 's/,//')
    local dockerBaseVersion
    dockerBaseVersion=${dockerVersion//-1/}

    if [[ "$installedVersion" != "$dockerBaseVersion" ]]; then
      echo "Docker CE ${installedVersion} is not the version you want."
      echo ""
      sudo apt-get -y remove docker-ce
      echo "Docker CE ${dockerVersion} is installing..."
      echo ""
      sudo apt-get -y install "docker-ce=5:$dockerVersion~$ubuntuVersion"
    else
      echo "Docker CE ${dockerVersion} is already installed."
      echo ""
    fi
  else
    echo "Docker CE ${dockerVersion} is installing..."
    echo ""
    sudo apt-get -y install "docker-ce=5:$dockerVersion~$ubuntuVersion"
  fi
}

if grep -qi 'ubuntu' /etc/os-release; then
  echo "Current is Ubuntu OS."
  echo ""
  installOnUbuntu
else
  echo "Not support this OS."
  exit 1
fi

echo ""
echo "    Docker CE       : $(docker --version | awk '{print $3}' | sed 's/,//')"
echo "    Docker compose  : $(docker compose version | awk '{print $4}')"
echo ""
echo "Install complete."
