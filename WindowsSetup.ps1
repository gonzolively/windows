### Intended to be run on a clean Windows install to set up basic packages, tools, preferences, and settings.

# Start logging
$scriptName = $MyInvocation.MyCommand.Name
$logFile = $scriptName + "_" + "$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFile -Append

# Activate Windows
$confirmActivation = Read-Host "Do you want to activate Windows? (Yes/No)"

if ($confirmActivation -eq "Yes" -or $confirmActivation -eq "Y") {
    Write-Host "Activating Windows..."
    irm https://get.activated.win | iex
}
else {
    Write-Host "Windows activation skipped."
}


# Check if Chocolatey is already installed
Write-Host "Checking to see if Choclatey is installed..."
if (-not (Get-Command -Name choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."

    # Install Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Chocolatey has been installed successfully."
}
else {
    Write-Host "Chocolatey is already installed."
}

# List of packages you want to ensure are installed
$requiredPackages = @("vim")

# Get all currently installed Chocolatey packages
$installedPackages = choco list --local-only | Select-String -Pattern "^\w"

Write-Host "Installing Choclatey packages..."

# Loop through the required packages and check if each one is installed
foreach ($package in $requiredPackages) {
    if ($installedPackages -notmatch "^$package\b") {
        # Package is not installed, install it
        choco install $package -y --limit-output
    }
    else {
        Write-Host "$package is already installed."
    }
}

# Cleanup step: Remove gvim icons from the desktop
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

# Winget/Winutil Stuff
$wingetSettings = Join-Path $PSScriptRoot "configs\settings.json"
$wingetSettingsTarget = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
$winutilSettings = Join-Path $PSScriptRoot "configs\winutil.json"

# Check if the repo's settings.json file exists
Write-Host "Adding winget settings to system..."
if (Test-Path $wingetSettings) {
    # Remove the existing winget settings.json file if it exists
    if (Test-Path $wingetSettingsTarget) {
        Remove-Item $wingetSettingsTarget
    }

    # Copy over winget Settings
    Copy-Item -Path $wingetSettings -Destination $wingetSettingsTarget

    # Run winutil (uses winget to install packages)
    Write-Host "Running WinUtil..."
    Invoke-Expression "& { $(Invoke-RestMethod christitus.com/win) } -Config $winutilSettings -Run"
}
else {
    Write-Warning "The settings.json file was not found in the repo's root directory."
    Write-Warning "Please make sure the file exists and try again."
}

# Prompt the user to choose whether to run the PowershellSetup.ps1 script
$runPowershellSetup = Read-Host "Do you want to run the PowershellSetup.ps1 script? (Y/N)"

if ($runPowershellSetup -eq "Y" -or $runPowershellSetup -eq "y") {
    # Check if the PowershellSetup.ps1 script exists in the same directory
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

# Stop logging
Stop-Transcript