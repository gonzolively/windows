# ------------------------------------------------------------------------
# Script:   AD-LockedOutUsers.ps1 
# Author:   ad-klively 
# Date:     09/25/2013 18:32:08 
# Comments: This checks for locked out users...and yes I do feel a little
# dirty by writing a script for this...but I mean, who will remember this?
# I know I know, chances ar I will remember, but I didn't think it would
# hurt anyone.  What?!  This script has hurt someone?!...I do feel really
# ashamed now...just leave me alone...
# ------------------------------------------------------------------------

Import-Module ActiveDirectory
$lockedout = search-adaccount -lockedout | Select-Object -ExpandProperty Name | Out-String

if (!$lockedout){
write-host "`nNo one is locked out"}

else{
write-host "`nThe following users are currently locked out: `n"
write-host $lockedout -ForegroundColor Yellow}
