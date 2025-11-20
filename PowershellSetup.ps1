### minimal setup script to load PowerShell configs, vimrc, and other misc tasks

### Start logging
$scriptName = $MyInvocation.MyCommand.Name
$logFile = $scriptName + "_" + "$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFile -Append

### Set git path before continuing
$env:PATH += ";C:\Program Files\Git\cmd"

Write-Host "`nRunning PowershellSetup.ps1...`n" -ForegroundColor Magenta

### Basic command checks
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git is not available on PATH. Please ensure Git is installed before running this script."
    Stop-Transcript
    exit 1
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget is not available. Install App Installer from the Microsoft Store and try again."
    Stop-Transcript
    exit 1
}

### Resolve actual Documents path (handles OneDrive redirection)
$documentsPath = [Environment]::GetFolderPath('MyDocuments')
Write-Host "Resolved Documents path: $documentsPath" -ForegroundColor DarkGray

### Clone windows repo
Write-Host "Cloning windows repo..." -ForegroundColor Magenta
$repoPath = Join-Path $env:USERPROFILE "Repos"
$windowsRepoPath = Join-Path $repoPath "windows"

if (!(Test-Path -Path $repoPath)) {
    try {
        New-Item -ItemType Directory -Path $repoPath -Force | Out-Null
        Write-Host "Created repository directory: $repoPath"
    }
    catch {
        Write-Error "Failed to create repository directory: $repoPath"
        Stop-Transcript
        exit 1
    }
}

if (Test-Path -Path $windowsRepoPath) {
    Set-Location $windowsRepoPath
    git pull
}
else {
    Set-Location $repoPath
    git clone git@github.com:gonzolively/windows.git
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to clone windows repo. Exit code: $LASTEXITCODE"
        Stop-Transcript
        exit 1
    }
}

### Check if PowerShell 7 is installed
Write-Host "Checking if PowerShell 7 is installed..." -ForegroundColor Magenta

$powershell7Info = winget list --id Microsoft.Powershell --accept-source-agreements --source winget
if ($powershell7Info -match "Microsoft.PowerShell") {
    Write-Host "PowerShell 7 is already installed."
}
else {
    ### Install PowerShell 7
    Write-Host "PowerShell 7 is not installed. Installing..." -ForegroundColor Magenta
    winget install --id Microsoft.Powershell --source winget --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Host "PowerShell 7 installed successfully." -ForegroundColor Green
    }
    else {
        Write-Error "Failed to install PowerShell 7. Exit code: $LASTEXITCODE"
        Stop-Transcript
        exit 1
    }
}

### Symlink Windows PowerShell Profile (WindowsPowerShell)
Write-Host "Symlinking Windows PowerShell profile..." -ForegroundColor Magenta
$windowsPowershellFolder = Join-Path $documentsPath "WindowsPowerShell"
$windowsPowershellTarget = Join-Path $windowsRepoPath "WindowsPowerShell"

if (Test-Path -Path $windowsPowershellFolder) {
    Remove-Item -Path $windowsPowershellFolder -Force -Recurse -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $windowsPowershellFolder -Value $windowsPowershellTarget -Force | Out-Null

### Symlink PowerShell 7 Profile (Documents\PowerShell)
Write-Host "Symlinking PowerShell 7 profile..." -ForegroundColor Magenta
$windowsPowershell7Folder = Join-Path $documentsPath "PowerShell"
$windowsPowershell7ProfileSource = Join-Path $windowsRepoPath "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$windowsPowershell7ProfileTarget = Join-Path $windowsPowershell7Folder "Microsoft.PowerShell_profile.ps1"

if (!(Test-Path -Path $windowsPowershell7Folder)) {
    New-Item -ItemType Directory -Path $windowsPowershell7Folder -Force | Out-Null
    Write-Host "Created $windowsPowershell7Folder..."
}

if (Test-Path -Path $windowsPowershell7ProfileTarget) {
    Write-Host "Removing existing PowerShell 7 profile ..."
    Remove-Item -Path $windowsPowershell7ProfileTarget -Force
}

try {
    New-Item -ItemType SymbolicLink -Path $windowsPowershell7ProfileTarget -Value $windowsPowershell7ProfileSource -Force | Out-Null
    Write-Host "Created symbolic link for PowerShell 7 profile." -ForegroundColor Green
}
catch {
    Write-Error "Failed to create symbolic link for PowerShell 7 profile. Error: $($_.Exception.Message)"
}

### Symlink PowerShell profile to ISE profile
Write-Host "Symlinking PowerShell ISE profile..." -ForegroundColor Magenta
$iseProfilePath = Join-Path $windowsPowershellFolder "Microsoft.PowerShellISE_profile.ps1"
$iseProfileTarget = Join-Path $windowsRepoPath "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

if (Test-Path -Path $iseProfilePath) {
    Remove-Item -Path $iseProfilePath -Force -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $iseProfilePath -Value $iseProfileTarget -Force | Out-Null
Write-Host "Symlinked PowerShell ISE profile successfully" -ForegroundColor Green

### Symlink Terminal Settings
Write-Host "Symlinking terminal settings..." -ForegroundColor Magenta
$terminalSettingsPath = Join-Path $env:USERPROFILE "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$terminalSettingsTarget = Join-Path $windowsRepoPath "Terminal Settings\LocalState"

$terminalSettingsParent = Split-Path $terminalSettingsPath -Parent
if (-not (Test-Path $terminalSettingsParent)) {
    New-Item -ItemType Directory -Path $terminalSettingsParent -Force | Out-Null
}

if (Test-Path -Path $terminalSettingsPath) {
    Remove-Item -Path $terminalSettingsPath -Force -Recurse -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $terminalSettingsPath -Value $terminalSettingsTarget -Force | Out-Null
Write-Host "Symlinked terminal settings successfully" -ForegroundColor Green

### Vim Stuff
# Set up vimrc file
Write-Host "Symlinking vimrc..." -ForegroundColor Magenta
$vimrcPath = "C:\tools\vim\_vimrc"
$vimrcTarget = Join-Path $PSScriptRoot "configs\_vimrc"

if (Test-Path -Path $vimrcPath) {
    Remove-Item -Path $vimrcPath -Force -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $vimrcPath -Value $vimrcTarget -Force | Out-Null
Write-Host "Symlinked vimrc successfully" -ForegroundColor Green

# Check for Vundle, download if it doesn't exist.
Write-Host "Installing Vundle..." -ForegroundColor Magenta
$vundlePath = "C:\tools\vim\vim91\Vundle.vim"
if (-Not (Test-Path $vundlePath)) {
    Write-Host "Vundle not found at $vundlePath. Cloning Vundle from GitHub..."
    $gitUrl = "https://github.com/VundleVim/Vundle.vim.git"
    git clone $gitUrl $vundlePath
    if ($?) {
        Write-Host "Vundle was successfully cloned to $vundlePath." -ForegroundColor Green
    }
    else {
        Write-Error "Failed to clone Vundle."
        Stop-Transcript
        exit 1
    }
}
else {
    Write-Host "Vundle is already installed at $vundlePath."
}

### Install vim plugins with Vundle
Write-Host "Installing Vim plugins..." -ForegroundColor Magenta
vim -E -s -u "$vimrcPath" -c "BundleInstall" -c "qa!"
Write-Host "Installed Vim plugins successfully" -ForegroundColor Green

### Install Fonts
Write-Host "Installing fonts ..." -ForegroundColor Magenta
$fontsFolder = Join-Path $windowsRepoPath "fonts"
Write-Host "Fonts folder: $fontsFolder"

# 0x14 = system Fonts folder in Shell.Application
$fontsShellFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)

if (Test-Path -Path $fontsFolder) {
    $fontFiles = Get-ChildItem -Path $fontsFolder
    Write-Host "Found $($fontFiles.Count) font files in $fontsFolder"

    foreach ($font in $fontFiles) {
        Write-Host "Processing font file: $($font.Name)"
        try {
            # Check if font already exists in the Windows Fonts shell folder
            $existingFont = $fontsShellFolder.Items() | Where-Object { $_.Name -eq $font.Name }
            if ($existingFont) {
                Write-Host "Font '$($font.Name)' already exists. Skipping installation."
            }
            else {
                $fontsShellFolder.CopyHere($font.FullName)
                Write-Host "Installed font: $($font.Name)"
            }
        }
        catch {
            Write-Error "Failed to install font: $($font.Name)"
        }
    }
    Write-Host "Successfully installed fonts" -ForegroundColor Green
}
else {
    Write-Warning "Fonts folder not found: $fontsFolder"
}

### Set default console font
$defaultFont = "Hack Nerd Font Mono"
Write-Host "Setting default font to " -ForegroundColor Magenta -NoNewline
Write-Host $defaultFont -ForegroundColor Yellow
Write-Host "..." -ForegroundColor Magenta

if (!(Get-Module -ListAvailable -Name WindowsConsoleFonts)) {
    Write-Host "WindowsConsoleFonts module not found. Installing..."
    Install-Module -Name WindowsConsoleFonts -Scope CurrentUser -Force
    Write-Host "WindowsConsoleFonts module installed successfully..." -ForegroundColor Green
}

try {
    Set-ConsoleFont $defaultFont
    Write-Host "Default font set to " -NoNewline
    Write-Host $defaultFont -ForegroundColor Yellow
}
catch {
    Write-Host "Failed to set the console font. Error: $($_.Exception.Message)"
}

### Source PowerShell profile
Write-Host "Sourcing PowerShell profile..." -ForegroundColor Magenta
if ($PSVersionTable.PSVersion.Major -ge 7) {
    # PowerShell 7 uses Documents\PowerShell (whatever Documents is resolved to)
    $profilePath = Join-Path $windowsPowershell7Folder "Microsoft.PowerShell_profile.ps1"
}
else {
    # Windows PowerShell uses Documents\WindowsPowerShell
    $profilePath = Join-Path $windowsPowershellFolder "Microsoft.PowerShell_profile.ps1"
}

if (Test-Path -Path $profilePath) {
    . $profilePath
    Write-Host "PowerShell profile sourced successfully." -ForegroundColor Green
}
else {
    Write-Warning "PowerShell profile not found at $profilePath"
}

Write-Host "`nPowerShell setup complete." -ForegroundColor Green

### Stop logging
Stop-Transcript
