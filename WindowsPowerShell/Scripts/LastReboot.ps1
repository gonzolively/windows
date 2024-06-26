# -------------------------------------------------------------------------------------
# Script:   LastReboot.ps1 
# Author:   knox 
# Date:     02/28/2013 09:19:29 
# Comments: Finds when the last reboot time of a computer was
# -------------------------------------------------------------------------------------


$computername=Read-Host "`n Which computer do you want to check? (Press 'Enter' for this machine)"

if ($computername -match $null)
{$computername="localhost"}
$data= Get-WmiObject 'win32_operatingsystem' -ComputerName $computername

$raw_time=$data.LastBootUpTime

$lastboot= [Management.ManagementDateTimeConverter]::ToDateTime($raw_time)

Write-Host "`n`nLast Reboot Time for '$computername' was:                            " -NoNewline            
write-host "$lastboot" -Foregroundcolor Yellow
write-host "`n"

