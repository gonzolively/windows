# -------------------------------------------------------------------------------------
# Script:   ComputerCountByType.ps1 
# Author:   knox 
# Date:     02/28/2013 09:25:32 
# Comments: This script searches the WMI namespace "directory\ldap" for
# computers and then sorts them by OS and gives a count of each type and total
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
# Find all Win 2000 Machines
$allwin2000=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows 2000 Professional"
write-host "`n"
write-host "`nWin 2000 Machines Found: " -nonewline 
write-host $allwin2000.count -foregroundcolor yellow

# Find all Xp Machines
$allxp=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows XP Professional"
write-host "`nXP Machines Found: " -nonewline 
write-host $allxp.count -foregroundcolor yellow

# Find all Vista Business Machines
$vistabus=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows Vista™ Business"

# Find all Vista Enterprise Machines
$vistaent=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows Vista™ Enterprise"
$allvista=$vistabus+$vistaent
Write-Host "`nVista Machines Found: " -nonewline 
write-host $allvista.Count -foregroundcolor yellow

# Find all Windows 7 Enterprise machines
$win7enterprise=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows 7 Enterprise"

# Find all Windows 7 Professional Machines
$allwindows7=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows 7 Professional"

# Find all Win 7 Ultimate Machines
$allwin7ultimate=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows 7 Ultimate"

# Print total number of windows 7 machines
$allwindows7machines=$allwindows7+$allwin7ultimate+$win7enterprise
Write-Host "`nWindows 7 Machines found: " -nonewline 
write-host $allwindows7machines.Count -ForegroundColor Yellow

# Find all Windows 8 Machines
$win8=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows 8 Enterprise"
write-host "`nWindows 8 Machines Found: " -NoNewline 
write-host $win8.count -ForegroundColor Yellow

# Find all Mac OS X Machines
$mac=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Mac OS X"
write-host "`nMac OS X Machines Found: " -NoNewline 
write-host $mac.count -ForegroundColor Yellow

### Server List ###

# Find all Win 2003 Machines
$allwin2003=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows Server 2003"
write-host "`nWindows Server 2003 Machines Found: " -NoNewline 
write-host $allwin2003.count -ForegroundColor Yellow

# Find all win 2008 servers
# Find all Windows Server 2008 Standard machines
$2008std=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows Server® 2008 Standard"
# Find all Windows Server 2008 R2 Standard
$2008r2std=Get-WmiObject -namespace "root\directory\ldap" ads_computer | select ds_operatingsystem | Sort-Object ds_operatingsystem|
Out-String -Stream |Select-String "Windows Server 2008 R2 Standard"
$all2008=$2008std+$2008r2std
Write-Host "`nWindows Server 2008 Machines Found: " -NoNewline 
write-host $all2008.count -ForegroundColor Yellow
Write-Host "----------------------------------------"
$all=$all2008+$allwin2003+$mac+$win8+$allwindows7machines+$allvista+$allxp+$allwin2000
Write-Host "`Total Machines Found: " -NoNewline 
write-host $all.count -ForegroundColor Yellow
Write-host "`n"