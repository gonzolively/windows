# -------------------------------------------------------------------------------------
# Script:   Get-RandomPassword.ps1 
# Author:   ad-klively 
# Date:     06/25/2013 18:32:15 
# Comments: This script generates a random password 12 characters long
# -------------------------------------------------------------------------------------

function Get-RandomPassword {
    param(
        $length = 12,
        $characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789!$%&?*@'
    )
    # select random characters
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    # output random pwd
    $private:ofs = ""
    [String]$characters[$random]
}