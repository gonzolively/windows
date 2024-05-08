# ------------------------------------------------------------------------
# Script:   Ex-DeleteExportedMailboxes.ps1 
# Author:   ad-klively 
# Date:     12/06/2013 12:50:39 
# Comments: This script is meant to run after "AD-CopyAndRemoveOldMailboxes.ps1"
# and only after it has completed.  This script will check and see if any
# of the disabled users in the user specified OU have a pst file on the storage
# share, if they do, then it will remove their mailbox from exchange.
# ------------------------------------------------------------------------

$backup_path="\\exchange\Backup"

Get-Mailuser StupidExchangeBug -erroraction SilentlyContinue
Get-ADUser -Filter * -SearchBase "OU=Users,OU=Disabled,DC=LFILMS,DC=NET" | Select-Object -Property samaccountname | ForEach-Object {
if (Test-path $backup_path\$($_.samaccountname).pst)
{remove-mailbox -identity $_.samaccountname -whatif }
else 
{Write-Host "`n File NOT found for" $_.samaccountname}
}

# ForEach-Object {New-MailboxExportRequest -Mailbox $_.samaccountname -FilePath "$backup_path\$($_.samaccountname).pst" -verbose}