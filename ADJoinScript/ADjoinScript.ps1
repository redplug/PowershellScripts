Read-Host "도메인 조인 작업을 시작 합니다. `n`재부팅이 진행되오니 필요한 파일 저장 부탁드립니다 `n`시작하시려면 아무키나 눌러주세요"

### reuser 로컬 관리자 계정 설정 ###
$reuserPassword = ConvertTo-SecureString "rerere@123!" –AsPlainText –Force
$reuserexist = get-localuser -name  "reuser"

if ($reuserexist -ne $null) {
    ## reuser가 존재할 경우 패스워드만 초기화
    set-LocalUser -Name reuser -Password $reuserPassword
}else{
    ## reuser가 존재하지 않을 경우 계정 생성 및 초기화
    New-LocalUser -Name reuser -Password $reuserPassword -AccountNeverExpires -FullName reuser -PasswordNeverExpires
    Add-LocalGroupMember -Group Administrators -Member reuser
}

### 도메인 조인 ###

write-host "1 : A법인"
write-host "2 : B법인"
write-host "3 : C법인"
write-host "4 : 스크립트 종료"

do {
    $company = read-host "소속 법인의 숫자를 입력 해주세요"
} until ($company -in 1..4)

if ($company -eq 4){
    write-host "스크립트를 종료합니다."
    exit
}

### 도메인 조인 ###

$domain = "redplug.test"
$account = read-host "AD계정명을 입력부탁드립니다." 
$accountnondot = $account -replace ('\.','')

switch($company){
    1 { $Hostname = "A-$accountnondot"}
    2 { $Hostname = "B-$accountnondot"}
    3 { $Hostname = "C-$accountnondot"}
}

$ComputerTrue = get-adcomputer -Identity $Hostname

if($ComputerTrue -eq $null){
    Add-Computer -DomainName $Domain -NewName $Hostname
    } else {
        $AnotherHostname = Read-host "기존 컴퓨터 이름($Hostname)이 존재합니다. 수동으로 입력 부탁드립니다."
        Add-Computer -DomainName $Domain -NewName $AnotherHostname
    }
sleep 10;

## 사용자 계정 관리자 그룹 추가
Add-LocalGroupMember -Group Administrators -Member redplug\$account

Read-Host "아무키나 눌러주시면 컴퓨터를 재시작 합니다."
Restart-Computer -Force


