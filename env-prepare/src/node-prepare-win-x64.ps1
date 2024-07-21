. "$PSScriptRoot\.utils\index.ps1"

# Software name and version
$softwareName="Node.js Preparer"

$nodeVersion="18.20.4"  # Node.js Version

# $nodeRegistryUrl="https://nodejs.org/dist"
$nodeRegistryUrl="https://mirrors.huaweicloud.com/nodejs"

$pm2Version="5.2.0"  # PM2 Version

# $npmRegistryUrl="https://registry.npmjs.org"
$npmRegistryUrl="https://registry.npmmirror.com"

# ---------- Prepare log message ----------
startLog "$softwareName"

$packageName="node-v$nodeVersion-win-x64"
$downloadDir="$DOWNLOAD_FOLDER\$CURRENT_DATE_S\nodejs\node-v$nodeVersion-win-x64"
$downloadUrl="$nodeRegistryUrl/v$nodeVersion/node-v$nodeVersion-win-x64.zip"

if (Test-Path   -Path "$downloadDir" -PathType Container) {
  Remove-Item -Path "$downloadDir" -Recurse -Force
}
New-Item     -ItemType Directory -Force -Path $downloadDir | Out-Null

downloadFile "$downloadUrl" "$downloadDir"
unzipDir     "$downloadDir/node-v$nodeVersion-win-x64.zip"
Remove-Item  "$downloadDir/node-v$nodeVersion-win-x64.zip"

$nodeExe="$downloadDir\node-v$nodeVersion-win-x64\node.exe"
$npmCmd="$downloadDir\node-v$nodeVersion-win-x64\npm.cmd"
$pm2Cmd="$downloadDir\node-v$nodeVersion-win-x64\pm2.cmd"

Write-Host "node version: $(Invoke-Expression "$nodeExe -v")"
Write-Host "npm  version: $(Invoke-Expression "$npmCmd -v")"

Invoke-Expression "$npmCmd i -g pm2 --registry=$npmRegistryUrl"
Invoke-Expression "$pm2Cmd ping"
Write-Host "pm2  version: $(Invoke-Expression "$pm2Cmd -v")"

if ($null -eq $env:HOMEPATH) {
  # ...
} else {
  taskkill /f /t /im node.exe

  $pm2Store="$env:HOMEPATH\.pm2"
  Move-Item  -Path $pm2Store -Destination "$downloadDir\.pm2"
}

setVersion   "$downloadDir" "$nodeVersion"
zipDir       "${downloadDir}"
Remove-Item  "${downloadDir}"

# # ----------   Complete message  ----------
completeLog "$softwareName"
