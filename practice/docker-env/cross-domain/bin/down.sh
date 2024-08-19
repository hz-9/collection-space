#!/bin/bash

root=$(cd "$(dirname "$0")" || exit; dirname "$(pwd)")

docker-compose -p nginx -f "${root}/compose/docker-compose.yml" down --rmi local
