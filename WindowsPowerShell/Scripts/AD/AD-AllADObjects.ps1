# ----------------------------------------------------------------------------------
# Script:   AD-AllADObjects.ps1 
# Author:   klively 
# Date:     10/24/2014 12:16:11 
# Comments: This script counts all objects in an AD Organiztion
# ----------------------------------------------------------------------------------

Import-Module ActiveDirectory

$ObjectTypes=@(Get-ADObject -Filter * | Select-Object -Property objectclass -Unique -ExpandProperty objectclass|
Sort-Object -Property objectclass)


foreach ($i in $ObjectTypes)
{$CountPerClass=Get-ADObject -Filter * |?{$_.Objectclass -match $i} | Measure-Object -Line |Select-Object -ExpandProperty lines
$table = New-Object -TypeName psobject
$table | Add-Member  -MemberType NoteProperty -Name "ObjectType" -Value $i
$table | Add-Member -MemberType NoteProperty -Name "Count" -Value $CountPerClass
$table
$total+=$CountPerClass
}

# Total
Write-Host "`n===================================`n"
Write-Host   "Total Objects =                " -NoNewline
Write-Host $total -ForegroundColor Yellow
