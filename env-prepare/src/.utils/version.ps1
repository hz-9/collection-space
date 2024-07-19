Function setVersion {
  param(
    [string]$dir,
    [string]$version
  )

  $version | Out-File -FilePath "$dir/version.txt"

  Write-Host "Set version: $version"
}

Function getVersion {
  param(
    [string]$dir
  )

  $file = "$dir/version.txt"

  if (Test-Path $file) {
    $version = Get-Content $file
    Write-Host "Get version: $version"
    return $version
  } else {
    Write-Host "Not found $file"
    exit 1
  }
}
