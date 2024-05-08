# -------------------------------------------------------------------------------------
# Script:   LocalAdminChecker.ps1 
# Author:   ad-klively 
# Date:     06/03/2013 15:42:52 
# Comments: This script queries a user-specified machine for local administrators
# -------------------------------------------------------------------------------------

#$strcomputer=Read-Host "`nWhich computer would you like to check?"
$computers=(get-content computers.txt) 
foreach ($i in $computers){
$admins = Gwmi win32_groupuser –computer $i   
$admins = $admins |? {$_.groupcomponent –like '*"Administrators"'}

$admins |% {  
$_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul  
$matches[1].trim('"') + “\” + $matches[2].trim('"')  
}
}
