# ------------------------------------------------------------------------
# Script:   AD-UserLocation(OU).ps1 
# Author:   ad-klively 
# Date:     10/08/2013 12:18:53 
# Comments: This script finds the location of a user in the AD heirachy
# ------------------------------------------------------------------------

Import-Module ActiveDirectory
$which_user=Read-host "`nWhich user would you like to find the location of in Active Directory?"
$user=Get-Aduser -Identity $which_user -Properties canonicalname

Write-Host "`n'$which_user' is located in " -NoNewline
write-host $user.CanonicalName -ForegroundColor Yellow
write-host "`n"
