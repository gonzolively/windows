# ----------------------------------------------------------------------------------
# Script:   Lock-Workstation.ps1 
# Author:   klively 
# Date:     12/04/2014 16:08:26 
# Comments: This function locks a workstation
# ----------------------------------------------------------------------------------

Function Lock-WorkStation {
$signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool LockWorkStation();
"@
$LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru
$LockWorkStation::LockWorkStation() | Out-Null
}