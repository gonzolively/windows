$ErrorActionPreference = 'SilentlyContinue'
 
$time = Get-Date
$minutes = Read-Host "`nHow many minutes would you like to keep the computer active?"
$newtime = ($time.AddMinutes($minutes))
$newtimetostring =($time.AddMinutes($minutes)).ToString("HH:mm:ss")
$actioncolor = 'Red'
$timecolor = 'Yellow'
 
Function Lock-WorkStation {
$signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool LockWorkStation();
"@
$LockWorkStation = Add-Type -memberDefinition $signature -name"Win32LockWorkStation" -namespace Win32Functions -passthru
$LockWorkStation::LockWorkStation() | Out-Null
}
 
try {
$choice = Read-Host "`nWould you like to hibernate(h), sleep(s), lock (l), or power down (p) the computer afterwards, or neither (n)?"
 
Write-Host "`nCurrent time is " -NoNewline
Write-Host $time.ToString("HH:mm:ss") -ForegroundColor Yellow -NoNewline
 
switch ($choice) {
'n' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor Yellow -NoNewline
Write-Host "." -NoNewline
}
'h' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
Write-Host " and then " -NoNewline
Write-Host "hibernate." -ForegroundColor $actioncolor
}
's' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
Write-Host " and then " -NoNewline
Write-Host "sleep." -ForegroundColor $actioncolor
}
'l' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
Write-Host " and then " -NoNewline
Write-Host "lock/" -ForegroundColor $actioncolor
}
'p' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
Write-Host " and then " -NoNewline
Write-Host "power off." -ForegroundColor $actioncolor
}
}
 
$wshShell = New-Object -ComObject Wscript.Shell
for ($i = 0; $i -lt $minutes; $i++) {
    Start-Sleep -Seconds 60
    $wshShell.SendKeys("{SCROLLLOCK}")
}
 
switch ($choice) {
'l' { Lock-WorkStation }
's' {
powercfg.exe /hibernate off | Out-Null
&"$env:SystemRoot\System32\rundll32.exe"powrprof.dll,SetSuspendState Standby
}
'p' {
powercfg.exe /hibernate off | Out-Null
Stop-Computer -Force
}
'h' {
powercfg.exe /hibernate on | Out-Null
&"$env:SystemRoot\System32\rundll32.exe"powrprof.dll,SetSuspendState Hibernate
}
}
}
finally {
Write-Host "`n`nThe script has succesfully completed. Your computer will now resume it's normal operations, and lock per your domains' policy." -ForegroundColor Green
Read-Host "`nPress any key to exit"
}
