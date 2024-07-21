#!/bin/bash

CURRENT_DIR=$(cd "$(dirname "$0")" || exit;pwd)
source "${CURRENT_DIR}/.utils/index.sh"

# Software name and version
softwareName="Erlang Preparer"

version="26.2.5.2"  # jq Version

winPacakgeName="erlang-${version}-win64"
winDownloadDir=$PROJECT_FOLDER/temp/$winPacakgeName
winDownloadUrl="https://github.com/erlang/otp/releases/download/OTP-${version}/otp_win64_${version}.exe"

# ---------- Prepare log message ---------- 
startLog "${softwareName}"

# ---------- Windows ---------- 

rm -rf       "${winDownloadDir}"
mkdir -p     "${winDownloadDir}"
downloadFile "${winDownloadUrl}" "${winDownloadDir}" "erlang-${version}-win64.exe"
setVersion   "${winDownloadDir}" "${version}"
zipDir       "${winDownloadDir}"
rm -rf       "${winDownloadDir}"

# # ----------   Complete message  ----------
completeLog "${softwareName}"
