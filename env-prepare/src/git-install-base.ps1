. "$PSScriptRoot\.utils\index.ps1"

$version="2.45.2"
$filename="PortableGit-$version-64-bit.7z.exe"
$filename2="PortableGit-$version-64-bit.7z" 
$downloadUrl="https://mirrors.huaweicloud.com/git-for-windows/v$version.windows.1/$filename"
$downloadPath=$DOWNLOAD_FOLDER

# Office Download URL
# $downloadUrl="https://github.com/git-for-windows/git/releases/download/v$version.windows.1/$filename"

echo "Version       : $version"
echo "Filename      : $filename"
echo "Download Url  : $downloadUrl"
echo "Download Path : $downloadPath"
