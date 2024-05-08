# ------------------------------------------------------------------------
# Script:   AD-DeleteComputers(From File).ps1 
# Author:   ad-klively 
# Date:     09/10/2013 13:24:08 
# Comments: This script will delete computers from a text file you supply
# ------------------------------------------------------------------------


Write-Host "`nPlease provide the path to the file of computers you wish to delete"
Start-Sleep -Milliseconds 300
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$openFile = New-Object System.Windows.Forms.OpenFileDialog
$openFile.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*"
If($openFile.ShowDialog() -eq "OK")

{
Write-Host "`nDeleting hosts from " -NoNewline
write-host "'"$openFile.FileName"'" -ForegroundColor Yellow
Get-Content $openFile.FileName | ForEach-Object {Remove-ADComputer -Confirm:$false -Identity $_}
}