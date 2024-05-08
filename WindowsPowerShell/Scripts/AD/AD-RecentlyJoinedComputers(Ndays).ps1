# -------------------------------------------------------------------------------------
# Script:   RecentlyJoinedComputers(Ndays).ps1 
# Author:   knox 
# Date:     02/28/2013 09:10:14 
# Comments: Finds computers added to AD in the last "n" days
# -------------------------------------------------------------------------------------

$howmanydays=Read-Host "`n How many days back do you want to go?"
Import-Module ActiveDirectory
Get-ADComputer -Filter * | Select-Object -Last $howmanydays | Format-Table -Property name
