#!/bin/bash

root=$(cd "$(dirname "$0")" || exit; dirname "$(pwd)")

docker-compose -p cross-domain -f "${root}/compose/docker-compose.yml" up -d
