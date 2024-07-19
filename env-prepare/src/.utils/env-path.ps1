Function setMachineEnvPath {
  param($name, $path)

  if ($PSVersionTable.PSEdition -eq "Desktop") {
    [Environment]::SetEnvironmentVariable($name, $path, 'Machine')

    Write-Host "Set Machine env $name - $path"
  } else {
    Write-Host "Not in windows, Set Machine env $name - $path"
  }
}
