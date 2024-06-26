# -------------------------------------------------------------------------------------
# Script:   DisabledUsersByDate.ps1 
# Author:   knox 
# Date:     02/28/2013 09:23:17 
# Comments: Searches AD for disabled users and sorts them by date (descending)
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
Search-ADAccount -AccountDisabled -UsersOnly | Sort-Object -Descending -Property lastlogondate,samaccountname,name | 
Format-Table -Property lastlogondate,samaccountname,name
