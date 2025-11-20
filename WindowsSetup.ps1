### Intended to be run on a clean Windows install to set up basic packages, tools, preferences, and settings.

### Start logging
$scriptName = $MyInvocation.MyCommand.Name
$logFile = $scriptName + "_" + "$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFile -Append

Write-Host "Running WindowsSetup.ps1..." -ForegroundColor Magenta

function Confirm-Yes($message) {
    $response = Read-Host $message
    return ($response -match '^(y|yes)$')
}

### Activate Windows
$confirmActivation = Read-Host "Do you want to activate Windows? (y/n)"

if ($confirmActivation -eq "Yes" -or $confirmActivation -eq "Y") {
    Write-Host "Activating Windows..."
    irm https://get.activated.win | iex
}
else {
    Write-Host "Windows activation skipped."
}

### Install Chocolatey
Write-Host "Checking to see if Chocolatey is installed..." -ForegroundColor Magenta
if (-not (Get-Command -Name choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..." -ForegroundColor Yellow

    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    Write-Host "Chocolatey has been installed successfully." -ForegroundColor Green
}
else {
    Write-Host "Chocolatey is already installed." -ForegroundColor Green
}

### Install Chocolatey packages
$requiredPackages = @("oh-my-posh", "vim", "git", "notepadplusplus.install")

Write-Host "Checking installed Chocolatey packages..." -ForegroundColor Magenta
$installedPackages = choco list --local-only --limit-output |
    ForEach-Object { ($_ -split '\|')[0].Trim() }

Write-Host "Installing Chocolatey packages..." -ForegroundColor Magenta

foreach ($package in $requiredPackages) {
    if ($installedPackages -notcontains $package) {
        Write-Host "Installing $package..." -ForegroundColor Yellow
        choco install $package -y --limit-output
    }
    else {
        Write-Host "$package is already installed." -ForegroundColor Green
    }
}

### Cleanup step: Remove gvim icons from the desktop(s)
Write-Host "Checking for gvim icons on desktops..." -ForegroundColor Magenta

# Collect desktop paths for current user and Public
$desktopPaths = @(
    [Environment]::GetFolderPath('Desktop'),
    "$env:PUBLIC\Desktop"
) | Where-Object { Test-Path $_ }

$gvimIcons = foreach ($path in $desktopPaths) {
    Get-ChildItem -Path $path -Filter "gvim*" -ErrorAction SilentlyContinue
}

if ($gvimIcons) {
    Write-Host "Removing gvim icons from desktop(s)..." -ForegroundColor Magenta
    foreach ($icon in $gvimIcons) {
        Remove-Item -Path $icon.FullName -Force
    }
    Write-Host "gvim desktop icon cleanup completed." -ForegroundColor Green
}
else {
    Write-Host "No gvim icons found on any desktop." -ForegroundColor Green
}

### Check and install NuGet package provider
Write-Host "Checking if NuGet package provider is installed..." -ForegroundColor Magenta
if (!(Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Write-Host "NuGet package provider is not installed. Installing..." -ForegroundColor Yellow

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -Force
    Write-Host "NuGet package provider has been installed successfully." -ForegroundColor Green
}
else {
    Write-Host "NuGet package provider is already installed." -ForegroundColor Green
}

### Winget/Winutil Stuff
if (Confirm-Yes "Do you want to run WinUtil? (y/n)") {
    $wingetSettings = Join-Path $PSScriptRoot "configs\settings.json"
    $wingetSettingsTarget = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
    $winutilSettings = Join-Path $PSScriptRoot "configs\winutil.json"

    Write-Host "Adding winget settings to system..." -ForegroundColor Magenta
    if (Test-Path $wingetSettings) {
        if (Test-Path $wingetSettingsTarget) {
            Remove-Item $wingetSettingsTarget -Force
        }

        # Ensure target directory exists
        $wingetTargetDir = Split-Path $wingetSettingsTarget -Parent
        if (-not (Test-Path $wingetTargetDir)) {
            New-Item -ItemType Directory -Path $wingetTargetDir -Force | Out-Null
        }

        Copy-Item -Path $wingetSettings -Destination $wingetSettingsTarget -Force

        Write-Host "Running WinUtil..." -ForegroundColor Magenta
        Invoke-RestMethod -UseBasicParsing -Uri "https://christitus.com/win" | Invoke-Expression
        # Disabling auto-config for now, not entirely sure I want these defaults to always run.
        #Invoke-Expression "& { $(Invoke-RestMethod christitus.com/win) } -Config $winutilSettings -Run"
    }
    else {
        Write-Warning "The settings.json file was not found in the repo's configs directory."
        Write-Warning "Please make sure the file exists and try again."
    }
}
else {
    Write-Host "WinUtil skipped." -ForegroundColor Yellow
}

### Prompt the user to choose whether to run the PowershellSetup.ps1 script
if (Confirm-Yes "Do you want to run the PowershellSetup.ps1 script? (y/n)") {
    $powershellSetupPath = Join-Path $PSScriptRoot "PowershellSetup.ps1"
    if (Test-Path $powershellSetupPath) {
        Write-Host "Running PowershellSetup.ps1 script..." -ForegroundColor Magenta
        & $powershellSetupPath
    }
    else {
        Write-Warning "PowershellSetup.ps1 script not found in the same directory."
    }
}
else {
    Write-Host "Skipping PowershellSetup.ps1 script." -ForegroundColor Yellow
}

Write-Host "Windows setup script complete." -ForegroundColor Green

### Stop logging
Stop-Transcript
