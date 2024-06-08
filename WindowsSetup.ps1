### Intended to be run on a clean Windows install to set up basic packages, tools, preferences, and settings.

### Start logging
$scriptName = $MyInvocation.MyCommand.Name
$logFile = $scriptName + "_" + "$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFile -Append

### Activate Windows
$confirmActivation = Read-Host "Do you want to activate Windows? (Yes/No)"

if ($confirmActivation -eq "Yes" -or $confirmActivation -eq "Y") {
    Write-Host "Activating Windows..."
    irm https://get.activated.win | iex
}
else {
    Write-Host "Windows activation skipped."
}

### Install Cholatey
Write-Host "Checking to see if Choclatey is installed..."
if (-not (Get-Command -Name choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."

    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Chocolatey has been installed successfully."
}
else {
    Write-Host "Chocolatey is already installed."
}

### Install Choclatey packages
$requiredPackages = @("oh-my-posh", "vim", "git", "notepadplusplus.install")

$installedPackages = choco list --local-only | Select-String -Pattern "^\w"

Write-Host "Installing Choclatey packages..."

foreach ($package in $requiredPackages) {
    if ($installedPackages -notmatch "^$package\b") {
        choco install $package -y --limit-output
    }
    else {
        Write-Host "$package is already installed."
    }
}

### Cleanup step: Remove gvim icons from the desktop
$gvimIconsPath = "C:\Users\Public\Desktop"
$gvimIcons = Get-ChildItem -Path $gvimIconsPath -Filter "gvim*"

if ($gvimIcons) {
    Write-Host "Removing gvim icons from the desktop..."
    foreach ($icon in $gvimIcons) {
        Remove-Item -Path $icon.FullName -Force
    }
    Write-Host "Cleanup completed."
}
else {
    Write-Host "No gvim icons found on the desktop."
}

### Check and install NuGet package provider
Write-Host "Checking if NuGet package provider is installed..."
if (!(Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Write-Host "NuGet package provider is not installed. Installing..."

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -Force
    Write-Host "NuGet package provider has been installed successfully."
}
else {
    Write-Host "NuGet package provider is already installed."
}

### Winget/Winutil Stuff
$confirmWinUtil = Read-Host "Do you want to run WinUtil? (Yes/No)"

if ($confirmWinUtil -eq "Yes" -or $confirmWinUtil -eq "Y") {
    Write-Host "Activating Windows..."
    $wingetSettings = Join-Path $PSScriptRoot "configs\settings.json"
    $wingetSettingsTarget = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
    $winutilSettings = Join-Path $PSScriptRoot "configs\winutil.json"

    Write-Host "Adding winget settings to system..."
    if (Test-Path $wingetSettings) {
        if (Test-Path $wingetSettingsTarget) {
            Remove-Item $wingetSettingsTarget
        }

        Copy-Item -Path $wingetSettings -Destination $wingetSettingsTarget

        Write-Host "Running WinUtil..."
        Invoke-RestMethod -useb https://christitus.com/win | iex
        # Disabling auto-config for now, not entirely sure I want these defaults to always run.
        #Invoke-Expression "& { $(Invoke-RestMethod christitus.com/win) } -Config $winutilSettings -Run"
    }
    else {
        Write-Warning "The settings.json file was not found in the repo's root directory."
        Write-Warning "Please make sure the file exists and try again."
    }
}

else {
    Write-Host "WinUtil skipped."
}

### Prompt the user to choose whether to run the PowershellSetup.ps1 script
$runPowershellSetup = Read-Host "Do you want to run the PowershellSetup.ps1 script? (Yes/No)"

if ($runPowershellSetup -eq "Yes" -or $runPowershellSetup -eq "Y") {
    $powershellSetupPath = Join-Path $PSScriptRoot "PowershellSetup.ps1"
    if (Test-Path $powershellSetupPath) {
        Write-Host "Running PowershellSetup.ps1 script..."
        & $powershellSetupPath
    }
    else {
        Write-Warning "PowershellSetup.ps1 script not found in the same directory."
    }
}
else {
    Write-Host "Skipping PowershellSetup.ps1 script."
    Write-Host "Windows Setup complete." -ForegroundColor green
}

### Stop logging
Stop-Transcript