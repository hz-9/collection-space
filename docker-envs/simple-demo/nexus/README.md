# Nexus Docker Image Deploy Demo

[文档](./README.zh-CN.md)

## Description

Supports starting a `Nexus` instance in a server or personal terminal with Docker and Docker compose plugin installed.

This example requires the installation of `Docker` and `Docker Compose`. If not installed, you can refer to [Overview of Docker Desktop](https://docs.docker.com/desktop/).

Before running, please pay attention to the paths in the `volumes` parameter. When in the current script collection, use the sibling `./temp` folder to store volumes. However, for actual usage, it is recommended to switch to the `/usr/project-name/envs` folder to store volumes.

## Start

Run `./bin/up.sh` in the current file path to start.

## Shutdown

Run `./bin/down.sh` in the current file path.
