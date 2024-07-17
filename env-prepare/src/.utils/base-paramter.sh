#!/bin/bash

# shellcheck disable=SC2034

SRC_FOLDER=$(cd "$(dirname "$0")" || exit;pwd)

PROJECT_FOLDER=$(dirname "$SRC_FOLDER")

DOWNLOAD_FOLDER=$HOME/Downloads

# `C:\Program Files` in Windows
WIN_PROGRAM_FILES=$PROGRAMFILES

CURRENT_TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S')
CURRENT_TIMESTAMP_S=$(date '+%Y%m%d%H%M%S')

CURRENT_DATE=$(date '+%Y-%m-%d')
CURRENT_DATE_S=$(date '+%Y%m%d')

CURRENT_TIME=$(date '+%H:%M:%S')
CURRENT_TIME_S=$(date '+%H%M%S')
