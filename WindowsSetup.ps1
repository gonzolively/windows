### Intended to be run on a clean Windows install to set up basic packages, tools, preferences, and settings.

# Check if Chocolatey is already installed
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
$requiredPackages = @("oh-my-posh", "vim", "git", "notepadplusplus.install")

# Get all currently installed Chocolatey packages
$installedPackages = choco list --local-only | Select-String -Pattern "^\w"

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
$wingetSettingsTarget = Join-Path $PSScriptRoot "configs\settings.json"
$wingetSettings = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"

# Check if the repo's settings.json file exists
if (Test-Path $wingetSettingsTarget) {
    # Remove the existing winget settings.json file if it exists
    if (Test-Path $wingetSettings) {
        Remove-Item $wingetSettings
    }

    # Create a symbolic link from the winget settings.json file to the repo's settings.json file
    New-Item -ItemType SymbolicLink -Path $wingetSettings -Target $wingetSettingsTarget

# Run winutil (uses winget to install packages)
Invoke-WebRequest -UseBasicParsing -Uri 'https://christitus.com/win' | Invoke-Expression

# In the future, remove choclatey install of packages (except vim) and pass winutl a config file with all pre-defined packages/tweaks
# iex "& { $(irm christitus.com/win) } -Config (Join-Path $PSScriptRoot "configs\WinUtil.json") -Run"

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
}