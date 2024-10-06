#!/bin/bash
{
  get_outline_package() {
    local packageName="$1"
    echo "${HOME}"/Downloads/"$packageName"
  }

  # to_windows_path_format() {
  #   local original_path=$1
  #   local windows_path
  #   windows_path=$(echo "$original_path" | sed 's|^/c/|C:\\|' | sed 's|/|\\|g')
  #   echo "$windows_path"
  # }

  to_windows_path_format() {
    local original_path=$1
    local windows_path
    windows_path=$(echo "$original_path" | sed 's|^/\([a-zA-Z]\)/|\1:\\|' | sed 's|/|\\|g')
    echo "$windows_path"
  }

  to_git_bash_path_format() {
    local original_path=$1
    local git_bash_path
    git_bash_path=$(echo "$original_path" | sed 's|^\([a-zA-Z]\):|/\1|' | sed 's|\\|/|g')
    echo "$git_bash_path"
  }
}
