#!/bin/bash

# 遍历当前路径的所有文件夹
for dir in */; do
  if [ -d "$dir" ]; then
    echo "-----------------------------------"

    echo "进入文件夹: $dir"
    cd "$dir" || exit

    # 在这里执行你的命令
    echo "执行命令: ls"
    rm -rf node_modules
    # npm install
    npm install > /dev/null 2>&1
    npm run lint
    npm run prettier

    # 返回上一级目录
    cd ..
  fi
done