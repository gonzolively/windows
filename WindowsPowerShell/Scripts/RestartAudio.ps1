# ----------------------------------------------------------------------------------
# Script:   RestartAudio.ps1 
# Author:   klively 
# Date:     10/28/2014 10:20:22 
# Comments: Restarts the audio service
# ----------------------------------------------------------------------------------

net stop audiosrv
sleep 5
net start audiosrv
