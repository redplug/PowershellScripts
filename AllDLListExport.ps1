# Exchange management Shell Connect #
. 'D:\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto 


# 작업 날짜
$Date = (Get-date).toString("yyyyMMdd") 
# Export path
$Path = "C:\Work\Scripts\DLCleanUp\Export" 

get-DistributionGroup -resultsize unlimited -filter {HiddenFromAddressListsEnabled -eq "False"} | `
Select SamAccountName, OrganizationalUnit,CustomAttribute15,CustomAttribute2,DisplayName,`
HiddenFromAddressListsEnabled,WindowsEmailAddress,WhenCreated | `
export-csv -Encoding UTF8 -Path $Path\AllDLList_$Date.csv -NoTypeInformation

