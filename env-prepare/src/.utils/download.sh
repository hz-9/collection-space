#!/bin/bash

urlToName() {
  url=$1
  urlWithoutQuery="${url%%\?*}"
  lastSegment=$(basename "${urlWithoutQuery}")
  echo "${lastSegment}"
}

# downloadFile "https://heavenzhen.oss-cn-beijing.aliyuncs.com/TEMP/7-zip-24.06-winx64.zip?OSSAccessKeyId=LTAIsFfhGOKJoEdl&Expires=1721275314&Signature=%2BqGHDRzZ7smeufrDlRge1ycfedk%3D" "/Users/heaven/Downloads"
downloadFile() {
  downloadUrl=$1
  downloadDir=$2

  downloadFilename=$3
  if [ -z "${downloadFilename}" ]; then
    downloadFilename=$(urlToName "${downloadUrl}")
  fi

  if [ ! -d "${downloadDir}" ]; then
    mkdikr -p "${downloadDir}"
  fi

  absolutionPath="${downloadDir}/${downloadFilename}"
  echo ""
  echo "File: ${absolutionPath}"
  echo "Url:  ${downloadUrl}"
  curl -L -o "${absolutionPath}" "${downloadUrl}"
  echo ""

  echo "Download ${downloadFilename} complete."
}
