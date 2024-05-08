# ------------------------------------------------------------------------
# Script:   AD-CountUsersForEachOU.ps1 
# Author:   klively 
# Date:     10/16/2014 11:14:57 
# Comments: This script will count users per each top level OU.
# ------------------------------------------------------------------------

Import-Module activeDirectory
$ErrorActionPreference = "silentlycontinue"

$ous=@(Get-ADOrganizationalUnit -SearchBase "DC=crossview,DC=inc" -Filter * -SearchScope OneLevel|
Select-Object -Property Name -ExpandProperty Name| Sort-Object -Property Name )

write-host "`n`n*************************************" -NoNewline

ForEach ($i in $ous)
{$count = (Get-ADUser -SearchBase "OU=$i,DC=crossview,DC=inc" -Filter * | Measure-Object -Line |
Select-Object -ExpandProperty Lines) 

if ($count -igt '0'){
$table = New-Object -TypeName psobject
$table | Add-Member -MemberType NoteProperty -Name "OU" -Value $i 
$table | Add-Member -MemberType NoteProperty -Name "Users" -Value $count
$table
$total+=$count
}
}   
write-host "*************************************"
write-host "Total =                          " -NoNewline
write-host $total -ForegroundColor Yellow