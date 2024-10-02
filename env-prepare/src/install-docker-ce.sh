#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--docker-version${_m_}${_m_}Docker CE version.${_m_}"
  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SUPPORT_OS_LIST=(
  "Ubuntu 20.04 AMD64"
  "Ubuntu 22.04 AMD64"
  "Ubuntu 24.04 AMD64"

  "Debian 11.9 AMD64"
  "Debian 12.2 AMD64"

  "Fedora 40 AMD64"

  "RedHat 8.5 AMD64"
  "RedHat 9.0 AMD64"

  "AlibabaCloudLinux 3.2104 AMD64"
)

SHELL_NAME="Docker CE Installer"
SHELL_DESC="Install 'docker-ce' 'docker-compose'."

source ./__judge-system.sh

source ./__console.sh

source ./__parse-user-paramter.sh

source ./__parse-paramter.sh

source ./__install.common.sh

print_help_or_param

dockerVersion=$(get_param '--docker-version')
inChina=$(get_param '--in-china')

# ------------------------------------------------------------

install_by_apt_get() {
  # ------------------------------

  # step 0: Remove history version
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    # sudo apt-get -y remove $pkg;
    eval "sudo apt-get -y remove $pkg $(get_redirect_output)"
  done

  # ------------------------------

  # step 1: Install necessary system tools
  apt_get_update

  console_content_starting "The necessary system tools is installing..."
  # sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
  eval "sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common $(get_redirect_output)"
  console_content_complete

  # ------------------------------

  # step 2: Install GPG certificate
  local dockerRegistry

  if [[ "$OS_NAME" == "Ubuntu" ]]; then
    if [[ "${inChina}" == "true" ]]; then
      dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/ubuntu"
      console_content "Docker source registry use the Chinese mirror."
    else
      dockerRegistry="https://download.docker.com/linux/ubuntu"
      console_content "Docker source registry use the Official mirror."
    fi
  elif [[ "$OS_NAME" == "Debian" ]]; then
    if [[ "${inChina}" == "true" ]]; then
      dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/debian"
      console_content "Docker source registry use the Chinese mirror."
    else
      dockerRegistry="https://download.docker.com/linux/debian"
      console_content "Docker source registry use the Official mirror."
    fi
  else
    echo "Not support this OS."
    exit 1
  fi

  if [ ! -f '/etc/apt/keyrings/docker.asc' ]; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL $dockerRegistry/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    console_content "The GPG certificate is installed."
  else
    console_content "The GPG certificate is already installed."
  fi

  # ------------------------------

  # Step 3: Write software source information
  if [ ! -f '/etc/apt/sources.list.d/docker.list' ]; then
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] $dockerRegistry \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    console_content "The software source information is written."
  else
    console_content "The software source information is already written."
  fi

  # ------------------------------

  # Step 4: Update
  apt_get_update

  # View all versions of Docker CE
  # apt-cache madison docker-ce

  # ------------------------------

  # Step 5: Install
  local local="Docker CE"
  local name="docker-ce"
  local version=$dockerVersion
  apt_get_install "$local" "$name" "$version"

  local="Docker CE Cli"
  name="docker-ce-cli"
  version=$dockerVersion
  apt_get_install "$local" "$name" "$version"

  apt_get_install "containerd.io" "containerd.io"
  apt_get_install "docker-buildx-plugin " "docker-buildx-plugin"
  apt_get_install "docker-compose-plugin" "docker-compose-plugin"
}

install_by_dnf() {
  # ------------------------------

  # step 0: Remove history version
  if [[ "$OS_NAME" == "RedHat" ]]; then
    eval "sudo dnf remove -y 
      docker-client-latest \
      docker-common \
      docker-latest \
      docker-latest-logrotate \
      docker-logrotate \
      docker-selinux \
      docker-engine-selinux \
      docker-engine
      $(get_redirect_output)"
  else
    eval "sudo dnf remove -y docker \
      docker-client \
      docker-client-latest \
      docker-common \
      docker-latest \
      docker-latest-logrotate \
      docker-logrotate \
      docker-selinux \
      docker-engine-selinux \
      docker-engine
      $(get_redirect_output)"
  fi

  # ------------------------------

  # step 1: Set repository
  local dockerRegistry

  if [[ "$OS_NAME" == "Fedora" ]]; then
    if [[ "${inChina}" == "true" ]]; then
      console_content "Docker source registry use the Chinese mirror."
      dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/fedora/docker-ce.repo"
    else
      console_content "Docker source registry use the Official mirror."
      dockerRegistry="https://download.docker.com/linux/fedora/docker-ce.repo"
    fi
    eval "sudo dnf -y install dnf-plugins-core $(get_redirect_output)"
  elif [[ "$OS_NAME" == "RedHat" ]]; then
    if [[ "${inChina}" == "true" ]]; then
      console_content "Docker source registry use the Chinese mirror."
      dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/rhel/docker-ce.repo"
    else
      console_content "Docker source registry use the Official mirror."
      dockerRegistry="https://download.docker.com/linux/rhel/docker-ce.repo"
    fi
    eval "sudo dnf -y install dnf-plugins-core $(get_redirect_output)"
  elif [[ "$OS_NAME" == "AlibabaCloudLinux" ]]; then
    dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"
    console_content "Docker source registry use the Chinese mirror."
    eval "sudo dnf -y install dnf-plugin-releasever-adapter --repo alinux3-plus $(get_redirect_output)"
  else
    echo "Not support this OS."
    exit 1
  fi

  eval "sudo dnf config-manager --add-repo $dockerRegistry $(get_redirect_output)"

  dnf_update

  # ------------------------------

  # Step 5: Install
  local local="Docker CE"
  local name="docker-ce"
  local version=$dockerVersion
  dnf_install "$local" "$name" "$version"

  local="Docker CE Cli"
  name="docker-ce-cli"
  version=$dockerVersion
  dnf_install "$local" "$name" "$version"

  dnf_install "containerd.io" "containerd.io"
  dnf_install "docker-buildx-plugin " "docker-buildx-plugin"
  dnf_install "docker-compose-plugin" "docker-compose-plugin"
}

if command -v docker &>/dev/null; then
  console_content "Docker is already installed."
else
  if [[ "$OS_NAME" == "Ubuntu" ]] || [[ "$OS_NAME" == "Debian" ]]; then
    install_by_apt_get
  elif [[ "$OS_NAME" == "Fedora" ]] || [[ "$OS_NAME" == "RedHat" ]] || [[ "$OS_NAME" == "AlibabaCloudLinux" ]]; then
    install_by_dnf
  else
    echo "Not support this OS."
    exit 1
  fi
fi

console_key_value "Docker CE" "$(docker --version | awk '{print $3}' | sed 's/,//')"
console_key_value "Docker compose" "$(docker compose version | awk '{print $4}')"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
