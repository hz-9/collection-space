#!/bin/bash

setVersion() {
  dir=$1
  version=$2

  echo "${version}" > "${dir}/version.txt"

  echo "Set version: ${version}"
}

getVersion() {
  dir=$1

  file="${dir}/version.txt"

  if [ -f "${file}" ];then
    version=$(cat "${file}")
    echo "Get version: ${version}"
  else
    echo "Not found ${file}"
    exit 1
  fi
}
