###############################################
# Core Host / Profile Settings
###############################################

# Disable the bell
Set-PSReadlineOption -BellStyle None

# Console buffer (clamped to host limits)
$rawUI         = $Host.UI.RawUI
$desiredWidth  = 120
$desiredHeight = 3000

$maxSize   = $rawUI.MaxPhysicalWindowSize
$current   = $rawUI.BufferSize

$bufferWidth  = [Math]::Min($desiredWidth,  [int]$maxSize.Width)
$bufferHeight = [Math]::Min($desiredHeight, [int]$maxSize.Height)

if ($bufferWidth -gt 0 -and $bufferHeight -gt 0 -and
    ($bufferWidth -ne $current.Width -or $bufferHeight -ne $current.Height)) {

    try {
        $rawUI.BufferSize = New-Object System.Management.Automation.Host.Size($bufferWidth, $bufferHeight)
    }
    catch {
        Write-Verbose "Could not set buffer size to ${bufferWidth}x${bufferHeight}: $($_.Exception.Message)"
    }
}

# Start in home directory
Set-Location $HOME

# Editor / config paths
$global:VIMRC = 'C:\tools\vim\_vimrc'

###############################################
# Modules
###############################################
$modules = @('posh-git', 'Terminal-Icons')

foreach ($module in $modules) {
    if (Get-Module -ListAvailable -Name $module) {
        Import-Module $module -ErrorAction SilentlyContinue
    }
    else {
        Write-Verbose "Module '$module' not found. Install with: Install-Module $module -Scope CurrentUser"
    }
}

###############################################
# Aliases (Alphabetical)
###############################################
Set-Alias reboot Restart-Computer
Set-Alias touch  New-Item

###############################################
# Directory / Navigation Helpers (Alphabetical)
###############################################
function desktop   { Set-Location "$HOME\Desktop" }
function documents { Set-Location "$HOME\Documents" }
function downloads { Set-Location "$HOME\Downloads" }
function home      { Set-Location $HOME }
function repos     { Set-Location "$HOME\Repos" }
function scripts   { Set-Location "$HOME\Repos\windows\WindowsPowerShell\Scripts" }
function tools     { Set-Location 'C:\tools' }

###############################################
# Git Helpers (Alphabetical)
###############################################
function GitDeleteBranch {
    param([Parameter(Mandatory)][string]$Branch)
    $ErrorActionPreference = 'SilentlyContinue'
    git branch -d $Branch
    git push origin --delete $Branch
}

###############################################
# Linux-like Helpers (Alphabetical)
###############################################
function df       { Get-Volume }

function grep {
    param([string]$Regex,[string]$Dir)
    if ($Dir) { Get-ChildItem $Dir | Select-String $Regex }
    else      { $input | Select-String $Regex }
}

function symlink  { param([string]$Target,[string]$Link); New-Item -Path $Link -ItemType SymbolicLink -Value $Target -Force }

function tail     { param([string]$Path,[int]$n=10); Get-Content $Path -Tail $n }

function which    { param([string]$Command); (Get-Command $Command).Path }

###############################################
# Network Utilities (Alphabetical)
###############################################
function flushdns { Clear-DnsClientCache }

function Get-PubIP {
    try {
        (Invoke-WebRequest 'https://ifconfig.me/ip' -UseBasicParsing -TimeoutSec 5).Content.Trim()
    }
    catch {
        Write-Warning "Unable to retrieve public IP: $($_.Exception.Message)"
    }
}

###############################################
# Package Management (Alphabetical)
###############################################
function ChocoUpgrade { choco upgrade all -y --except="vim" --ignore-checksums }

###############################################
# System Utilities (Alphabetical)
###############################################
function Add-HeaderToScript {
    if (-not $psISE) {
        Write-Warning "This function only works inside the PowerShell ISE."
        return
    }

    $header = @"
# ----------------------------------------------------------------------------------
# Script:   $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf)
# Author:   Knox Lively
# Date:     $(Get-Date -Format "MMMM dd, yyyy")
# Comments:
# ----------------------------------------------------------------------------------

"@
    $psise.CurrentFile.Editor.InsertText($header)
}

function Get-EnvironmentVariables { Get-ChildItem Env:* | Sort-Object Name }

function Get-NetTypes {
    $search = Read-Host "`nPlease enter a search string"
    $results = [AppDomain]::CurrentDomain.GetAssemblies() |
        ForEach-Object {
            $_.GetTypes() | Where-Object { $_.FullName -match $search }
        }
    $results | Select-Object Name, Namespace | Sort-Object -Property Name
}

function Get-Path {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string]$Path
    )
    process {
        $fullPath = (Get-Item $Path).FullName
        $fullPath | Set-Clipboard
        Write-Host "Path for '$fullPath' successfully copied to the clipboard." -ForegroundColor Green
    }
}

function Get-RandomPassword {
    param(
        [int]$length = 14,
        [string]$characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789!$%&?*@'
    )
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.Length }
    $private:ofs = ""
    [string]$characters[$random]
}

function hist { Get-Content (Get-PSReadlineOption).HistorySavePath }

function notepad {
    param([string]$Path)
    $npp = 'C:\Program Files\Notepad++\notepad++.exe'
    if (-not (Test-Path $npp)) {
        Write-Warning "Notepad++ not found at '$npp'"
        return
    }
    if ($Path) { & $npp $Path } else { & $npp }
}

function pbc {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)
    Get-Content -Raw -Path $Path | Set-Clipboard
    Write-Host "Successfully copied contents of '$Path' to the clipboard" -ForegroundColor Green
}

function printenv { Get-ChildItem Env: | Sort-Object Name }

function reload-profile { & $PROFILE }

function Remote-PSS {
    $whichcomputer = Read-Host "Which computer would you like to connect to?"
    Enter-PSSession -ComputerName $whichcomputer -Credential 'CORP\sa-klively'
}

function Reset-IseTab {
    if (-not $psISE) {
        Write-Warning "This function only works inside the PowerShell ISE."
        return
    }

    param(
        [switch]$SaveFiles,
        [ScriptBlock]$InvokeInNewTab
    )

    $ErrorActionPreference = 'SilentlyContinue'
    $Current = $psISE.CurrentPowerShellTab
    $FileList = @()

    $Current.Files | ForEach-Object {
        if ($SaveFiles -and (-not $_.IsSaved)) {
            try { $_.Save(); $FileList += $_ } catch {}
        } elseif ($_.IsSaved) {
            $FileList += $_
        }
    }

    $NewTab = $psISE.PowerShellTabs.Add()
    $FileList | ForEach-Object {
        $NewTab.Files.Add($_.FullPath) | Out-Null
        $Current.Files.Remove($_)
    }

    if ($InvokeInNewTab) {
        while (-not $NewTab.CanInvoke) { Start-Sleep 1 }
        $NewTab.Invoke($InvokeInNewTab)
    }

    if ($Current.Files.Count -eq 0) {
        $psISE.PowerShellTabs.Remove($Current)
    }
}

function Sleep-Computer {
    &"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Standby
}

function unzip {
    param([Parameter(Mandatory)][string]$File)
    Write-Output "Extracting $File to $PWD"
    $fullFile = Get-ChildItem -Path $PWD -Filter $File | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $PWD
}

function WinUtil { iwr -UseBasicParsing -UseB https://christitus.com/win | iex }

function word {
    param([Parameter(Mandatory)][string]$Path)
    Start-Process winword.exe $Path
}