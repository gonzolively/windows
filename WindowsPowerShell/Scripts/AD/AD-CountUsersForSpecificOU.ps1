# ------------------------------------------------------------------------
# Script:   AD-CountUsersForSpecificOU.ps1 
# Author:   klively 
# Date:     10/16/2014 11:14:57 
# Comments: This script will count users per the user specified OU.
# ------------------------------------------------------------------------

Import-Module activeDirectory
$ErrorActionPreference = "silentlycontinue"
$OU = Read-Host "`nWhich OU would you like to count"?

$users = Get-ADUser -SearchBase "$OU" -Filter * 

Write-Host "`nThere are " -NoNewline
Write-Host $users.Count -ForegroundColor Yellow -NoNewline
write-host " objects in the OU " -NoNewline
Write-Host $OU -ForegroundColor Yellow