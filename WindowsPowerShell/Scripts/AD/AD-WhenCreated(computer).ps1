# -------------------------------------------------------------------------------------
# Script:   WhenCreated(computer).ps1 
# Author:   knox 
# Date:     02/28/2013 09:05:44 
# Comments: Searches AD for the date a computer was added to AD
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
$whichcomputer=Read-Host "`nPlease enter the computer name to query"
$computerproperties=Get-ADComputer -Filter * -Properties whencreated | Where-Object{$_.name -contains $whichcomputer} 

if ($computerproperties -eq $null) {
Write-Host "`n Found no results.  Please enter a valid comptuer name"}

else {
write-host "`n$whichcomputer was created on:                               " -NoNewline
write-host $computerproperties.whencreated -ForegroundColor Yellow
}