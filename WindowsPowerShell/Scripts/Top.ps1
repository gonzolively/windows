# -------------------------------------------------------------------------------------
# Script:   top.ps1 
# Author:   knox 
# Date:     02/28/2013 09:07:19 
# Comments: A top like utility for windows 
# -------------------------------------------------------------------------------------

While(1) {ps | sort -des privatememorysize | select -f 50 | ft -a; sleep 1; cls}