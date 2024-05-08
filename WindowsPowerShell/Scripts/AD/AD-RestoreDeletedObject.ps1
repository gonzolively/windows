# -------------------------------------------------------------------------------------
# Script:   AD-RestoreDeletedObject.ps1 
# Author:   ad-klively 
# Date:     06/25/2013 12:31:09 
# Comments: This script allows a user to search for a deleted object in AD
# and then gives them to restore it.  If multiple results come back matching
# the string query it will iterate through each result.
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
$search_term=Read-Host "`nPlease provide a search string, or press enter to see all deleted objects"
$objects=Get-ADObject -Filter * -IncludeDeletedObjects| where {$_.name -match $search_term} | Where-Object {$_.deleted -match 'True'}


if($objects -eq $null)
{
Write-Host "`nFound no deleted object by that name here!"
}

elseif($objects -ne $null)
{
write-host "`n`nTOTAL OBJECTS FOUND:`n"
write-host "`*********************************************************************************************"
$objects
write-host "*********************************************************************************************"


ForEach ($i in $objects)
{
write-host "`n`nWould you like to restore this object?`n" 
write-host "Object type:" $i.objectclass "`n"
Write-Host $i
$answer=read-host "`ny/n? "
write-host "`n"

if ($answer -match 'y')
{restore-adobject -identity $i
write-host "Successfully restored object!`n`n"}

else 
{write-host "Object not removed`n`n"}
}
}


