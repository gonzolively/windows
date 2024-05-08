# ------------------------------------------------------------------------
# Script:   Untitled3.ps1 
# Author:   klively 
# Date:     10/14/2014 10:19:17 
# Comments: This script finds open RDP sessions on a host
# ------------------------------------------------------------------------

$server=Read-Host "Please enter the hostname you wish to check"
Write-Host "`n"
quser /server:$server