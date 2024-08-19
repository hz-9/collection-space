#!/bin/bash

root=$(cd "$(dirname "$0")" || exit; dirname "$(pwd)")

docker-compose -p jenkins -f "${root}/compose/docker-compose.yml" "$@"