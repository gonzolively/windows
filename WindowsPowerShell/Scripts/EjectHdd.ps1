$drive_letter = Read-Host "`nWhat is the drive letter of the disk you'd like to eject?"
$vol = get-wmiobject -Class Win32_Volume | where{$_.Name -eq $drive_letter + ':\'}  
$vol.DriveLetter = $null  
$vol.Put()
$vol.Dismount($false, $false)