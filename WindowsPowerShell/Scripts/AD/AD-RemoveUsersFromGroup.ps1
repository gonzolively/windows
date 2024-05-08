#----------------------------------------------------------------------------------
# Script:   AD-RemoveUsersFromGroup.ps1 
# Author:   klively 
# Date:     06/18/2015 10:16:03 
# Comments: This script will remove all users from a user-specified group
# ----------------------------------------------------------------------------------

Import-Module ActiveDirectory

$which_group = Read-Host "`nWhich group would you like to remove all users from?"

$members = Get-ADGroupMember -identity $which_group

Foreach ($member in $members){
Remove-ADGroupMember -Identity $which_group -Members $member -ErrorVariable errors
}

$members_clean = $members | Select-Object -Property name -ExpandProperty name | Sort-Object -Property 

if (!$Errors){
Write-Host "`n The following members " -NoNewline
Write-Host " have been removed from the group" -NoNewline
Write-Host " '$which_group'`n" -ForegroundColor Red
$members_clean | Out-String
}

if($errors){
Write-host "`n Oops! There were errors, please check the group name and make sure you are connected via vpn"
}
