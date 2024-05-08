# Misc options
Set-PSReadlineOption -BellStyle None                                                        #Disable bell

$host.UI.RawUI.BufferSize = (New-Object System.Management.Automation.Host.Size(250,9999))   #Set scrollback buffer

#Set home directory and path Powershell starts in
Remove-Variable -Force HOME
Set-Variable HOME C:\Users\Knox
Set-Location C:\Users\Knox

# Directories
Set-Variable DOWNLOADS C:\Users\Knox\downloads
Set-Variable DOCUMENTS C:\Users\Knox\documents
Set-Variable DESKTOP C:\Users\Knox\Desktop
Set-Variable REPOS C:\Users\Knox\Repos
Set-Variable TOOLS C:\tools

# Config Files location
Set-Variable VIMRC C:\tools\vim\_vimrc

# Alias'
Set-Alias -Name reboot -Value Restart-Computer
Set-Alias -Name touch -Value New-Item

####################### SNAPINS & MODULES ##########################################################
Import-Module posh-git

####################### CUSTOM FUNCTIONS #############################################################
function Disable-RealTimeMonitoring {
reg add  "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1
}

function ChocoUpgrade {
choco upgrade all -y --except="vim" --ignore-checksums
}

function which($command) {
(Get-Command $command).Path
}

function hist {
Get-Content (Get-PSReadlineOption).HistorySavePath
}

function symlink ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target -force
}

function Get-EnvironmentVariables() {
Get-ChildItem env:* | sort-object name
}

function GitDeleteBranch ($branch) {
$ErrorActionPreference = "SilentlyContinue"
git branch -d $branch
git push origin --delete $branch
}

# Get a list of all of the .NET assemblies available
function Get-NetTypes() {
$search=read-host "`nPlease Enter a search string"
$results=[AppDomain]::CurrentDomain.GetAssemblies() |  Foreach-Object { $_.GetTypes() | where-object {$_.FullName -match $search}}
$results | select Name,NameSpace | Sort-Object -Property Name
}

# use notepad++ instead of notepad
function notepad($file)
{
  if ($file -eq $null)
    {
        & 'C:\Program Files\Notepad++\notepad++.exe';
    }
    else
    {
        & 'C:\Program Files\Notepad++\notepad++.exe' $file;
    }
}

# Sleeps computer if powercfg /hibernate off; hibernates if powercfg /hibernate on
function Sleep-Computer {
    &"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Standby
}

# This function adds headers to each of my scripts
function Add-HeaderToScript { 
$header = @" 
# ----------------------------------------------------------------------------------
# Script:   $(split-path -Path $psISE.CurrentFile.FullPath -Leaf) 
# Author:   Knox Lively 
# Date:     $(Get-Date -Format "MMMM dd, yyyy")
# Comments: 
# ----------------------------------------------------------------------------------

"@ 
 $psise.CurrentFile.Editor.InsertText($header)
}

function Get-RandomPassword {
    param(
        $length = 14,
        $characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789!$%&?*@'
    )
    # select random characters
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    # output random pwd
    $private:ofs = ""
    [String]$characters[$random]
}

function Remote-PSS {
	$whichcomputer=read-host "Which computer would you like to connect to?"
	Enter-PSSession -computername $whichcomputer -credential 'CORP\sa-klively'
 }
  
  
function Reset-IseTab {
 $ErrorActionPreference = "silentlycontinue"
    Param(
        [switch]$SaveFiles,
        [ScriptBlock]$InvokeInNewTab
    )
 
    $Current = $psISE.CurrentPowerShellTab    
    $FileList = @()
            
    $Current.Files | ForEach-Object {        
        if ($SaveFiles -and (-not $_.IsSaved)) {
 
            Write-Verbose "Saving $($_.FullPath)"           
            try {
                	$_.Save()             
                	$FileList  += $_     
                } 
			catch [System.Management.Automation.MethodInvocationException] {
                	# Save will fail saying that you need to SaveAs because the 
                	# file doesn't have a path.
                	Write-Verbose "Saving $($_.FullPath) Failed"                           
            	}            
        }   
			elseif ($_.IsSaved) {            
            $FileList  += $_
        }
    }
                   
    $NewTab = $psISE.PowerShellTabs.Add() 
    $FileList | ForEach-Object { 
        $NewTab.Files.Add($_.FullPath) | Out-Null
        $Current.Files.Remove($_) 
    }
 
    # If a code block was to be sent to the new tab, add it here. 
    #  Think module loading or dot-sourcing something to put your environment
    # correct for the specific debug session.
    if ($InvokeInNewTab) {
         
        Write-Verbose "Will call this after the Tab Loads:`n $InvokeInNewTab"
         
        # Wait for the new tab to be ready to run more commands.
        While (-not $NewTab.CanInvoke) {
            Start-Sleep -Seconds 1
        }
 
        $NewTab.Invoke($InvokeInNewTab)
    }
 
    if ($Current.Files.Count -eq 0) {        
        #Only remove the tab if all of the files closed.
        $psISE.PowerShellTabs.Remove($Current)
    }
}

function Get-MovieLists {

  function Format-FileSize() {
      Param ([int64]$size)
      [string]::Format("{0:0.00}", $size/1GB)
  }

  $ip = Get-SmbConnection | Where-Object -Property ShareName -Match "Data" | foreach {$_.ServerName}
  $files = "\\$ip\Data\Movies"
  $fileCount = (Get-ChildItem $files | Measure-Object).Count
  $totalSize = [math]::Round((Get-Childitem $files | Measure-Object -Sum Length).Sum / 1GB,2)
  $avgSizePerFile = [math]::Round($totalSize/$fileCount, 2)

  # Write movie lists
  $moviesByName = "$DOWNLOADS\allMoviesByName.txt"
  Get-ChildItem $files | Select-Object Name, @{Name="Size(GB)";Expression={Format-FileSize($_.length)}} | Sort-Object -Property Name | Out-File $moviesByName
  Add-Content -path $moviesByName -value "-------------------------------------------------------------------"
  Add-Content -path $moviesByName -value "Average File Size                                             $avgSizePerFile"

  $moviesBySize = "$DOWNLOADS\allMoviesBySize.txt"
  Get-ChildItem $files | Select-Object Name, @{Name="Size(GB)";Expression={Format-FileSize($_.length)}} | Sort-Object { [float]$_."Size(GB)"} -Descending| Out-File $moviesBySize
  Add-Content -path $moviesBySize -value "------------------------------------------------------------------"
  Add-Content -path $moviesBySize -value "Average File Size                                            $avgSizePerFile"
}