# -------------------------------------------------------------------------------------
# Script:   AllComputersAD.ps1 
# Author:   knox 
# Date:     02/28/2013 09:42:29 
# Comments: Searches AD and lists all computers found, performs a count as well 
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
Get-ADComputer -Filter * -Properties Name| Sort-Object | Format-Table -Property Name|
Tee-Object -Variable computers
Write-Host "`nItems Found: "$computers.Count
