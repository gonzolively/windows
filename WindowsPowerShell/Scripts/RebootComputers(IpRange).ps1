# -------------------------------------------------------------------------------------
# Script:   RebootComputers(IpRange).ps1 
# Author:   ad-klively 
# Date:     05/07/2013 09:16:26 
# Comments: This script will reboot computers within an IP block
# BE VERY CAREFUL!!!!!!!
# -------------------------------------------------------------------------------------

$ip_block=Read-Host "`nPlease enter the first 3 octets of ip-block you would like to restart in the form x.x.x.* leaving the last octet blank)"
foreach ($i in 1..254) {Restart-Computer $ip_block$i -Force}
