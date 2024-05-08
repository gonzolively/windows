# ------------------------------------------------------------------------
# Script:   AD-CountUsersByOU.ps1 
# Author:   klively 
# Date:     10/16/2014 11:14:57 
# Comments: This script will count users per OU underneath "clients" and
# place in the output in a text file, in the root (C:\) of the users machine.
# ------------------------------------------------------------------------

Import-Module activeDirectory
$ErrorActionPreference = "silentlycontinue"
$date=(Get-Date).ToString("s").Replace(":","-").Remove(10)


$clients=@(Get-ADOrganizationalUnit -SearchBase "OU=Clients,OU=CrossView,DC=crossview,DC=inc" -Filter * -SearchScope 1|
Select-Object -Property Name -ExpandProperty Name| Sort-Object -Property Name)

 

ForEach ($i in $clients)
{$count = Get-ADUser -SearchBase "OU=$i,OU=Clients,OU=CrossView,DC=crossview,DC=inc" -Filter * | Measure-Object -Line |
Select-Object -ExpandProperty Lines
$table = New-Object -TypeName psobject
$table | Add-Member -MemberType NoteProperty -Name "Customer" -Value $i 
$table | Add-Member -MemberType NoteProperty -Name "# of users" -Value $count
$table
$table | Out-File -NoClobber -Append -LiteralPath "C:\client_count_$date.txt" -
}


                        

                 