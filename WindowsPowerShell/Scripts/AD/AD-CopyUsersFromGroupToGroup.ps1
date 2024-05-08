# ----------------------------------------------------------------------------------
# Script:   AD-CopyUsersFromGroupToGroup.ps1 
# Author:   klively 
# Date:     12/04/2014 09:39:24 
# Comments: This script will copy all users from one user specified
# group to another group.
# ----------------------------------------------------------------------------------

Import-Module ActiveDirectory
$ErrorActionPreference = 'SilentlyContinue'

$FromGrp = Read-Host "`nPlease enter the group you wish to copy members from"
Get-ADGroup $FromGrp -ErrorVariable fromgrperror | Out-Null
if ($fromgrperror)
{Write-Host "`nThe group '$fromgrp' you specified could not be found, please try again."
Break
}

$ToGrp = Read-Host "`nPlease enter the group you wish to copy members to"
Get-ADGroup $ToGrp -ErrorVariable togrperror -ErrorAction Stop | Out-Null
if ($togrperror)
{Write-Host "`nThe group '$ToGrp' you specified could not be found, please try again."
Break
}

$FromPrpUsers = Get-ADGroup $FromGrp -Properties member | Select-Object -Property member -ExpandProperty member


ForEach ($user in $FromPrpUsers)
{Add-ADGroupMember -Identity $ToGrp $user -Confirm:$false -ErrorVariable adderror
if ($adderror -match 'The specified account name is already a member of the group'){
$clean=($user.Split(",")[0].replace("CN=",[string]::Empty))
Write-Host "`n'$clean'" -NoNewline -ForegroundColor Yellow
write-host " was already in the target group " -NoNewline
write-host "'$ToGrp'`n" -NoNewline -ForegroundColor Yellow
}
}

Write-Host "`nTask Complete!"