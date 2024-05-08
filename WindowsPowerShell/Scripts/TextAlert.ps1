# ----------------------------------------------------------------------------------
# Script:   TextAlert.ps1 
# Author:   klively 
# Date:     12/12/2014 11:43:46 
# Comments: This script is the basis for creating an email to text alert.
# ----------------------------------------------------------------------------------

<# Carrier info:
AT&T:          number@txt.att.net
T-Mobile:      number@tmomail.net
Verizon:       number@vtext.com
Sprint:        number@pm.sprint.com
Virgin Mobile: number@vmobl.com
#>
$scriptname = $MyInvocation.MyCommand.Name

$smtpServer = "mail.crossview.inc"
$msg = new-object System.Net.Mail.MailMessage
$msg.From = "$scriptname@$env:COMPUTERNAME.com"
$msg.To.Add("9365468667@txt.att.net")
$msg.Subject = "Alert: "
$msg.Body = "Body"
$smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
$smtpClient.Send($msg)