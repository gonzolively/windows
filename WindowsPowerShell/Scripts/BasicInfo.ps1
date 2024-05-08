# -------------------------------------------------------------------------------------
# Script:   BasicInfo.ps1 
# Author:   knox 
# Date:     04/09/2013 14:42:07 
# Comments: This script queries WMI and gets 'basic info' about a machine
# -------------------------------------------------------------------------------------

#Query for computer name
$whichcomputer=Read-Host "`nWhich computer do you want to check? (Hit 'Enter' for localhost.)"

if ($whichcomputer -match $null) { 
  $whichcomputer="localhost"}

# Pingtest so to avoid throwing errors
$pingtest=Test-Connection -ComputerName $whichcomputer -Quiet -Count 2

if ($pingtest -match 'false')
   {Write-Host "`n$whichcomputer is offline, or does not exist.`n"}

else
  {
#Gather Hardware/Software Details
$computersystem=Get-WmiObject -Class 'win32_computersystem' -ComputerName $whichcomputer
$memory=[math]::Round($computersystem.totalphysicalmemory/1024/1024/1024,2)
$disk=Get-WmiObject 'win32_logicaldisk' -ComputerName $whichcomputer -Filter "name like 'c:'"
$diskfree=[math]::Round($disk.freespace/1024/1024/1024,2)
$disksize=[math]::Round($disk.size/1024/1024/1024,2)
$diskused=[math]::Round($disksize-$diskfree,2)
$processor=Get-WmiObject -Class 'cim_processor' -ComputerName $whichcomputer
$os=Get-WmiObject -Class 'win32_operatingsystem' -ComputerName $whichcomputer
$biosdata=Get-WmiObject -Namespace 'root\cimv2' -Class 'win32_bios' -ComputerName $whichcomputer
$ip= Test-Connection -ComputerName $whichcomputer -Count 1

# UPTIME
$wmi = Get-WmiObject -ComputerName $whichcomputer -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem"
$now = Get-Date
$boottime = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
$uptime = $now - $boottime
$d=$uptime.days
$h=$uptime.hours
$m=$uptime.Minutes
$s=$uptime.Seconds
$Uptime = "$d Days,$h Hours,$m Min,$s Sec"

# Gather IP address
#$IP=(([System.Net.Dns]::GetHostAddresses($whichcomputer)| findstr [0-9].\.)[0]).Split()[-1] 

#Formatting
Write-Host `n
Write-Host ' *******************************************************************************'
write-host ' IP               :'$ip.IPV4Address
write-host ' Hostname         :'$computersystem.name  
write-host ' Current User     :'$computersystem.UserName                                                
write-host ' Owner            :'$computersystem.primaryownername                               
write-host ' Domain           :'$computersystem.domain                                         
write-host ' Uptime           :'$uptime                                                       
# Add "member of groups in AD" (in domain) when you get time please, ok, thanks, I will        
Write-Host '--------------------------------------------------------------------------------'
Write-Host ' Manufacturer     :'$computersystem.manufacturer
Write-Host ' Model            :'$computersystem.model
Write-Host ' Serial Number    :'$biosdata.SerialNumber
Write-Host ' Bios Information :'$biosdata.name
write-host ' Operating System :'$os.caption"("$os.OSArchitecture")"
Write-Host ' CPU              :'$processor.name"("$processor.numberoflogicalprocessors Core ")"
write-host ' Memory           :'$memory 'Gb'
Write-host ' Disk (C:\)'
write-host '     Size         :'$disksize 'Gb'
write-host '     Used         :'$diskused 'Gb'
write-host '     Free         :'$diskfree 'Gb'
#Write-Host ' Printers:        :'$printer

Write-Host ' *******************************************************************************'
Write-host `n
}
