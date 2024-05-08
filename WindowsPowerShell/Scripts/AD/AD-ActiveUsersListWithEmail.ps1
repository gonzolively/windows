# ----------------------------------------------------------------------------------
# Script:   AD-ActiveUsersListWithEmail.ps1 
# Author:   klively 
# Date:     03/09/2015 11:40:31 
# Comments: This script gets a list of active users and their email
# address and then outputs the results to a csv file in my downloads dir.
# ----------------------------------------------------------------------------------

Import-Module ActiveDirectory
Get-ADUser -Filter 'enabled -eq$true' -Properties name, mail  |? {$_.mail -ine $null} |Select-Object -Property name,mail|
Sort-Object -Property Name, mail | Export-Csv -LiteralPath "$DOWNLOADS\output.csv"
