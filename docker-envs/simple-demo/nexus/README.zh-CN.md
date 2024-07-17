# Nexus Docker 镜像部署示例

[Document](./README.md)

## 说明

支持在安装了 Docker 与 Docker compose plugin 的服务器或个人终端中启动 `Nexus` 实例。

本示例需要安装了 `Docker` 与 `Dicjer Compose`，若未安装，可查看 [Overview of Docker Desktop](https://docs.docker.com/desktop/)

在运行前请关注 `volumes` 参数内的路径，处于当前脚本收藏集时，使用同级 `./temp` 文件夹用以存放数据卷，但用于实际使用时，建议切换为 `/usr/项目名称/envs` 文件夹用以存放数据卷。

## 启动

在本文件路径下运行 `./bin/up.sh` 启动。

## 关闭

在本文件路径下运行 `./bin/down.sh`
