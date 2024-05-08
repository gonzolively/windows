# ------------------------------------------------------------------------
# Script:   PingTest(IpRange).ps1 
# Author:   ad-klively 
# Date:     08/05/2013 12:54:02 
# Comments: This script will ping all hosts on a user-specified sub-net
# ------------------------------------------------------------------------

$ip_block=Read-Host "`nPlease enter the first 3 octets of ip-block you would like to ping in the form x.x.x.* leaving the last octet blank)"
foreach ($i in 1..254) {Test-Connection -Count 1 $ip_block$i}
