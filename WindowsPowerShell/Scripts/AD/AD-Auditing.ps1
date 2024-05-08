# ------------------------------------------------------------------------
# Script:   AD-Auditing.ps1 
# Author:   ad-klively 
# Date:     07/01/2013 14:22:54 
# Comments: This script is used for ActiveDirectory auditing, at the moment
# it audits 8 different events.  It must be used in conjunction with a scheduled
# task that is triggered upon all of these events as well.
# ------------------------------------------------------------------------

$smtpServer = "mail.legend3d.com"


$msg = new-object System.Net.Mail.MailMessage

$msg.From = "alerts@example.com"
$msg.To.Add("klively@legend3d.com")

$msg.Subject = "Active Directory Change"

$msg.Body = (Get-WinEvent -Logname Security -MaxEvents 1 -FilterXPath `
	'*[System[(EventID=5136) or (EventID=4757) or (EventID=5137) or (EventID=5138) or (EventID=5141) or (EventID=4762) or (EventID=4726) or (EventID=5139)]]' `
	| Sort-Object -Property TimeCreated | Select-Object -First 1).message


$smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
$smtpClient.Send($msg)


<#
Event ID description:

4726 - A user account was deleted (both local sam and domain accounts)
4762 - A member was removed from a security-disabled universal group
4757 - A member was removed from a security-enabled universal group
5136 - A directory service object was modified
5137 - A directory service object was created
5138 - A directory service object was undeleted
5139 - A directory service object was moved
5141 - A directory service object was deleted
#>