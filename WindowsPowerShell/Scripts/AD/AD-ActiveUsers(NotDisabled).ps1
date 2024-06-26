# -------------------------------------------------------------------------------------
# Script:   ActiveUsers(NotDisabled).ps1 
# Author:   knox 
# Date:     02/28/2013 09:43:23 
# Comments: Searches AD for all users NOT disabled 
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
$enabled_users=Get-ADUser -Filter 'enabled -eq$true' | Sort-Object -Property Name | Format-Table -Property Name
$enabled_users
write-host "-----------------------------"
write-host "There are " -NoNewline
write-host $enabled_users.count -ForegroundColor yellow -NoNewline
write-host " active users in Active Directory"
write-host "`n"
