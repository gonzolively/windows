# -------------------------------------------------------------------------------------
# Script:   WhenCreated(AllUsersByDate).ps1 
# Author:   knox 
# Date:     02/28/2013 09:06:17 
# Comments: Searches AD and sorts all users by created date (oldest -> newest)
# -------------------------------------------------------------------------------------

Import-module ActiveDirectory
Get-ADUser -Filter * -Properties * | Sort-Object  -Property whencreated -Descending| 
Format-Table -Property whencreated, samaccountname
