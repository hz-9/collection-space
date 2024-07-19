. "$PSScriptRoot\base-parameter.ps1"

Function installByMsiexec {
  param($pacakgePath, $installDir = $WIN_PROGRAM_FILES)

  if (Test-Path $pacakgePath) {
    Write-Host "Path          : $pacakgePath"
  } else {
    Write-Host "Not found $pacakgePath"
  }

  Write-Host "Install dir   : $installDir"
  if (Test-Path $installDir) {
    # ...
  } else {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
  }

  $msiArgs = "/q /i `"$pacakgePath`" INSTALLDIR=`"$installDir`""
  $ps = Start-Process -PassThru -Wait msiexec -ArgumentList $msiArgs
}
