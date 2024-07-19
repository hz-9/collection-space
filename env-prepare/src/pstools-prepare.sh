#!/bin/bash

CURRENT_DIR=$(cd "$(dirname "$0")" || exit;pwd)
source "${CURRENT_DIR}/.utils/index.sh"

# Software name and version
softwareName="PsTools Preparer"
# softwareVersion="24.06"

packageCacheName="pstools-cache"

# Download parameters
downloadCacheDir=$PROJECT_FOLDER/temp/$packageCacheName
downloadUrl="https://download.sysinternals.com/files/PSTools.zip"

# ---------- Prepare log message ---------- 
startLog "${softwareName}"

# ----------    Download file    ---------- 
rm -rf "${downloadCacheDir}" && mkdir -p "${downloadCacheDir}"
downloadFile "${downloadUrl}" "${downloadCacheDir}"

unzipDir "${downloadCacheDir}/PSTools.zip"
rm -rf   "${downloadCacheDir}/PSTools.zip"
versionString=$(getVersion "${downloadCacheDir}" "psversion.txt")
softwareVersion=$(echo "${versionString}" | cut -d ' ' -f 8 | sed 's/[^0-9.]//g')
echo "softwareVersion: ${softwareVersion}"

packageName="pstools-${softwareVersion}"
packageDir=$PROJECT_FOLDER/temp/$packageName
rm -rf "${packageDir}" && mkdir -p "${packageDir}"
mv "${downloadCacheDir}" "${packageDir}/${packageName}"

# # ----------   Export Version    ----------
setVersion "${packageDir}" "${softwareVersion}"

# # ----------   Tar Package       ----------
zipDir     "${packageDir}"
rm -rf     "${packageDir}"

# # ----------   Complete message  ----------
completeLog "${softwareName}"
