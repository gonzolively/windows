# ------------------------------------------------------------------------
# Script:   FlushDNSCacheForSingleDomain.ps1 
# Author:   ad-klively 
# Date:     07/10/2013 16:20:06 
# Comments: This script flushes the DNS cache for a single user-specified domain
# ------------------------------------------------------------------------

$dc=Read-Host "`nDNS Server"
$url=Read-Host "`nDomain"
dnscmd $dc /NodeDelete ..Cache $url /tree /f