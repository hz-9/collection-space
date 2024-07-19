. "$PSScriptRoot\.utils\index.ps1"

. "$PSScriptRoot\git-install-base.ps1"

downloadFile $downloadUrl $downloadPath $filename

if (Test-Path "$downloadPath\$filename") {
  & "$downloadPath\$filename"
} else {
  Write-Host "$downloadPath\$filename not found."
}

