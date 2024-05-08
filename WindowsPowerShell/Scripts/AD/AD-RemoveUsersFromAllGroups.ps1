# -------------------------------------------------------------------------------------
# Script:   Untitled14.ps1 
# Author:   ad-klively 
# Date:     06/25/2013 18:06:48 
# Comments: This script removes all users in an OU from all groups they are currently 
# associated with.  This is intended to be used on users who are disabled, and in an
# appropriate OU that collects all disabled accounts.  Be very very very careful...this
# script is efficient and does exactly as it is told, make sure that you are using the 
# correct OU when setting the searchbase.
# -------------------------------------------------------------------------------------

<# Eventually include this to this script as to disable, move to "disabled" OU, and then remove that user from all groups 

 Disable-ADAccount -Identity $cleaned_up
 Move-ADObject -Identity $cleaned_up -TargetPath "OU=Test,OU=Accounts,OU=IT,OU=Departments,DC=LFILMS,DC=NET"
 #>

Get-ADUser -Filter * -SearchBase "OU=Test,OU=Accounts,OU=IT,OU=Departments,DC=LFILMS,DC=NET" | ForEach-Object {
$a = get-ADUser -identity $_ -Properties * | Select Memberof
		Foreach ($b in $a ) {
		$name = $b.Memberof
		$name	
		foreach ( $group in $name ) {
		remove-ADGroupMember -Identity $group -Members $_.SamAccountName -Confirm:$false}}
}