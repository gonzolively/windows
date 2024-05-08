$hostname=hostname
$smtpServer = "mail.legend3d.com"

$msg = new-object System.Net.Mail.MailMessage

$msg.From = "$Hostname@legend3d.com"
$msg.To.Add("klively@legend3d.com")

$msg.Subject = "User Logged On"

$msg.Body =(Get-WinEvent -MaxEvents 1 -Logname 'security' -FilterXPath '*[System[EventID=4624]]' | Sort-Object -Property TimeCreated | Select-Object -First 1).message

$smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
$smtpClient.Send($msg)