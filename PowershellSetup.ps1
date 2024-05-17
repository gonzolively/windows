### minimal setup script to load PowerShell configs, vimrc, and other misc tasks

### Pre-reqs:
# 1. Copy ssh folder (github key + configs) to local users SSH dir

# Clone windows repo
$repoPath = Join-Path $env:USERPROFILE "Repos"
$windowsRepoPath = Join-Path $repoPath "windows"

if (!(Test-Path -Path $repoPath)) {
    New-Item -ItemType Directory -Path $repoPath -Force | Out-Null
}

if (Test-Path -Path $windowsRepoPath) {
    Set-Location $windowsRepoPath
    git pull
} else {
    Set-Location $repoPath
    git clone git@github.com:gonzolively/windows.git
}

# Symlink PowerShell Folder
$powershellFolder = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell"
if (Test-Path -Path $powershellFolder) {
    Remove-Item -Path $powershellFolder -Force -Recurse -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $powershellFolder -Value (Join-Path $windowsRepoPath "\WindowsPowerShell")

# Symlink PowerShell profile to ISE profile
$iseProfilePath = Join-Path $powershellFolder "Microsoft.PowerShellISE_profile.ps1"
$iseProfileTarget = Join-Path $windowsRepoPath "\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
if (Test-Path -Path $iseProfilePath) {
    Remove-Item -Path $iseProfilePath -Force -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $iseProfilePath -Value $iseProfileTarget -Force

# Symlink Terminal Settings
$terminalSettingsPath = Join-Path $env:USERPROFILE "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path -Path $terminalSettingsPath) {
    Remove-Item -Path $terminalSettingsPath -Force -Recurse -Confirm:$false
}
$terminalSettingsTarget = Join-Path $windowsRepoPath "\Terminal Settings\LocalState"
New-Item -ItemType SymbolicLink -Path $terminalSettingsPath -Value $terminalSettingsTarget

### Vim Stuff
# Set up vimrc file
$vimrcPath = "C:\tools\vim\_vimrc"
$vimrcTarget = Join-Path $repoPath "\windows\_vimrc"
if (Test-Path -Path $vimrcPath) {
    Remove-Item -Path $vimrcPath -Force -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $vimrcPath -Value $vimrcTarget -Force

# Check for Vundle, download if it doesn't exist.
$vundlePath = "C:\tools\vim\vim91\Vundle.vim"
if (-Not (Test-Path $vundlePath)) {
    Write-Host "Vundle not found at $vundlePath. Cloning Vundle from GitHub..."
    $gitUrl = "https://github.com/VundleVim/Vundle.vim.git"
    git clone $gitUrl $vundlePath
    if ($?) {
        Write-Host "Vundle was successfully cloned to $vundlePath."
    } else {
        Write-Host "Failed to clone Vundle."
    }
} else {
    Write-Host "Vundle is already installed at $vundlePath."
}

# Install vim plugins with bundle
Write-Host "Installing Vim Plugins..."
vim -E -s -u "$vimrcPath" -c "BundleInstall" -c "qa!"
