#!/bin/bash

# root=$(cd "$(dirname "$0")" || exit; dirname "$(pwd)")

docker-compose -p es -f ./docker-compose.yml down --rmi local