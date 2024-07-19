. "$PSScriptRoot\.utils\index.ps1"

. "$PSScriptRoot\git-install-base.ps1"

$unpackgeDir="$downloadPath\PortableGit"

if ($null -eq $WIN_PROGRAM_FILES) {
  Write-Host "Not in Windows, skip."
} else {
  $installDir="$WIN_PROGRAM_FILES\Git\PortableGit-$version-64-bit"
  if (Test-Path   -Path "$installDir" -PathType Container) {
    Remove-Item -Path "$installDir" -Recurse -Force
  }
  cp -r  $unpackgeDir $installDir
}

setMachineEnvPath 'GIT_PATH' "$installDir\bin"

Write-Host "Please add 'GIT_PATH' to 'PATH'"
