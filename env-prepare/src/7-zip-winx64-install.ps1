. "$PSScriptRoot\.utils\index.ps1"

# # Software name and version
$softwareName="7-Zip Installer"

$downloadUrl=$args[0]

if ($null -eq $downloadUrl) {
  exit 1
} else {
  Write-Host "Download Url: $downloadUrl"
}

# Download parameters
$downloadDir="$DOWNLOAD_FOLDER\$CURRENT_DATE_S\7-zip"
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
$softwareVersion="$(getVersion $dirPath)".Replace(".", "")
Write-Host "Version: $softwareVersion"

# ----------  Install Package    ----------
$packagePath="$dirPath\7z$softwareVersion-x64.msi"
$packageName_=$packageName.Replace(".zip", "")
$installDir="$WIN_PROGRAM_FILES\7-Zip\$($packageName_)"

installByMsiexec $packagePath $installDir

setMachineEnvPath "7ZIP_PATH" "$installDir"

# ----------   Complete message  ----------
completeLog "$softwareName"
