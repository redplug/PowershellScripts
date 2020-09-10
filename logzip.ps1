## powershell자체 압축을 사용하였으나 10GB 압축 시 정상적으로 압축되지 않는 증상이 발생하여 7zip으로 대체하여 작성

## 7일전 로그를 대상으로 압축작업을 시작
$7daybefore = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")

# 30일 이전 로그를 삭제
$30daybefore = (Get-Date).AddDays(-30).ToString("yyyy-MM-dd")
Get-ChildItem "E:\syslog" -Filter "*$30daybefore*.log" | foreach { $_.Delete()}



# 비어있는 Zip파일을 만든다.

$zipfilename = "E:\syslog\Archive\" + $7daybefore + ".zip"

# 압축 준비

$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
    throw "7 zip file '$7zipPath' not found"
}

Set-Alias 7zip $7zipPath

# 압축 시작

$logFiles = Get-ChildItem "E:\syslog" -Filter "*$7daybefore*.log" | Sort-Object Length

foreach($file in $logFiles){

    $Source = "E:\syslog\" + $file
    $Target = $zipfilename

    7zip a $Target $Source
}
