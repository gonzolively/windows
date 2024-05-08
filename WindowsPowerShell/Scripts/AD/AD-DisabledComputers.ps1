# ------------------------------------------------------------------------
# Script:   AD-DisabledComputers.ps1 
# Author:   ad-klively 
# Date:     09/09/2013 16:05:54 
# Comments: This script finds all disabled computers in active directory
# ------------------------------------------------------------------------

Import-Module ActiveDirectory
$disabled = Search-ADAccount -AccountDisabled -ComputersOnly
$disabled | Sort-Object -Property name | Format-Table -Property name
Write-Host "----------------------------------------"
Write-Host "Total number of disabled machines in AD: " -nonewline
write-host $disabled.count -foregroundcolor yellow