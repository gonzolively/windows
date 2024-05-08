# ----------------------------------------------------------------------------------
# Script:   AD-CopyUsersFromOneGroupToAllJira-DevGroups.ps1 
# Author:   klively 
# Date:     09/18/2015 10:10:04 
# Comments: This script will copy all users from one Group to all groups begining 
# in 'jira' and ending in 'dev'
# ----------------------------------------------------------------------------------

Import-Module ActiveDirectory
$ErrorActionPreference = 'SilentlyContinue'

$from_group = "jira-filer-sharing"
$FromGroupUsers = Get-ADGroup $from_group -Properties member | Select-Object -Property member -ExpandProperty member

# Get all groups begining in 'jira' and ending in 'dev'
$dev_groups = Get-ADGroup -filter * | ?{$_.name -match '^jira..*dev$'} | Select-Object -Property name -ExpandProperty name | Sort-Object -Property Name


foreach ($dev_group in $dev_groups)

{
ForEach ($user in $FromGroupUsers)

{Add-ADGroupMember -Identity $dev_group $user -Confirm:$false -ErrorVariable adderror

if ($adderror -match 'The specified account name is already a member of the group'){
$clean=($user.Split(",")[0].replace("CN=",[string]::Empty))
Write-Host "`n'$clean'" -NoNewline -ForegroundColor Yellow
write-host " was already in the target group " -NoNewline
write-host "'$dev_groups'`n" -NoNewline -ForegroundColor Yellow
}
}
}