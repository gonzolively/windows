# ----------------------------------------------------------------------------------
# Script:   TotallyWorking.ps1 
# Author:   klively 
# Date:     10/28/2014 17:12:14 
# Comments: This script keeps a computer from locking by sending keystrokes in the
# background.  After keeping awake for N minutes the computer will then lock itself.
# ----------------------------------------------------------------------------------

Import-Module AWSPowerShell
$ErrorActionPreference = 'SilentlyContinue'
$time=Get-Date
$DomainLockoutTimeInMinutes=15
$minutes=Read-Host "`nHow many minutes would you like to keep the computer active?"
$newtime=($time.AddMinutes($minutes))
$autolocktime=($newtime.AddMinutes($DomainLockoutTimeInMinutes)).ToString("HH:mm:ss")
$newtimetostring=($time.AddMinutes($minutes)).ToString("HH:mm:ss")
[string]$actioncolor= 'Red'
[string]$timecolor= 'Yellow'
$scriptname = $MyInvocation.MyCommand.Name

 Function Set-SpeakerVolume {

 param (
 [Parameter(Mandatory=$true)]
 [ValidateSet('Up','Down')]
 [string]$Direction,
 [Parameter(Mandatory=$true)]
 [ValidateSet('10','20','30','40','50','60','70','80','90')]
 [int]$Amt
 )

  $wshShell = new-object -com wscript.shell

  if ($Direction -match 'Up')
  { while ($i -le $Amt/2){ $i++;
  $wshShell.SendKeys([char]175)
  }
  }
  
  if ($direction -match 'Down') 
  { while ($i -le $Amt/2){$i++;
  $wshShell.SendKeys([char]174)
  }
  }
}


Function Lock-WorkStation {
$signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool LockWorkStation();
"@
$LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru
$LockWorkStation::LockWorkStation() | Out-Null
}

try 
{
$choice=Read-Host "`nWould you like to hibernate(h), sleep(s), lock (l), or power down (p) the computer afterwards, or neither (n)?  (h/s/l/n/p)"

If ($choice -eq 'n'){
Write-host "`nCurrent time is " -nonewline
Write-Host $time.ToSTring("HH:mm:ss") -ForegroundColor Yellow -nonewline
$autolocktime=($newtime.AddMinutes($DomainLockoutTimeInMinutes)).ToString("HH:mm:ss")
Write-host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor Yellow -nonewline
write-host " and " -NoNewline 
write-host "autolock" -NoNewline -ForegroundColor $actioncolor
write-host " at " -nonewline 
write-host $autolocktime -foregroundColor $timecolor -NoNewline
write-host " (Per domain policy)`n"
}

elseIf ($choice -eq 'h'){

Write-host "`nCurrent time is " -nonewline
Write-Host $time.ToSTring("HH:mm:ss") -ForegroundColor Yellow -nonewline
$autolocktime=($newtime.AddMinutes($DomainLockoutTimeInMinutes)).ToString("HH:mm:ss")
Write-host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
write-host " and then " -NoNewline
write-host "hibernate" -ForegroundColor $actioncolor
}

elseIf ($choice -eq 's'){
Write-host "`nCurrent time is " -nonewline
Write-Host $time.ToSTring("HH:mm:ss") -ForegroundColor Yellow -nonewline
$autolocktime=($newtime.AddMinutes($DomainLockoutTimeInMinutes)).ToString("HH:mm:ss")
Write-host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
write-host " and then " -NoNewline
write-host "sleep" -ForegroundColor $actioncolor
}

elseIf ($choice -eq 'l'){
Write-host "`nCurrent time is " -nonewline
Write-Host $time.ToSTring("HH:mm:ss") -ForegroundColor Yellow -nonewline
$autolocktime=($newtime.AddMinutes($DomainLockoutTimeInMinutes)).ToString("HH:mm:ss")
Write-host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
write-host " and then " -NoNewline
write-host "lock" -ForegroundColor $actioncolor
}

elseIf ($choice -eq 'p'){
Write-host "`nCurrent time is " -nonewline
Write-Host $time.ToSTring("HH:mm:ss") -ForegroundColor Yellow -nonewline
$autolocktime=($newtime.AddMinutes($DomainLockoutTimeInMinutes)).ToString("HH:mm:ss")
Write-host ", your computer will stay active until " -NoNewline
Write-Host $newtimetostring -ForegroundColor $timecolor -NoNewline
write-host " and then " -NoNewline
write-host "power off" -ForegroundColor $actioncolor
}

$myshell = New-Object -com "Wscript.Shell"
Set-SpeakerVolume -Direction Up -Amt 50

for ($i = 0; $i -lt $minutes; $i++) {

  if ($minutes - $i -eq 10){
 # Send Alert
 $smtpServer = "mail.crossview.inc"
 $msg = new-object System.Net.Mail.MailMessage
 $msg.From = "$scriptname@$env:COMPUTERNAME.com"
 $msg.To.Add("9365468667@txt.att.net")
 $msg.Subject = "Alert:  "
 $msg.Body = "`n10 minutes or less until the computer resumes, and 25 minutes until it locks."
 $smtpClient = new-object Net.Mail.SmtpClient($smtpServer)
 $smtpClient.Send($msg)
  }

 else{
 Start-Sleep -Seconds 60
 $myshell.sendkeys(".")
 }
}


If ($choice -match 'l'){
Lock-WorkStation
}

If ($choice -match 's')
{
powercfg.exe /hibernate off | Out-Null
Set-SpeakerVolume -Direction Down -Amt 50
&"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Standby
}

If ($choice -match 'p')
{
powercfg.exe /hibernate off | Out-Null
Stop-Computer -Force
}

If ($choice -match 'h')
{
powercfg.exe /hibernate on | Out-Null
Set-SpeakerVolume -Direction Down -Amt 50
&"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Hibernate
}

If ($choice -match 'n'){
}
}


finally {
Set-SpeakerVolume -Direction Down -Amt 50
}
