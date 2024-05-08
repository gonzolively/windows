# ----------------------------------------------------------------------------------
# Script:   AD-RemoveUserFromAllGroups.ps1 
# Author:   klively 
# Date:     11/24/2014 13:20:02 
# Comments: A simple script to remove a user from all groups
# ----------------------------------------------------------------------------------


$user = Read-Host "Which user would you like to remove from all groups?"

$groups = (Get-ADuser $user -Properties memberof | Select-Object -ExpandProperty memberof)

$groups | Remove-ADGroupMember -members $user -Confirm:$true