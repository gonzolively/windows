### Pre-reqs:
# Copy ssh folder (github key + configs) to local users SSH dir


# Clone windows repo
cd C:\Users\Knox\
mkdir Repos
cd Repos
git clone git@github.com:gonzolively/windows.git

# Symlink PowerShell Folder
rm C:\Users\Knox\Documents\WindowsPowerShell -Force -Recurse -Confirm:$false
New-Item -Path C:\Users\Knox\Documents\WindowsPowerShell -ItemType SymbolicLink -Value C:\Users\Knox\Repos\windows\WindowsPowerShell

### Vim Stuff
New-Item -Path C:\tools\vim\_vimrc -ItemType SymbolicLink -Value C:\Users\Knox\Repos\windows\_vimrc -Force

### Terminal Settings


# Terminal Settings Location
rm C:\Users\Knox\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState -Force -Recurse -Confirm:$false

New-Item -Path C:\Users\Knox\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState -ItemType SymbolicLink -Value 'C:\Users\Knox\Repos\windows\Terminal Settings\LocalState'