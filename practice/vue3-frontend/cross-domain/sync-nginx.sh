#!/bin/bash

# cd ../../docker-env/cross-domain || exit

mkdir -p ../../docker-env/cross-domain/nginx/logs
mkdir -p ../../docker-env/cross-domain/nginx/website/web

# pwd
rm -rf ../../docker-env/cross-domain/nginx/website/web/*
cp -r ./dist/* ../../docker-env/cross-domain/nginx/website/web
