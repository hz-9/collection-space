$UTILS_FOLDER = $PSScriptRoot
$SRC_FOLDER = [System.IO.Path]::GetDirectoryName($UTILS_FOLDER)
$PROJECT_FOLDER = [System.IO.Path]::GetDirectoryName($SRC_FOLDER)

$DOWNLOAD_FOLDER=""
if ($null -eq $env:HOMEPATH) {
  $DOWNLOAD_FOLDER="$env:HOME/Downloads"
} else {
  $DOWNLOAD_FOLDER="$env:HOMEPATH\Downloads"
}

$CURRENT_TIMESTAMP=Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'
$CURRENT_TIMESTAMP_S=Get-Date -Format 'yyyyMMddHHmmss'

$CURRENT_DATE=Get-Date -Format 'yyyy-MM-dd'
$CURRENT_DATE_S=Get-Date -Format 'yyyyMMdd'

$CURRENT_TIME=Get-Date -Format 'HH:mm:ss'
$CURRENT_TIME_S=Get-Date -Format 'HHmmss'

# # `C:\Program Files` in Windows
$WIN_PROGRAM_FILES=$env:PROGRAMFILES

# Write-Host "UTILS_FOLDER        : $UTILS_FOLDER"
# Write-Host "SRC_FOLDER          : $SRC_FOLDER"
# Write-Host "PROJECT_FOLDER      : $PROJECT_FOLDER"
# Write-Host "DOWNLOAD_FOLDER     : $DOWNLOAD_FOLDER"
# Write-Host "CURRENT_TIMESTAMP   : $CURRENT_TIMESTAMP"
# Write-Host "CURRENT_TIMESTAMP_S : $CURRENT_TIMESTAMP_S"
# Write-Host "CURRENT_DATE        : $CURRENT_DATE"
# Write-Host "CURRENT_DATE_S      : $CURRENT_DATE_S"
# Write-Host "CURRENT_TIME        : $CURRENT_TIME"
# Write-Host "CURRENT_TIME_S      : $CURRENT_TIME_S"

# Write-Host "WIN_PROGRAM_FILES    : $WIN_PROGRAM_FILES"
