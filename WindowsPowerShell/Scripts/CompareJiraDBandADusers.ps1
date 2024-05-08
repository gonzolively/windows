# ----------------------------------------------------------------------------------
# Script:   CompareJiraDBandADusers.ps1 
# Author:   klively 
# Date:     10/23/2014 11:39:31 
# Comments: This script grabs users from AD and the JiraDB and then compares them.
# The output is users who are in AD, but not in JiraDB
# ----------------------------------------------------------------------------------

Import-module activedirectory
$ErrorActionPreference = "silentlycontinue"

Remove-Item D:\Scripts\AD-Jira\AdusersNotInJira.csv -recurse


# connects to cv-jira

invoke-command -scriptblock {D:\Scripts\AD-Jira\mysql -u crowdadmin -pJudgeMentD@y -h cv-jira -e "SELECT uname FROM jiradb.x_cvusers where startdate >= date_sub(CURDATE(), INTERVAL 30 DAY)" } -OutVariable JiraUsers |Out-Null

#Get last user from AD
$Date=(get-date).adddays(-30)

$ADUsers = @(Get-ADUser -Filter * -SearchBase "OU=Users,OU=CrossView,DC=crossview,DC=inc" -Properties * |
Where-Object {$_.whenCreated -gt $date } |?{$_.DistinguishedName -notmatch 'PFSWeb'}|?{$_.DistinguishedName -notmatch 'Service_Accounts'} |?{$_.enabled -match 'true'} | Select -exp sAMAccountName)

# Compare file script
Compare-Object -ReferenceObject $ADUsers -DifferenceObject $JiraUsers |?{$_ -notmatch 'uname'} |
?{$_.sideindicator -match '<='} |Select-Object -Property inputobject |Format-Table -AutoSize -HideTableHeaders|
Out-File ADUsersNotInJira.csv

$report=@(
Get-Content AdusersNotInJira.csv | Out-String
)

if (!$report)
{ $report = "`nThere are no users at this time`n`n"}

# Output Results
Write-Host "`n**************************************"
Write-Host "Users in AD that are not in Jira"
Write-Host "**************************************"
$report
Write-Host "**************************************`n"

# Mail Report

$smtpServer = "mail.crossview.inc"

$msg = new-object System.Net.Mail.MailMessage
$msg.From = "cv-batch@crossview.com"
$msg.To.Add("infrateam@crossview.com")
$msg.Subject = "ADUsers NOT in JiraDB"
$msg.Body = $report

$smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
$smtpClient.Send($msg)