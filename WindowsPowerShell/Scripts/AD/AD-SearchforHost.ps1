# -------------------------------------------------------------------------------------
# Script:   SearchADforHost.ps1 
# Author:   knox 
# Date:     04/12/2013 14:07:13 
# Comments: Searches AD for a computer with a name like 'xyz'
# 
# -------------------------------------------------------------------------------------
Import-Module ActiveDirectory
$whichcomputer=Read-Host "`nEnter part of a hostname you're looking for in AD"

if (!$whichcomputer){
Write-Host "`nYou did not enter a name or part of a name to search for. Please run the search 
again and provide the necessary input"}

else {
$results=(Get-ADComputer -Filter * | Where-Object {$_.name -match $whichcomputer} |
Format-Table -Property name | Out-String -Stream | Select-String $whichcomputer)}

if (!$results)
{
Write-Host "`nThere were no results found for"$whichcomputer}

else 
{Write-Host "`nRESULTS:"
Write-Host "***************************"
$results
Write-Host "***************************"
}




