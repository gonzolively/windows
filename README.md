A collection of windows configs, scripts, etc.

### Steps
1. Copy ssh keys/config from the `dotfiles` repo to local users SSH dir. (`C:\Users\yourusername\.ssh`)
2. Download `windows` repo to your downloads folder
3. Open PowerShell (as administrator) and set execution policy:
    `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force`
4. Run
    `WindowsSetup.ps1`