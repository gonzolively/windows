# ------------------------------------------------------------------------
# Script:   DisableUserScript.ps1 
# Author:   klively 
# Date:     10/08/2014 08:37:28 
# Comments: This script is used to disable crossview employees upon termination
# ------------------------------------------------------------------------

# AD Module
Import-Module Activedirectory

# Answer Question
Write-Host `n`tUser type 'Disable User Script'`n -ForegroundColor Magenta
$FullName = Read-Host "Please enter the User Name of user you want to disable"
$Description = Read-Host "Please Enter Jira #"

#Sets jira# in discription
Set-ADUser $FullName -description $description

# Execute - Disable User
Disable-ADAccount -Identity $FullName 

# Move's user to Users-Disabled ou
Get-ADUser $FullName | Move-ADObject -TargetPath 'OU=Users-Disabled,OU=CrossView,DC=crossview,DC=inc'

#Remove all groups from user
Get-ADPrincipalGroupMembership -Identity $FullName | % {Remove-ADPrincipalGroupMembership -Identity $FullName -MemberOf $_ -Confirm:$False}

# Email User
Send-MailMessage -SmtpServer 10.251.0.35 -From "infrateam@crossview.com" -To "infrateam@crossview.com" -Subject "Automated User Disable Script: " -Body "$FullName has been disabled and moved to User-Disabled OU."