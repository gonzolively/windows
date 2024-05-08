# ----------------------------------------------------------------------------------
# Script:   SendMailMessage.ps1 
# Author:   klively 
# Date:     01/13/2015 11:10:15 
# Comments: This is a generic template for sending email.
# ----------------------------------------------------------------------------------

 $smtpServer = "mail.crossview.inc"
 $msg = new-object System.Net.Mail.MailMessage
 $msg.From = ""
 $msg.To.Add("")
 $msg.Subject = ""
 $msg.Body = "`ns"
 $smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
 $smtpClient.Send($msg)