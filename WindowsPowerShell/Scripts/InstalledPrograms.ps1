# -------------------------------------------------------------------------------------
# Script:   InstalledPrograms.ps1 
# Author:   knox 
# Date:     04/24/2013 11:31:35 
# Comments: This script queries local and remote machines to find 
# which software is installed on them.  Note this only includes software with
# an uninstall agent.
# -------------------------------------------------------------------------------------

# Gather computer name
$whichcomputer=Read-Host "`n Which computer do you want to check? (Press 'Enter' for this machine)"

if ($whichcomputer -match $null)
{$whichcomputer="localhost"}

# Pingtest so to avoid throwing errors
$pingtest=Test-Connection -ComputerName $whichcomputer -Quiet -Count 2

if ($pingtest -match 'false')
   {Write-Host "`$whichcomputer is offline, or does not exist.`n"}

else
  {$remote_reg_data=Invoke-Command -ComputerName $whichcomputer{Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*}
  Write-Host "`nSoftware found on"$whichcomputer":"
  Write-Host "`n*******************************************"
  $remote_reg_data | select 'Displayname' | Sort-Object -Property Displayname
  }

