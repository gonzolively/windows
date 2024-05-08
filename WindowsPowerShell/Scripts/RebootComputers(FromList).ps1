# -------------------------------------------------------------------------------------
# Script:   RebootComputers(FromList).ps1 
# Author:   ad-klively 
# Date:     05/06/2013 17:44:52 
# Comments: This script will reboot a list of computers as specified by a user
# in the form of a flat txt file.
# -------------------------------------------------------------------------------------

$computers=(get-Content computers_to_reboot.txt)
foreach ($i in $computers) {Invoke-Command -ComputerName $i {Restart-computer -force}}
