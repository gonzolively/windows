# -------------------------------------------------------------------------------------
# Script:   Temperature.ps1 
# Author:   knox 
# Date:     04/18/2013 13:47:34 
# Comments:  Gets the temperature of the CPU, GPU, and Battery from HP Laptops...yeah that part kind of sucks
# -------------------------------------------------------------------------------------
$whichcomputer=Read-Host "`n Which computer do you want to check? (Press 'Enter' for this machine)"

if ($whichcomputer -match $null)
{$whichcomputer="localhost"}

# Pingtest so to avoid throwing errors
$pingtest=Test-Connection -ComputerName $whichcomputer -Quiet -Count 2

if ($pingtest -match 'false')# ------------------------------------------------------------------------

   {Write-Host "`n $whichcomputer is offline, or does not exist.`n"}
  
else {
# CPU TEMP
$cpu_temp_data=(Get-WmiObject -Namespace 'root\wmi'-computer $whichcomputer -Class 'msacpi_thermalZoneTemperature' |
Where-Object {$_.instancename -match "ACPI\\ThermalZone\\CPUZ_0"})
$cpu_temperature=(-1)*($cpu_temp_data.CurrentTemperature/10-273.15*9/5+32)
# GPU TEMP
$gpu_temp_data=(Get-WmiObject -Namespace 'root\wmi'-computer $whichcomputer -Class 'msacpi_thermalZoneTemperature' |
Where-Object {$_.instancename -match "ACPI\\ThermalZone\\GFXZ_0"})
$gpu_temperature=(-1)*($gpu_temp_data.CurrentTemperature/10-273.15*9/5+32)
# BATTERY TEMP
$bat_temp_data=(Get-WmiObject -Namespace 'root\wmi'-computer $whichcomputer -Class 'msacpi_thermalZoneTemperature' |
Where-Object {$_.instancename -match "ACPI\\ThermalZone\\BATZ_0"})
$bat_temperature=(-1)*($bat_temp_data.CurrentTemperature/10-273.15*9/5+32)

Write-Host `n
Write-Host ' ****************************************'
write-host "`  Temperature Data for $whichcomputer"
write-host " ----------------------------------------"
write-host "    CPU     : $cpu_temperature  degrees farenheit"
write-host "    GPU     : $gpu_temperature  degrees farenheit"
write-host "    Battery : $bat_temperature  degrees farenheit"
Write-Host ' ****************************************'
write-host `n
}
