# ------------------------------------------------------------------------
# Script:   PingTest(From File).ps1 
# Author:   ad-klively 
# Date:     09/10/2013 12:20:17 
# Comments: This will ping hosts from a provided list.
# ------------------------------------------------------------------------

Write-Host "`nPlease provide the path to the file of computers you wish to ping"
Start-Sleep -Milliseconds 300
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$openFile = New-Object System.Windows.Forms.OpenFileDialog
$openFile.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*"
If($openFile.ShowDialog() -eq "OK")
{
Write-Host "`nPinging hosts from " -NoNewline
write-host "'"$openFile.FileName"'" -ForegroundColor Yellow
Get-Content $openFile.FileName | ForEach-Object {Test-Connection -ComputerName $_ -Count 1}
}