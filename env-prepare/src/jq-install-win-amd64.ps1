. "$PSScriptRoot\.utils\index.ps1"

# # Software name and version
$softwareName="jq Installer"

$downloadUrl=$args[0]

if ($null -eq $downloadUrl) {
  exit 1
} else {
  Write-Host "Download Url: $downloadUrl"
}

# Download parameters
$downloadDir="$DOWNLOAD_FOLDER\$CURRENT_DATE_S\jq"
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
Write-Host "SoftwareVersion: $softwareVersion"

# ----------  Install Package    ----------
$packagePath="$dirPath\jq-windows-amd64.exe"

$installDir="$WIN_PROGRAM_FILES\jq\jq-$softwareVersion-win-amd64"
if (Test-Path $installDir) {
  # ...
} else {
  New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

Write-Host "From: $packagePath"
Write-Host "To  : $installDir"
Move-Item  -Path $packagePath -Destination "$installDir/jq.exe"

setMachineEnvPath "JQ_PATH" "$installDir"

# ----------   Complete message  ----------
completeLog "$softwareName"
