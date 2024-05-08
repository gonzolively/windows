# ------------------------------------------------------------------------
# Script:   Get-NetTypes.ps1 
# Author:   ad-klively 
# Date:     07/30/2013 14:11:32 
# Comments: This function explores all available .NET types.
# ------------------------------------------------------------------------

$search=read-host "`nPlease Enter a search string"
$results=[AppDomain]::CurrentDomain.GetAssemblies() |  Foreach-Object { $_.GetTypes() | where-object {$_.FullName -match $search}}
$results | select Name,NameSpace | Sort-Object -Property Name


<#

IsPublic IsSerial Name                                     BaseType                    Namespace           
-------- -------- ----                                     --------                     --------                
True     False    ManagementDateTimeConverter              System.Object               System.Management

#>