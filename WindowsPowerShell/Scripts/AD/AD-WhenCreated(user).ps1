# -------------------------------------------------------------------------------------
# Script:   WhenCreated(user).ps1 
# Author:   knox 
# Date:     02/28/2013 09:04:54 
# Comments: Searches AD to find when a user was created
# -------------------------------------------------------------------------------------

Import-module ActiveDirectory
$whichuser=Read-host "`nWhich user would you like to find the creation date for?"
$user=Get-Aduser $whichuser -Properties *
$datecreated=$user.whencreated

if ($datecreated -eq $null) {
Write-Host "`n Found no results.  Please enter a valid username"}

else {
write-host "`n$whichuser was created on:                               " -NoNewline
write-host  "$datecreated" -ForegroundColor Yellow
}
