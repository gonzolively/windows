# -------------------------------------------------------------------------------------
# Script:   uptime.ps1 
# Author:   knox 
# Date:     03/06/2013 17:25:20 
# Comments: Finds the the uptime of a machine
# -------------------------------------------------------------------------------------
$whichcomputer=Read-Host "`n Which computer do you want to check? (Press 'Enter' for this machine)"
if ($whichcomputer -match $null)
{$whichcomputer="localhost"}
$wmi = Get-WmiObject -ComputerName $whichcomputer -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem"
$now = Get-Date
$boottime = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
$uptime = $now - $boottime
$d=$uptime.days
$h=$uptime.hours
$m=$uptime.Minutes
$s=$uptime.Seconds

$Uptime = "$d Days $h Hours $m Min $s Sec"
Write-Host `n$whichcomputer "has been up for:                               " -NoNewline
write-host $uptime`n -ForegroundColor Yellow
