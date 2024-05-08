# -------------------------------------------------------------------------------------
# Script:   BatteryHealthChecker.ps1 
# Author:   knox 
# Date:     02/28/2013 09:28:07 Date:     3/28/2013 09:28:07 Comments: This script checks the capacity of a battery (not charge)
# and contains some basic error checking.
# -------------------------------------------------------------------------------------

$whichcomputer=Read-Host "`n Which computer do you want to check? (Press 'Enter' for this machine)"

if ($whichcomputer -match $null)
{$whichcomputer="localhost"}

$pingtest=Test-Connection -ComputerName $whichcomputer -Quiet -Count 2

if ($pingtest -match 'false'){
   Write-Host "`n$whichcomputer is offline, or does not exist.`n"
   }
  else
     {
  if ($myerr -match 'Invalid class')
     { 
      write-Host "`n$whichcomputer does not have a battery.`n"
     }
  else
     {
  if ($myerr -match 'The RPC server is')
      {
      write-Host "`n$whichcomputer is not configured for remote powershell queries, or is not running Windows.`n"
      }
  else
     {
   if ($myerr -match 'Call was canceled by')
      {
      write-Host "`n$whichcomputer is not configured for remote powershell queries, or is not running Windows.`n"
      }
   else
   {
    if ($myerr -match 'Access denied')
      {
       Write-Host "`nAccess denied: You do not have permission to query wmi from this account.`n"
       }      
else 
{
if ($pingtest -eq 'true') {
    #Uncomment statements below in case of needing to elevate privaledges/using a different username to query remote wmi-objects
    #$creds=Get-Credential -Credential spice\administrator
    $fullchargedcapacity=Get-WmiObject 'batteryfullchargedcapacity' -Namespace 'root\wmi' -ComputerName $whichcomputer #-Credential $creds
    $designedcapacity=Get-WmiObject 'batterystaticdata' -Namespace 'root\wmi' -ComputerName $whichcomputer #-Credential $creds
    [decimal]$health=[math]::Round((($fullchargedcapacity.FullChargedCapacity/$designedcapacity.DesignedCapacity)*100),2)
      
    Write-Host "`nBattery health: $health%`n" 
                  }      
               }
            }
         }
      }
}