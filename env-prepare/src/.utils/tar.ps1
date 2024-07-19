function zipDir {
  param(
    [string]$tarDir
  )

  $pwd_ = Get-Location
  $dirName = Split-Path -Path $tarDir -Parent
  $baseName = Split-Path -Path $tarDir -Leaf

  Write-Host ""
  Set-Location -Path $dirName
  Compress-Archive -Path $baseName -DestinationPath "$baseName.zip"
  Set-Location -Path $pwd_
  Write-Host ""

  Write-Host "Zip $tarDir complete."
}

function unzipDir {
  param(
    [string]$tarFile
  )

  $dirName = Split-Path -Path $tarFile -Parent
  $baseName = Split-Path -Path $tarFile -Leaf

  Write-Host ""
  Expand-Archive -Path $tarFile -DestinationPath $dirName -Force
  Write-Host ""

  Write-Host "Unzip $tarFile complete."
}
