#!/bin/bash

# import from sync-db-postgresql.sh
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--db-version${_m_}${_m_}The version of the database.${_m_}15.4"

  "--from-hostname${_m_}${_m_}The hostname of the source database.${_m_}127.0.0.1"
  "--from-port${_m_}${_m_}The port of the source database.${_m_}5432"
  "--from-username${_m_}${_m_}The username of the source database.${_m_}postgres"
  "--from-password${_m_}${_m_}The password of the source database.${_m_}12345678"
  "--from-database${_m_}${_m_}The database name of the source database.${_m_}postgres"
  "--to-hostname${_m_}${_m_}The hostname of the target database.${_m_}127.0.0.1"
  "--to-port${_m_}${_m_}The port of the target database.${_m_}5432"
  "--to-username${_m_}${_m_}The username of the target database.${_m_}postgres"
  "--to-password${_m_}${_m_}The password of the target database.${_m_}12345678"
  "--to-root-database${_m_}${_m_}The root database name of the target database.${_m_}postgres"
  "--to-database${_m_}${_m_}The database name of the target database.${_m_}postgres_backup"
  "--temp${_m_}${_m_}The temporary directory.${_m_}/tmp/hz-9/env-prepare/sync-db-postgresql"

  "--from-ssh-tunnel${_m_}${_m_}Use SSH tunnel to connect to the source database.${_m_}"
  "--from-ssh-private-key${_m_}${_m_}The private key file of the SSH tunnel.${_m_}"
  "--to-ssh-tunnel${_m_}${_m_}Use SSH tunnel to connect to the target database.${_m_}"
  "--to-ssh-private-key${_m_}${_m_}The private key file of the SSH tunnel.${_m_}"
)

SHELL_NAME="PostgreSQL Sync Tooler"
SHELL_DESC="Sync PostgreSQL database."

# source ./__judge-system.sh

# import from ./__console.sh
{
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  PURPLE='\033[0;35m'
  CYAN='\033[0;36m'
  WHITE='\033[0;37m'
  NC='\033[0m' # no color

  get_current_time_ms() {
    # local seconds
    # local nanoseconds
    # seconds=$(date +%s)
    # nanoseconds=$(date +%N)
    # echo $((seconds * 1000 + nanoseconds / 1000000))
    local seconds
    seconds=$(date +%s)
    echo $((seconds * 1000))
  }

  console_name() {
    printf "\n${PURPLE}%s${NC}\n\n" "$SHELL_NAME"
  }

  console_desc() {
    if [[ -n "$SHELL_DESC" ]]; then
      printf "  ${NC}%s${NC}\n\n" "$SHELL_DESC"
    fi
  }

  console_support_os() {
    printf "  ${YELLOW}%s${NC}\n\n" "Supported operating systems:"
    for os_info in "${SUPPORT_OS_LIST[@]}"; do
      printf "    ${YELLOW}%s${NC}\n" "$os_info"
    done
    console_empty_line
  }

  console_check_system() {
    if [[ "$IS_SUPPORT_OS" == false ]]; then
      printf "  ${RED}%s${NC}\n\n"   "This shell script does not support the current operating system. [$CURRENT_OS]"
      console_support_os
    
      exit 1
    else
      printf "  ${GREEN}%s${NC}\n\n" "This shell script supports the current operating system. [$CURRENT_OS]"
    fi
  }

  console_title() {
    local title="$1"
    printf "  ${CYAN}%s${NC}\n\n" "$title"
  }

  console_key_value() {
    local key="$1"
    local value="$2"

    if [[ ${#key} -gt 16 ]]; then
      printf "    ${GREEN}%s${NC}\n" "$key"
      printf "    ${GREEN}%-16s${NC}: %s\n" "" "$value"
    else
      printf "    ${GREEN}%-16s${NC}: %s\n" "$key" "$value"
    fi

    return 1
  }

  console_empty_line() {
    printf "\n"
  }

  console() {
    printf "%s\n" "$1"
  }

  console_content() {
    printf "    %s\n" "$1"
  }

  console_sulines() {
    # printf "    %s\n" "$1"
    local msg=$1
    _console_sub_lines() {
      # shellcheck disable=SC2317
      while IFS= read -r line; do
        printf "      %s\n" "$line"
      done
    }
    echo "$msg" | _console_sub_lines
  }

  tempTime=$(get_current_time_ms)
  console_content_starting() {
    tempTime=$(get_current_time_ms)

    if [ "$(get_param '--debug')" == 'false' ]; then
      printf "    %s" "$1"
    else
      printf "    %s\n\n" "$1"
    fi
  }

  console_content_complete() {
    local currentTime
    currentTime=$(get_current_time_ms)
    local timeDiff
    timeDiff=$((currentTime - tempTime))

    if [ "$(get_param '--debug')" == 'false' ]; then
      printf " ${GREEN}%s${NC} %s${NC}\n" "done." "(${timeDiff} ms)"
    else
      printf "\n ${GREEN}%s${NC} %s${NC}\n" "done." "(${timeDiff} ms)"
    fi
  }

  console_content_error() {
    local msg=$1

    if [ "$(get_param '--debug')" == 'false' ]; then
      printf " ${RED}%s${NC}\n" "error."
      printf "    ${RED}%s${NC}\n" "Reason: \"${msg}\""
    else
      printf "\n ${RED}%s${NC}\n" "error."
      printf "    ${RED}%s${NC}\n" "Reason: \"${msg}\""
    fi
  }

  console_content_emptystr() {
    printf "%s\n" ""
  }

  console_end() {
    printf "  ${CYAN}%s${NC}\n\n" "$1"
  }

  get_redirect_output() {
    if [ "$(get_param '--debug')" == 'false' ]; then
      echo "&> /dev/null"
    else
      echo ""
    fi
  }
}

# import from ./__parse-user-paramter.sh
{
  USER_PARAMTERS=()

  parse_user_param() {
    while [[ "$#" -gt 0 ]]; do
      case $1 in
      --*=*)
        key="${1%%=*}"
        value="${1#*=}"
        USER_PARAMTERS+=("$key${_m_}$value")
        ;;
      --*)
        key="$1"
        if [[ -n "$2" && "$2" != --* ]]; then
          USER_PARAMTERS+=("$key${_m_}$2")
          shift
        else
          USER_PARAMTERS+=("$key${_m_}true")
        fi
        ;;
      -*=*)
        key="${1%%=*}"
        value="${1#*=}"
        USER_PARAMTERS+=("$key${_m_}$value")
        ;;
      -*)
        key="$1"
        if [[ -n "$2" && "$2" != --* ]]; then
          USER_PARAMTERS+=("$key${_m_}$2")
          shift
        else
          USER_PARAMTERS+=("$key${_m_}true")
        fi
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
      esac
      shift
    done
  }

  print_user_param() {
    console_title "User paramters:"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"
      local value
      value="${split[1]}"
      
      console_key_value "${name//--/}" "$value"
    done
    echo ""

    return 1
  }

  has_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"

      if [[ "$name" == "$key" ]]; then
        return 0
      fi
    done

    return 1
  }

  get_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"
      local value
      value="${split[1]}"

      if [[ "$name" == "$key" ]]; then
        echo "$value"
      fi
    done
    return
  }

  parse_user_param "$@"
}

# import from ./__parse-paramter.sh
{

  print_default_param() {
    console_title "Default paramters:"

    # shellcheck disable=SC2153
    for PARAMTER in "${PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"
      local value
      value="${split[3]}"

      console_key_value "${name//--/}" "$value"
    done
    console_empty_line

    return 1
  }

  has_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"

      if [[ "$name" == "$key" ]]; then
        return 0
      fi
    done

    return 1
  }

  get_param() {
    local key="$1"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"

      if [[ "$name" == "$key" ]]; then
        local alias
        alias="${split[1]}"
        local default
        default="${split[3]}"

        if has_user_param "$name"; then
          get_user_param "$name"
        elif has_user_param "$alias"; then
          get_user_param "$alias"
        else
          echo "$default"
        fi
        break
      fi
    done

    return
  }

  print_help() {
    console_name

    console_desc

    for PARAMTER in "${PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"
      local alias
      alias="${split[1]}"
      local msg
      msg="${split[2]}"
      local default
      default="${split[3]}"

      if [[ -n "$alias" ]]; then
        name+=",$alias"
      fi
      local defaultStr=''
      if [[ -n "$default" ]]; then
        defaultStr=" (Default is '$default')"
      fi
      
      console_key_value "$name" "$msg$defaultStr"
    done
    console_empty_line

    console_check_system

    console_support_os

    return 1
  }

  print_param() {
    console_name

    console_desc

    console_check_system

    console_title "Paramters:"

    for PARAMTER in "${PARAMTERS[@]}"; do
      local split
      eval "split=('${PARAMTER//${_m_}/$'\'\n\''}')"

      local name
      name="${split[0]}"
      local value
      value=$(get_param "$name")

      console_key_value "${name//--/}" "$value"
    done
    console_empty_line

    return 1
  }

  print_help_or_param() {
    if [[ $(get_param '--help') == "true" ]]; then
      print_help
      exit 0
    else
      print_param
    fi
  }
}

print_help_or_param

# debug=$(get_param '--debug')

dbVersion=$(get_param '--db-version')

fromHostname=$(get_param '--from-hostname')
fromPort=$(get_param '--from-port')
fromUsername=$(get_param '--from-username')
fromPassword=$(get_param '--from-password')
fromDatabase=$(get_param '--from-database')

toHostname=$(get_param '--to-hostname')
toPort=$(get_param '--to-port')
toUsername=$(get_param '--to-username')
toPassword=$(get_param '--to-password')
toRootDatabase=$(get_param '--to-root-database')
toDatabase=$(get_param '--to-database')

fromSshTunnel=$(get_param '--from-ssh-tunnel')
fromSshPrivateKey=$(get_param '--from-ssh-private-key')
toSshTunnel=$(get_param '--to-ssh-tunnel')
toSshPrivateKey=$(get_param '--to-ssh-private-key')

# ------------------------------------------------------------

console_title "Temp"

temp=$(get_param '--temp')
syncFile="dump.$(date +"%Y-%m-%dT%H:%M:%S").sql"

console_key_value "temp dir" "$temp"
console_key_value "sync file" "$syncFile"

if [[ ! -d "$temp" ]]; then
  console_content "Create temp directory."
  mkdir -p "$temp"
fi

console_empty_line

# ------------------------------------------------------------

console_title "Docker environment"

if docker --version &>/dev/null; then
  console_content "Docker has been installed."
  console_empty_line
  console_key_value "Docker CE" "$(docker --version | awk '{print $3}' | sed 's/,//')"
  console_key_value "Docker compose" "$(docker compose version | awk '{print $4}')"
else
  console_content "Docker has not been installed."
  console_empty_line
  exit 1
fi

dockerImage="postgres:$dbVersion-alpine"

console_key_value "Docker image" "$dockerImage"
console_empty_line

console_content_starting "Image $dockerImage is pulling..."

# docker pull $dockerImage --platform linux/amd64
eval "docker pull $dockerImage --platform linux/amd64 $(get_redirect_output)"

console_content_complete
console_empty_line

# ------------------------------------------------------------

console_title "Generate scripts"

tempDockerfile="$temp/dockerfile"
tempFromSshPrivateKey="$temp/from-ssh-private-key"
tempToSshPrivateKey="$temp/to-ssh-private-key"

console_key_value "Dockerfile" "$tempDockerfile"
console_key_value "From ssh key" "$tempFromSshPrivateKey"
console_key_value "To ssh key" "$tempToSshPrivateKey"

rm -rf "$tempDockerfile"
echo "FROM $dockerImage" >>"$tempDockerfile"

echo """
RUN apk update && apk add --no-cache openssh
""" >>"$tempDockerfile"

rm -rf "$tempFromSshPrivateKey"
if [ -n "$fromSshPrivateKey" ]; then
  cp "$fromSshPrivateKey" "$tempFromSshPrivateKey"
else 
  echo "---EMPTY PRIVATE KEY---" > "$tempFromSshPrivateKey"
fi

rm -rf "$tempToSshPrivateKey"
if [ -n "$toSshPrivateKey" ]; then
  cp "$toSshPrivateKey" "$tempToSshPrivateKey"
else 
  echo "---EMPTY PRIVATE KEY---" > "$tempToSshPrivateKey"
fi

console_empty_line

# ------------------------------------------------------------

console_title "Build sync docker image"

syncDockerImage="hz-9/sync-db-postgresql:$dbVersion-alpine"

console_key_value "Sync image" "$syncDockerImage"
console_empty_line

console_content_starting "Image $syncDockerImage is building..."

# docker build -t "$syncDockerImage" -f "$tempDockerfile" "$temp"
eval "docker build -t '$syncDockerImage' -f '$tempDockerfile' '$temp' $(get_redirect_output)"

console_content_complete
console_empty_line

# ------------------------------------------------------------

console_title "Sync by $syncDockerImage"

console_content_starting "Syncing data from $fromHostname to $toHostname..."

syncCommand="""
if [ -n '$fromSshTunnel' ]; then
  $fromSshTunnel
  echo 'From ssh tunnel is running.'
fi
if [ -n '$toSshTunnel' ]; then
  $toSshTunnel
  echo 'To ssh tunnel is running.'
fi

export PGPASSWORD=$fromPassword
pg_dump -h $fromHostname -p $fromPort -U $fromUsername -d $fromDatabase   -f '/data-backup/$syncFile'

export PGPASSWORD=$toPassword
psql    -h $toHostname   -p $toPort   -U $toUsername   -d $toRootDatabase -c 'DROP   DATABASE IF EXISTS $toDatabase;'
psql    -h $toHostname   -p $toPort   -U $toUsername   -d $toRootDatabase -c 'CREATE DATABASE $toDatabase;'
psql    -h $toHostname   -p $toPort   -U $toUsername   -d $toDatabase      < '/data-backup/$syncFile'
"""

# docker run --rm \
#   -e "POSTGRES_DB=postgres" \
#   -e "POSTGRES_USER=postgres" \
#   -e "POSTGRES_PASSWORD=12345678" \
#   -v "$temp/backup:/data-backup" \
#   -v "$temp/from-ssh-private-key:/root/.ssh/from-ssh-private-key" \
#   -v "$temp/to-ssh-private-key:/root/.ssh/to-ssh-private-key" \
#   "$syncDockerImage" \
#   bash -c "$syncCommand"
eval """
docker run --rm \
  -e 'POSTGRES_DB=postgres' \
  -e 'POSTGRES_USER=postgres' \
  -e 'POSTGRES_PASSWORD=12345678' \
  -v '$temp/backup:/data-backup' \
  -v '$temp/from-ssh-private-key:/root/.ssh/from-ssh-private-key' \
  -v '$temp/to-ssh-private-key:/root/.ssh/to-ssh-private-key' \
  '$syncDockerImage' \
  bash -c \"$syncCommand\" $(get_redirect_output)
"""

console_content_complete
console_empty_line

# ------------------------------------------------------------

console_title "Delete sync docker image"

console_content_starting "Image $syncDockerImage is deleting..."

# docker rmi "$syncDockerImage"
eval "docker rmi '$syncDockerImage' $(get_redirect_output)"

console_content_complete
console_empty_line

# ------------------------------------------------------------

console_end "Sync complete."
