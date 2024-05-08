# ------------------------------------------------------------------------
# Script:   AD-MemberOf.ps1 
# Author:   ad-klively 
# Date:     07/03/2013 10:56:03 
# Comments: This script displays all of the groups a particular user is a 
# member of.
# ------------------------------------------------------------------------
Import-Module ActiveDirectory
$which_user=Read-host "`nWhich user would you like to display the group membership of?"
$user=Get-Aduser -Identity $which_user -Properties memberof 
$data=$user.MemberOf | Sort-Object
Write-Host "`n"
Write-Host "GROUPS:"
Write-Host "*****************************"
foreach ($u in $data){Write-Host $u.split(",")[0].Replace("CN=",[string]::empty)}
Write-Host "*****************************`n"
