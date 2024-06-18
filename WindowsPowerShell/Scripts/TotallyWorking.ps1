# ----------------------------------------------------------------------------------
# Script:   TotallyWorking.ps1 
# Author:   klively 
# Date:     10/28/2014 17:12:14 
# Comments: This script keeps a computer from locking by sending keystrokes in the
# background.  After keeping awake for N minutes the computer will then lock itself.
# ----------------------------------------------------------------------------------

$ErrorActionPreference = 'SilentlyContinue'
$time = Get-Date
$minutes = Read-Host "`nHow many minutes would you like to keep the computer active?"
$newtime = ($time.AddMinutes($minutes))
$newtimetostring =($time.AddMinutes($minutes)).ToString("HH:mm:ss")
$actioncolor = 'Red'
$timecolor = 'Yellow'

# Figure out what to do with these later, specifically get domain lockout time with powershell
$DomainLockoutTimeInMinutes = 15
$textWarningMinutes = 10

Function Lock-WorkStation {
$signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool LockWorkStation();
"@
$LockWorkStation = Add-Type -memberDefinition $signature -name"Win32LockWorkStation" -namespace Win32Functions -passthru
$LockWorkStation::LockWorkStation() | Out-Null
}

Function Set-SpeakerVolume {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Up', 'Down')]
        [string]$Direction,
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 100)]
        [int]$Amt
    )

    $wshShell = New-Object -ComObject Wscript.Shell
    1..($Amt / 2) | ForEach-Object {
        if ($Direction -eq 'Up') {
            $wshShell.SendKeys([char]175)
        }
        else {
            $wshShell.SendKeys([char]174)
        }
    }
}

### Program Begins
try {
$currentVolume = (Get-AudioDevice -PlaybackVolume).Volume
Set-SpeakerVolume -Direction Up -Amt 100

$choice = Read-Host "`nWould you like to hibernate(h), sleep(s), lock (l), or power down (p) the computer afterwards, or neither (n)?"
Write-Host "`nCurrent time is " -NoNewline
Write-Host $time.ToString("HH:mm:ss") -ForegroundColor Yellow -NoNewline

switch ($choice) {
'n' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor Yellow -NoNewline
Write-Host "." -NoNewline
$actionMessage = "automatically locks (per domain policy)"
}
'h' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
Write-Host " and then " -NoNewline
Write-Host "hibernates." -ForegroundColor $actioncolor
$actionMessage = "hibernates"
}
's' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
Write-Host " and then " -NoNewline
Write-Host "sleeps." -ForegroundColor $actioncolor
$actionMessage = "sleeps"
}
'l' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
Write-Host " and then " -NoNewline
Write-Host "locks." -ForegroundColor $actioncolor
$actionMessage = "locks"
}
'p' {
Write-Host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
Write-Host " and then " -NoNewline
Write-Host "power off." -ForegroundColor $actioncolor
$actionMessage = 'powers off'
}
}

# Send text message to alert user that their computer will resume normal functionality
Function Send-TextMessage {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $accountSid = "YOUR_TWILIO_ACCOUNT_SID"
    $authToken = "YOUR_TWILIO_AUTH_TOKEN"
    $fromNumber = "9365468667"
    $toNumber = "9365468667"

    $twilioUrl = "https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json"

    $twilioBody = @{
        From = $fromNumber
        To   = $toNumber
        Body = $Message
    }

    Invoke-RestMethod -Method Post -Uri $twilioUrl -Body $twilioBody -Authentication Basic -Credential (New-Object System.Management.Automation.PSCredential ($accountSid, (ConvertTo-SecureString $authToken -AsPlainText -Force)))
}

# Will rework this in the future
#$wshShell = New-Object -ComObject Wscript.Shell
#for ($i = 0; $i -lt $minutes; $i++) {
#    if ($minutes - $i -eq $textWarningMinutes) {
#        # Send text message alert
#        $totalTimeUntilAction = $textWarningMinutes + $DomainLockoutTimeInMinutes
#        $message = "`n$textWarningMinutes minutes or less until the computer resumes, and $totalTimeUntilAction minutes until it $actionMessage."
#        Send-TextMessage -Message $message
#    }
#    else {
#        Start-Sleep -Seconds 60
#        $wshShell.SendKeys("{SCROLLLOCK}")
#    }
#}

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
    Set-AudioDevice -PlaybackVolume $currentVolume
    Write-Host "`n`nThe script has succesfully completed. Your computer will now resume it's normal operations, and lock per your domains' policy." -ForegroundColor Green
    Read-Host "`nPress any key to exit"
}
