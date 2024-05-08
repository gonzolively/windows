
$smtpServer = "mail.legend3d.com"

$msg = new-object System.Net.Mail.MailMessage

$msg.From = "alerts@legend3d.com"
$msg.To.Add("klively@legend3d.com")

$msg.Subject = "User privileges elevated"

$msg.Body = (Get-WinEvent -Logname Security -MaxEvents 1 -FilterXPath `
	'*[System[(EventID=4673)]]' `
	| Sort-Object -Property TimeCreated | Select-Object -First 1).message


$smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
$smtpClient.Send($msg)


<# Event ID's
4673: A privileged service was called
#>