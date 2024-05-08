# -------------------------------------------------------------------------------------
# Script:   AD-ListDeletedObjects.ps1 
# Author:   ad-klively 
# Date:     06/25/2013 11:17:04 
# Comments: This script lists all deleted objects in Active Directory by the type that
# the end user specifies.
# -------------------------------------------------------------------------------------
Import-Module ActiveDirectory

write-host "`nWhich type of deleted objects would you like to see?`n"
Write-host "1. Users"
Write-host "2. Computers"
Write-host "3. Groups"
Write-host "4. OU's"
Write-host "5. Containers"
Write-host "6. Contacts"
Write-host "7. ActiveSync Devices"
Write-host "8. All Objects`n"
$choice=Read-Host "Choice"
Switch ($choice)
{
1{Get-ADObject -Filter * -IncludeDeletedObjects | Where-Object {$_.objectclass -match 'user'} | Where-Object {$_.deleted -match 'true'}| Sort-Object -Property name,objectclass| Format-Table -Property name,objectclass}
2{Get-ADObject -Filter * -IncludeDeletedObjects | Where-Object {$_.objectclass -match 'computer'} | Where-Object {$_.deleted -match 'true'} | Sort-Object -Property name,ObjectClass| Format-Table -Property name,objectclass}
3{Get-ADObject -Filter * -IncludeDeletedObjects | Where-Object {$_.objectclass -match 'group'} | Where-Object {$_.deleted -match 'true'} | Sort-Object -Property name,objectclass| Format-Table -Property name,objectclass}
4{Get-ADObject -Filter * -IncludeDeletedObjects | Where-Object {$_.objectclass -match 'organizationalunit'} | Where-Object {$_.deleted -match 'true'} | Sort-Object -Property name,objectclass| Format-Table -Property name,objectclass}
5{Get-ADObject -Filter * -IncludeDeletedObjects | Where-Object {$_.objectclass -match 'container'} | Where-Object {$_.deleted -match 'true'} | Sort-Object -Property name,objectclass| Format-Table -Property name,objectclass}
6{Get-ADObject -Filter * -IncludeDeletedObjects | Where-Object {$_.objectclass -match 'contact'} | Where-Object {$_.deleted -match 'true'} | Sort-Object -Property name,objectclass| Format-Table -Property name,objectclass}
7{Get-ADObject -Filter * -IncludeDeletedObjects | Where-Object {$_.objectclass -match 'msExchActiveSyncDevice'} | Where-Object {$_.deleted -match 'true'} | Sort-Object -Property name,objectclass| Format-Table -Property name,objectclass}
8{Get-ADObject -Filter * -IncludeDeletedObjects | Where-Object {$_.deleted -match 'true'} |Sort-Object -Property objectclass| Format-Table -Property name,objectclass}
}
