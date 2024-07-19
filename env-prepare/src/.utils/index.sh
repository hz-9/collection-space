#!/bin/bash

CURRENT_DIR=$(cd "$(dirname "$0")" || exit;pwd)
UTILS_DIR="${CURRENT_DIR}/.utils"

source "${UTILS_DIR}/base-parameter.sh"
source "${UTILS_DIR}/log.sh"
source "${UTILS_DIR}/download.sh"
source "${UTILS_DIR}/tar.sh"
source "${UTILS_DIR}/version.sh"