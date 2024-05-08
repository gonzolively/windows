# -------------------------------------------------------------------------------------
# Script:   LastTimeUserLoggedIn(SpecificUser).ps1 
# Author:   knox 
# Date:     02/28/2013 09:14:23 
# Comments: Searches AD for a user (specified by user of script) for the
# last time they logged in
# -------------------------------------------------------------------------------------

Import-Module ActiveDirectory
$ErrorActionPreference="SilentlyContinue"
$domain_data= Get-ADDomain
$domain = $domain_data.dnsroot
$samaccountname = Read-Host "`nWhat user do you want to check?"
$myForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
$domaincontrollers = $myforest.Sites | % { $_.Servers } | Select Name
$RealUserLastLogon = $null
$LastusedDC = $null
$domainsuffix = "*."+$domain

foreach ($DomainController in $DomainControllers) 
{
	if ($DomainController.Name -like $domainsuffix )
	{
		$UserLastlogon = Get-ADUser -Identity $samaccountname -Properties LastLogon -Server $DomainController.Name
		if ($RealUserLastLogon -le [DateTime]::FromFileTime($UserLastlogon.LastLogon))
		{
			$RealUserLastLogon = [DateTime]::FromFileTime($UserLastlogon.LastLogon)
			$LastusedDC =  $DomainController.Name
		}
	}
}

if ($RealUserLastLogon -match '12/31/1600 17:00:00')
{Write-Host "`n$samaccountname" -NoNewline -ForegroundColor Yellow
 Write-host " has never logged in to the domain"}

else{
Write-Host "`n"
write-host "'$samaccountname' last logged in at:    " -NoNewline
write-host $RealUserLastLogon -NoNewline -ForegroundColor Yellow
write-host " from " -NoNewline
write-host $LastusedDC  -ForegroundColor Magenta
write-host "`n"
}