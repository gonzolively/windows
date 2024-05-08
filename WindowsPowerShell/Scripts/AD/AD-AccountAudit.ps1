# ----------------------------------------------------------------------------------
# Script:   AD-AccountAudit.ps1 
# Author:   klively 
# Date:     01/13/2015 11:20:43 
# Comments: This script checks for accounts that have not logged in to AD in the last
# 30 days, disables them, sends an email notification, creates a jira.  It then
# re-iterates through all of those disabled users, looking for users who have been 
# disabled for over 60 days and removes them from all groups, edits the "description"
# field to say they were permanently disabled, as well as being moved to the 
# "Users-Disabled" OU.And for the love of god, and all things decent please do not 
# edit the long spaces in between quotes, it took FOREVER to get the output to format
# properly, it is hacky but just LEAVE IT!
# ----------------------------------------------------------------------------------

Import-Module ActiveDirectory

# Global vars
$ErrorActionPreference = "silentlycontinue"
$scriptname = $MyInvocation.MyCommand.Name
$DateTime = Get-Date
$date_users_disabled = @()
$Destination="OU=Users-Disabled,DC=crossview,DC=inc"

# Get list of inactive users, minus 'dbi sftp'
$inactive_users = Get-ADUser -filter * -properties lastlogondate,samaccountname,name,DistinguishedName|
Where-Object {$_.enabled -match 'True'} | Where-Object { $_.lastlogondate -le $DateTime.AddDays(-30)} |
?{$_.name -notmatch 'DBI SFTP'} |?{$_.DistinguishedName -notmatch 'Service_Accounts'} 
$inactive_users_formatted = ($inactive_users | Sort-Object -Descending -Property lastlogondate, samaccountname,name|
Format-Table -Property lastlogondate, samaccountname,name | Out-String)

# Disable inactive users
if ($inactive_users)
{
ForEach ($i in $inactive_users)
{
# Removing variables, otherwise values will pile into an array and give 'wonky' output
Remove-Variable -Name description,notes,new_description
Disable-ADAccount $i -Confirm:$false -ErrorVariable disableerorr -Verbose

$description = Get-ADUser $i -Properties description | Select-Object -Property description -ExpandProperty description

if ($description)
{
$notes = Get-ADUser $i -Properties info | Select-Object -Property info -ExpandProperty info
if (!$notes)
{$notes = "No notes were found"
}
$new_description = ("Description: $Description" + "`n" + "                                        " + "============================" + "                                               " + "Original Notes field: $notes")
Set-ADUser $i -Replace @{info=$new_description}
Set-ADUser $i -Description "Disabled per:  $scriptname@$env:COMPUTERNAME @ $DateTime"
}

elseif (!$description) {
Set-ADUser $i -Description "Disabled per:  $scriptname@$env:COMPUTERNAME @ $DateTime"
}
}

if (!$disableerorr)
{
 $i2 = $i.Name
 # Send Email with results
 $smtpServer = "mail.crossview.inc"
 $msg = new-object System.Net.Mail.MailMessage
 $msg.From = "trector@crossview.com".
 $msg.To.Add("svg-support@crossview.com")
 $msg.CC.Add("infrateam@crossview.com")
 $msg.Subject = "'$i2' has been disabled"
 $msg.Body =  "`nThe account '$i2' been inactive for 30 days or more in Active Directory, and therefore disabled.  The user is still a member
of all security and distribution groups, as well as still in the original OU.  After 60 more days of inactivity the account will be moved to 
the 'Users-disabled' OU and subsequently removed from all groups."
 $smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
 $smtpClient.Send($msg)
 }
}

 if (!$inactive_users){
 # Send Email with results
 $smtpServer = "mail.crossview.inc"
 $msg = new-object System.Net.Mail.MailMessage
 $msg.From = "trector@crossview.com"
 $msg.To.Add("infrateam@crossview.com")
 $msg.Subject = "No inactive users in AD were disabled"
 $msg.Body = "`n There were no inactive users to disable at this time."
 $smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
 $smtpClient.Send($msg)
 }

#########################################################################################################################
# Get disabled users, if they've been disabled for more than 60 days, remove from all groups, move to users-disabled ou.#
#########################################################################################################################

$disabled_users = (Get-ADUser -Filter * | ? {$_.enabled -match 'False'} | ?{$_.name -notmatch "guest|krbtgt|911|template|DBI SFTP"})

ForEach ($u in $disabled_users)
{
 $u2 = $u.DistinguishedName
 $u3 = $u.Name
 $date_users_disabled=@([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().DomainControllers[1].GetReplicationMetadata("$u2").Item('userAccountControl').LastOriginatingChangeTime)
 $table = New-Object -TypeName psobject
 $table | Add-Member -MemberType NoteProperty -Name "User" -Value $u.Name
 $table | Add-Member -MemberType NoteProperty -Name "Date Disabled" -Value $date_users_disabled

 if ($table.'Date Disabled'-lt $DateTime.AddDays(-60)){

$groups = (Get-ADuser $u -Properties memberof | Select-Object -ExpandProperty memberof)

Function DescriptionCheck{

$global:description2 = Get-ADUser $u -Properties description | Select-Object -Property description -ExpandProperty description

if ($description2)
{
$global:notes2 = Get-ADUser $u -Properties info | Select-Object -Property info -ExpandProperty info
if (!$notes2)
{$global:notes2 = "    No notes were found"
}
$global:new_description2 = ("Description: $Description2" + "`n" + "                                        " + "============================" + "                                                " + "Notes:                                                                                              " + $notes2)
Set-ADUser $u -Replace @{info=$new_description2}
Set-ADUser $u -Description "User permanantly disabled @ $DateTime"
}

elseif (!$description2) {
Set-ADUser $u -Description "User permanantly disabled @ $DateTime"
$global:notes2 = (Get-ADUser $u -Properties info | Select-Object -Property info -ExpandProperty info)
if (!$notes2)
{$global:notes2 = "    No notes were found"
}
}
}

Function RemoveFromGroups{
# Remove from Groups
$groups | Remove-ADGroupMember -members $u -Confirm:$false -Verbose
$global:clean=@(foreach ($g in $groups)
{$g.Split(",")[0].replace("CN=",[string]::Empty)| Out-String})
$clean = ,"                                        " + $clean
DescriptionCheck
Set-ADUser $u -Replace @{info= "User was removed from the following groups: $clean" + "============================" + "                                        " + $new_description2}
}

Function MoveToOU{
Get-ADUser $u | Move-ADObject -TargetPath $Destination -Confirm:$false -verbose
}

Function MainProgram{

# Send Email with results
$smtpServer = "mail.crossview.inc"
$msg = new-object System.Net.Mail.MailMessage
$msg.From = "trector@crossview.com"
$msg.To.Add("svg-support@crossview.com")
$msg.CC.Add("infrateam@crossview.com")
$msg.Subject = "'$u3' removed from groups and moved to 'Disabled-Users'"
$msg.Body = "The account '$u3' has been disabled for 60 days or more, therefore it was moved moved to the 'Users-Disabled' OU, and removed from the following groups: `n`n $clean`n "
$smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
$smtpClient.Send($msg)
}

if (($groups) -and ($u2 -notmatch 'OU=Users-Disabled,DC=crossview,DC=inc')) {
RemoveFromGroups
MoveToOU
MainProgram
}

elseif ((!$groups) -and ($u2 -notmatch 'OU=Users-Disabled,DC=crossview,DC=inc')) {
$clean = ' No groups found'
DescriptionCheck
MoveToOU
MainProgram
}

elseif (($groups) -and ($u2 -match 'OU=Users-Disabled,DC=crossview,DC=inc')){
RemoveFromGroups
MainProgram
}

elseif ((!$groups) -and ($u2 -match 'OU=Users-Disabled,DC=crossview,DC=inc')){
continue
}
}

else {
continue
}
}
