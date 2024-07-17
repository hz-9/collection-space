if (-not ([Net.ServicePointManager]::SecurityProtocol).ToString().Contains([Net.SecurityProtocolType]::Tls12)) {
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol.toString() + ', ' + [Net.SecurityProtocolType]::Tls12
}

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent

echo "Workspace: $scriptDir"

$version="2.45.2"
$filename="PortableGit-$version-64-bit.7z.exe"
$filename2="PortableGit-$version-64-bit.7z" 
$downloadUrl="https://mirrors.huaweicloud.com/git-for-windows/v$version.windows.1/$filename"
$downloadPath="$env:HOMEPATH\Downloads"
# Office Download URL
# $downloadUrl="https://github.com/git-for-windows/git/releases/download/v$version.windows.1/$filename"

echo "Version       : $version"
echo "Filename      : $filename"
echo "Download Url  : $downloadUrl"
echo "Download Path : $downloadPath"
