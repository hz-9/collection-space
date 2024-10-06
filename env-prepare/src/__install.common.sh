#!/bin/bash
{
  apt_get_update() {
    console_content_starting "Package list is updating..."
    # sudo apt-get -y update
    eval "sudo apt-get -y update $(get_redirect_output)"
    console_content_complete
  }

  apt_get_install() {
    local label="$1"
    local name="$2"
    local version="$3"

    # shellcheck disable=SC2086,SC2155
    local versions="$(apt-cache madison $name | awk '{print $3}')"

    console_content_starting "$label is installing..."
    if [[ -z "$version" ]]; then
      # sudo apt-get -y install git
      eval "sudo apt-get -y install $name $(get_redirect_output)"
    else
      # choose version
      if echo "$versions" | grep -q "^${version}$"; then
        # sudo apt-get install git="$gitVersion" -y
        eval "sudo apt-get -y install $name=$version $(get_redirect_output)"
      else
        console_content_error "$label $version is not available."
        console_content "Support versions:"
        console_sulines "$versions"
        console_empty_line
        exit 1
      fi
    fi
    console_content_complete
  }

  dnf_update() {
    console_content_starting "Package list is updating..."
    # sudo apt-get -y update
    eval "sudo dnf makecache $(get_redirect_output)"
    console_content_complete
  }

  dnf_add_epel_repo() {
    local inChina="$1"
    local version="$2"
    local repoUrl

    if [[ "$inChina" == "true" ]]; then
      console_content "dnf registry use the Chinese mirror."

      repoUrl="https://mirrors.aliyun.com/epel/epel-release-latest-$version.noarch.rpm"
    else
      console_content "dnf registry use the Fedora Offical mirror."
      repoUrl="https://dl.fedoraproject.org/pub/epel/epel-release-latest-$version.noarch.rpm"
    fi

    console_content_starting "Epel repo is installing..."
    # sudo dnf install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm
    eval "sudo dnf install -y $repoUrl $(get_redirect_output)"
    console_content_complete
  }

  dnf_install() {
    local label="$1"
    local name="$2"
    local version="$3"

    # shellcheck disable=SC2086,SC2155
    local versions="$(dnf list --showduplicates $name | awk '{print $2}' | tail -n +2)"
    if echo "$versions" | grep -q "Packages"; then
      versions=$(echo "$versions" | tail -n +2)
    fi

    console_content_starting "$label is installing..."
    if [[ -z "$version" ]]; then
      # sudo dnf -y install git
      eval "sudo dnf -y install $name $(get_redirect_output)"
    else
      # choose version
      if echo "$versions" | grep -q "^${version}$"; then
        # sudo dnf install git="$gitVersion" -y
        eval "sudo dnf -y install $name-$version $(get_redirect_output)"
      else
        console_content_error "$label $version is not available."
        console_content "Support versions:"
        console_sulines "$versions"
        console_empty_line
        exit 1
      fi
    fi
    console_content_complete
  }

  download_file() {
    local url="$1"
    local target="$2"
    local dir
    dir=$(dirname "$target")
    local filename
    filename=$(basename "$target")
    local showConsoleContent="$3"

    mkdir -p "$dir"

    if [[ "$showConsoleContent" != "false" ]]; then
      console_content "The file '$filename' is downloading..."
      console_content "  from : $url"
      console_content "  to   : $target"
      console_content_starting "..."
    fi

    eval "curl -L '$url' -o '$target' $(get_redirect_output)"

    if [[ "$showConsoleContent" != "false" ]]; then
      console_content_complete
    fi
  }

  unzip_file() {
    local sourceFile=$1
    local targetDir=$2

    mkdir -p "$targetDir"

    if [[ $IS_WINDOWS == true ]]; then
      # powershell.exe -Command "
      #   \$zipFile = '$(to_windows_path_format "$sourceFile")'
      #   \$targetDir = '$(to_windows_path_format "$targetDir")'
      #   Add-Type -AssemblyName System.IO.Compression.FileSystem
      #   [System.IO.Compression.ZipFile]::ExtractToDirectory(\$zipFile, \$targetDir)
      # "
      eval """
        powershell.exe -Command \"
          Add-Type -AssemblyName System.IO.Compression.FileSystem
          [System.IO.Compression.ZipFile]::ExtractToDirectory(
            '$(to_windows_path_format "$sourceFile")'
          , '$(to_windows_path_format "$targetDir")')
        \"
       $(get_redirect_output)

      """
    else
      # tar -xf "$1" -C "$2"
      echo "TODO"
    fi
  }
}
