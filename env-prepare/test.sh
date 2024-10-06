#!/bin/bash

# 示例参数
PARAMTER="param1@@param2@param3"
_m_="@"
split=()
# 使用 IFS 和 read 处理字符串替换
IFS="${_m_}" read -r -a split <<< "$PARAMTER"

# 输出结果
for element in "${split[@]}"; do
  echo "----------"
  echo "$element"
done