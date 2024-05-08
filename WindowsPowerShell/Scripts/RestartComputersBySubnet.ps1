# ------------------------------------------------------------------------
# Script:   RestartComputersBySubnet.ps1 
# Author:   ad-klively 
# Date:     08/01/2013 15:54:03 
# Comments: This script reboots all computers within a user specified 
# subdomain. It goes without saying that you should be very careful with
# this script, especially with the "-force" parameter.
# ------------------------------------------------------------------------


$ip_block=Read-Host "`nPlease enter the first 3 octets of ip-block you would like to reboot in the form x.x.x.* leaving the last octet blank)"
foreach ($i in 1..254) {Restart-Computer -ComputerName $ip_block$i -Force}
