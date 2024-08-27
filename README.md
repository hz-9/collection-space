# Repository for Scripts and Examples for a Web Project

## Path planning

| Path                       | Plan                                                   |
| -------------------------- | ------------------------------------------------------ |
| `ci&cd`                    | Some ci&cd scripts.                                    |
| ~~`data-structure`~~       | Some data-structure class. Move to [@hz-9/algorithm](https://github.com/hz-9/tool/tree/master/libraries/algorithm) |
| `docker-envs`              | Some docker-compose scripts.                           |
| `env-prepare`              | [Prepare environment scripts.]                           |
| `handwritten-code`         | A handwritten example.                                 |
| `practice`                 | Some practice projects.                                |
| `test-space/{libraryName}` | Test spaces for various component libraries.           |

For the service under the `practice/nodejs-service` path, you can access the API interface published on [APIfox](https://apifox.com/apidoc/shared-b220fa2f-dc80-4283-9dee-311a22e04d03).

[Prepare environment scripts.]: ./env-prepare

## Init

Bind `git hooks`.

``` sh
cp ./.githooks/* ./.git/hooks/ && chmod +x ./.git/hooks/*
```
