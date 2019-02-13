# Exchange management Shell Connect #
. 'D:\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto 

$StartDay = (Get-Date).AddDays(-2).ToString("yyyy-MM-dd")
$EndDay = (Get-Date)
$EndDayprint = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")
$Path = "C:\Work\Scripts\DLCleanUp\Export"
$From = "sender@redplug.co.kr"
$To = "receiver@redplug.co.kr"
$SmtpServer = "mail.redplug.co.kr"
$Subject = "[AutoJob] $EndDay DLReceiveListExport End"
$Body = get-content -path $Path\Childitem.txt | Out-String


get-exchangeserver | Get-MessageTrackingLog -start $StartDay -End $EndDay.ToString("yyyy-MM-dd") -ResultSize unlimited -eventid `
expand | select Timestamp,RelatedRecipientAddress,Sender,MessageSubject | export-csv -Encoding UTF8 -Path $Path\DLReceive_$StartDay"_"$EndDayprint.csv -NoTypeInformation

get-childitem -path $Path -exclude childitem.txt -name > "$Path\childitem.txt"

Send-MailMessage -From $From -To $To -SmtpServer $SmtpServer -Subject $Subject -Body $Body

