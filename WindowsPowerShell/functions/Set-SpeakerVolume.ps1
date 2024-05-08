# ----------------------------------------------------------------------------------
# Script:   Set-SpeakerVolume.ps1 
# Author:   klively 
# Date:     12/04/2014 15:28:18 
# Comments: This function was built to control speaker volume.
# ----------------------------------------------------------------------------------

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