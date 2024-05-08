# -------------------------------------------------------------------------------------
# Script:   AllUsers(withcount).ps1 
# Author:   knox 
# Date:     02/28/2013 09:37:22 
# Comments: Searches AD and prints out alist of all users and provides a count
# of the total
# -------------------------------------------------------------------------------------

import-module ActiveDirectory
$alladusers=Get-ADuser -Filter * 
$alladusers | Sort-Object -Property samaccountname,name | Format-Table -Property samaccountname,name
Write-Host "-------------------------------------"
write-host "Total users in Active Directory" -NoNewline
Write-Host ": " -NoNewline
write-host $alladusers.count -ForegroundColor Yellow
write-host "`n"
