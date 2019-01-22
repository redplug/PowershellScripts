## 패스워드 일괄 초기화 스크립트 ##

# ActiveDirectory 모듈 임포트
Import-Module ActiveDirectory

# SearchBase 설정
$SearchBase = "OU=Test,OU=TEST,DC=tmoncorp,DC=com"

# 일괄 초기화 패스워드
$Password = "xptmxm123!"

# SearchBase에 속하며 test*로 시작하는 계정에 대한 패스워드 일괄 초기화 
get-aduser -Filter {name -like 'test*'} -Searchbase $SearchBase -SearchScope "Onelevel" | Set-ADAccountPassword -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
