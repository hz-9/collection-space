# Repository for Scripts and Examples for a Web Project

## 路径规划

| 路径                       | 规划                                         |
| -------------------------- | -------------------------------------------- |
| `ci&cd`                    | 一些 ci&cd 脚本。                            |
| `data-structure`           | 一些数据结构类。                             |
| `docker-envs`              | 一些 docker-compose 脚本。                   |
| `env-prepare`              | 准备环境脚本。                               |
| `handwritten-code`         | 一个手写示例。                               |
| `practice`                 | 一些练习项目。                               |
| `test-space/{libraryName}` | 各种组件库的测试空间。                       |

对于 `practice/nodejs-service` 路径下的服务，可以访问 [在 APIfox 发布的 API 接口](https://apifox.com/apidoc/shared-b220fa2f-dc80-4283-9dee-311a22e04d03)。

## 初始化

挂载 `git hook`。

``` sh
cp ./.githooks/* ./.git/hooks/ && chmod +x ./.git/hooks/pre-commit
```
