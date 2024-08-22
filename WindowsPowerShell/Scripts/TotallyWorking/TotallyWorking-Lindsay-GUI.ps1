# Add required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Form logic
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Totally Working (v0.6.0)'
$form.Size = New-Object System.Drawing.Size(450,450)  # Increased width for better fit
$form.StartPosition = 'CenterScreen'

# Set a consistent font size for all controls
$font = New-Object System.Drawing.Font("Arial", 10)

# Minutes label
$minutesLabel = New-Object System.Windows.Forms.Label
$minutesLabel.AutoSize = $true
$minutesLabel.Location = New-Object System.Drawing.Point(10,20)  # Reduced top space
$minutesLabel.Size = New-Object System.Drawing.Size(420,20)  # Adjusted width to match form size
$minutesLabel.Font = $font
$minutesLabel.Padding = New-Object System.Windows.Forms.Padding(0, 0, 0, 3)  # Reduce bottom padding slightly
$minutesLabel.Text = 'How many minutes would you like to keep the computer active?'
$form.Controls.Add($minutesLabel)

# Minutes box
$minutesBox = New-Object System.Windows.Forms.TextBox
$minutesBox.Location = New-Object System.Drawing.Point(10,50)  # Move the input box slightly up
$minutesBox.Size = New-Object System.Drawing.Size(100,25)
$minutesBox.Font = $font
$form.Controls.Add($minutesBox)

# Action label
$actionLabel = New-Object System.Windows.Forms.Label
$actionLabel.AutoSize = $true
$actionLabel.Location = New-Object System.Drawing.Point(10,90)  # Keep the label location
$actionLabel.Size = New-Object System.Drawing.Size(420,20)  # Adjusted width to match form size
$actionLabel.Font = $font
$actionLabel.Padding = New-Object System.Windows.Forms.Padding(0, 0, 0, 3)  # Reduce bottom padding slightly
$actionLabel.Text = 'After the active time ends, your computer will:'
$form.Controls.Add($actionLabel)

# Action dropdown
$actionDropDown = New-Object System.Windows.Forms.ComboBox
$actionDropDown.Location = New-Object System.Drawing.Point(10,115)  # Move the dropdown slightly up
$actionDropDown.Size = New-Object System.Drawing.Size(200,25)
$actionDropDown.Font = $font
$actionDropDown.Items.AddRange(@('Do nothing', 'Hibernate', 'Sleep', 'Lock', 'Power off'))
$form.Controls.Add($actionDropDown)

# Output window
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(10,165)  # Adjust as needed for spacing
$outputBox.Size = New-Object System.Drawing.Size(420,180)  # Adjusted width to match form size
$outputBox.Multiline = $true
$outputBox.ScrollBars = 'Vertical'
$outputBox.ReadOnly = $true
$outputBox.Font = $font
$form.Controls.Add($outputBox)

# Run button
$runButton = New-Object System.Windows.Forms.Button
$runButton.Location = New-Object System.Drawing.Point(10,380)
$runButton.Size = New-Object System.Drawing.Size(75,25)
$runButton.Text = 'Run'
$runButton.Font = $font
$form.Controls.Add($runButton)

# Stop button
$stopButton = New-Object System.Windows.Forms.Button
$stopButton.Location = New-Object System.Drawing.Point(95,380)
$stopButton.Size = New-Object System.Drawing.Size(75,25)
$stopButton.Text = 'Stop'
$stopButton.Enabled = $false
$stopButton.Font = $font
$form.Controls.Add($stopButton)

# Timer
$timer = New-Object System.Windows.Forms.Timer

# Function to perform final action
function PerformFinalAction {
    switch ($action) {
        'Lock' { 
            $outputBox.AppendText("Locking workstation...`r`n")
            $signature = @"
            [DllImport("user32.dll", SetLastError = true)]
            public static extern bool LockWorkStation();
"@
            $LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru
            $LockWorkStation::LockWorkStation() | Out-Null
        }
        'Sleep' {
            $outputBox.AppendText("Putting computer to sleep...`r`n")
            powercfg.exe /hibernate off | Out-Null
            &"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Standby
        }
        'Power off' {
            $outputBox.AppendText("Powering off computer...`r`n")
            powercfg.exe /hibernate off | Out-Null
            Stop-Computer -Force
        }
        'Hibernate' {
            $outputBox.AppendText("Hibernating computer...`r`n")
            powercfg.exe /hibernate on | Out-Null
            &"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Hibernate
        }
    }
    $outputBox.AppendText("Script completed successfully.`r`n")
    $runButton.Enabled = $true
    $stopButton.Enabled = $false
}

# Run button action
$runButton.Add_Click({
    $minutes = $minutesBox.Text
    $action = $actionDropDown.SelectedItem
    $outputBox.Clear()

    $time = Get-Date
    $newtime = ($time.AddMinutes($minutes))
    $newtimetostring = $newtime.ToString("HH:mm:ss")

    $outputBox.AppendText("Current time is $($time.ToString('HH:mm:ss'))`r`n")
    $outputBox.AppendText("Computer will stay active until $newtimetostring`r`n")
    
    if ($action -ne 'Do nothing') {
        $outputBox.AppendText("and then $action.`r`n")
    }

    $outputBox.AppendText("`r`nKeeping computer active...`r`n")
    $form.Refresh()

    $script:remainingMinutes = [int]$minutes
    $script:wshShell = New-Object -ComObject Wscript.Shell

    $timer.Interval = 60000  # 60 seconds
    $timer.Add_Tick({
        if ($script:remainingMinutes -gt 0) {
            $script:wshShell.SendKeys("{SCROLLLOCK}")
            $outputBox.AppendText(".")
            $script:remainingMinutes--
        } else {
            $timer.Stop()
            $outputBox.AppendText("`r`nFinished keeping computer active.`r`n")
            PerformFinalAction
        }
    })

    $timer.Start()
    $runButton.Enabled = $false
    $stopButton.Enabled = $true
})

# Stop button action
$stopButton.Add_Click({
    $timer.Stop()
    $outputBox.AppendText("`r`nProcess stopped by user.`r`n")
    $runButton.Enabled = $true
    $stopButton.Enabled = $false
})

# Show the form
$form.Topmost = $true
$form.ShowDialog()
