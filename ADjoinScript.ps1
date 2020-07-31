Read-Host "도메인 조인 작업을 시작 합니다. `n`재부팅이 진행되오니 필요한 파일 저장 부탁드립니다 `n`시작하시려면 아무키나 눌러주세요"

### Yauser 로컬 관리자 계정 설정 ###
$YauserPassword = ConvertTo-SecureString "yayaya@123!" –AsPlainText –Force
$yauserexist = get-localuser -name  "yauser"

if ($yauserexist -ne $null) {
    ## Yauser가 존재할 경우 패스워드만 초기화
    set-LocalUser -Name yauser -Password $YauserPassword
}else{
    ## Yauser가 존재하지 않을 경우 계정 생성 및 초기화
    New-LocalUser -Name yauser -Password $YauserPassword -AccountNeverExpires -FullName yauser -PasswordNeverExpires
    Add-LocalGroupMember -Group Administrators -Member yauser
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

##도메인 조인
$domain = "redplug.test"
$account = read-host "AD계정명을 입력부탁드립니다."
## 계정에 점있으면 제거
$accountnondot = $account -replace ('\.','')

switch($company){
    1 { ## A법인
        $ComputerTrue = get-adcomputer -Identity A-$accountnondot
        if($ComputerTrue -eq $null){
            Add-Computer -DomainName $Domain -NewName A-$accountnondot
       } else {
            $ComputerName = Read-host "기존 컴퓨터 이름이 존재합니다. 수동으로 입력 부탁드립니다."
            Add-Computer -DomainName $Domain -NewName $ComputerName
       }
       }
    2 { ## B법인
        $ComputerTrue = get-adcomputer -Identity B-$accountnondot
        if($ComputerTrue -eq $null){
            Add-Computer -DomainName $Domain -NewName B-$accountnondot
       } else {
            $ComputerName = Read-host "기존 컴퓨터 이름이 존재합니다. 수동으로 입력 부탁드립니다."
            Add-Computer -DomainName $Domain -NewName $ComputerName
       }
      }
    3 { ## C법인
        $ComputerTrue = get-adcomputer -Identity C-$accountnondot
        if($ComputerTrue -eq $null){
            Add-Computer -DomainName $Domain -NewName C-$accountnondot
       } else {
            $ComputerName = Read-host "기존 컴퓨터 이름이 존재합니다. 수동으로 입력 부탁드립니다."
            Add-Computer -DomainName $Domain -NewName $ComputerName
       }       
      }
}

sleep 10;

## 사용자 계정 관리자 그룹 추가
Add-LocalGroupMember -Group Administrators -Member redplug\$account

Read-Host "아무키나 눌러주시면 컴퓨터를 재시작 합니다."
Restart-Computer -Force
