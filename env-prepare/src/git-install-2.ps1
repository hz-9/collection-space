. "./git-install-common.ps1"

$unpackgeDir="$downloadPath\PortableGit"
$installDir="$env:PROGRAMFILES\Git\PortableGit-$version-64-bit"

if (Test-Path   -Path "$installDir" -PathType Container) {
    Remove-Item -Path "$installDir" -Recurse -Force
}

cp -r  $unpackgeDir $installDir

[Environment]::SetEnvironmentVariable('GIT_PATH', "$installDir\bin", 'Machine')

echo "Please add 'GIT_PATH' to 'PATH'"
