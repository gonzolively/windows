# -------------------------------------------------------------------------------------
# Script:   IsUserLocked.ps1 
# Author:   ad-klively 
# Date:     05/24/2013 11:39:47 
# Comments: This script searches for locked out accounts in a domain
# ------------------------------------------------------------------------------------

Import-Module ActiveDirectory
$locked_out=Search-ADAccount -LockedOut
if (!$locked_out){Write-Host "`nNo one on this domain is locked out`n"}
else
{Write-Host "`nLocked out:"
 $locked_out}