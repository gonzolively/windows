# ------------------------------------------------------------------------
# Script:   ServerBackup.ps1 
# Author:   ad-klively 
# Date:     09/20/2013 11:30:34 
# Comments: This accompanied with a scheduled task will perform windows backups
# of the servers it runs on.
#
# Note:  The "Windows Server Backup Features" (commandline utilities as well)
# must be installed as a prerequisite
# ------------------------------------------------------------------------

# Windows Server Backup on NAS 
############# Costants #############
$mailServer = "mail.legend3d.com"
$mailFrom = "backupnotifications@legend3d.com"
$mailTo = "sa@legend3d.com"
$BackupDir = "\\l3d-nl\ServerBackups"

############# Backup #############
# add Windows Server Backup snap-in
if((get-pssnapin windows.serverbackup -ErrorAction SilentlyContinue) -eq $null)
 {add-pssnapin windows.serverbackup}

# create daily backup folder
$DayofWeek = (get-date).DayOfWeek.tostring().substring(0,3).tolower()
$BackupDir = "$BackupDir\$env:computername\$DayOfWeek"
if(!(test-path $BackupDir -pathtype container))
 {new-item $BackupDir -type directory -Force}

$policy = New-WBPolicy 
 
# add volumes
$volume = Get-WBVolume -AllVolumes
Add-WBVolume -Policy $policy -Volume $volume 

# system state and bare metal recovery 
Add-WBSystemState $policy 
Add-WBBareMetalRecovery $policy 
 
$backupLocation = New-WBBackupTarget -NetworkPath $BackupDir
Add-WBBackupTarget -Policy $policy -Target $backupLocation 
 
Set-WBVssBackupOptions -Policy $policy -VssFullBackup 

# execute backup 
Start-WBBackup -Policy $policy

############# Send email #############
$mailTitle = "Windows Server Backup for '$env:computername'"
$mailBody = get-wbjob -previous 1 | out-string

$mailClient = new-object Net.Mail.SmtpClient -arg $mailServer
$mailClient.Send($mailFrom, $mailTo, $mailTitle, $mailBody)