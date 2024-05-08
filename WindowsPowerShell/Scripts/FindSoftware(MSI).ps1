# -------------------------------------------------------------------------------------
# Script:   FindSoftware.ps1 
# Author:   knox 
# Date:     04/22/2013 14:52:51 
# Comments: This script queries a machine for software containing the specified
# string entered by the user, with one catch, it has to be a program that was installed
# using MSI!!!!
# -------------------------------------------------------------------------------------
$whichcomputer=Read-Host "`n Which computer do you want to check? (Press 'Enter' for this machine)"

if ($whichcomputer -match $null)
{$whichcomputer="localhost"}

$whichapp=Read-Host "`nFind software with containing this string"
Write-Host `n
$app_info=Get-WmiObject -Class 'win32_product' -ComputerName $whichcomputer |Where-Object {$_.name -match $whichapp}
Write-Host "Found applications containing" $whichapp "in the name"
$app_info.Name
