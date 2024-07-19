. "$PSScriptRoot\.utils\index.ps1"

# # Software name and version
$softwareName="PsTools Installer"

$downloadUrl=$args[0]

if ($null -eq $downloadUrl) {
  exit 1
} else {
  Write-Host "Download Url: $downloadUrl"
}

# Download parameters
$downloadDir="$DOWNLOAD_FOLDER\$CURRENT_DATE_S\pstools"
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
$packagePath="$dirPath\pstools-$softwareVersion"

$installDir="$WIN_PROGRAM_FILES\pstools\pstools-$softwareVersion"
if (Test-Path "$WIN_PROGRAM_FILES\pstools") {
  # ...
} else {
  New-Item -ItemType Directory -Force -Path "$WIN_PROGRAM_FILES\pstools" | Out-Null
}

Write-Host "From: $packagePath"
Write-Host "To  : $installDir"
Move-Item  -Path $packagePath -Destination $installDir

setMachineEnvPath "PSTOOLS_PATH" "$installDir"

# ----------   Complete message  ----------
completeLog "$softwareName"
