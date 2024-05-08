# ------------------------------------------------------------------------
# Script:   DriversInstalled.ps1 
# Author:   ad-klively 
# Date:     07/23/2013 16:27:05 
# Comments: Gets a list of currently installed drivers, their name and whether
# ------------------------------------------------------------------------


Get-WmiObject -Class 'win32_systemdriver' | Sort-Object -Property Displayname | Format-Table DisplayName,Name,State