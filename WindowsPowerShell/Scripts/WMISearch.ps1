# -------------------------------------------------------------------------------------
# Script:   WMISearch.ps1 
# Author:   knox 
# Date:     02/28/2013 09:03:50 
# Comments: This script checks searches WMI recursively for a keyword
# specified by the user.
# -------------------------------------------------------------------------------------
$search=read-host "`n Enter a keyword to search for"
$whichcomputer=Read-Host "`n Which computer do you want to check? ('localhost' for this machine)"
#if ($whichcomputer -match $null)
#{$whichcomputer="localhost"}
$ErrorActionPreference = "silentlycontinue"
Get-WmiObject -List -Recurse -Namespace 'root' -ComputerName $whichcomputer| Where-Object {$_.name -match $search}

