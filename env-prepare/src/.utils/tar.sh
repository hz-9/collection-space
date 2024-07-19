#!/bin/bash

zipDir() {
  tarDir=$1

  echo "tarDir: ${tarDir}"

  pwd_=$(pwd)
  dirName=$(dirname "${tarDir}")
  baseName=$(basename "${tarDir}")

  echo ""
  cd "${dirName}" || exit
  zip -r   "${baseName}.zip" "${baseName}"
  cd "${pwd_}" || exit
  echo ""

  echo "Zip ${tarDir} complete."
}

unzipDir() {
  tarFile=$1

  dirName=$(dirname "${tarFile%\?*}")
  baseName=$(basename "${tarFile%\?*}")

  echo ""
  unzip "${tarFile}" -d "${dirName}"
  echo ""

  echo "Unzip ${tarFile} complete."
}
