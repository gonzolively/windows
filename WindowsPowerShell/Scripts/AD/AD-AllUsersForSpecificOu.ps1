# -------------------------------------------------------------------------------------
# Script:   AllUsers(withcount).ps1 
# Author:   knox 
# Date:     02/28/2013 09:37:22 
# Comments: Searches AD and prints out alist of all users and provides a count
# of the total number of users in a user-specified OU
# -------------------------------------------------------------------------------------

import-module ActiveDirectory
$OU = Read-Host "`nWhich OU would you like to get a list of users from? (Please use 'disginguished name')"
$alladusers=Get-ADuser -Filter * -SearchBase "$OU"
$alladusers | Sort-Object -Property samaccountname,name | Format-Table -Property samaccountname,name
Write-Host "-------------------------------------"
write-host "Total users in Active Directory" -NoNewline
Write-Host ": " -NoNewline
write-host $alladusers.count -ForegroundColor Yellow
write-host "`n"
