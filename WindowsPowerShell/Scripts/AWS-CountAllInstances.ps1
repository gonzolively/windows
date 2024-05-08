# ------------------------------------------------------------------------
# Script:   AWS-CountAllInstances.ps1 
# Author:   klively 
# Date:     10/13/2014 17:47:32 
# Comments: This script mainly was built to showcase basic search functions
# in aws with powershell.
# ------------------------------------------------------------------------

$profile=Read-Host "Please enter a profile name to count"
($instances=Get-AWSRegion | % {Get-EC2Instance -ProfileName $profile -Region $_} | Measure-Object -Property ReservationId | Select-Object -ExpandProperty count)
Write-Host "`n There are " -NoNewline
Write-Host $instances -ForegroundColor Yellow -NoNewline
Write-Host " ec2 instances in " -NoNewline
Write-host $profile "`n" -ForegroundColor Magenta