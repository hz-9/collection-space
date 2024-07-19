#!/bin/bash

CURRENT_DIR=$(cd "$(dirname "$0")" || exit;pwd)
source "${CURRENT_DIR}/.utils/index.sh"

# Software name and version
softwareName="7-Zip Preparer"
softwareVersion="24.06"

pacakgeName="7-zip-${softwareVersion}-winx64"

# Download parameters
downloadDir=$PROJECT_FOLDER/temp/$pacakgeName
downloadUrl="https://www.7-zip.org/a/7z${softwareVersion/./}-x64.msi"

# ---------- Prepare log message ---------- 
startLog "${softwareName}"

# ----------    Download file    ---------- 
rm -rf "${downloadDir}" && mkdir -p "${downloadDir}"
downloadFile "${downloadUrl}" "${downloadDir}"

# ----------   Export Version    ----------
setVersion "${downloadDir}" $softwareVersion

# ----------   Tar Package       ----------
zipDir   "${downloadDir}"
rm -rf   "${downloadDir}"

# ----------   Complete message  ----------
completeLog "${softwareName}"
