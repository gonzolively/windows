# ------------------------------------------------------------------------
# Script:   AD-SearchforGroup.ps1 
# Author:   ad-klively 
# Date:     07/02/2013 16:51:20 
# Comments: This script finds groups like the term specified by the user
# ------------------------------------------------------------------------


Import-Module ActiveDirectory
$which_group=Read-Host "`nEnter part of a group you're looking for in AD"

if (!$which_group){
Write-Host "`nYou did not enter a name or part of a name to search for. Please run the search 
again and provide the necessary input"}

else {
$results=(Get-ADgroup -Filter * | Where-Object {$_.name -match $which_group} |
Format-Table -Property name | Out-String -Stream | Select-String $which_group)}

if (!$results)
{
Write-Host "`nThere were no results found for"$which_group}

else 
{Write-Host "`nRESULTS:"
Write-Host "***************************"
$results
Write-Host "***************************"
}

