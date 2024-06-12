# Jenkins Docker 镜像部署示例

## 说明

支持在安装了 Docker 与 Docker compose plugin 的服务器或个人终端中启动 `Jenkins` 实例。

确保部署服务器，已安装了 `Docker`，否则请查看 [安装 Docker & Docker Desktop](TODO)。

在运行前请关注 `volumes` 参数内的路径，处于当前脚本收藏集时，使用同级 `./temp` 文件夹用以存放数据卷，但用于实际使用时，建议切换为 `/usr/公司名-项目名称/envs` 文件夹用以存放数据卷。

## 尝试启动

在此文件所在路径下运行 `./bin/up.sh`，启动后，请根据 [Jenkins 安装](http://47.92.86.108:11001/software/install/jenkins.html#%E5%AE%89%E8%A3%85) 文档进行操作初始化。

## 尝试关闭

在此文件所在路径下运行 `./bin/down.sh`
