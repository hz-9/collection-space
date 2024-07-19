#!/bin/bash

CURRENT_DIR=$(cd "$(dirname "$0")" || exit;pwd)
source "${CURRENT_DIR}/.utils/index.sh"

# Software name and version
softwareName="GDAL Preparer"

version1="1928"  # Base Version
version2="3.9.1" # GDAL Version
version3="8.2.0" # Mapserver Version

pacakgeName="gdal-${version1}-${version2}-${version3}-winx64"

# Download parameters
winDownloadDir=$PROJECT_FOLDER/temp/$pacakgeName
winDownloadName="release-${version1}-x64-gdal-${version2//./-}-mapserver-${version3//./-}"
winDownloadUrl=https://download.gisinternals.com/sdk/downloads/${winDownloadName}.zip

# ---------- Prepare log message ---------- 
startLog "${softwareName}"

# ----------    Download file    ---------- 
rm -rf "${winDownloadDir}" && mkdir -p "${winDownloadDir}"
downloadFile "${winDownloadUrl}" "${winDownloadDir}/${pacakgeName}"

unzipDir "${winDownloadDir}/${pacakgeName}/${winDownloadName}.zip"
rm -rf   "${winDownloadDir}/${pacakgeName}/${winDownloadName}.zip"

# mkdir -p "${winDownloadDir}"
# mv       "${winDownloadDir}/cache/*" "${winDownloadDir}/${pacakgeName}"

# ----------   Export Version    ----------
setVersion "${winDownloadDir}" "${version1}-${version2}-${version3}"

# ----------   Tar Package       ----------
zipDir   "${winDownloadDir}"
rm -rf   "${winDownloadDir}"

# # ----------   Complete message  ----------
completeLog "${softwareName}"
