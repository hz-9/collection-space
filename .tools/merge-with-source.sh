#!/bin/bash

output_file="combined_script.sh"
main_script="main_script.sh"

# 清空输出文件
> "$output_file"

# 递归合并脚本
function merge_script {
  local script="$1"
  while IFS= read -r line; do
    if [[ "$line" =~ ^source\ (.*) ]]; then
      local sourced_file="${BASH_REMATCH[1]}"
      merge_script "$sourced_file"
    else
      echo "$line" >> "$output_file"
    fi
  done < "$script"
}

merge_script "$main_script"
