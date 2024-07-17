if (-not ([Net.ServicePointManager]::SecurityProtocol).ToString().Contains([Net.SecurityProtocolType]::Tls12)) {
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol.toString() + ', ' + [Net.SecurityProtocolType]::Tls12
}

. "./git-install-common.ps1"

Start-BitsTransfer -Source $downloadUrl -Destination "$downloadPath\$filename"

& "$downloadPath\$filename" 

echo "Please continue run 'git-install-2.ps1'"
