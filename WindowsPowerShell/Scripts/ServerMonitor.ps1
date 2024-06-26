# -------------------------------------------------------------------------------------
# Script:   ServerMonitor.ps1 
# Author:   knox 
# Date:     02/28/2013 09:07:50 
# Comments: This script searches though a server list (provided by a txt file
# at the moment) and checks if they're up or not
# -------------------------------------------------------------------------------------

# reset the lists of hosts prior to looping 
$OutageHosts = $Null 
# specify the time you want email notifications resent for hosts that are down 
#EmailTimeOut = 30 
# specify the time you want to cycle through your host lists. 
$SleepTimeOut = 10
# specify the maximum hosts that can be down before the script is aborted 
$MaxOutageCount = 10 
 
# start looping here 
Do{ 
$available = $Null 
$notavailable = $Null 
Write-Host ""
Write-Host "-----------------------------------"
Write-Host (Get-Date) 
Write-Host ""
 
# Read the File with the Hosts every cycle, this way to can add/remove hosts 
# from the list without touching the script/scheduled task,  
# also hash/comment (#) out any hosts that are going for maintenance or are down. 
#get-content \\oberon\users\knox\hosts.txt | Where-Object {!($_ -match "#")} | 

get-content "" | Where-Object {!($_ -match "#")} | 
#get-content "C:\test.txt" | Where-Object {!($_ -match "#")} |
ForEach-Object { 
if(Test-Connection -ComputerName $_ -Count 1 -ea silentlycontinue) 
    { 
     # if the Host is available then just write it to the screen 
     write-host "Available host ---> "$_ -BackgroundColor Green -Foregroundcolor white 
     [Array]$available += $_ 
    } 
else 
    { 
     #If the host is unavailable, give a warning to screen 
     write-host "Unavailable host ------------> "$_ -BackgroundColor Magenta -ForegroundColor White 
     if(!(Test-Connection -ComputerName $_ -Count 4 -ea silentlycontinue)) 
       { 
        # If the host is still unavailable for 4 full pings, write error and send email 
        write-host "Unavailable host ------------> "$_ -BackgroundColor Red -ForegroundColor White 
        [Array]$notavailable += $_ 
 
        if ($OutageHosts -ne $Null) 
            { 
                if (!$OutageHosts.ContainsKey($_)) 
                { 
                 # First time down add to the list
                 #Write-Host "$_ Is not in the OutageHosts list, first time down" 
                 $OutageHosts.Add($_,(get-date)) 
                 $Now = Get-date 
                 $Body = "$_ has not responded for 5 pings at $Now" 
                 #Send-MailMessage -Body "$body" -to $notificationto -from $notificationfrom -Subject "Host $_ is down" -SmtpServer $smtpserver 
                } 
                else 
                { 
                    # If the host is in the list do nothing for 1 hour and then remove from the list. 
                    #Write-Host "$_ Is in the OutageHosts list" 
                    if (((Get-Date) - $OutageHosts.Item($_)).TotalMinutes -gt $EmailTimeOut) 
                    {$OutageHosts.Remove($_)} 
                } 
            } 
        else 
            { 
                # First time down create the list and send email 
               # Write-Host "Adding $_ to OutageHosts." 
                $OutageHosts = @{$_=(get-date)} 
                $Body = "$_ has not responded for 5 pings at $Now"  
                #Send-MailMessage -Body "$body" -to $notificationto -from $notificationfrom `-Subject "Host $_ is down" -SmtpServer $smtpserver 
            }  
       } 
    } 
} 
#>
# Report to screen the details 
Write-Host ""
Write-Host "Available count:"$available.count 
Write-Host "Not available count:"$notavailable.count 
Write-Host "Not available hosts:" 
$OutageHosts 
Write-Host ""
Write-Host ""
Write-Host "...Refreshing in $SleepTimeOut seconds" 
Write-Host ""
sleep $SleepTimeOut 
if ($OutageHosts.Count -gt $MaxOutageCount) 
{ 
    # If there are more than a certain number of host down in an hour abort the script. 
    $Exit = $True 
    $body = $OutageHosts | Out-String 
    #Send-MailMessage -Body "$body" -to $notificationto -from $notificationfrom `-Subject "More than $MaxOutageCount Hosts down, monitoring aborted" -SmtpServer $smtpServer 
} 
} 
while ($Exit -ne $True) 