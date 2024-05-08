# -------------------------------------------------------------------------------------
# Script:   DisplaySettings.ps1 
# Author:   knox 
# Date:     04/18/2013 13:39:09 
# Comments: This script gets detailed information about video cards, displays, 
# and anything related to graphics setting,s # of montiors, type, and resolution
# -------------------------------------------------------------------------------------

# Gather computer name
$whichcomputer=Read-Host "`n Which computer do you want to check? ('localhost' for this machine)"

#if ($whichcomputer -match $null)
#{$whichcomputer=$hostname}


# Pingtest so to avoid throwing errors
$pingtest=Test-Connection -ComputerName $whichcomputer -Quiet -Count 2



if ($pingtest -match 'false')
   {Write-Host "`n $whichcomputer is offline, or does not exist.`n"}

else
{

$video_controller_data=Get-WmiObject -ComputerName $whichcomputer -Class 'win32_videocontroller'
$video_controller_resolution=gwmi -ComputerName $whichcomputer -Class 'CIM_VideoControllerResolution'
$video_controller_resolution_horizontal=$video_controller_resolution.horizontalresolution | Measure-Object -Maximum
$video_controller_resolution_veritcal=$video_controller_resolution.verticalresolution | Measure-Object -Maximum
$monitor_info=get-wmiobject -class 'win32_desktopmonitor'
$ram=[math]::Round($video_controller_data.AdapterRam /1024/1024,2) 
$ram_pretty="{0:N0}" -f $ram


Write-Host `n
Write-Host " Video Card Information for $whichcomputer"
Write-Host '********************************************************'
Write-Host " Video Controller         :" $video_controller_data.name
Write-Host " Video Processor          :" $video_controller_data.videoprocessor
Write-Host "--------------------------------------------------------"
Write-host " Max Resolution           :" $video_controller_resolution_horizontal.Maximum "X" $video_controller_resolution_veritcal.maximum
Write-Host " Current Resolution       :" $video_controller_data.CurrentHorizontalResolution "X" $video_controller_data.CurrentVerticalResolution
write-host " Max Refresh Rate         :" $video_controller_data.MaxRefreshRate "Hz"
Write-Host " Current Refresh Rate     :" $video_controller_data.CurrentRefreshRate "Hz"
#write-host " Min Refresh Rate         :" $video_controller_data.MinRefreshRate "Hz"
write-host " Bits Per Pixel           :" $video_controller_data.CurrentBitsPerPixel
write-host " Driver Version           :"$video_controller_data.driverversion
write-host " RAM                      :"$ram_pretty -NoNewline
write-host " Mb "
#write-host " Installed Drivers        :" $video_controller_data.InstalledDisplayDrivers
Write-Host '********************************************************'
Write-Host `n
Write-Host " Monitor Information for $whichcomputer"
Write-Host '********************************************************'
Write-Host " Manufacturer             :"$monitor_info.monitormanufacturer
Write-Host " Model                    :"$monitor_info.caption
Write-Host `n
}
