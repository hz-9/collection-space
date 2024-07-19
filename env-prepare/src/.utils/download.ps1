if (-not ([Net.ServicePointManager]::SecurityProtocol).ToString().Contains([Net.SecurityProtocolType]::Tls12)) {
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol.toString() + ', ' + [Net.SecurityProtocolType]::Tls12
}

Function urlToName {
  param($Url)

  $uri = New-Object System.Uri $Url
  $pathSegments = $uri.Segments
  $lastSegment = $pathSegments[$pathSegments.Length - 1]

  return $lastSegment.TrimEnd('/')
}

# downloadFile "https://heavenzhen.oss-cn-beijing.aliyuncs.com/TEMP/7-zip-24.06-winx64.zip?OSSAccessKeyId=LTAIsFfhGOKJoEdl&Expires=1721275314&Signature=%2BqGHDRzZ7smeufrDlRge1ycfedk%3D" "/Users/heaven/Downloads"
Function downloadFile {
  param($downloadUrl, $downloadDir, $downloadFilename = $null)

  if ($downloadFilename -eq $null) {
    $downloadFilename = "$(urlToName $downloadUrl)"
  }

  if (Test-Path $downloadDir) {
    # ...
  } else {
    New-Item -ItemType Directory -Force -Path $downloadDir | Out-Null
  }

  $absolutionPath = Join-Path $downloadDir $downloadFilename
  Write-Host ""
  Write-Host "File: $absolutionPath"
  Write-Host "Url:  $downloadUrl"

  try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($downloadUrl,$absolutionPath)
  } catch {
    Write-Host "Not found Start-BitsTransfer, use curl."
    curl -L -o "$absolutionPath" "$downloadUrl"
  }

  Write-Host ""
  Write-Host "Download $downloadFilename complete."
}
