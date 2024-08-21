#!/bin/bash

root=$(cd "$(dirname "$0")" || exit; dirname "$(pwd)")

docker-compose -p docker-image -f "${root}/compose/docker-compose.yml" "$@"
