# 변수 기입
$ErrorActionPreference= 'silentlycontinue'
## Web Broswer
$WebBroswer = "chrome"

## OK URL 보이기(안보이기 할경우 0으로 수정)
$OKshow = 1

## URL Check Interval (60초)
$CheckInterval = 60

# Test URL (코드 내 기입, 
$urls = @(
'https://naver.com'
#'http://google.com'
)

## answer1(URL,CSV) answer(반복,1회성(크롬)
$answer1 = 1
$answer2 = 1

## file path
$fullPathIncFileName = $MyInvocation.MyCommand.Definition # Script 파일의 full path
$currentScriptName = $MyInvocation.MyCommand.Name # Script 파일 이름
$currentExecutingPath = $fullPathIncFileName.Replace($currentScriptName, "") # Script 폴더
$csv = import-Csv $currentExecutingPath\urls.csv -Encoding UTF8

$answer1 = read-host "URL변수면 1(기본), CSV면 2"
write-host ""

$answer2 = read-host "Shell창 반복 1(기본), Chrome창1회 2"
write-host ""

if($answer1 -eq 1){
    write-host "URL Inline Check"
}
elseif($answer1 -eq 2)
{
    write-host "CSV Check"
    $urls = $csv.urls
}

# 200 체크 (OK 떨어지는것까지는 체크 안함)
if($answer2 -eq 1){
    for(;;) { 
    $OK = 0
    $Fal = 0
    $time = get-date
    Write-Host "Now Time : " $time
    write-host "==== URL CHECK START ==="
    foreach ($url in $urls){
        #write-host $url
        $w = ''
        $w = Invoke-Webrequest $url -DisableKeepAlive
        #write-host $w
        if(($w.StatusCode -eq '200'))
            {
            if($OKshow -eq 1){
            write-host "OK :" $url
            }
            $OK = $OK + 1
            } 
        else {
            write-host "False" $url
            $Fal = $Fal + 1
        }
    }
    write-host "==== URL CHECK END   ==="
    write-host "==== Summery START   ==="        
    write-host "OK    Summery : " $OK
    write-host "False Summery : " $Fal
    $Count = $OK + $Fal
    Write-host "Sum Count : " $Count
    write-host "==== Summery END     ==="     
    Write-Host ""
    sleep $CheckInterval
}
}
elseif($answer2 -eq 2)
{
    foreach ($url in $urls){
    Start-Process -FilePath $WebBroswer -ArgumentList $url
    }
}
