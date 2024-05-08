# -------------------------------------------------------------------------------------
# Script:   AD-GroupMembers.ps1 
# Author:   ad-klively 
# Date:     06/25/2013 18:30:26 
# Comments: This script finds the members from a particular user-specified group in AD 
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
$ErrorActionPreference="SilentlyContinue"
$group = Read-Host "`nWhich group would you like to query?"

Get-AdGroupMember -Identity $group -ErrorVariable test | Out-Null

$results=@(Get-ADGroupMember -Identity $group)

if ($test -ne $null)
{Write-host "`nThere were no groups named '$group'`n"}

else {
Write-Host "`n"
$results | Select-Object -Property samaccountname,name| Sort-Object -Property samaccountname
Write-Host "========================"
write-host "Members in $group" -NoNewline
write-host ": " -NoNewline 
write-host $results.Count -ForegroundColor Yellow
}