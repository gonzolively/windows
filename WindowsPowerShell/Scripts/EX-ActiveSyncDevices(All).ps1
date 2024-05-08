# -------------------------------------------------------------------------------------
# Script:   EX-ActiveSyncDevices(All).ps1 
# Author:   ad-klively 
# Date:     06/25/2013 18:27:16 
# Comments: This script lists all ActiveSync Devices found on a domain, it is made to be
# ran in the exchange console
# -------------------------------------------------------------------------------------

$devices_on_network=Get-ActiveSyncDevice | select -Property devicetype,deviceuseragent,deviceid |
Sort-Object -Property Devicetype
$devices_on_network
write-host " `n----------------------------------"
write-host "There are"$devices_on_network.count"ActiveSync enabled devices on this Exchange Server`n"
