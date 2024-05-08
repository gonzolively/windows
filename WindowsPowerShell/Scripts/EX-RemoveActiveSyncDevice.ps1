# -------------------------------------------------------------------------------------
# Script:   RemoveActiveSyncDevice.ps1 
# Author:   ad-klively 
# Date:     05/06/2013 10:21:59 
# Comments: This script removes device from ActiveSync for a user specified
# mailbox.
# -------------------------------------------------------------------------------------

$whichuser=read-host "`nWhich user would you like to get info for?"
$devices=get-ActiveSyncDevice -Mailbox $whichuser| select deviceuseragent,deviceid
Write-Host "`n Here are the available devices for $whichuser" 
$devices
$whichdevice=Read-Host "`nWhich device would you like to remove? (DeviceId)"
Remove-ActiveSyncDevice -Identity $(Get-ActiveSyncDevice -Mailbox $whichuser | where {$_.DeviceId -like $whichdevice} | select Identity).identity
