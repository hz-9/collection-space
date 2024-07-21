. "$PSScriptRoot\.utils\index.ps1"

# # Software name and version
$softwareName="Node.js Installer"

$downloadUrl=$args[0]

if ($null -eq $downloadUrl) {
  exit 1
} else {
  Write-Host "Download Url: $downloadUrl"
}

# Download parameters
$downloadDir="$DOWNLOAD_FOLDER\$CURRENT_DATE_S\nodejs"
$packageName="$(urlToName $downloadUrl)"

Write-Host "pacakgeName: $packageName"

# # ---------- Prepare log message ---------- 
startLog "$softwareName"

# ----------    Download file    ----------
downloadFile $downloadUrl $downloadDir $packageName

# ----------   unTar Package     ----------
$tarPath="${downloadDir}\$packageName"
$dirPath=$tarPath.Replace(".zip", "")
unzipDir $tarPath

# ----------   Read   Version    ----------
$softwareVersion="$(getVersion $dirPath)"
Write-Host "Version: $softwareVersion"

# ----------  Install Package    ----------
$nodePath="$dirPath\node-v$softwareVersion-win-x64"
$pm2Path="$dirPath\.pm2"

$nodeInstallDir="$WIN_PROGRAM_FILES\node\node-v$softwareVersion-win-x64"
$pm2InstallDir="$env:HOMEPATH\.pm2"
if (Test-Path "$WIN_PROGRAM_FILES\node") {
  # ...
} else {
  New-Item -ItemType Directory -Force -Path "$WIN_PROGRAM_FILES\node" | Out-Null
}

Move-Item -Path $nodePath -Destination $nodeInstallDir

Move-Item -Path $pm2Path  -Destination $pm2InstallDir

setMachineEnvPath "NODE_PATH" "$nodeInstallDir"

# ----------   Complete message  ----------
completeLog "$softwareName"
