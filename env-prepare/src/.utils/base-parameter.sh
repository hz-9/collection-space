#!/bin/bash

# shellcheck disable=SC2034

SRC_FOLDER=$(cd "$(dirname "$0")" || exit;pwd)
UTILS_FOLDER="${SRC_FOLDER}/.utils"
PROJECT_FOLDER=$(dirname "$SRC_FOLDER")

DOWNLOAD_FOLDER=$HOME/Downloads

CURRENT_TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S')
CURRENT_TIMESTAMP_S=$(date '+%Y%m%d%H%M%S')

CURRENT_DATE=$(date '+%Y-%m-%d')
CURRENT_DATE_S=$(date '+%Y%m%d')

CURRENT_TIME=$(date '+%H:%M:%S')
CURRENT_TIME_S=$(date '+%H%M%S')

# echo "UTILS_FOLDER        : ${UTILS_FOLDER}"
# echo "SRC_FOLDER          : ${SRC_FOLDER}"
# echo "PROJECT_FOLDER      : ${PROJECT_FOLDER}"
# echo "DOWNLOAD_FOLDER     : ${DOWNLOAD_FOLDER}"
# echo "CURRENT_TIMESTAMP   : ${CURRENT_TIMESTAMP}"
# echo "CURRENT_TIMESTAMP_S : ${CURRENT_TIMESTAMP_S}"
# echo "CURRENT_DATE        : ${CURRENT_DATE}"
# echo "CURRENT_DATE_S      : ${CURRENT_DATE_S}"
# echo "CURRENT_TIME        : ${CURRENT_TIME}"
# echo "CURRENT_TIME_S      : ${CURRENT_TIME_S}"
