# ----------------------------------------------------------------------------------
# Script:   DisableUser.ps1 
# Author:   klively 
# Date:     10/31/2014 10:57:51 
# Comments: This script will disable a user, then moves user to the appropriate OU, adds 
# the Jira # in the description of the AD Account, and lastly removes the user
# from all AD groups.
# ----------------------------------------------------------------------------------


Import-Module ActiveDirectory
$ErrorActionPreference = "silentlycontinue"
$Destination="OU=Users-Disabled,DC=crossview,DC=inc"
$user=Read-Host "`nWhich user would you like to disable?"

Get-ADUser $user -ErrorVariable errorvariable | Out-Null

if ($errorvariable -ne $null){
write-host "`nUser '$user' not found.`n"
}

else{
$sure=Read-Host "`nAre you sure you want to remove user '$user'? (y/n)"

if ($sure -match 'y'){
$description=Read-Host "`nEnter the Jira # for the ticket to disable $user (Ex: INF-12345)"
Set-ADUser $user -Description "Disabled per:  $description"
Disable-ADAccount $user -Confirm:$false
Get-ADUser $user | Move-ADObject -TargetPath $Destination
$groups = (Get-ADuser $user -Properties memberof | Select-Object -ExpandProperty memberof)
$groups | Remove-ADGroupMember -members $user -Confirm:$false

$clean=@(foreach ($i in $groups)
{$i.Split(",")[0].replace("CN=",[string]::Empty)| Out-String})

Write-Host "`nUser " -NoNewline
write-host $user -ForegroundColor Yellow -NoNewline
write-host " has been disabled, moved to 'Users-Disabled', and removed from the following groups in AD: `n`n $clean`n"

# Add removed groups to "notes" field
$clean = ,"                                        " + $clean
Set-ADUser $user -Replace @{info="User was removed from the following groups: $clean"}
}
}

