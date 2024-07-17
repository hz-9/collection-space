#!/bin/bash

source ./.utils/base-paramter.sh
source ./.utils/log-message.sh
source ./.utils/download-file.sh
source ./.utils/tar-dir.sh
source ./.utils/version.sh

# # Software name and version
softwareName="7-Zip Installer"

# # Download parameters
downloadUrl=$1
downloadDir="${DOWNLOAD_FOLDER}/${CURRENT_DATE_S}/7-zip"
pacakgeName=$(utlToName "${downloadUrl}")

# # ---------- Prepare log message ---------- 
printPrepareLogMessage "${softwareName}"

# ----------    Download file    ----------
rm -rf "${downloadDir}" && mkdir -p "${downloadDir}"
downloadFile "${downloadUrl}" "${downloadDir}" "${pacakgeName}"

# ----------   unTar Package     ----------
tarPath="${downloadDir}/${pacakgeName}"
dirPath="${tarPath%.zip}"
unzipDir "${tarPath}"
rm -rf   "${tarPath}"

# ----------   Read   Version    ----------
echo "XXX ${dirPath}"
softwareVersion=$(getVersion "${dirPath}")
echo "softwareVersion: ${softwareVersion}"

# ----------  Install Package    ----------
pacakgePath="${dirPath}/7z${softwareVersion}-x64.msi"
msiexec /i "${pacakgePath}" /q INSTALLDIR="${WIN_PROGRAM_FILES}"

# # ----------   Complete message  ----------
printCompleteLogMessage "${softwareName}"
