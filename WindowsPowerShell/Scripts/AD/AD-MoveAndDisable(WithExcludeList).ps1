# -------------------------------------------------------------------------------------
# Script:   MoveAndDisable(WithExcludeList).ps1 
# Author:   ad-klively 
# Date:     05/24/2013 11:37:42 
# Comments: This script queries ad for incative users (within N days) and then
# disables and moves them to a specified OU
# -------------------------------------------------------------------------------------
Import-Module ActiveDirectory
# Test withouth the "$perf_search" i'm pretty sure this is redundant
$perf_search = Search-ADAccount -UsersOnly -AccountInactive -TimeSpan 30.00:00:00 | 
?{$_.enabled -eq $true} | Select-Object distinguishedname | Export-Csv -NoTypeInformation c:\users\mdiaz\desktop\inactive_user_5_17.csv
$inactives = Get-Content c:\users\mdiaz\desktop\inactive_user_5_17.csv
$exclude = Get-Content c:\users\mdiaz\desktop\excl_curr.csv
# Here we grab only the objects that are found in the first list "$inactives" and NOT in the second list "exclude"
# which is indicated by the "<=" sign, "=>" would imply they're only in the exclude list, and "==" means they're found in both
$to_disable=Compare-Object -IncludeEqual $inactives $exclude | Where-Object {$_.SideIndicator -eq "<="}
$user_to_disable=$to_disable.InputObject 
$cleaned_up=$user_to_disable.Replace("`"","")

if ($to_disable -eq $null) {Write-Host "`nNothing to see here!"}
else
{
 Disable-ADAccount -Identity $cleaned_up
 Move-ADObject -Identity $cleaned_up -TargetPath "OU=Test,OU=Accounts,OU=IT,OU=Departments,DC=LFILMS,DC=NET"
} 

