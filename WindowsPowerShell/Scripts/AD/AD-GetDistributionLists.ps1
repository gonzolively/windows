# ----------------------------------------------------------------------------------
# Script:   AD-GetDistributionLists.ps1 
# Author:   klively 
# Date:     01/30/2015 15:46:14 
# Comments: This script will print out a list of distribution all distribution groups.
# You can choose if you want only groups with email, only groups without, or both
# ----------------------------------------------------------------------------------
Import-Module Activedirectory
$choice = Read-Host "Would you like to print a list of distribution groups with email (with), without email (without), or all (all)?"

if ($choice -contains 'with'){
# With Email
Get-ADGroup -SearchBase "OU=CrossView,DC=crossview,DC=inc" -Filter * -Properties mail | ?{$_.GroupCategory -match 'Distribution'} |
?{$_.mail -ne $null} | Select-Object -Property name -ExpandProperty name |  Sort-Object
}

if ($choice -contains 'without'){
# Without email
Get-ADGroup -SearchBase "OU=CrossView,DC=crossview,DC=inc" -Filter * -Properties mail | ?{$_.GroupCategory -match 'Distribution'} |
?{$_.mail -eq $null} | Select-Object -Property name -ExpandProperty name |  Sort-Object
}

if ($choice -contains 'all'){
# All
Get-ADGroup -SearchBase "OU=CrossView,DC=crossview,DC=inc" -Filter *| ?{$_.GroupCategory -match 'Distribution'}|
Select-Object -Property name -ExpandProperty name |  Sort-Object 
}