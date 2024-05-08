# -------------------------------------------------------------------------------------
# Script:   InactiveComputersAD(Ndays).ps1 
# Author:   knox 
# Date:     02/28/2013 09:20:47 
# Comments: Searches AD for computers with inactivity (haven't been logged into)
# by "n" days specified by user
# -------------------------------------------------------------------------------------
Import-Module ActiveDirectory
$howmanydays=Read-Host "How many days back do you want to go?"
$cs = dsquery computer -inactive $howmanydays -limit 0| Sort-Object
foreach ($c in $cs) {Write-Host $c.split(",")[0].Replace("""CN=", [string]::empty)} 