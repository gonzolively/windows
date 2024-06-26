# -------------------------------------------------------------------------------------
# Script:   AccountsOlderThan(Ndays).ps1 
# Author:   knox 
# Date:     02/28/2013 09:00:41 
# Comments: This script gets and sorts accounts in Active Directory that
# haven't been logged into in since "n" days.
# -------------------------------------------------------------------------------------

import-module ActiveDirectory
$howmanydays=Read-Host "How many days back do you want to go?"
$DateTime = Get-Date 
Get-ADUser -filter * -properties lastlogondate,samaccountname,name | Where-Object { $_.lastlogondate -le $DateTime.AddDays(-$howmanydays)} |
Sort-Object -Descending -Property lastlogondate, samaccountname,name |Format-Table -Property lastlogondate, samaccountname,name #| Out-String -Stream



