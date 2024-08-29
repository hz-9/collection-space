#!/bin/bash
{

  installOnUbuntu() {
    # ------------------------------------------------------------

    console_title "Install docker-ce on Ubuntu"

    local ubuntuRelease
    ubuntuRelease=$(lsb_release -rs)
    local ubuntuCodename
    ubuntuCodename=$(lsb_release -cs)
    local ubuntuVersion
    ubuntuVersion=$(lsb_release -is | tr '[:upper:]' '[:lower:]').${ubuntuRelease}~${ubuntuCodename}

    console_key_value "OS Version" "$ubuntuVersion"

    if [[ "$inChina" == "true" ]]; then
      dockerRegistry="https://mirrors.aliyun.com/docker-ce/linux/ubuntu"
      console_content "Docker source registry use the Chinese mirror."
    else
      dockerRegistry="https://download.docker.com/linux/ubuntu"
      console_content "Docker source registry use the Official mirror."
    fi

    # ------------------------------------------------------------

    # step 1: Install necessary system tools
    console_content_starting "The necessary system tools is installing..."

    # sudo apt-get -y update
    # sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
    eval "sudo apt-get -y update $(get_redirect_output)"
    eval "sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common $(get_redirect_output)"

    console_content_complete

    # ------------------------------------------------------------

    # step 2: Install GPG certificate
    if [ ! -f '/etc/apt/keyrings/docker.asc' ]; then
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL $dockerRegistry/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      console_content "The GPG certificate is installed."
    else
      console_content "The GPG certificate is already installed."
    fi

    # ------------------------------------------------------------

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

    # ------------------------------------------------------------

    # Step 4: Update
    console_content_starting "The software source information is updating..."

    # sudo apt-get -y update
    eval "sudo apt-get -y update $(get_redirect_output)"

    console_content_complete

    # View all versions of Docker CE
    # apt-cache madison docker-ce

    # ------------------------------------------------------------

    installDocker() {
      console_content_starting "Docker CE '5:$dockerVersion~$ubuntuVersion' is installing..."

      # sudo apt-get -y install "docker-ce=5:$dockerVersion~$ubuntuVersion"
      eval "sudo apt-get -y install docker-ce=5:$dockerVersion~$ubuntuVersion $(get_redirect_output)"

      console_content_complete
    }

    uninstallDocker() {
      console_content_starting "Docker CE $1 is removing..."

      # sudo apt-get -y remove docker-ce
      eval "sudo apt-get -y remove docker-ce $(get_redirect_output)"

      console_content_complete
    }

    if dpkg-query -W -f='${Status}' docker-ce 2>/dev/null | grep -q "ok installed"; then
      local installedVersion
      installedVersion=$(apt-cache policy docker-ce | grep 'Installed' | awk '{print $2}')
      local dockerBaseVersion
      dockerBaseVersion="5:$dockerVersion~$ubuntuVersion"

      if [[ "$installedVersion" != "$dockerBaseVersion" ]]; then
        console_content "Docker CE ${installedVersion} is not the version you want."
        uninstallDocker "$installedVersion"
        installDocker
      else
        console_content "Docker CE ${dockerVersion} is already installed."
      fi
    else
      installDocker
    fi
  }

}
