# ----------------------------------------------------------------------------------
# Script:   AD-AddUsersFromOuToGroup.ps1 
# Author:   klively 
# Date:     02/02/2015 16:07:12 
# Comments: This script will take users from a user specified ou and add them to the 
# user specified group
# ----------------------------------------------------------------------------------

Import-Module ActiveDirectory
$ErrorActionPreference = "silentlycontinue"
$OU = Read-Host "`nPlease provide an OU in the form of its 'distinguished name' to copy users from"
$users = @(Get-ADUser -filter * -SearchBase "$OU")
$group = Read-Host "`nPlease provide a group (distribution or security) to copy these users to"

foreach ($u in $users)
{Add-ADGroupMember -Identity $group -Members $u -Confirm:$false -ErrorVariable errorronadd
}
$new_users = ($users.SamAccountName | Sort-Object | Out-String)

if (!$errorronadd)
{$clean = $OU.Split(",")[0].replace("CN=",[string]::Empty)
$clean_again = $clean.Split(",")[0].replace("OU=",[string]::Empty)
Write-Host "`nThe following users have been added from the " -NoNewline
write-host "'$clean_again'" -ForegroundColor Yellow -NoNewline
write-host " OU to the " -NoNewline 
write-host "'$group'" -ForegroundColor Yellow -NoNewline
write-host " group: `n"
write-host "$new_users"
}

if ($errorronadd)
{Write-Host "nError occured somewhere in the script, please check your inputs and run again."}
