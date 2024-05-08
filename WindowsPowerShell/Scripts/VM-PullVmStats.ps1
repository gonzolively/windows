# ----------------------------------------------------------------------------------
# Script:   VM-PullVmStats.ps1 
# Author:   klively 
# Date:     06/12/2015 13:35:31 
# Comments: This script connects to our local vcenter cluster and pulls basic data about
# all vms and exports it to a csv file, which is then published to our wiki.
# ----------------------------------------------------------------------------------

# Host utilization

# FOR TESTING PURPOSES ONLY
Remove-Item .\reports\vcenter_data_$date.csv -ErrorAction SilentlyContinue

# add snappin and make vcenter connection
$ErrorActionPreference = "silentlycontinue"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer -Server vcenter.crossview.inc -User klively -Password 24AJaxeVU6! | Out-Null

# Grab all vm's and set date variable

$date = get-date -uFormat "%m-%d-%Y"

# create csv
New-Item -Path .\reports\ -name vcenter_data_$date.csv -ItemType "file"


# iterate through each vm and gather data
foreach ($v in $vm){
$vm_host = $v.Host | Select-Object -Property name -ExpandProperty name
$name = $v.name
$id = $v.id
$ip = $v.Guest | Select-Object -Property ipaddress -ExpandProperty ipaddress | ?{$_ -notmatch 'fe'} | Select-Object -First 1
$disk_space = [math]::Round($v.UsedSpaceGB,2)
$powerstate = $v.powerstate
$memory = $v.memoryGB
$cpu = $v.numcpu
$Uptime = $v | Get-Stat -Stat sys.uptime.latest -MaxSamples 1 -Realtime |
select Entity, Value, Unit -ErrorAction SilentlyContinue | Select-Object -Property value -ExpandProperty value | % {[math]::Round($_ /60/60/24,2)}


# create table
$table = New-Object -TypeName psobject
$table | Add-Member -MemberType NoteProperty -Name "Host" -Value $vm_host
$table | Add-Member -MemberType NoteProperty -Name "Name" -Value $name
$table | Add-Member -MemberType NoteProperty -Name "Id" -Value $id
$table | Add-Member -MemberType NoteProperty -Name "IP Address" -Value $ip
$table | Add-Member -MemberType NoteProperty -Name "Disk Space Used (Gb)" -Value $disk_space
$table | Add-Member -MemberType NoteProperty -Name "Powerstate" -Value $powerstate
$table | Add-Member -MemberType NoteProperty -Name "Memory (Gb)" -Value $Memory
$table | Add-Member -MemberType NoteProperty -Name "CPU" -Value $cpu
$table | Add-Member -MemberType NoteProperty -Name "Uptime (Days)" -Value $Uptime

# Export each table to csv
$table | Select-Object -Property 'Host','Name','Id','IP Address','Disk Space Used (Gb)','Powerstate','Memory (Gb)','CPU', 'Uptime (Days)' | 
Export-Csv .\reports\vcenter_data_$date.csv -NoTypeInformation -Append
}