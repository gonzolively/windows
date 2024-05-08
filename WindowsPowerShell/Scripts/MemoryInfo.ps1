[Cmdletbinding()] 
Param( 
    [string]$Computername = "localhost" 
) 

cls 

$PysicalMemory = Get-WmiObject -class "win32_physicalmemory" -namespace "root\CIMV2" -ComputerName $Computername 
 
Write-Host "Installed Memory Modules:" -ForegroundColor Green 
$PysicalMemory | Format-Table Name,Bank,@{n="Capacity(GB)";e={$_.Capacity/1GB}},Manufacturer,PartNumber,Speed -AutoSize 
 
write-host "--------------------------------------------------------------------------------"

$UsedSlots = (($PysicalMemory) | Measure-Object).Count  
Write-Host "`nUsed Memory Slots:" -ForegroundColor Red
Write-Host $UsedSlots 

$available_slots=($TotalSlots - $UsedSlots)
Write-host "`nAvailble Memory Slots:" -Foregroundcolor yellow
write-host $available_slots

$TotalSlots = ((Get-WmiObject -Class "win32_PhysicalMemoryArray" -namespace "root\CIMV2" -ComputerName $Computername).MemoryDevices | Measure-Object -Sum).Sum 
Write-Host "`nTotal Memory Slots:" -ForegroundColor Green
Write-Host $TotalSlots 

Write-Host "`nTotal Memory:" -ForegroundColor Green
Write-Host "$((($PysicalMemory).Capacity | Measure-Object -Sum).Sum/1GB)GB`n" 
 
If($UsedSlots -eq $TotalSlots) 
{ 
    Write-Host "All memory slots are filled up, none is empty!" -ForegroundColor Yellow 
} 