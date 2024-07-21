#!/bin/bash

CURRENT_DIR=$(cd "$(dirname "$0")" || exit;pwd)
source "${CURRENT_DIR}/.utils/index.sh"

# Software name and version
softwareName="jq Preparer"

version="1.7.1"  # jq Version

winPacakgeName="jq-${version}-win_amd64"
winDownloadDir=$PROJECT_FOLDER/temp/$winPacakgeName
winDownloadUrl="https://github.com/jqlang/jq/releases/download/jq-${version}/jq-windows-amd64.exe"

linuxPacakgeName="jq-${version}-linux_amd64"
linuxDownloadDir=$PROJECT_FOLDER/temp/$linuxPacakgeName
linuxDownloadUrl="https://github.com/jqlang/jq/releases/download/jq-${version}/jq-linux-amd64"

# ---------- Prepare log message ---------- 
startLog "${softwareName}"

# ---------- Windows ---------- 

rm -rf       "${winDownloadDir}"
mkdir -p     "${winDownloadDir}"
downloadFile "${winDownloadUrl}" "${winDownloadDir}"
setVersion   "${winDownloadDir}" "${version}"
zipDir       "${winDownloadDir}"
rm -rf       "${winDownloadDir}"

# ---------- Linux ---------- 

rm -rf       "${linuxDownloadDir}"
mkdir -p     "${linuxDownloadDir}"
downloadFile "${linuxDownloadUrl}" "${linuxDownloadDir}"
setVersion   "${linuxDownloadDir}" "${version}"
zipDir       "${linuxDownloadDir}"
rm -rf       "${linuxDownloadDir}"

# # ----------   Complete message  ----------
completeLog "${softwareName}"
