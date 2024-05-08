# ----------------------------------------------------------------------------------
# Script:   AD-MoveUsersToGroup.ps1 
# Author:   klively 
# Date:     10/23/2014 15:07:06 
# Comments: This script was designed to add all users from 3 different OU's to a
# security group.  It can be modified for various OU's and groups
# ----------------------------------------------------------------------------------

Import-Module ActiveDirectory

$GlobalLogicUsers=(Get-ADUser -SearchBase "OU=Globallogic,OU=Users,OU=CrossView,DC=crossview,DC=inc" -Filter * -Properties * |
?{$_.enabled -match 'true'}|Select-Object -Property Samaccountname -ExpandProperty Samaccountname|
Sort-Object -Property samaccountname)

$Admins=(Get-ADUser -SearchBase "OU=Admins,OU=Users,OU=CrossView,DC=crossview,DC=inc" -Filter * -Properties * |
?{$_.enabled -match 'true'}|Select-Object -Property Samaccountname -ExpandProperty samaccountname|
Sort-Object -Property samaccountname)

$Users=(Get-ADUser -SearchBase "OU=Users,OU=CrossView,DC=crossview,DC=inc" -Filter * -Properties * -SearchScope OneLevel|
?{$_.enabled -match 'true'}|Select-Object -Property Samaccountname -ExpandProperty Samaccountname |
Sort-Object -Property samaccountname)

$all=($GlobalLogicUsers + $Admins + $Users)

$group="CN=jira-crossview-STD,OU=JIRA,OU=Infrastructure-APPS,OU=Infrasructure,OU=Departments,OU=CrossView,DC=crossview,DC=inc"

ForEach ($i in $all){
# To Add Members to $group
Add-ADGroupMember -Identity $group -Members $i
# To Remove Members from $group
#Remove-ADGroupMember -Identity $group -Members $i -Confirm:$false
}