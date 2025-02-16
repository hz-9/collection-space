#!/bin/bash
# 初始化变量
page=1
per_page=30
all_tags=()
desired_versions=("v2.4.2.windows.1" "v2.5.0.windows.1") # 你想要查询的版本号

# 循环获取每一页的版本信息
while true; do
    # 获取当前页的版本信息
    response=$(curl -s "https://api.github.com/repos/git-for-windows/git/releases?page=$page&per_page=$per_page")
    
    # 提取当前页符合条件的 tag_name
    tags=$(echo "$response" | jq -r '.[].tag_name')
    
    # 如果当前页没有返回任何 tag，则退出循环
    if [ -z "$tags" ]; then
        break
    fi
    
    # 将当前页的 tag 添加到 all_tags 数组中
    all_tags+=($tags)
    
    # 增加页码
    page=$((page + 1))
done

# 过滤出所需的版本号
for tag in "${all_tags[@]}"; do
    for version in "${desired_versions[@]}"; do
        if [ "$tag" == "$version" ]; then
            echo "$tag"
        fi
    done
done