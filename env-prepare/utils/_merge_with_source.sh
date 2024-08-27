#!/bin/bash

root=$(cd "$(dirname "$0")" || exit; dirname "$(pwd)")

main_dir="${root}/src"
output_dir="${root}/dist"

mkdir -p "$output_dir" && rm -rf "${output_dir:?}"/*

output_file=""

function merge_script {
  local script="$1"
  while IFS= read -r line; do
    if [[ "$line" =~ ^source\ (.*) ]]; then
      local sourced_file="${BASH_REMATCH[1]}"
      merge_script "$sourced_file"
    elif [[ "$line" == "#!/bin/bash" ]]; then
      echo "# build from $script" >> "$output_file"
    else
      echo "$line" >> "$output_file"
    fi
  done < "${main_dir}/$script"
}

echo "Env Prepare scripts is building..."

for file in "$main_dir"/*; do
  if [[ "$(basename "$file")" != _* ]]; then
      output_file="${output_dir}/$(basename "$file")"
      echo "#!/bin/bash" >> "$output_file"
      echo "" >> "$output_file"
      merge_script "$(basename "$file")"

      echo "  > $(basename "$file")"
  fi
done

echo "Env Prepare scripts build completed."
