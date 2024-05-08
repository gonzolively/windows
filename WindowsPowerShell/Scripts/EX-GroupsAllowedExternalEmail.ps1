# ------------------------------------------------------------------------
# Script:   EX-GroupsAllowedExternalEmail.ps1 
# Author:   ad-klively 
# Date:     07/03/2013 15:57:35 
# Comments: This script queries distribution groups in exchange to find the 
# ones that are confiugred to receive external email.
# ------------------------------------------------------------------------

Get-DistributionGroup * | Where-Object {$_.Requiresenderauthenticationenabled -match 'false'} | 
Select-Object -Property name,primarysmtpaddress,requiresenderauthenticationenabled,grouptype,moderationenabled,moderatedby | 
Sort-Object -Property name | Format-table -Property name,primarysmtpaddress,requiresenderauthenticationenabled,grouptype