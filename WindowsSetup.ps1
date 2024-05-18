### Intended to be run on a clean Windows install to set up basic packages, tools, preferences, and settings.

# Security stuff
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

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
$requiredPackages = @("oh-my-posh", "vim", "notepadplusplus.install")

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

# Run winutil
Invoke-WebRequest -UseBasicParsing -Uri 'https://christitus.com/win' | Invoke-Expression

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