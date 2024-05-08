# -------------------------------------------------------------------------------------
# Script:   RemotePSS.ps1 
# Author:   knox 
# Date:     02/28/2013 09:09:40 
# Comments: A quick way to initiate remote PowerShell sessions
# -------------------------------------------------------------------------------------

$whichcomputer=read-host "Which computer would you like to connect to?"
Enter-PSSession -computername $whichcomputer -credential 'LFILMS\ad-klively'

