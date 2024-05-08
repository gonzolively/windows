# ------------------------------------------------------------------------
# Script:   AD-CopyAndRemoveOldMailboxes.ps1 
# Author:   ad-klively 
# Date:     12/04/2013 17:15:45 
# Comments: This script will search though a specific OU and find 
# ------------------------------------------------------------------------

Import-Module ActiveDirectory
$backup_path="\\exchange\Backup"
Get-ADUser -Filter * -SearchBase "OU=Users,OU=Disabled,DC=LFILMS,DC=NET" -Properties mail |
Where-Object {$_.mail -ne $null} |
ForEach-Object {New-MailboxExportRequest -Mailbox $_.samaccountname -FilePath "$backup_path\$($_.samaccountname).pst" -verbose}