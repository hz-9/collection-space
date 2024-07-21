. "$PSScriptRoot\.utils\index.ps1"

# # Software name and version
$softwareName="Erlang Installer"

$downloadUrl=$args[0]

if ($null -eq $downloadUrl) {
  exit 1
} else {
  Write-Host "Download Url: $downloadUrl"
}

# Download parameters
$downloadDir="$DOWNLOAD_FOLDER\$CURRENT_DATE_S\Erlang"
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
$packagePath="$dirPath\erlang-$softwareVersion-win64.exe"

$installDir="$WIN_PROGRAM_FILES\Erlang\erlang-$softwareVersion-win64"
if (Test-Path $installDir) {
  # ...
} else {
  New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

$msiArgs = "/NCRC /S /D=$installDir"
$ps = Start-Process -PassThru -Wait $packagePath -ArgumentList $msiArgs

setMachineEnvPath "ERLANG_HOME" "$installDir\bin"

# ----------   Complete message  ----------
completeLog "$softwareName"
