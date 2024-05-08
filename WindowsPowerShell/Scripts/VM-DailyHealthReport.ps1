$VISRV = "vcenter.crossview.inc"

param( [string] $VISRV)
###############################
# vCheck - Daily Error Report # 
###############################
# Thanks to all who have commented on my blog to help improve this project
# Especially - Thanks to Raphaël SCHITZ (http://www.hypervisor.fr/) for his contributions and time
# And also thanks to the many vExperts who have added suggestions for this report.

$Version = "5.31"

# You can change the following defaults by altering the below settings:
#
# Set the SMTP Server address
$SMTPSRV = "mail.crossview.inc"
# Set the Email address to recieve from
$EmailFrom = "infrateam@crossview.com"
# Set the Email address to send the email t
$EmailTo = "klively@crossview.com"

# Use the following item to define if the output should be displayed in the local browser once completed
$DisplaytoScreen = $false

# When displaying to the screen an output file is created.  Set the format of the filename below:
$dateFormat = "yyyyMMdd_HHmm" # use "d-M-yyyy" for legacy v5.0 format

# Use the following item to define if an email report should be sent once completed
$SendEmail = $true

# Use the following area to define the colours of the report
$Colour1 = "000000" # Main Title - currently red
$Colour2 = "000000" # Secondary Title - currently blue

#### Detail Settings ####
# Set the username of the account with permissions to access the VI Server 
# for event logs and service details - you will be asked for the same username and password
# only the first time this runs after setting the below username.
# If it is left blank it will use the credentials of the user who runs the script
$SetUsername = ""
# Set the location to store the credentials in a secure manner
$CredFile = ".\mycred.crd"
# Set if you would like to see the helpfull comments about areas of the checks
$Comments = $true
# Set the warning threshold for Datastore % Free Space
$DatastoreSpace = "5"
# Set the warning threshold for snapshots in days old
$SnapshotAge = 7
# Set the number of days to show VMs created & removed for
$VMsNewRemovedAge = 5
# Set the number of days of VC Events to check for errors
$VCEventAge = 1
# Set the number of days of VC Event Logs to check for warnings and errors
$VCEvntlgAge = 1
# Set the number of days of DRS Migrations to report and count on
$DRSMigrateAge = 1
# Local Stored VMs, do not report on any VMs who are defined below
$LVMDoNotInclude = "Template_*|VDI*"
# VMs with CD/Floppy drives not to report on
$CDFloppyConnectedOK = "APP*"
# The NTP server to check
$ntpserver = "pool.ntp.org" #Multiple servers can be specified with pipe separator as in "pool.ntp.org|myntp.domain.local"
# vmkernel log file checks - set the number of days to check before today
$vmkernelchk = 1
# CPU ready on VMs - To learn more read here: http://communities.vmware.com/docs/DOC-7390
$PercCPUReady = 10.0
# Change the next line to the maximum amount of vCPUs your VMs are allowed
$vCpu = 2
# Number of slots available in a cluster
$numslots = 10
# VM Cpu above x for the last x days
$CPUValue = 75
$CPUDays = 2
# VM Disk space left, set the amount you would like to report on
$MBFree = 10
# Max number of VMs per Datastore
$NumVMsPerDatastore = 5
# HA VM reset day(s) number
$HAVMresetold = 1
# HA VM restart day(s) number
$HAVMrestartold = 1
# VMHost/VMFS quota
$VMHostVMFSQuota = 28
# Datastore OverAllocation %
$OverAllocation = 100
# vSwitch Port Left
$vSwitchLeft = 5

# This section can be used to turn off certain areas of the report which may not be relevent to your installation
# Set them to $False if you do not want them in your output.

# Show headers for all selected tests (not just problem/issues)
$ShowAllHeaders = $False
# General Summary Info
$ShowGenSum = $true
# Show version information of PowerCLI and snapins
$showPowerCLIVersion = $False
# Show CPU Cluster Ratios
$ShowCPUClusterRatio = $False
# Snapshot Information
$ShowSnap = $true
# Datastore Information
$Showdata = $true
# Show SSL Certificate status
$showSSLexpiration = $true
# Hosts in Maintenance mode
$ShowMaint = $true
# Hosts not responding or Disconnected
$ShowResDis = $true
#Show Host Hardware Issues
$ShowHostHdwrIssues = $true
# Dead LunPath
$ShowLunPath = $true
#Create Guest OS Pivot table
$GuestOSPivot = $true
# VMs Created or cloned
$ShowCreated = $true
# VMs vCPU
$Showvcpu = $true
# VMs Removed
$ShowRemoved = $true
# Host Swapfile datastores
$ShowSwapFile = $true
# DRS Migrations
$ShowDRSMig = $true
# Cluster Slot Sizes
$ShowSlot = $False
# VM Hardware Version
$ShowHWVer = $true
# VI Events
$ShowVIevents = $true
# VMs in inconsistent folders
$ShowFolders = $true
# VM Tools
$Showtools = $true
# Connected CDRoms
$ShowCDRom = $true
# ConnectedFloppy Drives
$ShowFloppy = $true
#Find unwanted virtual hardware
$showUnwantedHardware = $true
$unwantedHardware = "VirtualUSBController|VirtualParallelPort|VirtualSerialPort"
# NTP Issues
$ShowNTP = $true
# Single storage VMs
$ShowSingle = $true
# VM CPU Ready
$ShowCPURDY = $true
# Host Alarms
$ShowHostAlarm = $true
# VM Alarms
$ShowVMAlarm = $true
# Cluster Alarms
$ShowCLUAlarm = $true
# Show Datastore Over Allocation
$ShowOverAllocation = $true
# Show Host Uptime warnings
$CheckHostUptime = $true
# Show Host vCenter Update Manager Non Compliance
$ShowHostVUMNonCompliance = $true
# Show Host version pivot table (ESX vs ESXi/with build numbers)
$HostOSPivot = $true
# VCB garbage
$ShowVCBGarbage = $true
# VC Service Details
$ShowVCDetails = $true
# VC Event Log Errors
$ShowVCError = $true
# VC Event Log Warnings
$ShowVCWarn = $true
# VMKernel Warning entries
$ShowVMKernel = $true
# Show VM CPU Usage
$ShowVMCPU = $true
# Show virtual machines with resource limits
$VMresourcelimts = $true
#Show thick provisioned virtual disks
$ShowThickDisk = $true
#Show VMs whose names don't match the installed OS name
$ShowMisnamedVM = $true
#Show VMs whose configured OS doesn't match installed OS
$ShowWrongOS = $true
#Show VMs pointing at the wrong syslog server
$ShowWrongSyslog = $true
$syslogserver = "Your_syslog_server:514"
#Show ESXi hosts listening on port 21 (remote TSM enabled)
$ShowRemoteTSM = $true
# Show ESXi Tech Support mode
$ShowTech = $true
# Show ESXi Hosts which do not have lockdown mode enabled
$Lockdown = $true
# Show VMs disk space check
$ShowGuestDisk = $true
# Show Number of VMs per Datastore
$ShowNumVMperDS = $true
# Show Overcommit
$ShowOvercommit = $true
# Show Ballooning and Swapping for VMs
$ShowSwapBal = $true
# HA VM reset log
$HAVMreset = $true
# HA VM restart log
$HAVMrestart = $true
# Host ConfigIssue
$ShowHostCIAlarm = $true
# Map Disk Region Events (http://kb.vmware.com/kb/1007331)
$ShowMapDiskRegionEvents = $true
# Capacity Info
$ShowCapacityInfo = $true
$LimitDiskCapacityForecastToSharedStorageOnly = $true
# VMHost/VMFS Quota
$VMHostVMFS = $true
# Check inaccessible or invalid VM
$ShowBlindedVM = $true
# Check VMTools Issues
$ShowtoolsIssues = $true
# Show VMTools that need updates
$Showtoolsupdate = $true
# Show VMTools installer connected
$ShowtoolsConnected = $true
# Check vSwitch Port Left
$vSwitchCheck = $true

#######################################
# Start of script

# Turn off Errors
$ErrorActionPreference = "silentlycontinue"

if ($VISRV -eq ""){
	Write-Host
	Write-Host "Please specify a VI Server name eg...."
	Write-Host "      powershell.exe vCheck.ps1 MyvCenter"
	Write-Host
	Write-Host
	exit
}

function Write-CustomOut ($Details){
	$LogDate = Get-Date -Format T
	Write-Host "$($LogDate) $Details"
}
function Send-SMTPmail($to, $from, $subject, $smtpserver, $body) {
	$mailer = new-object Net.Mail.SMTPclient($smtpserver)
	$msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)
	$msg.IsBodyHTML = $true
	$mailer.send($msg)
}

Function Get-CustomHTML ($Header){
$Report = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>$($Header)</title>
		<META http-equiv=Content-Type content='text/html; charset=windows-1252'>

		<style type="text/css">

		TABLE 		{
						TABLE-LAYOUT: fixed; 
						FONT-SIZE: 100%; 
						WIDTH: 100%
					}
		*
					{
						margin:0
					}

		.dspcont 	{
	
						BORDER-RIGHT: #bbbbbb 1px solid;
						BORDER-TOP: #bbbbbb 1px solid;
						PADDING-LEFT: 0px;
						FONT-SIZE: 8pt;
						MARGIN-BOTTOM: -1px;
						PADDING-BOTTOM: 5px;
						MARGIN-LEFT: 0px;
						BORDER-LEFT: #bbbbbb 1px solid;
						WIDTH: 95%;
						COLOR: #000000;
						MARGIN-RIGHT: 0px;
						PADDING-TOP: 4px;
						BORDER-BOTTOM: #bbbbbb 1px solid;
						FONT-FAMILY: Tahoma;
						POSITION: relative;
						BACKGROUND-COLOR: #f9f9f9
					}
					
		.filler 	{
						BORDER-RIGHT: medium none; 
						BORDER-TOP: medium none; 
						DISPLAY: block; 
						BACKGROUND: none transparent scroll repeat 0% 0%; 
						MARGIN-BOTTOM: -1px; 
						FONT: 100%/8px Tahoma; 
						MARGIN-LEFT: 43px; 
						BORDER-LEFT: medium none; 
						COLOR: #ffffff; 
						MARGIN-RIGHT: 0px; 
						PADDING-TOP: 4px; 
						BORDER-BOTTOM: medium none; 
						POSITION: relative
					}

		.pageholder	{
						margin: 0px auto;
					}
					
		.dsp
					{
						BORDER-RIGHT: #bbbbbb 1px solid;
						PADDING-RIGHT: 0px;
						BORDER-TOP: #bbbbbb 1px solid;
						DISPLAY: block;
						PADDING-LEFT: 0px;
						FONT-WEIGHT: bold;
						FONT-SIZE: 8pt;
						MARGIN-BOTTOM: -1px;
						MARGIN-LEFT: 0px;
						BORDER-LEFT: #bbbbbb 1px solid;
						COLOR: #FFFFFF;
						MARGIN-RIGHT: 0px;
						PADDING-TOP: 4px;
						BORDER-BOTTOM: #bbbbbb 1px solid;
						FONT-FAMILY: Tahoma;
						POSITION: relative;
						HEIGHT: 2.25em;
						WIDTH: 95%;
						TEXT-INDENT: 10px;
					}

		.dsphead0	{
						BACKGROUND-COLOR: #$($Colour1);
					}
					
		.dsphead1	{
						
						BACKGROUND-COLOR: #$($Colour2);
					}
					
	.dspcomments 	{
						BACKGROUND-COLOR:#FFFFE1;
						COLOR: #000000;
						FONT-STYLE: ITALIC;
						FONT-WEIGHT: normal;
						FONT-SIZE: 8pt;
					}

	td 				{
						VERTICAL-ALIGN: TOP; 
						FONT-FAMILY: Tahoma
					}
					
	th 				{
						VERTICAL-ALIGN: TOP; 
						COLOR: #$($Colour1); 
						TEXT-ALIGN: left
					}
					
	BODY 			{
						margin-left: 4pt;
						margin-right: 4pt;
						margin-top: 6pt;
					} 
	.MainTitle		{
						font-family:Arial, Helvetica, sans-serif;
						font-size:20px;
						font-weight:bolder;
					}
	.SubTitle		{
						font-family:Arial, Helvetica, sans-serif;
						font-size:14px;
						font-weight:bold;
					}
	.Created		{
						font-family:Arial, Helvetica, sans-serif;
						font-size:10px;
						font-weight:normal;
						margin-top: 20px;
						margin-bottom:5px;
					}
	.links			{	font:Arial, Helvetica, sans-serif;
						font-size:10px;
						FONT-STYLE: ITALIC;
					}
					
		</style>
	</head>
	<body>
<div class="MainTitle">$($Header)</div>
        <hr size="8" color="#$($Colour1)">
        <div class="Created">Report created on $(Get-Date)</div>
"@
Return $Report
}

Function Get-CustomHeader0 ($Title){
$Report = @"
		<div class="pageholder">		

		<h1 class="dsp dsphead0">$($Title)</h1>
	
    	<div class="filler"></div>
"@
Return $Report
}

Function Get-CustomHeader ($Title, $cmnt){
$Report = @"
	    <h2 class="dsp dsphead1">$($Title)</h2>
"@
If ($Comments) {
	$Report += @"
			<div class="dsp dspcomments">$($cmnt)</div>
"@
}
$Report += @"
        <div class="dspcont">
"@
Return $Report
}

Function Get-CustomHeaderClose{

	$Report = @"
		</DIV>
		<div class="filler"></div>
"@
Return $Report
}

Function Get-CustomHeader0Close{
	$Report = @"
</DIV>
"@
Return $Report
}

Function Get-CustomHTMLClose{
	$Report = @"
</div>

</body>
</html>
"@
Return $Report
}

Function Get-HTMLTable {
	param([array]$Content)
	$HTMLTable = $Content | ConvertTo-Html -Fragment
	#$HTMLTable = $HTMLTable -replace '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">', ""
	#$HTMLTable = $HTMLTable -replace '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"  "http://www.w3.org/TR/html4/strict.dtd">', ""
	#$HTMLTable = $HTMLTable -replace '<html xmlns="http://www.w3.org/1999/xhtml">', ""
	#$HTMLTable = $HTMLTable -replace '<html>', ""
	#$HTMLTable = $HTMLTable -replace '<head>', ""
	#$HTMLTable = $HTMLTable -replace '<title>HTML TABLE</title>', ""
	#$HTMLTable = $HTMLTable -replace '</head><body>', ""
	#$HTMLTable = $HTMLTable -replace '</body></html>', ""
	$HTMLTable = $HTMLTable -replace '&lt;', "<"
	$HTMLTable = $HTMLTable -replace '&gt;', ">"
	Return $HTMLTable
}

Function Get-HTMLDetail ($Heading, $Detail){
$Report = @"
<TABLE>
	<tr>
	<th width='50%'><b>$Heading</b></font></th>
	<td width='50%'>$($Detail)</td>
	</tr>
</TABLE>
"@
Return $Report
}

Function Find-Username ($username){
	if ($username -ne $null)
	{
		$root = [ADSI]""
		$filter = ("(&(objectCategory=user)(samAccountName=$Username))")
		$ds = new-object  system.DirectoryServices.DirectorySearcher($root,$filter)
		$ds.PageSize = 1000
		$UN = $ds.FindOne()
		If ($UN -eq $null){
			Return $username
		}
		Else {
			Return $UN
		}
	}
}

function Get-VIServices
{
	If ($SetUsername -ne ""){
		$Services = get-wmiobject win32_service -Credential $creds -ComputerName $VISRV | Where {$_.DisplayName -like "VMware*" }
	} Else {
		$Services = get-wmiobject win32_service -ComputerName $VISRV | Where {$_.DisplayName -like "VMware*" }
	}
	
	$myCol = @()
	Foreach ($service in $Services){
		$MyDetails = "" | select-Object Name, State, StartMode, Health
		If ($service.StartMode -eq "Auto")
		{
			if ($service.State -eq "Stopped")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "Unexpected State"
			}
		}
		If ($service.StartMode -eq "Auto")
		{
			if ($service.State -eq "Running")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "OK"
			}
		}
		If ($service.StartMode -eq "Disabled")
		{
			If ($service.State -eq "Running")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "Unexpected State"
			}
		}
		If ($service.StartMode -eq "Disabled")
		{
			if ($service.State -eq "Stopped")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "OK"
			}
		}
		$myCol += $MyDetails
	}
	Write-Output $myCol
}

function Get-DatastoreSummary {
	param(
		$InputObject = $null
	)
	process {
		if ($InputObject -and $_) {
			throw 'The input object cannot be bound to any parameters for the command either because the command does not take pipeline input or the input and its properties do not match any of the parameters that take pipeline input.'
			return
		}
		$processObject = $(if ($InputObject) {$InputObject} else {$_})
		if ($processObject) {
			$myCol = @()
			foreach ($ds in $_)
			{
				$MyDetails = "" | select-Object Name, CapacityMB, FreeSpaceMB, PercFreeSpace
				$MyDetails.Name = $ds.Name
				#$MyDetails.Type = $ds.Type
				$MyDetails.CapacityMB = $ds.CapacityMB
				$MyDetails.FreeSpaceMB = $ds.FreeSpaceMB
				$MyDetails.PercFreeSpace = [math]::Round(((100 * ($ds.FreeSpaceMB)) / ($ds.CapacityMB)),0)
				$myCol += $MyDetails
			}
			$myCol | Where { $_.PercFreeSpace -lt $DatastoreSpace }
		}
	}
	end {
	}
}

function Get-SnapshotSummary {
	param(
		$InputObject = $null
	)

	PROCESS {
		if ($InputObject -and $_) {
			throw 'ParameterBinderStrings\AmbiguousParameterSet'
			break
		} elseif ($InputObject) {
			$InputObject
		} elseif ($_) {
			
			$mySnaps = @()
			foreach ($snap in $_){
				$SnapshotInfo = Get-SnapshotExtra $snap
				$mySnaps += $SnapshotInfo
			}

			$mySnaps | Select VM, Name, @{N="DaysOld";E={((Get-Date) - $_.Created).Days}}, @{N="Creator";E={(Find-Username (($_.Creator.split("\"))[1])).Properties.displayname}}, SizeMB, Created, Description -ErrorAction SilentlyContinue | Sort DaysOld

		} else {
			throw 'ParameterBinderStrings\InputObjectNotBound'
		}
	}
}

function Get-SnapshotTree{
	param($tree, $target)
	
	$found = $null
	foreach($elem in $tree){
		if($elem.Snapshot.Value -eq $target.Value){
			$found = $elem
			continue
		}
	}
	if($found -eq $null -and $elem.ChildSnapshotList -ne $null){
		$found = Get-SnapshotTree $elem.ChildSnapshotList $target
	}
	
	return $found
}

function Get-SnapshotExtra ($snap){
	$guestName = $snap.VM	# The name of the guest
	$tasknumber = 999		# Windowsize of the Task collector
	$taskMgr = Get-View TaskManager
	
	# Create hash table. Each entry is a create snapshot task
	$report = @{}
	
	$filter = New-Object VMware.Vim.TaskFilterSpec
	$filter.Time = New-Object VMware.Vim.TaskFilterSpecByTime
	$filter.Time.beginTime = (($snap.Created).AddDays(-5))
	$filter.Time.timeType = "startedTime"
	
	$collectionImpl = Get-View ($taskMgr.CreateCollectorForTasks($filter))
	
	$dummy = $collectionImpl.RewindCollector
	$collection = $collectionImpl.ReadNextTasks($tasknumber)
	while($collection -ne $null){
		$collection | where {$_.DescriptionId -eq "VirtualMachine.createSnapshot" -and $_.State -eq "success" -and $_.EntityName -eq $guestName} | %{
			$row = New-Object PsObject
			$row | Add-Member -MemberType NoteProperty -Name User -Value $_.Reason.UserName
			$vm = Get-View $_.Entity
			if($vm -ne $null){ 
				$snapshot = Get-SnapshotTree $vm.Snapshot.RootSnapshotList $_.Result
				if($snapshot -ne $null){
					$key = $_.EntityName + "&" + ($snapshot.CreateTime.ToString())
					$report[$key] = $row
				}
			}
		}
		$collection = $collectionImpl.ReadNextTasks($tasknumber)
	}
	$collectionImpl.DestroyCollector()
	
	# Get the guest's snapshots and add the user
	$snapshotsExtra = $snap | % {
		$key = $_.vm.Name + "&" + ($_.Created.ToString())
		if($report.ContainsKey($key)){
			$_ | Add-Member -MemberType NoteProperty -Name Creator -Value $report[$key].User
		}
		$_
	}
	$snapshotsExtra
}

Function Set-Cred ($File) {
	$Credential = Get-Credential
	$credential.Password | ConvertFrom-SecureString | Set-Content $File
}

Function Get-Cred ($User,$File) {
	$password = Get-Content $File | ConvertTo-SecureString
	$credential = New-Object System.Management.Automation.PsCredential($user,$password)
	$credential
}

function Get-UnShareableDatastore {
	$Report = @()
	Foreach ($datastore in (Get-Datastore)){
		If (($datastore | get-view).summary.multiplehostaccess -eq $false){
			ForEach ($VM in (get-vm -datastore $Datastore )){
				$SAHost = "" | Select VM, Datastore
				$SAHost.VM = $VM.Name 
				$SAHost.Datastore = $Datastore.Name
				$Report += $SAHost
			}
		}
	}
	$Report
}

If ($SetUsername -ne ""){
	if ((Test-Path -Path $CredFile) -eq $false) {
		Set-Cred $CredFile
	}
	$creds = Get-Cred $SetUsername $CredFile
}

# PowerCLI Version Checker
if (!(Get-Command Get-PowerCLIVersion -errorAction SilentlyContinue)) {
	Write-Host "PowerCLI does not appear to be installed on this computer.  vCheck will not continue."
	send-SMTPmail -to $EmailTo -from $EmailFrom -subject "ERROR: $VISRV vCheck" -smtpserver $SMTPSRV -body "The Get-PowerCLIVersion Cmdlet was not found, please check your vCheck client machine [$($ENV:Computername)]."
	exit
}

Write-CustomOut "Connecting to VI Server"
$VIServer = Connect-VIServer $VISRV
If ($VIServer.IsConnected -ne $true){
	# Fix for scheduled tasks not running.
	$USER = $env:username
	$APPPATH = "C:\Documents and Settings\" + $USER + "\Application Data"

	#SET THE APPDATA ENVIRONMENT WHEN NEEDED
	if ($env:appdata -eq $null -or $env:appdata -eq 0)
	{
		$env:appdata = $APPPATH
	}
	$VIServer = Connect-VIServer $VISRV
	If ($VIServer.IsConnected -ne $true){
		Write $VIServer
		send-SMTPmail -to $EmailTo -from $EmailFrom -subject "ERROR: $VISRV vCheck" -smtpserver $SMTPSRV -body "The Connect-VISERVER Cmdlet did not work, please check you VI Server."
		exit
	}
	
}

# Find out which version of the API we are connecting to
If ((Get-View ServiceInstance).Content.About.Version -ge "4.0.0"){
	$VIVersion = 4
}
Else{
	$VIVersion = 3
}

Write-CustomOut "Collecting VM Objects"
$VM = Get-VM | Sort Name
Write-CustomOut "Collecting Datacenter Objects"
$Datacenter = get-datacenter | sort name
Write-CustomOut "Collecting VM Host Objects"
$VMH = Get-VMHost | Sort Name
Write-CustomOut "Collecting Cluster Objects"
$Clusters = Get-Cluster | Sort Name
Write-CustomOut "Collecting Datastore Objects"
$Datastores = Get-Datastore | Sort Name
Write-CustomOut "Collecting Detailed VM Objects"
$FullVM = Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}
Write-CustomOut "Collecting Template Objects"
$VMTmpl = Get-Template
Write-CustomOut "Collecting Detailed VI Objects"
$serviceInstance = get-view ServiceInstance
Write-CustomOut "Collecting Detailed Alarm Objects"
$alarmMgr = get-view $serviceInstance.Content.alarmManager
Write-CustomOut "Collecting Detailed VMHost Objects"
$HostsViews = Get-View -ViewType hostsystem

$Date = Get-Date

# Check for vSphere
If ($serviceInstance.Client.ServiceContent.About.Version -ge 4){
	$vSphere = $true
}

$MyReport = Get-CustomHTML "$VIServer vCheck"
	$MyReport += Get-CustomHeader0 ($VIServer.Name)
		
		# ---- General Summary Info ----
		If ($ShowGenSum){
			Write-CustomOut "..Adding General Summary Info to the report"
			$CommentsSet = $Comments
			$Comments = $false
			$MyReport += Get-CustomHeader "General Details" ""
				$MyReport += Get-HTMLDetail "Number of Hosts:" (@($VMH).Count)
				$MyReport += Get-HTMLDetail "Number of VMs:" (@($VM).Count)
				$MyReport += Get-HTMLDetail "Number of Templates:" (@($VMTmpl).Count)
				$MyReport += Get-HTMLDetail "Number of Clusters:" (@($Clusters).Count)
				$MyReport += Get-HTMLDetail "Number of Datastores:" (@($Datastores).Count)
				$MyReport += Get-HTMLDetail "Active VMs:" (@($FullVM | Where { $_.Runtime.PowerState -eq "poweredOn" }).Count) 
				$MyReport += Get-HTMLDetail "In-active VMs:" (@($FullVM | Where { $_.Runtime.PowerState -eq "poweredOff" }).Count) 
				$MyReport += Get-HTMLDetail "DRS Migrations for last $($DRSMigrateAge) Days:" @(Get-VIEvent -maxsamples 10000 -Start ($Date).AddDays(-$DRSMigrateAge ) | where {$_.Gettype().Name -eq "DrsVmMigratedEvent"}).Count
			$Comments = $CommentsSet
			$MyReport += Get-CustomHeaderClose
		}
		
		# Capacity Planner Info
		if ($ShowCapacityInfo){
			Write-CustomOut "..Checking Capacity Info"
			$capacityinfo = @()
			
			foreach ($cluv in (Get-View -ViewType ClusterComputeResource)){
				if ((Get-Cluster $cluv.name|Get-VM).count -gt 0){
					$clucapacity = "" |Select ClusterName, "Estimated Num VM Left (CPU)", "Estimated Num VM Left (MEM)"
					#CPU
					$DasRealCpuCapacity = $cluv.Summary.EffectiveCpu - (($cluv.Summary.EffectiveCpu*$cluv.Configuration.DasConfig.FailoverLevel)/$cluv.Summary.NumEffectiveHosts)
					$CluCpuUsage = get-stat -entity $cluv.name -stat cpu.usagemhz.average -Start ($Date).adddays(-7) -Finish ($Date)
					$CluCpuUsageAvg = ($CluCpuUsage|Where-object{$_.value -gt ($CluCpuUsage|Measure-Object -average -Property value).average}|Measure-Object -Property value -Average).Average
					$VmCpuAverage = $CluCpuUsageAvg/(Get-Cluster $cluv.name|Get-VM).count
					$CpuVmLeft = [math]::round(($DasRealCpuCapacity-$CluCpuUsageAvg)/$VmCpuAverage,0)
				
					#MEM
					$DasRealMemCapacity = $cluv.Summary.EffectiveMemory - (($cluv.Summary.EffectiveMemory*$cluv.Configuration.DasConfig.FailoverLevel)/$cluv.Summary.NumEffectiveHosts)
					$CluMemUsage = get-stat -entity $cluv.name -stat mem.consumed.average -Start ($Date).adddays(-7) -Finish ($Date)
					$CluMemUsageAvg = ($CluMemUsage|Where-object{$_.value -gt ($CluMemUsage|Measure-Object -average -Property value).average}|Measure-Object -Property value -Average).Average/1024
					$VmMemAverage = $CluMemUsageAvg/(Get-Cluster $cluv.name|Get-VM).count
					$MemVmLeft = [math]::round(($DasRealMemCapacity-$CluMemUsageAvg)/$VmMemAverage,0)
				
					$clucapacity.ClusterName = $cluv.name
					$clucapacity."Estimated Num VM Left (CPU)" = $CpuVmLeft
					$clucapacity."Estimated Num VM Left (MEM)" = $MemVmLeft
				
					$capacityinfo += $clucapacity
				}
			}
			If (($capacityinfo | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Capacity Planner Info" "The following gives brief capacity information for each cluster based on average CPU/Mem usage and counting for HA failover requirements"
					$MyReport += Get-HTMLTable $capacityinfo
				$MyReport += Get-CustomHeaderClose
			}
			
			Write-CustomOut "..Checking Capacity Info (disk)"
			$diskcapacityinfo = @()
			
			# The disk forecast will be per datacenter instead of per cluster since
			# Get-Datastore -Entity only supports VirtualMachine, VMHost, and Datacenter objects.
			# To improve performance in code, we are going to make the following assumptions
			#   Assumption 1.) Disk capacity - Free Space = space used by VMs
			#   Assumption 2.) used space / count of VMs = Avg Space used per VM
			#   Assumption 3.) we will reserve 15% of capacity for overhead
			
			foreach ($dc in $Datacenter) {
				Clear-Variable forecast*
				Get-Datastore -Entity $dc | Get-View | %{ 
					if ($LimitDiskCapacityForecastToSharedStorageOnly) {
						$_ | where-object {$_.Summary.MultipleHostAccess -eq $true} | %{$forecastDiskCapacity += $_.Summary.Capacity; $forecastDiskFree += $_.Summary.FreeSpace}
					} else {
						$_ | %{$forecastDiskCapacity += $_.Summary.Capacity; $forecastDiskFree += $_.Summary.FreeSpace}
					}
				}
				$forecastUsedSpace = (0.85 * $forecastDiskCapacity) - $forecastDiskFree
				
				$existingVmCount = (Get-VM -Location $dc).Count
				if ($existingVmCount -ne 0){
					$forecastAveragedUsedPerVM = $forecastUsedSpace / $existingVmCount
					if ($forecastAveragedUsedPerVM -ne 0) {
						$forecastVMcount = [math]::round(($forecastDiskFree / $forecastAveragedUsedPerVM),1)
					}
				}
				
				if ($forecastVMcount -ne $null) {
					$dcdiskcapacity = "" |select "DataCenter Name", "Existing VM Count", "Average used per VM (MB)", "Estimated Num VM Left (Disk)"
					$dcdiskcapacity."DataCenter Name" = $dc.Name
					$dcdiskcapacity."Existing VM Count" = $existingVmCount
					$dcdiskcapacity."Average used per VM (MB)" =  "{0:N1}" -f [math]::round(($forecastAveragedUsedPerVM/1024/1024),1)
					$dcdiskcapacity."Estimated Num VM Left (Disk)" = $forecastVMcount
					$diskcapacityinfo += $dcdiskcapacity
				}
			}
			
			If (($diskcapacityinfo | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Capacity Planner Info (Storage)" "The following gives brief capacity information for virtual machine storage per datacenter."
				$MyReport += Get-HTMLTable $diskcapacityinfo
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# Cluster CPU allocation ratios
		if ($ShowCPUClusterRatio){
			Write-CustomOut "..Checking Cluster CPU ratio"
			$FullClusterDetail = @()
			Foreach ($Cluster in $Clusters){
				$guestcnt,$clustervcpu,$hostCount,$clustercores = 0,0,0,0
				Foreach ($ESXHost in ($Cluster |Get-VMHost |Sort Name)){
					$hostview = $ESXHost | get-view
					$guestvcpu = 0
					foreach ($clustCpuVM in ($ESXHost |Get-VM)){
						$guestcnt += 1
						$guestvcpu += ($clustCpuVM).NumCpu
					}
					$hdwrCores = $hostview.Hardware.CpuInfo.NumCpuCores
					$hostCount += 1
					$clustercores += $hdwrCores
					$clustervcpu += $guestvcpu
				}
				$ClusterDetails = "" | Select Name, Hosts, Cores, Guests, vCPU_Count,vCPU_per_VM, vCPU_per_Core
				$ClusterDetails.name = $Cluster
				$ClusterDetails.hosts = $hostCount
				$ClusterDetails.cores = $clustercores
				$ClusterDetails.guests = $guestcnt
				$ClusterDetails.vCPU_Count = $clustervcpu
				$ClusterDetails.vCPU_per_VM = ([math]::round(($clustervcpu/$guestcnt), 2))
				$ClusterDetails.vCPU_per_Core = ([math]::round(($clustervcpu/$clustercores), 2))
				$FullClusterDetail += $ClusterDetails
			}	
			If (($FullClusterDetail | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Cluster CPU Allocation ratio" "The following gives brief cluster level view of vCPU and physical core allocation ratios."
				$MyReport += Get-HTMLTable $FullClusterDetail
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# We need to know the version number even if it doesn't show up on the report
		$powercliVersion = Get-PowerCliVersion
		
		# Get the latest version of vCenter Update Manager snapins
		# http://communities.vmware.com/community/vmtn/vsphere/automationtools/powercli/updatemanager
		# As of 2010/12/29 the latest version is 4.1 build 266648 @ http://www.vmware.com/downloads/download.do?downloadGroup=VUM41PCLI
		$vPowercliVersion = @()
		for ($i = 0; $i -lt $powercliVersion.SnapinVersions.Count; $i++) {
			 $myObj = "" | Select Name, Build
			 $myObj.Name = $powercliVersion.SnapinVersions[$i].userFriendlyVersion
			 $myObj.Build = $powercliVersion.SnapinVersions[$i].Build
			 $vPowercliVersion += $myObj
			#This is for later; we are creating a variable for the vCenter Update Manager version
			#to be used by $ShowHostVUMNonCompliance check
			if ($powercliVersion.SnapinVersions[$i].userFriendlyVersion -match "Update Manager") { 
				$powerclivumVersion = $powercliVersion.SnapinVersions[$i]
			}
		}
		
		if ($showPowerCLIVersion) {	
			If (($vPowercliVersion | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "PowerCLI Version Information" "Please verify that you are running a version of PowerCLI which relates to your environment.  This script was tested with 4.1 U1 build 332441."
				$MyReport += Get-HTMLTable $vPowercliVersion
				$MyReport += Get-CustomHeaderClose
			}
		}

		# ---- Snapshot Information ----
		If ($ShowSnap){
			Write-CustomOut "..Checking Snapshots"
			$Snapshots = @($VM | Get-Snapshot | Where {$_.Created -lt (($Date).AddDays(-$SnapshotAge))} | Get-SnapshotSummary)
			If (($Snapshots | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Snapshots (Over $SnapshotAge Days Old) : $($snapshots.count)" "VMware snapshots which are kept for a long period of time may cause issues, filling up datastores and also may impact performance of the virtual machine."
					$MyReport += Get-HTMLTable $Snapshots
				$MyReport += Get-CustomHeaderClose
			}
		}
				
		# ---- Datastore Information ----
		If ($Showdata){
			Write-CustomOut "..Checking Datastores"
			$OutputDatastores = @($Datastores | Get-DatastoreSummary | Sort PercFreeSpace)
			If (($OutputDatastores | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Datastores (Less than $DatastoreSpace% Free) : $($OutputDatastores.count)" "Datastores which run out of space will cause impact on the virtual machines held on these datastores"
					$MyReport += Get-HTMLTable $OutputDatastores
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Map disk region ----
		If ($ShowMapDiskRegionEvents){
			Write-CustomOut "..Checking for Map disk region event"
			$MapDiskRegionEvents = @($VIEvent | Where {$_.FullFormattedMessage -match "Map disk region"} | Foreach {$_.vm}|select name |Sort-Object -unique)
			If (($MapDiskRegionEvents | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Map disk region event (Last $VMsNewRemovedAge Day(s)) : $($MapDiskRegionEvents.count)" "These may occur due to VCB issues, check <a href='http://kb.vmware.com/kb/1007331' target='_blank'>this article</a> for more details "
					$MyReport += Get-HTMLTable $MapDiskRegionEvents
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- SSL Certificate Checker ----
		Write-CustomOut "..Checking for SSL Certificate Status"
		if ($showSSLexpiration){
			function Check-SSLCertificate () {
				#Found starting point here:
				#http://myitpath.blogspot.com/2010/03/checking-ssl-cert-values-with.html
				$myhostname = $args[0]
				$port = $args[1]
				
				$myObj = "" | select HostName, IssuedBy, Expires, Status
				
				try {
				    $conn = new-object system.net.sockets.tcpclient($myhostname,$port)
				} catch {
				    $myObj.Hostname = $myhostname
				    $myObj.IssuedBy = "Unable to reach host on port $port"
				    $myObj.Expires = "Unknown"
				    $myObj.Status = "Error"
				    return $myObj
				}
				if ($conn -ne $null) {
					$stream = new-object system.net.security.sslstream($conn.getstream())
					#send hostname on cert to try SSL negotiation
					try {
						$stream.authenticateasclient($myhostname) 2> $errorString
					} catch {
						$myObj.Hostname = $myhostname
						$myObj.IssuedBy = "SSL Failure - Unable to AuthenticateAsClient"
						$myObj.Expires = "Unknown"
						$myObj.Status = "Error"
						return $myObj
					}
					if ($?) {
						#if connection succeeds, get cert information
						$cert = $stream.get_remotecertificate()
						      
						if ($stream.isauthenticated) {
							#stream is authenticated, so print out success and expiration information read from cert
							$validto = $cert.getexpirationdatestring()
							$issuer =  $cert.get_issuer()
							$expirationDays = (New-TimeSpan $date $validto).days
							
							$myObj.HostName = $myhostname
							$myObj.IssuedBy = $issuer.Replace(" DC=","").Replace("CN=","").Replace(",",".")
							$myObj.Expires = $validto
							if ($expirationDays -lt 45) {
								$myObj.Status = "Warning"
							} else {
								$myObj.Status = "Normal"
							}
							return $myObj
						}
					}
				}
			}
			
			$MySslObj = @()
			$SslDetails = "" | Select HostName, IssuedBy, Expires, Status
			#First we will check the vCenter Server SSL Certificate
			$SslDetails = Check-SSLCertificate $VIServer.name $VIServer.Port
			if ($SslDetails.Status -ne "Normal") {
			    	$mySslObj += $SslDetails 
			}
			
			#Then we will check each host certificate.
			Foreach ($VMHost in $VMH) {
			    $hview = $vmHost |get-view
			    $SslDetails = "" | Select HostName, IssuedBy, Expires, Status
			    $SslDetails = Check-SSLCertificate $VMHost.name $hview.Summary.Config.Port
			    if ($SslDetails.Status -ne "Normal") {
			    	$mySslObj += $SslDetails 
			    }
			}

			If (($MySslObj | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "SSL Status Check : $($MySslObj.count)" "SSL Certificates should be replaced with ones issued from a trusted authority."
				$MyReport += Get-HTMLTable $MySslObj
				$MyReport += Get-CustomHeaderClose
			}
		
		}
		
		# ---- Hosts in Maintenance Mode ----
		If ($ShowMaint){
			Write-CustomOut "..Checking Hosts in Maintenance Mode"
			$MaintHosts = @($VMH | where {$_.ConnectionState -match "Maintenance"} | Select Name, ConnectionState)
			If (($MaintHosts | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Hosts in Maintenance Mode : $($MaintHosts.count)" "Hosts held in Maintenance mode will not be running any virtual machine worloads, check the below Hosts are in an expected state"
					$MyReport += Get-HTMLTable $MaintHosts
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Hosts Not responding or Disconnected ----
		If ($ShowResDis){
			Write-CustomOut "..Checking Hosts Not responding or Disconnected"
			$RespondHosts = @($VMH | where {$_.ConnectionState -ne "Connected" -and $_.State -ne "Maintenance"} | get-view | Select name, @{N="Connection State";E={$_.Runtime.ConnectionState}}, @{N="Power State";E={$_.Runtime.PowerState}})
			If (($RespondHosts | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Hosts not responding or disconnected : $($RespondHosts.count)" "Hosts which are in a disconnected state will not be running any virtual machine worloads, check the below Hosts are in an expected state"
				$MyReport += Get-HTMLTable $RespondHosts
				$MyReport += Get-CustomHeaderClose
			}
		}

		# ---- Hosts which are overcomitting ----
		If ($ShowOvercommit){
			Write-CustomOut "..Checking Hosts Overcommit state"
			$MyObj = @()
			Foreach ($VMHost in $VMH) {
				$Details = "" | Select Host, TotalMemMB, TotalAssignedMemMB, TotalUsedMB, OverCommitMB
				$Details.Host = $VMHost.Name
				$Details.TotalMemMB = $VMHost.MemoryTotalMB
				if ($VMMem) { Clear-Variable VMMem }
				Get-VMHost $VMHost | Get-VM | Foreach {
					[INT]$VMMem += $_.MemoryMB
				}
				$Details.TotalAssignedMemMB = $VMMem
				$Details.TotalUsedMB = $VMHost.MemoryUsageMB
				If ($Details.TotalAssignedMemMB -gt $VMHost.MemoryTotalMB) {
					$Details.OverCommitMB = ($Details.TotalAssignedMemMB - $VMHost.MemoryTotalMB)
				} Else {
					$Details.OverCommitMB = 0
				}
				$MyObj += $Details
			}
			$OverCommit = @($MyObj | Where {$_.OverCommitMB -gt 0})
			If (($OverCommit | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Hosts overcommiting memory : $($OverCommit.count)" "Overcommitted hosts may cause issues with performance if memory is not issued when needed, this may cause ballooning and swapping"
				$MyReport += Get-HTMLTable $OverCommit
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Host hardware issues ---- 
		#bwuch Hardware request feature request from RobVM
		#      with help from http://spininfo.homelinux.com/news/vSphere_PowerCLI/2009/12/13/Vsphere_Host_Health_status_-_VI_SDK
		Write-CustomOut "..Checking host hardware issues"
		$MyObj = @()
		if ($ShowHostHdwrIssues) {
			foreach ($hdwrCheckHost in $VMH) {
				$esx = Get-VMHost $hdwrCheckHost | Get-View
				$systemHealthInfo = $esx.Runtime.HealthSystemRuntime.SystemHealthInfo
				for($i = 0; $i -lt $systemHealthInfo.NumericSensorInfo.Count; $i++){
					if ($systemHealthInfo.NumericSensorInfo[$i].HealthState.key -ne "green") {
						$Details = "" | Select Host, SensorName, SensorType, SensorStatus
						$Details.Host = $hdwrCheckHost
						$Details.SensorName = $systemHealthInfo.NumericSensorInfo[$i].Name
						$Details.SensorType = $systemHealthInfo.NumericSensorInfo[$i].SensorType
						$Details.SensorStatus = $systemHealthInfo.NumericSensorInfo[$i].HealthState.key
						$myObj += $Details
					}
				}
			}
			
			If (($myObj | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Hosts with hardware sensor issues : $($myObj.count)" "Non-green status on host hardware sensors may indicate a possible hardware issue and may require investigation."
				$MyReport += Get-HTMLTable $myObj
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Dead LunPath ----
		If ($ShowLunPath){
			Write-CustomOut "..Checking Hosts Dead Lun Path"
			$deadluns = @()
			foreach ($esxhost in ($VMH | where {$_.ConnectionState -eq "Connected" -or $_.ConnectionState -eq "Maintenance"}))
			{
				$esxluns = Get-ScsiLun -vmhost $esxhost |Get-ScsiLunPath
				foreach ($esxlun in $esxluns){
					if ($esxlun.state -eq "Dead") {
						$myObj = "" |
						Select VMHost, Lunpath, ConnectionState
						$myObj.VMHost = $esxhost
						$myObj.Lunpath = $esxlun.Lunpath
						$myObj.ConnectionState = $esxlun.state
						$deadluns += $myObj
					}    
				}
			}
			If (($deadluns | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Dead LunPath : $($deadluns.count)" "Dead LUN Paths may cause issues with storage performance or be an indication of loss of redundancy"
				$MyReport += Get-HTMLTable $deadluns
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VM Guest OS Pivot Table ----
		if ($GuestOSPivot) {
			Write-CustomOut "..Creating Guest OS Pivot table"
			$VMOSversions = @{ }
			$VM | Get-View | % {
				# Prefer to use GuestFullName but try AltGuestName first
				if ($_.Config.AlternateGuestName) { $VMOSversion = $_.Config.AlternateGuestName }
				if ($_.Guest.GuestFullName) { $VMOSversion = $_.Guest.GuestFullName }
				# Seeing if any of these options worked
			        if (!($VMOSversion)) { 
					# No 'version' so checking for tools
					if (!($_.Guest.ToolsStatus.Value__ )) { 
						$VMOSversion = "Unknown - no VMTools" 
					} else { 
					# Still no 'version', must be old tools
						$toolsversion = $_.Config.Tools.ToolsVersion
						$VMOSversion = "Unknown - tools version $toolsversion"
					}
				}			
				$VMOSversions.$VMOSversion++
			}
			
			$myCol = @()
			foreach ( $gosname in $VMOSversions.Keys | sort) {
				$MyDetails = "" | select OS, Count
				$MyDetails.OS = $gosname
				$MyDetails.Count = $VMOSversions.$gosname
				$myCol += $MyDetails
			}
			
			$vVMOSversions = $myCol | sort Count -desc
			If (($vVMOSversions | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VMs by Operating System : $($vVMOSversions.count)" "The following Operating Systems are in use in this vCenter."
				$MyReport += Get-HTMLTable $vVMOSversions
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMs created or Cloned ----
		If ($ShowCreated){
			Write-CustomOut "..Checking for created or cloned VMs"
			$VIEvent = Get-VIEvent -maxsamples 10000 -Start ($Date).AddDays(-$VMsNewRemovedAge)
			$OutputCreatedVMs = @($VIEvent | where {$_.Gettype().Name -eq "VmCreatedEvent" -or $_.Gettype().Name -eq "VmBeingClonedEvent" -or $_.Gettype().Name -eq "VmBeingDeployedEvent"} | Select createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)
			If (($OutputCreatedVMs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VMs Created or Cloned (Last $VMsNewRemovedAge Day(s)) : $($OutputCreatedVMs.count)" "The following VMs have been created over the last $($VMsNewRemovedAge) Days"
					$MyReport += Get-HTMLTable $OutputCreatedVMs
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMs Removed ----
		If ($ShowRemoved){
			Write-CustomOut "..Checking for removed VMs"
			$OutputRemovedVMs = @($VIEvent | where {$_.Gettype().Name -eq "VmRemovedEvent"}| Select createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)
			If (($OutputRemovedVMs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VMs Removed (Last $VMsNewRemovedAge Day(s)) : $($OutputRemovedVMs.count)" "The following VMs have been removed/deleted over the last $($VMsNewRemovedAge) days"
					$MyReport += Get-HTMLTable $OutputRemovedVMs
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMs vCPU ----
		If ($Showvcpu){
			Write-CustomOut "..Checking for VMs with over $vCPU vCPUs"
			$OverCPU = @($VM | Where {$_.NumCPU -gt $vCPU} | Select Name, PowerState, NumCPU)
			If (($OverCPU | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VMs with over $vCPU vCPUs : $($OverCPU.count)" "The following VMs have over $vCPU CPU(s) and may impact performance due to CPU scheduling"
					$MyReport += Get-HTMLTable $OverCPU
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMs Swapping or Ballooning ----
		If ($ShowSwapBal){
			Write-CustomOut "..Checking for VMs swapping or Ballooning"
			$BALSWAP = $vm | Where {$_.PowerState -eq "PoweredOn" }| Select Name, VMHost, @{N="SwapKB";E={(Get-Stat -Entity $_ -Stat mem.swapped.average -Realtime -MaxSamples 1 -ErrorAction SilentlyContinue).Value}}, @{N="MemBalloonKB";E={(Get-Stat -Entity $_ -Stat mem.vmmemctl.average -Realtime -MaxSamples 1 -ErrorAction SilentlyContinue).Value}}
			$bs = @($BALSWAP | Where { $_.SwapKB -gt 0 -or $_.MemBalloonKB -gt 0}) | Sort SwapKB -Descending
			If (($bs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VMs Ballooning or Swapping : $($bs.count)" "Ballooning and swapping may indicate a lack of memory or a limit on a VM, this may be an indication of not enough memory in a host or a limit held on a VM, <a href='http://www.virtualinsanity.com/index.php/2010/02/19/performance-troubleshooting-vmware-vsphere-memory/' target='_blank'>further information is available here</a>."
					$MyReport += Get-HTMLTable $bs
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# invalid or inaccessible VM
		if ($ShowBlindedVM) {
		Write-CustomOut "..Checking invalid or inaccessible VM"
			$BlindedVM = $FullVM|?{$_.Runtime.ConnectionState -eq "invalid" -or $_.Runtime.ConnectionState -eq "inaccessible"}|sort name |select name
			If (($BlindedVM | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VM invalid or inaccessible : $(($BlindedVM | Measure-Object).count)" "The following VMs are marked as inaccessible or invalid"
				$MyReport += Get-HTMLTable $BlindedVM
				$MyReport += Get-CustomHeaderClose
			}		
		}		
		
		# ---- HA VM reset log ----
		If ($HAVMreset){
			Write-CustomOut "..Checking HA VM reset"
			$HAVMresetlist = @(Get-VIEvent -maxsamples 100000 -Start ($Date).AddDays(-$HAVMresetold) -type info |?{$_.FullFormattedMessage -match "reset due to a guest OS error"} |select CreatedTime,FullFormattedMessage |sort CreatedTime -Descending)
			If (($HAVMresetlist | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "HA VM reset (Last $HAVMresetold Day(s)) : $($HAVMresetlist.count)" "The following VMs have been restarted by HA in the last $HAVMresetold days"
					$MyReport += Get-HTMLTable $HAVMresetlist
				$MyReport += Get-CustomHeaderClose
			}
		}	
	
		# ---- HA VM restart log ----
		If ($HAVMrestart){
			Write-CustomOut "..Checking HA VM restart"
			$HAVMrestartlist = @(Get-VIEvent -maxsamples 100000 -Start ($Date).AddDays(-$HAVMrestartold) -type info |?{$_.FullFormattedMessage -match "was restarted"} |select CreatedTime,FullFormattedMessage |sort CreatedTime -Descending)
			If (($HAVMrestartlist | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "HA VM restart (Last $HAVMrestartold Day(s)) : $($HAVMrestartlist.count)" "The following VMs have been restarted by HA in the last $HAVMresetold days"
					$MyReport += Get-HTMLTable $HAVMrestartlist
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VMSwapfileDatastore not set----
		If ($Showswapfile){
			Write-CustomOut "..Checking Host Swapfile datastores"
			$cluswap = @()
			foreach ($clusview in $clusviews) {
				if ($clusview.ConfigurationEx.VmSwapPlacement -eq "hostLocal") {
					$CluNodesViews = Get-VMHost -Location $clusview.name |Get-View
					foreach ($CluNodesView in $CluNodesViews) {
						if ($CluNodesView.Config.LocalSwapDatastore.Value -eq $null) {
							$Details = "" | Select-Object Cluster, Host, Message
							$Details.cluster = $clusview.name
							$Details.host = $CluNodesView.name
							$Details.Message = "Swapfile location NOT SET"
							$cluswap += $Details
						}
					}
				}
			}
		
			If (($cluswap | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$cluswap = $cluswap | sort name
				$MyReport += Get-CustomHeader "VMSwapfileDatastore(s) not set : $($cluswap.count)" "The following hosts are in a cluster which is set to store the swapfile in the datastore specified by the host but no location has been set on the host"
					$MyReport += Get-HTMLTable $cluswap
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- DRS Migrations ----
		If ($ShowDRSMig){
			Write-CustomOut "..Checking DRS Migrations"
			$DRSMigrations = @(Get-VIEvent -maxsamples 10000 -Start ($Date).AddDays(-$DRSMigrateAge ) | where {$_.Gettype().Name -eq "DrsVmMigratedEvent"} | select createdTime, fullFormattedMessage)
			If (($DRSMigrations | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "DRS Migrations (Last $DRSMigrateAge Day(s)) : $($DRSMigrations.count)" "Multiple DRS Migrations may be an indication of overloaded hosts, check resouce levels of the cluster"
					$MyReport += Get-HTMLTable $DRSMigrations
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# --- Cluster Slot Sizes ---
		If ($Showslot){
			If ($vSphere -eq $true){
				Write-CustomOut "..Checking Cluster Slot Sizes"
				$SlotInfo = @()
				Foreach ($Cluster in ($Clusters| Get-View)){
					If ($Cluster.Configuration.DasConfig.Enabled -eq $true){
						$SlotDetails = $Cluster.RetrieveDasAdvancedRuntimeInfo()
						$Details = "" | Select Cluster, TotalSlots, UsedSlots, AvailableSlots
						$Details.Cluster = $Cluster.Name
						$Details.TotalSlots =  $SlotDetails.TotalSlots
						$Details.UsedSlots = $SlotDetails.UsedSlots
						$Details.AvailableSlots = $SlotDetails.UnreservedSlots
						$SlotInfo += $Details
					}
				}
				$SlotCHK = @($SlotInfo | Where { $_.AvailableSlots -lt $numslots})
				If (($SlotCHK | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
					$MyReport += Get-CustomHeader "Clusters with less than $numslots Slot Sizes : $($SlotCHK.count)" "Slot sizes in the below cluster are less than is specified, this may cause issues with creating new VMs, for more information click here: <a href='http://www.yellow-bricks.com/vmware-high-availability-deepdiv/' target='_blank'>Yellow-Bricks HA Deep Dive</a>"
						$MyReport += Get-HTMLTable $SlotCHK
					$MyReport += Get-CustomHeaderClose	
				}
			}
		}
		
		# ---- VM Disk Space - Less than x MB ----
		If ($ShowGuestDisk){
			Write-CustomOut "..Checking for Guests with less than $MBFree MB"
			$MyCollection = @()
			$AllVMs = $FullVM | Where {-not $_.Config.Template } | Where { $_.Runtime.PowerState -eq "poweredOn" -And ($_.Guest.toolsStatus -ne "toolsNotInstalled" -And $_.Guest.ToolsStatus -ne "toolsNotRunning")}
			$SortedVMs = $AllVMs | Select *, @{N="NumDisks";E={@($_.Guest.Disk.Length)}} | Sort-Object -Descending NumDisks
			ForEach ($VMdsk in $SortedVMs){
				$Details = New-object PSObject
				$DiskNum = 0
				Foreach ($disk in $VMdsk.Guest.Disk){
					if (([math]::Round($disk.FreeSpace/ 1MB)) -lt $MBFree){
						$Details | Add-Member -Name Name -Value $VMdsk.name -Membertype NoteProperty
						$Details | Add-Member -Name "Disk$($DiskNum)path" -MemberType NoteProperty -Value $Disk.DiskPath
						$Details | Add-Member -Name "Disk$($DiskNum)Capacity(MB)" -MemberType NoteProperty -Value ([math]::Round($disk.Capacity/ 1MB))
						$Details | Add-Member -Name "Disk$($DiskNum)FreeSpace(MB)" -MemberType NoteProperty -Value ([math]::Round($disk.FreeSpace / 1MB))
						$DiskNum++
						$MyCollection += $Details
						}
				}
				
			}
			If (($MyCollection | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VMs with less than $MBFree MB : $($MyCollection.count)" "The following guests have less than $MBFree MB Free, if a guest disk fills up it may cause issues with the guest Operating System"
					$MyReport += Get-HTMLTable $MyCollection
				$MyReport += Get-CustomHeaderClose	
			}
		}
		
		#Stuff added by bwuch:
		
		
		if ($ShowThickDisk) {       
		    Write-CustomOut "..Checking for thick provisioned virtual disk files"
		    $thickdisks = @()
		    foreach ($vmguest in ($VM | get-view))
		    {
		        $name = $vmguest.name
		        $vmguest.Config.Hardware.Device | where {$_.GetType().Name -eq "VirtualDisk"} |  %{
		        if(!$_.Backing.ThinProvisioned){
		            $myObj = "" |
		            select Name,Label,File,CapacityGB
		            $myObj.Name = $name
		            $myObj.Label = $_.DeviceInfo.Label
		            $myObj.File = $_.Backing.FileName
		            $myObj.CapacityGB = [math]::round(($_.CapacityInKB / 1024 / 1024),2)
		            $thickdisks += $myObj
		            }
		        }   
		    }
		    If (($thickdisks | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
		    $myReport += Get-CustomHeader "Thick provisioned virtual disks : $($thickdisks.count)" "Standard virtual disks in this environment are thin provisioned.  Thick provisioned disks represent a possible waste of storage space and should only be used when disk I/O performance is a top concern."
		    $myReport += Get-HTMLTable $thickdisks
		    $MyReport += Get-CustomHeaderClose
		    }
		}
		
		#--------------------
		if ($ShowMisnamedVM) {
		    Write-CustomOut "..Finding mis-named VMs"
		    $misnamed = @()
		    foreach ($vmguest in ($FullVM | where { $_.Guest.HostName -ne $NULL -AND $_.Guest.HostName -notmatch $_.Name }))
		    {
		        $myObj = "" | select VMName,GuestName
		        $myObj.VMName = $vmguest.name
		        $myObj.GuestName = $vmguest.Guest.HostName
		        $misnamed += $myObj
		    }
		    If (($misnamed | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
		    $myReport += Get-CustomHeader "Mis-named virtual machines : $($misnamed.count)" "The following guest names do not match the name inside of the guest."
		    $myReport += Get-HTMLTable $misnamed
		    $MyReport += Get-CustomHeaderClose
		    }
		}
		
		#--------------------
		if ($ShowWrongOS) {
		    Write-CustomOut "..Finding guests with wrong OS selected."
		    $wrongOS = @()
		    foreach ($vmguest in ($VM | get-view | 
		    where ({ $_.Guest.GuestFullname -ne $NULL -AND $_.Guest.GuestFullname -ne $_.Summary.Config.GuestFullName})))
		    {
		        $myObj = "" | select Name,InstalledOS,SelectedOS
		        $myObj.Name = $vmguest.name
		        $myObj.InstalledOS = $vmguest.Guest.GuestFullName
		        $myObj.SelectedOS = $vmguest.Summary.Config.GuestFullName
		        $wrongOS += $myObj
		    }
		    If (($wrongOS | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
		    $myReport += Get-CustomHeader "Guests with wrong OS : $($wrongOS.count)" "The following virtual machines contain operating systems other than the ones selected in the VM configuration."
		    $myReport += Get-HTMLTable $wrongOS
		    $MyReport += Get-CustomHeaderClose
		    }
		}
		
		#--------------------
		if ($ShowWrongSyslog) {
		    Write-CustomOut "..Checking VM Host syslog server"
		    $wrongSyslog = @()
		    foreach ($vmhost in ($VMH | 
		    Where {$_.ConnectionState -ne "Disconnected"} | Select Name, @{N="SLServer";E={$_ | Get-VMHostSyslogServer}} | 
		    Where {$_.SLServer -notmatch $syslogserver}))
		    {
		        $myObj = "" | select Name,SyslogServer
		        $myObj.name = $vmhost.name
		        $myObj.SyslogServer = $vmhost.SLServer
		        $wrongSyslog += $myObj
		    }
		    If (($wrongSyslog | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
		    $myReport += Get-CustomHeader "Hosts with the wrong syslog specified : $($wrongSyslog.count)" "The following hosts do not have a proper syslog of $syslogserver specified."
		    $myReport += Get-HTMLTable $wrongSyslog
		    $MyReport += Get-CustomHeaderClose
		    }
		}
		
		#--------------------
		if ($ShowRemoteTSM) {
		    Write-CustomOut "..Checking VM Host for remote TSM enabled"
		    $startingEAP = $ErrorActionPreference
		    $ErrorActionPreference="SilentlyContinue"
		    $remoteTSM = @()
		    foreach ($vmhost in ($VMH))
		    {
		        $socket = new-object Net.Sockets.TcpClient
		        $socket.connect($vmhost,22)
		        if ($socket.Connected) {
		            $myObj = "" | select Name,Connected
		            $myObj.Name = $vmhost.name
		            $myObj.Connected = "TRUE"
		            $remoteTSM += $myObj
		            $socket.close()
		        }   
		    }
		    $ErrorActionPreference = $startingEAP
		    If (($remoteTSM | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
		    $myReport += Get-CustomHeader "Hosts with remote tech support enabled : $($remoteTSM.count)" "The following hosts have SSH/remote tech support mode enabled."
		    $myReport += Get-HTMLTable $remoteTSM
		    $MyReport += Get-CustomHeaderClose
		    }
		}
		
		# ---- Virtual Machines with Resource Limits ----
		If ($VMresourcelimts){
			Write-CustomOut "..Checking for Resource Limits"
			$VMResourceLimits = @($VM | get-view | where {$_.ResourceConfig.CpuAllocation.Limit -ne -1 -or $_.ResourceConfig.MemoryAllocation.Limit -ne -1} | Select Name, @{N="CPULimit";E={$_.ResourceConfig.CpuAllocation.Limit}}, @{N="MEMLimit";E={$_.ResourceConfig.MemoryAllocation.Limit}} | Sort Name)
			If (($VMResourceLimits | Measure-Object).count -gt 0 -or $ShowAllHeaders){
				$MyReport += Get-CustomHeader "Number of VMs with resource limits : $($VMResourceLimits.count)" "VMs with Resource limits"
				$MyReport += Get-HTMLTable $VMResourceLimits
				$MyReport += Get-CustomHeaderClose
			}
		}
			

		# ---- ESXi Technical Support Mode ----
		If ($ShowTech){
			Write-CustomOut "..Checking for ESXi with Technical Support mode enabled"
			$ESXiTechMode = $VMH | Where {$_.ConnectionState -eq "Connected" -or $_.ConnectionState -eq "Maintenance"} | Get-View | Where {$_.Summary.Config.Product.Name -match "i"} | Select Name, @{N="TechSuportModeEnabled";E={(Get-VMHost $_.Name | Get-VMHostAdvancedConfiguration -Name VMkernel.Boot.techSupportMode).Values}}
			$ESXTech = @($ESXiTechMode | Where { $_.TechSuportModeEnabled -eq "True" })
			If (($ESXTech | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "ESXi Hosts with Tech Support Mode Enabled : $($ESXTech.count)" "The following ESXi Hosts have Technical support mode enabled, this may not be the best security option, see here for more information: <a href='http://www.yellow-bricks.com/2010/03/01/disable-tech-support-on-esxi/' target='_blank'>Yellow-Bricks Disable Tech Support on ESXi</a>."
					$MyReport += Get-HTMLTable $ESXTech
				$MyReport += Get-CustomHeaderClose	
			}
		}
		
		# ---- ESXi Lockdown Mode ----
		If ($Lockdown){	
			Write-CustomOut "..Checking for ESXi hosts which do not have Lockdown mode enabled"
			$ESXiLockDown = $VMH | Where {$_.ConnectionState -eq "Connected" -or $_.ConnectionState -eq "Maintenance"} | Get-View | Where {$_.Summary.Config.Product.Name -match "i"} | Select Name, @{N="LockedMode";E={$_.Config.AdminDisabled}}
			$ESXiUnlocked = @($ESXiLockDown | Where { $_.LockedMode -ne "False" })
			If (($ESXiUnlocked | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "ESXi Hosts with Lockdown Mode not Enabled : $($ESXiUnlocked.count)" "The following ESXi Hosts do not have lockdown enabled, think about using Lockdown as an extra security feature."
					$MyReport += Get-HTMLTable $ESXiUnlocked
				$MyReport += Get-CustomHeaderClose	
			}
		}
		
		# ---- VM Hardware Version ----
		If ($ShowHWVer){
			If ($vSphere -eq $true){
				Write-CustomOut "..Checking VM Hardware Version"
				$HV = @($FullVM | Select Name, @{N="HardwareVersion";E={"Version $($_.Config.Version[5])"}} | Where {$_.HardwareVersion -ne "Version 7"} | sort name)
				If (($HV | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
					$MyReport += Get-CustomHeader "VMs with old hardware : $($HV.count)" "The following VMs are not at the latest hardware version, you may gain performance enhancements if you convert them to the latest version"
						$MyReport += Get-HTMLTable $HV
					$MyReport += Get-CustomHeaderClose	
				}
			}
		}
		
		# ---- VC Errors ----
		If ($ShowVIEvents){
			Write-CustomOut "..Checking VI Events"
			$OutputErrors = @(Get-VIEvent -maxsamples 10000 -Start ($Date).AddDays(-$VCEventAge ) -Type Error | Select @{N="Host";E={$_.host.name}}, createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)
			If (($OutputErrors | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Error Events (Last $VCEventAge Day(s)) : $($OutputErrors.count)" "The Following Errors were logged in the vCenter Events tab, you may wish to investigate these"
					$MyReport += Get-HTMLTable $OutputErrors
				$MyReport += Get-CustomHeaderClose	
			}
		}
		
		# ---- vSwitch Ports Check ----		
		if ($vSwitchCheck){
			$vswitchinfo = @()
			foreach ($vhost in $VMH)
			{
				foreach ($vswitch in ($vhost|Get-VirtualSwitch))
				{
					$vswitchinf = "" | Select VMHost, vSwitch, PortsLeft
					$vswitchinf.VMHost = $vhost
					$vswitchinf.vSwitch = $vswitch.name
					$vswitchinf.PortsLeft = $vswitch.NumPortsAvailable
					$vswitchinfo += $vswitchinf
				}
			}
			$vswitchinfo = $vswitchinfo |sort PortsLeft | Where {$_.PortsLeft -lt $($vSwitchLeft)}
			
			If (($vswitchinfo | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "vSwitch with less than $vSwitchLeft Port(s) Free : $($vswitchinfo.count)" "The following vSwitches have less than $vSwitchLeft left"
					$MyReport += Get-HTMLTable $vswitchinfo
				$MyReport += Get-CustomHeaderClose
			}		
		}
		
		# ---- VMs in inconsistent folders ----
		If ($Showfolders){
			Write-CustomOut "..Checking VMs in Inconsistent folders"
			$VMFolder = @()
			Foreach ($CHKVM in $FullVM){
				$Details = "" |Select-Object VM,Path
				$Folder = ((($CHKVM.Summary.Config.VmPathName).Split(']')[1]).Split('/'))[0].TrimStart(' ')
				$Path = ($CHKVM.Summary.Config.VmPathName).Split('/')[0]
				If ($CHKVM.Name-ne $Folder){
					$Details.VM= $CHKVM.Name
					$Details.Path= $Path
					$VMFolder += $Details}
			}
			If (($VMFolder | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VMs in Inconsistent folders : $($VMFolder.count)" "The Following VM's are not stored in folders consistent to their names, this may cause issues when trying to locate them from the datastore manually"
					$MyReport += Get-HTMLTable $VMFolder
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- No VM Tools ----
		If ($Showtools){
			Write-CustomOut "..Checking VM Tools"
			$NoTools = @($FullVM | Where {$_.Runtime.Powerstate -eq "poweredOn" -And ($_.Guest.toolsStatus -eq "toolsNotInstalled" -Or $_.Guest.ToolsStatus -eq "toolsNotRunning")} | Select Name, @{N="Status";E={$_.Guest.ToolsStatus}} |sort Name)
			If (($NoTools | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "No VMTools : $($NoTools.count)" "The following VMs do not have VM Tools installed or are not running, you may gain increased performance and driver support if you install VMTools"
					$MyReport += Get-HTMLTable $NoTools
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VM Tools Issues ----
		If ($ShowtoolsIssues){
			Write-CustomOut "..Checking VM Tools Issues"
			$FailTools = $VM |Where {$_.Guest.State -eq "Running" -And ($_.Guest.OSFullName -eq $NULL -or $_.Guest.IPAddress -eq $NULL -or $_.Guest.HostName -eq $NULL -or $_.Guest.Disks -eq $NULL -or $_.Guest.Nics -eq $NULL)} |select -ExpandProperty Guest |select vmname,@{N= "IPAddress";E={$_.IPAddress[0]}},OSFullName,HostName,@{N="NetworkLabel";E={$_.nics[0].NetworkName}} -ErrorAction SilentlyContinue|sort VmName
			If (($FailTools | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VM Tools Issues : $($FailTools.count)" "The following VMs have issues with VMtools, these should be checked and reinstalled if necessary"
					$MyReport += Get-HTMLTable $FailTools
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VM Tools out of date ----
		If ($Showtoolsupdate){
			Write-CustomOut "..Checking VM Tools Out of Date"
			$UpdateTools = @($FullVM |Where {$_.Guest.ToolsStatus -eq "ToolsOld"} |Select Name, @{N="Status";E={$_.Guest.ToolsStatus}} | sort Name)
			If (($UpdateTools | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VM Tools Updates : $($UpdateTools.count)" "The following VMs have issues with VMtools and need to be updated"
				$MyReport += Get-HTMLTable $UpdateTools
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VM Tools connected ----
		If ($ShowtoolsConnected){
			Write-CustomOut "..Checking VM Tools Installer connected"
			$ToolsConnect = @($FullVM | where {$_.Runtime.ToolsInstallerMounted -eq $true} | select Name, @{N="Connected";E={$_.RunTime.ToolsInstallerMounted}} | sort Name)
			If (($ToolsConnect | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VM Tools Installer connected : $($ToolsConnect.count)" "The following VMs have the VMware Tools installer mounted and may create VMotion violations."
				$MyReport += Get-HTMLTable $ToolsConnect
				$MyReport += Get-CustomHeaderClose
			}
		}

		# ---- CD-Roms Connected ----
		If ($ShowCDROM){
			Write-CustomOut "..Checking for connected CDRoms"
			$CDConn = @($VM | Where { $_ | Get-CDDrive | Where { $_.ConnectionState.Connected -eq $true } } | Select Name, VMHost)
			$CDConn = $CDConn | Where { $_.Name -notmatch $CDFloppyConnectedOK }
			If (($CDConn | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VM: CD-ROM Connected - VMotion Violation : $($CDConn.count)" "The following VMs have a CD-ROM connected, this may cause issues if this machine needs to be migrated to a different host"
					$MyReport += Get-HTMLTable $CDConn
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Floppys Connected ----
		If ($ShowFloppy){
			Write-CustomOut "..Checking for connected floppy drives"
			$Floppy = @($VM | Where { $_ | Get-FloppyDrive | Where { $_.ConnectionState.Connected -eq $true } } | Where { $_.Name -notmatch $CDFloppyConnectedOK } | Select Name, VMHost)
			$Floppy = $Floppy | Where { $_.Name -notmatch $CDFloppyConnectedOK }
			If (($Floppy | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VM:Floppy Drive Connected - VMotion Violation : $($Floppy.count)" "The following VMs have a floppy disk connected, this may cause issues if this machine needs to be migrated to a different host"
					$MyReport += Get-HTMLTable $Floppy
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Unwanted hardware connected ----		
		If ($showUnwantedHardware){  
		 #Thanks to @lucd http://communities.vmware.com/message/1546618
		 $vUnwantedHw = @()
		 foreach ($vmguest in ($vm | get-view))
		 {
		  $vmguest.Config.Hardware.Device | where {$_.GetType().Name -match $unwantedHardware} |  %{
		   $myObj = "" | select Name,Label
		   $myObj.Name = $vmguest.name 
		   $myObj.Label = $_.DeviceInfo.Label
		   $vUnwantedHw += $myObj
		  }
		 }
		 If (($vUnwantedHw | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
		 $myReport += Get-CustomHeader "Unwanted virtual hardware found : $($vUnwantedHw.count)" "Certain kinds of hardware are unwanted on virtual machines as they may cause unnecessary vMotion constraints."
		 $myReport += Get-HTMLTable $vUnwantedHw
		 $MyReport += Get-CustomHeaderClose
		 }
		}  

		# ---- Single Storage VMs ----
		If ($ShowSingle){
			Write-CustomOut "..Checking Datastores assigned to single hosts for VMs"
			$LocalVMs = @($LocalOnly | Get-UnShareableDatastore | Where { $_.VM -notmatch $LVMDoNotInclude }) 
			If (($LocalVMs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VMs stored on non shared datastores : $($LocalVMs.count)" "The following VMs are located on storage which is only accesible by 1 host, these will not be compatible with VMotion and may be disconnected in the event of host failure"
					$MyReport += Get-HTMLTable $LocalVMs
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- NTP Check ----
		If ($ShowNTP){
			Write-CustomOut "..Checking NTP Name and Service"
			$NTPCheck = @($VMH | Where {$_.ConnectionState -ne "Disconnected"} | Select Name, @{N="NTPServer";E={$_ | Get-VMHostNtpServer}}, @{N="ServiceRunning";E={(Get-VmHostService -VMHost $_ | Where-Object {$_.key -eq "ntpd"}).Running}} | Where {$_.ServiceRunning -eq $false -or $_.NTPServer -notmatch $ntpserver})
			If (($NTPCheck | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "NTP Issues : $($NTPCheck.count)" "The following hosts do not have the correct NTP settings of $ntpserver and may cause issues if the time becomes far apart from the vCenter/Domain or other hosts"
					$MyReport += Get-HTMLTable $NTPCheck
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- CPU %Ready Check ----
		If ($ShowCPURDY){
			Write-CustomOut "..Checking VM CPU %RDY"
			$myCol = @()
			ForEach ($v in ($VM | Where {$_.PowerState -eq "PoweredOn"})){
				For ($cpunum = 0; $cpunum -lt $v.NumCpu; $cpunum++){
					$myObj = "" | Select VM, VMHost, CPU, PercReady
					$myObj.VM = $v.Name
					$myObj.VMHost = $v.VMHost
					$myObj.CPU = $cpunum
					$myObj.PercReady = [Math]::Round((($v | Get-Stat -ErrorAction SilentlyContinue -Stat Cpu.Ready.Summation -Realtime | Where {$_.Instance -eq $cpunum} | Measure-Object -Property Value -Average).Average)/200,1)
					$myCol += $myObj
				}
			}
			
			$rdycheck = @($myCol | Where {$_.PercReady -gt $PercCPUReady} | Sort PercReady -Descending)
			If (($rdycheck | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VM CPU % RDY over $PercCPUReady : $($rdycheck.count)" "The following VMs have high CPU RDY times, this can cause performance issues for more information please read <a href='http://communities.vmware.com/docs/DOC-7390' target='_blank'>This article</a>"
					$MyReport += Get-HTMLTable $rdycheck
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VM CPU Check ----
		If ($ShowVMCPU){
			Write-CustomOut "..Checking VM CPU Usage"
			$VMCPU = $VM | Select Name, @{N="AverageCPU";E={[Math]::Round(($_ | Get-Stat -ErrorAction SilentlyContinue -Stat cpu.usage.average -Start (($Date).AddDays(-$CPUDays)) -Finish ($Date) | Measure-Object -Property Value -Average).Average)}}, NumCPU, VMHost | Where {$_.AverageCPU -gt $CPUValue} | Sort AverageCPU -Descending
			If (($VMCPU | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VM(s) CPU above $CPUValue : $($VMCPU.count)" "The following VMs have high CPU usage and may have rogue guest processes or not enough CPU resource assigned"
					$MyReport += Get-HTMLTable $VMCPU
				$MyReport += Get-CustomHeaderClose
			}                 
		}
		
		# ---- Num VM Per Datastore Check ----
		If ($ShowNumVMperDS){
			Write-CustomOut "..Checking Number of VMs per Datastore"
			$VMPerDS = @($Datastores | Select Name, @{N="NumVM";E={@($_ | Get-VM).Count}} | Where { $_.NumVM -gt $NumVMsPerDatastore} | Sort Name)
			If (($VMPerDS | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Number of VMs per Datastore over $NumVMsPerDatastore : $($VMPerDS.count)" "The Maximum number of VMs per datastore is 256, the following VMs are above the defined $NumVMsPerDatastore and may cause performance issues"
					$MyReport += Get-HTMLTable $VMPerDS
				$MyReport += Get-CustomHeaderClose
			}                 
		}
		
		# ---- Host ConfigIssue ----
		If ($ShowHostCIAlarm){
			Write-CustomOut "..Checking Host Configuration Issues"
			$hostcialarms = @()
			foreach ($HostsView in $HostsViews) {
				if ($HostsView.ConfigIssue) {           
					$HostConfigIssues = $HostsView.ConfigIssue
					Foreach ($HostConfigIssue in $HostConfigIssues) {
						$Details = "" | Select-Object Name, Reason, Message
						$Details.name = $HostsView.name
						$Details.Reason = $HostConfigIssue.Reason
						$Details.Message = $HostConfigIssue.FullFormattedMessage
						$hostcialarms += $Details
					}
				}
			}
	
			If (($hostcialarms | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$hostcialarms = $hostcialarms | sort name
				$MyReport += Get-CustomHeader "Host(s) Config Issue(s) : $($hostcialarms.count)" "The following configuration issues have been registered against Hosts in vCenter"
					$MyReport += Get-HTMLTable $hostcialarms
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Host Alarm ----
		If ($ShowHostAlarm){
			Write-CustomOut "..Checking Host Alarms"
			$alarms = $alarmMgr.GetAlarm($null)
			$valarms = $alarms | select value, @{N="name";E={(Get-View -Id $_).Info.Name}}
			$hostsalarms = @()
			foreach ($HostsView in $HostsViews){
				if ($HostsView.TriggeredAlarmState){
					$hostsTriggeredAlarms = $HostsView.TriggeredAlarmState
					Foreach ($hostsTriggeredAlarm in $hostsTriggeredAlarms){
						$Details = "" | Select-Object Object, Alarm, Status, Time
						$Details.Object = $HostsView.name
						$Details.Alarm = ($valarms |?{$_.value -eq ($hostsTriggeredAlarm.alarm.value)}).name
						$Details.Status = $hostsTriggeredAlarm.OverallStatus
						$Details.Time = $hostsTriggeredAlarm.time
						$hostsalarms += $Details
					}
				}
			}
	
			If (($hostsalarms | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$hostsalarms = @($hostsalarms |sort Object)
				$MyReport += Get-CustomHeader "Host(s) Alarm(s) : $($hostalarms.count)" "The following alarms have been registered against hosts in vCenter"
					$MyReport += Get-HTMLTable $hostsalarms
				$MyReport += Get-CustomHeaderClose
			}                 
		}
		
		# ---- VM Alarm ----
		If ($ShowVMAlarm){
			Write-CustomOut "..Checking VM Alarms"
			$vmsalarms = @()
			foreach ($VMView in $FullVM){
				if ($VMView.TriggeredAlarmState){
					$VMsTriggeredAlarms = $VMView.TriggeredAlarmState
					Foreach ($VMsTriggeredAlarm in $VMsTriggeredAlarms){
						$Details = "" | Select-Object Object, Alarm, Status, Time
						$Details.Object = $VMView.name
						$Details.Alarm = ($valarms |?{$_.value -eq ($VMsTriggeredAlarm.alarm.value)}).name
						$Details.Status = $VMsTriggeredAlarm.OverallStatus
						$Details.Time = $VMsTriggeredAlarm.time
						$vmsalarms += $Details
					}
				}
			}
	
			If (($vmsalarms | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$vmsalarms = $vmsalarms | sort Object
				$MyReport += Get-CustomHeader "VM(s) Alarm(s) : $($vmsalarms.count)" "The following alarms have been registered against VMs in vCenter"
					$MyReport += Get-HTMLTable $vmsalarms
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Cluster ConfigIssue ----
		If ($ShowCLUAlarm){
			Write-CustomOut "..Checking Cluster Configuration Issues"
			$clualarms = @()
			$clusviews = Get-View -ViewType ClusterComputeResource
			foreach ($clusview in $clusviews) {
				if ($clusview.ConfigIssue) {           
					$CluConfigIssues = $clusview.ConfigIssue
					Foreach ($CluConfigIssue in $CluConfigIssues) {
						$Details = "" | Select-Object Name, Message
						$Details.name = $clusview.name
						$Details.Message = $CluConfigIssue.FullFormattedMessage
						$clualarms += $Details
					}
				}
			}
	
			If (($clualarms | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$clualarms = $clualarms | sort name
				$MyReport += Get-CustomHeader "Cluster(s) Config Issue(s) : $($Clualarms.count)" "The following alarms have been registered against clusters in vCenter"
					$MyReport += Get-HTMLTable $clualarms
				$MyReport += Get-CustomHeaderClose
			}
		}

		# ---- Datastore OverAllocation ----
		if ($ShowOverAllocation) {
			Write-CustomOut "..Checking Datastore OverAllocation"
			$storages = $Datastores |Get-View
			$voverallocation = @()
			foreach ($storage in $storages)
			{
				if ($storage.Summary.Uncommitted -gt "0")
				{
					$Details = "" | Select-Object Datastore, Overallocation
					$Details.Datastore = $storage.name
					$Details.overallocation = [math]::round(((($storage.Summary.Capacity - $storage.Summary.FreeSpace) + $storage.Summary.Uncommitted)*100)/$storage.Summary.Capacity,0)
						if ($Details.overallocation -gt $OverAllocation)
						{
							$voverallocation += $Details
						}
				}
			}
			
			If (($voverallocation | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
			$MyReport += Get-CustomHeader "Datastore OverAllocation % over $OverAllocation : $($voverallocation.count)" "The following datastores may be overcommitted it is strongly sugested you check these"
			$MyReport += Get-HTMLTable $voverallocation
			$MyReport += Get-CustomHeaderClose
			}			
		}
		
		# ---- VM Host Uptime Warnings ----
		if ($CheckHostUptime) {
			Write-CustomOut "..Checking for Host Uptime warnings"
			$HostUptime = @()
			$VMH | Get-View | % {
				$myDetails = "" | select Host, "Uptime (days)", Status
				$uptime = New-TimeSpan $_.Runtime.BootTime $date
				$myDetails.Host = $_.name
				$myDetails."Uptime (days)" = $uptime.days
				if ($uptime.days -lt 3) {
					$myDetails.Status = "Recently Rebooted"
				} elseif ($uptime.days -gt 60) {
					$myDetails.Status = "Uptime over 60 days - verify security patch levels"
				} else {
					$myDetails.Status = "Normal"
				}
				if ($myDetails.Status -ne "Normal") {$HostUptime += $myDetails}
			}
			
			If (($HostUptime | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Host uptime warnings : $($HostUptime.count)" "The following hosts have uptime over 60 days (and may require security patches) or under 3 days (recently added/rebooted)."
				$MyReport += Get-HTMLTable $HostUptime
				$MyReport += Get-CustomHeaderClose
			}
		}

		if ($ShowHostVUMNonCompliance) {
		# ---- Hosts VMware Update Manager Baseline non-compliance ---- 
			Write-CustomOut "..Checking Hosts VMware Update Manager Baseline non-compliance"
			$vHostVUMNonCompliance = @()
			if ($powerclivumVersion -eq $null) {
				Write-CustomOut "..WARNING: vCenter Update Manager cmdlets not found."
				$myObj = "" | Select Warning
				$myObj.Warning = "vCenter Update Manager cmdlets not found, unable to process this check"
				$vHostVUMNonCompliance += $myObj
			} else {
				$NonCompliance = $VMH | Get-Compliance | Where-Object {$_.Status -ne "Compliant"}
				foreach ($ncHost in $NonCompliance) {
					$myObj = "" | select Host, Baseline, Status
					$myObj.Host = $ncHost.Entity
					$myObj.Baseline = $ncHost.Baseline.Name
					$myObj.Status = $ncHost.Status
					$vHostVUMNonCompliance += $myObj
				}
			}
		
			If (($vHostVUMNonCompliance | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Hosts VMware Update Manager Baseline non-compliance : $($vHostVUMNonCompliance.count)" "The following hosts are not compliant to the attached baselines"
				$MyReport += Get-HTMLTable $vHostVUMNonCompliance
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- VM Host OS Pivot Table ----
		if ($HostOSPivot) {
			Write-CustomOut "..Creating Host OS Pivot table"
			$HostOSversions = @{ }
			$VMH | Get-View | % {
				$HostOSVersion = $_.Summary.Config.Product.FullName
				$HostOSversions.$HostOSversion++
			}
			
			$myCol = @()
			foreach ( $hosname in $HostOSversions.Keys | sort) {
				$MyDetails = "" | select OS, Count
				$MyDetails.OS = $hosname
				$MyDetails.Count = $HostOSversions.$hosname
				$myCol += $MyDetails
			}
			
			$vHostOSversions = $myCol | sort Count -desc
			If (($vHostOSversions | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "Host Build versions in use : $($vHostOSversions.count)" "The following host builds are in use in this vCenter."
				$MyReport += Get-HTMLTable $vHostOSversions
				$MyReport += Get-CustomHeaderClose
			}
		}


		# VCB Garbage
		if ($ShowVCBgarbage) {
		Write-CustomOut "..Checking VCB Garbage"
			$VCBGarbage = $VM |where { (Get-Snapshot -VM $_).name -contains "VCB|Consolidate|veeam" } |sort name |select name
			If (($VCBGarbage | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "VCB Garbage : $($VCBGarbage.count)" "The following snapshots have been left over from using VCB, you may wish to investigate if these are still needed"
				$MyReport += Get-HTMLTable $VCBGarbage
				$MyReport += Get-CustomHeaderClose
			}		
		}		
		
		# ---- Virtual Center Details ----
		If ($ShowVCDetails){
			Write-CustomOut "..Checking VC Services"
			$Services = @(Get-VIServices | Where {$_.Name -ne $null -and $_.Health -ne "OK"})
			If (($Services | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "$VIServer Service Details : $($Services.count)" "The following vCenter Services are not in the required state"
					$MyReport += Get-HTMLTable ($Services)
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Virtual Center Event Logs - Error ----
		If ($Showvcerror){
			Write-CustomOut "..Checking VC Error Event Logs"
			$ConvDate = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime([DateTime]::Now.AddDays(-$VCEvntlgAge))
			If ($SetUsername -ne ""){
				$ErrLogs = @(Get-WmiObject -Credential $creds -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Error' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
			} Else {
				$ErrLogs = @(Get-WmiObject -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Error' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
			}
			
			If (($ErrLogs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "$VIServer Event Logs ($VCEvntlgAge day(s)): Error : $($ErrLogs.count)" "The following errors were found in the vCenter Event Logs, you may wish to check these further"
					$MyReport += Get-HTMLTable ($ErrLogs)
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# ---- Virtual Center Event Logs - Warning ----
		If ($Showvcwarn){
			Write-CustomOut "..Checking VC Warning Event Logs"
			$ConvDate = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime([DateTime]::Now.AddDays(-$VCEvntlgAge))
			If ($SetUsername -ne ""){
				$WarnLogs = @(Get-WmiObject -Credential $creds -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Warning' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
			} Else {
				$WarnLogs = @(Get-WmiObject -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Warning' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message )
			}
			If (($WarnLogs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$MyReport += Get-CustomHeader "$VIServer Event Logs ($VCEvntlgAge day(s)): Warning : $($WarnLogs.count)" "The following warnings were found in the vCenter Event Logs, you may wish to check these further"
					$MyReport += Get-HTMLTable ($WarnLogs)
				$MyReport += Get-CustomHeaderClose
			}
		}
		
		# VMKernel	Warnings check
		if ($ShowVMKernel) {
		Write-CustomOut "..Checking VMKernel Warnings"
			$SysGlobalization = New-Object System.Globalization.CultureInfo("en-US")
			$VMHV = Get-View -ViewType HostSystem
			$VMKernelWarnings = @()
			foreach ($VMHost in ($VMHV)){
				
				$product = $VMHost.config.product.ProductLineId
				if ($product -eq "embeddedEsx"){
					$Warnings = (Get-Log -vmhost ($VMHost.name) -Key messages -ErrorAction SilentlyContinue).entries |where {$_ -match "warning" -and $_ -match "vmkernel"}
					if ($Warnings -ne $null) {
						$VMKernelWarning = @()
						$Warnings | % {
							$Details = "" | Select-Object VMHost, Time, Message, Length, KBSearch, Google
							$Details.VMHost = $VMHost.Name
							if (($_.split()[1]) -eq "")
							{$Details.Time = ([datetime]::ParseExact(($_.split()[0] + " " + $_.split()[2] + " " + $_.split()[3]), "MMM d HH:mm:ss", $SysGlobalization))}
							else
							{$Details.Time = ([datetime]::ParseExact(($_.split()[0] + " " + $_.split()[1] + " " + $_.split()[2]), "MMM dd HH:mm:ss", $SysGlobalization))}
							$Message = ([regex]::split($_, "WARNING: "))[1]
							$Message = $Message -replace "'", " "
							$Details.Message = $Message
							$Details.Length = ($Details.Message).Length
							$Details.KBSearch = "<a href='http://kb.vmware.com/selfservice/microsites/search.do?searchString=$Message&sortByOverride=PUBLISHEDDATE&sortOrder=-1' target='_blank'>Click Here</a>"
							$Details.Google = "<a href='http://www.google.co.uk/search?q=$Message' target='_blank'>Click Here</a>"
							if ($Details.Length -gt 0)
							{
								if ($Details.Time -gt $Date.AddDays(-$vmkernelchk) -and $Details.Time -lt $Date)
								{
									$VMKernelWarning += $Details
								}
							}
						}
						$VMKernelWarnings += $VMKernelWarning | Sort-Object -Property Length -Unique |select VMHost, Message, Time, KBSearch, Google
					}	
				}
				else
				{
					
					$Warnings = (Get-Log –VMHost ($VMHost.Name) -Key vmkernel -ErrorAction SilentlyContinue).Entries | where {$_ -match "warning" -and $_ -match "vmkernel"}
					if ($Warnings -ne $null) {
						$VMKernelWarning = @()
	.					$Warnings | % {
							$Details = "" | Select-Object VMHost, Time, Message, Length, KBSearch, Google
							$Details.VMHost = $VMHost.Name
							if (($_.split()[1]) -eq "")
							{$Details.Time = ([datetime]::ParseExact(($_.split()[0] + " " + $_.split()[2] + " " + $_.split()[3]), "MMM d HH:mm:ss", $SysGlobalization))}
							else
							{$Details.Time = ([datetime]::ParseExact(($_.split()[0] + " " + $_.split()[1] + " " + $_.split()[2]), "MMM dd HH:mm:ss", $SysGlobalization))}
							$Message = ([regex]::split($_, "WARNING: "))[1]
							$Message = $Message -replace "'", " "
							$Details.Message = $Message
							$Details.Length = ($Details.Message).Length
							$Details.KBSearch = "<a href='http://kb.vmware.com/selfservice/microsites/search.do?searchString=$Message&sortByOverride=PUBLISHEDDATE&sortOrder=-1' target='_blank'>Click Here</a>"
							$Details.Google = "<a href='http://www.google.co.uk/search?q=$Message' target='_blank'>Click Here</a>"
							if ($Details.Length -gt 0)
							{						
								if ($Details.Time -gt $Date.AddDays(-$VMKernelchk))
								{
									$VMKernelWarning += $Details
								}
							}
						}
						$VMKernelWarnings += $VMKernelWarning | Sort-Object -Property Length -Unique |select VMHost, Message, Time, KBSearch, Google
						
					}
				}
			}	
			
			If (($VMKernelWarnings | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
				$VMKernelWarnings = $VMKernelWarnings |sort time -Descending
				$MyReport += Get-CustomHeader "ESX/ESXi VMKernel Warnings" "The following VMKernel issues were found, it is suggested all unknown issues are explored on the VMware Knowledge Base. Use the below links to automatically search for the string"
				$MyReport += Get-HTMLTable $VMKernelWarnings
				$MyReport += Get-CustomHeaderClose
			}			

<#


				$MyReport += Get-CustomHeader "Capacity Planner Info (Storage)" "The following gives brief capacity information for virtual machine storage per datacenter."
				$MyReport += Get-HTMLTable $diskcapacityinfo
				$MyReport += Get-CustomHeaderClose
		
#>

               $MyReport += Get-CustomHeader "VM Uptime (in Days)" "The following gives VM Uptime in days"
               foreach ($v in $vm){
               $Uptime = $v | Get-Stat -Stat sys.uptime.latest -MaxSamples 1 -Realtime |
               select Entity, Value, Unit -ErrorAction SilentlyContinue | Select-Object -Property value -ExpandProperty value|
               % {[math]::Round($_ /60/60/24,2)}
               $Details.Name = $v.name
               $Details.Uptime = $Uptime
               $MyReport += $Details.Name
               $MyReport += $Details.Uptime
               $MyReport += Get-HTMLTable $Uptime
               $MyReport += Get-CustomHeaderclose
               }

		}
	$MyReport += Get-CustomHeader0Close
$MyReport += Get-CustomHTMLClose

#Uncomment the following lines to save the htm file in a central location
if ($DisplayToScreen) {
	Write-CustomOut "..Displaying HTML results"
	if (-not (test-path c:\tmp\)){
		MD c:\tmp | Out-Null
	}
	$Filename = "C:\tmp\" + $VIServer + "vCheck" + "_" + $date.ToString($dateFormat) + ".htm"
	$MyReport | out-file -encoding ASCII -filepath $Filename
	Invoke-Item $Filename
}

if ($SendEmail) {
	Write-CustomOut "..Sending Email"
	send-SMTPmail $EmailTo $EmailFrom "Daily VMware Health Report" $SMTPSRV $MyReport
}

$VIServer | Disconnect-VIServer -Confirm:$false
