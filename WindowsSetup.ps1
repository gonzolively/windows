# Intended to be run on a clean windows install to set up basic packages, tools, preferences and settings.

# Security stuff
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Install Chocolatey
function Install-Chocolatey {
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
}

Install-Chocolatey -and

# Function to ensure Chocolatey packages are installed
function Ensure-ChocoPackagesInstalled {
    # List of packages you want to ensure are installed
    $requiredPackages = @("oh-my-posh", "vim")

    # Get all currently installed Chocolatey packages
    $installedPackages = choco list --local-only | Select-String -Pattern "^\w"

    # Loop through the required packages and check if each one is installed
    foreach ($package in $requiredPackages) {
        if ($installedPackages -notmatch "^$package\b") {
            # Package is not installed, install it
            choco install $package -y --limit-output
        } else {
            Write-Host "$package is already installed."
        }
    }
}

Ensure-ChocoPackagesInstalled -and

# Run winutil
iwr -useb https://christitus.com/win | iex