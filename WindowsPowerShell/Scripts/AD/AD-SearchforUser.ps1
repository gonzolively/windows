# -------------------------------------------------------------------------------------
# Script:   SearchADforUser.ps1 
# Author:   ad-klively 
# Date:     05/03/2013 10:08:00 
# Comments: This script queries AD for a username based on input from a user
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
$which_user=Read-Host "`nEnter part of a user you're looking for in AD"

if (!$which_user){
Write-Host "`nYou did not enter a name or part of a name to search for. Please run the search 
again and provide the necessary input"}

else {
$results=(Get-ADUser -Filter * | Where-Object {$_.name -match $which_user -or $_.samaccountname -match $which_user} |
Format-Table -Property name,samaccountname | Out-String -Stream | Select-String $which_user)}

if (!$results)
{
Write-Host "`nThere were no results found for"$which_user}

else 
{Write-Host "`nRESULTS:"
Write-Host "***************************"
$results
Write-Host "***************************"
}
