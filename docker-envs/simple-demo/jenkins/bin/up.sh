#!/bin/bash

root=$(cd `dirname $0`; dirname `pwd`)

docker-compose -p jenkins -f ${root}/compose/docker-compose.yml up -d
