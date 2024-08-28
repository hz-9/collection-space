#!/bin/bash
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

# TODO use passwordless ssh tunnel

SHELL_NAME="PostgreSQL Sync Tooler"
SHELL_DESC="Sync PostgreSQL database."

source ./_console.sh

source ./_parse-user-paramter.sh

source ./_parse-paramter.sh

print_help_or_param

debug=$(get_param '--debug')

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
  console_key_value "Docker CE" "$(docker --version | awk '{print $3}' | sed 's/,//')"
  console_key_value "Docker compose" "$(docker compose version | awk '{print $4}')"
else
  console_content "Docker has not been installed."
  exit 1
fi

dockerImage="postgres:$dbVersion-alpine"

console_key_value "Docker image" "$dockerImage"
console_empty_line

console_content "Image $dockerImage is pulling..."
if [ "$debug" == 'true' ]; then
  docker pull "$dockerImage" --platform linux/amd64
else
  docker pull "$dockerImage" --platform linux/amd64 &> /dev/null
fi
console_content "Image $dockerImage is pulling...done."
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

console_content "Image $syncDockerImage is building..."
if [ "$debug" == 'true' ]; then
  docker build -t "$syncDockerImage" -f "$tempDockerfile" "$temp"
else
  docker build -t "$syncDockerImage" -f "$tempDockerfile" "$temp" &>/dev/null
fi
console_content "Image $syncDockerImage is building...done."
console_empty_line

# ------------------------------------------------------------

console_title "Sync by $syncDockerImage"

console_content "Syncing data from $fromHostname to $toHostname..."

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

# echo $syncCommand

if [ "$debug" == 'true' ]; then
  docker run --rm \
    -e "POSTGRES_DB=postgres" \
    -e "POSTGRES_USER=postgres" \
    -e "POSTGRES_PASSWORD=12345678" \
    -v "$temp/backup:/data-backup" \
    -v "$temp/from-ssh-private-key:/root/.ssh/from-ssh-private-key" \
    -v "$temp/to-ssh-private-key:/root/.ssh/to-ssh-private-key" \
    "$syncDockerImage" \
    bash -c "$syncCommand"
else
  docker run --rm \
    -e "POSTGRES_DB=postgres" \
    -e "POSTGRES_USER=postgres" \
    -e "POSTGRES_PASSWORD=12345678" \
    -v "$temp/backup:/data-backup" \
    -v "$temp/from-ssh-private-key:/root/.ssh/from-ssh-private-key" \
    -v "$temp/to-ssh-private-key:/root/.ssh/to-ssh-private-key" \
    "$syncDockerImage" \
    bash -c "$syncCommand" &>/dev/null
fi

console_content "Syncing data from $fromHostname to $toHostname...done."
console_empty_line

# ------------------------------------------------------------

console_title "Delete sync docker image"

console_content "Image $syncDockerImage is deleting..."
if [ "$debug" == 'true' ]; then
  docker rmi "$syncDockerImage"
else
  docker rmi "$syncDockerImage" &>/dev/null
fi
console_content "Image $syncDockerImage is deleting...done."
console_empty_line

console_empty_line
echo "Sync complete."
