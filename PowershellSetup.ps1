### minimal setup script to load PowerShell configs, vimrc, and other misc task

### Start logging
$scriptName = $MyInvocation.MyCommand.Name
$logFile = $scriptName + "_" + "$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFile -Append

### Set git path before continueing
$env:PATH += ";C:\Program Files\Git\cmd"

### Clone windows repo
Write-Host "Cloning windows repo..."
$repoPath = Join-Path $env:USERPROFILE "Repos"
$windowsRepoPath = Join-Path $repoPath "windows"

if (!(Test-Path -Path $repoPath)) {
    try {
        New-Item -ItemType Directory -Path $repoPath -Force | Out-Null
        Write-Host "Created repository directory: $repoPath"
    }
    catch {
        Write-Error "Failed to create repository directory: $repoPath"
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
}

### Symlink PowerShell Folder
Write-Host "Symlinking PowerShell folder..."
$powershellFolder = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell"
$powershellTarget = Join-Path $windowsRepoPath "WindowsPowerShell"
if (Test-Path -Path $powershellFolder) {
    Remove-Item -Path $powershellFolder -Force -Recurse -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $powershellFolder -Value $powershellTarget -Force | Out-Null

### Symlink PowerShell profile to ISE profile
Write-Host "Symlinking PowerShell ISE profile..."
$iseProfilePath = Join-Path $powershellFolder "Microsoft.PowerShellISE_profile.ps1"
$iseProfileTarget = Join-Path $windowsRepoPath "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
if (Test-Path -Path $iseProfilePath) {
    Remove-Item -Path $iseProfilePath -Force -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $iseProfilePath -Value $iseProfileTarget -Force | Out-Null

### Symlink Terminal Settings
Write-Host "Symlinking terminal settings..."
$terminalSettingsPath = Join-Path $env:USERPROFILE "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$terminalSettingsTarget = Join-Path $windowsRepoPath "Terminal Settings\LocalState"
if (Test-Path -Path $terminalSettingsPath) {
    Remove-Item -Path $terminalSettingsPath -Force -Recurse -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $terminalSettingsPath -Value $terminalSettingsTarget -Force | Out-Null

### Vim Stuff
# Set up vimrc file
Write-Host "Symlinking vimrc..."
$vimrcPath = "C:\tools\vim\_vimrc"
$vimrcTarget = Join-Path $PSScriptRoot "configs\_vimrc"
if (Test-Path -Path $vimrcPath) {
    Remove-Item -Path $vimrcPath -Force -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $vimrcPath -Value $vimrcTarget -Force | Out-Null

# Check for Vundle, download if it doesn't exist.
Write-Host "Installing Vundle..."
$vundlePath = "C:\tools\vim\vim91\Vundle.vim"
if (-Not (Test-Path $vundlePath)) {
    Write-Host "Vundle not found at $vundlePath. Cloning Vundle from GitHub..."
    $gitUrl = "https://github.com/VundleVim/Vundle.vim.git"
    git clone $gitUrl $vundlePath
    if ($?) {
        Write-Host "Vundle was successfully cloned to $vundlePath."
    }
    else {
        Write-Error "Failed to clone Vundle."
        exit 1
    }
}
else {
    Write-Host "Vundle is already installed at $vundlePath."
}

### Install vim plugins with bundle
Write-Host "Installing Vim Plugins..."
vim -E -s -u "$vimrcPath" -c "BundleInstall" -c "qa!"

### Install Fonts
Write-Host "Installing fonts ..."
$fontsFolder = Join-Path $windowsRepoPath "fonts"
Write-Host "Fonts folder: $fontsFolder"

$windowsFontsFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)

if (Test-Path -Path $fontsFolder) {
	$fontFiles = Get-ChildItem -Path $fontsFolder
    Write-Host "Found $($fontFiles.Count) font files in $fontsFolder"

    foreach ($font in $fontFiles) {
        Write-Host "Processing font file: $($font.Name)"
        try {
            $destinationPath = Join-Path $windowsFontsFolder $font.Name
            if (Test-Path -Path $destinationPath) {
                Write-Host "Font '$($font.Name)' already exists. Skipping installation."
            }
            else {
                $windowsFontsFolder.CopyHere($font.FullName)
                Write-Host "Installed font: $($font.Name)"
            }
        }
        catch {
            Write-Error "Failed to install font: $($font.Name)"
        }
    }
}
else {
    Write-Warning "Fonts folder not found: $fontsFolder"
}

### Set default font
$defaultFont = "Hack Nerd Font Mono"
Write-Host "Setting default font to " -NoNewline; Write-Host $defaultFont -ForegroundColor Yellow; Write-Host "..."

if (!(Get-Module -ListAvailable -Name WindowsConsoleFonts)) {
    Write-Host "WindowsConsoleFonts module not found. Installing..."

    Install-Module -Name WindowsConsoleFonts -Scope CurrentUser -Force

    Write-Host "WindowsConsoleFonts module installed successfully..."
}

try {
    Set-ConsoleFont $defaultFont
    Write-Host "Default font set to " -NoNewline; Write-Host $defaultFont -ForegroundColor Yellow
}
catch {
    Write-Host "Failed to set the console font. Error: $($_.Exception.Message)"
}

### Source PowerShell profile
Write-Host "Sourcing PowerShell Profile..."
. $profile

Write-Host "PowerShell Setup complete." -ForegroundColor green

### Stop logging
Stop-Transcript