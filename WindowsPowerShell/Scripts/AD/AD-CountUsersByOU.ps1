# ------------------------------------------------------------------------
# Script:   AD-CountUsersByOU.ps1 
# Author:   klively 
# Date:     10/16/2014 11:14:57 
# Comments: This script will count users per OU underneath "clients".
# ------------------------------------------------------------------------

Import-Module activeDirectory
$ErrorActionPreference = "silentlycontinue"


$clients=@(Get-ADOrganizationalUnit -SearchBase "OU=Clients,OU=CrossView,DC=crossview,DC=inc" -Filter * -SearchScope 1|
Select-Object -Property Name -ExpandProperty Name| Sort-Object -Property Name )

write-host "`n`n*************************************" -NoNewline
ForEach ($i in $clients)
{$count = (Get-ADUser -SearchBase "OU=$i,OU=Clients,OU=CrossView,DC=crossview,DC=inc" -Filter * | Measure-Object -Line |
Select-Object -ExpandProperty Lines) 

if ($count -igt '0'){
$table = New-Object -TypeName psobject
$table | Add-Member -MemberType NoteProperty -Name "Customer" -Value $i 
$table | Add-Member -MemberType NoteProperty -Name "Users" -Value $count
$table
}
}   
write-host "*************************************"