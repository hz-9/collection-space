#!/bin/bash

utlToName() {
  url=$1
  filename_1=$(basename "${url%\?*}")
  filename_2=$(echo -n "${filename_1}" | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"
  # shellcheck disable=SC2059
  filename_3=$(printf  "${filename_2}")
  # shellcheck disable=SC2001
  filename=$(echo "${filename_3}" | sed 's/.tar.gz//g')
  echo "${filename}"
}

downloadFile() {
  downloadUrl=$1
  downloadDir=$2

  downloadFilename=$3
  if [ -z "${downloadFilename}" ]; then
    downloadFilename=$(utlToName "${downloadUrl}")
  fi

  absolutionPath="${downloadDir}/${downloadFilename}"
  echo "File: ${absolutionPath}"
  echo "Url:  ${downloadUrl}"
  curl -L -o "${absolutionPath}" "${downloadUrl}"
  echo ""

  echo "Download ${downloadFilename} complete."
}