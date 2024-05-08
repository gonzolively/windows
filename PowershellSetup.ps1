### minimal setup script to load PowerShell configs, vimrc, and other misc tasks

# Pre-reqs:
# 1. Copy ssh folder (github key + configs) to local users SSH dir

# Security stuff
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Install Chocolatey
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Vim and Git using Chocolatey
choco install vim git -y

# Clone windows repo
Set-Location $env:USERPROFILE
if (!(Test-Path -Path "Repos")) {
    New-Item -ItemType Directory -Path "Repos"
}
Set-Location "Repos"
git clone git@github.com:gonzolively/windows.git

# Symlink PowerShell Folder
$powershellFolder = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell"
if (Test-Path -Path $powershellFolder) {
    Remove-Item -Path $powershellFolder -Force -Recurse -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $powershellFolder -Value (Join-Path $env:USERPROFILE "Repos\windows\WindowsPowerShell")

# Symlink PowerShell profile to ISE profile
$iseProfilePath = Join-Path $powershellFolder "Microsoft.PowerShellISE_profile.ps1"
$iseProfileTarget = Join-Path $env:USERPROFILE "Repos\windows\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
if (Test-Path -Path $iseProfilePath) {
    Remove-Item -Path $iseProfilePath -Force -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $iseProfilePath -Value $iseProfileTarget -Force

# Vim Stuff
$vimrcPath = "C:\tools\vim\_vimrc"
$vimrcTarget = Join-Path $env:USERPROFILE "Repos\windows\_vimrc"
if (Test-Path -Path $vimrcPath) {
    Remove-Item -Path $vimrcPath -Force -Confirm:$false
}
New-Item -ItemType SymbolicLink -Path $vimrcPath -Value $vimrcTarget -Force

# Terminal Settings
$terminalSettingsPath = Join-Path $env:USERPROFILE "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path -Path $terminalSettingsPath) {
    Remove-Item -Path $terminalSettingsPath -Force -Recurse -Confirm:$false
}
$terminalSettingsTarget = Join-Path $env:USERPROFILE "Repos\windows\Terminal Settings\LocalState"
New-Item -ItemType SymbolicLink -Path $terminalSettingsPath -Value $terminalSettingsTarget
